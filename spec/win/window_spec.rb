require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'win/window'

module WinWindowTest

  include WinTest
  include Win::Window

  def launch_test_app
    system TEST_APP_START
    sleep TEST_SLEEP_DELAY until (handle = find_window(nil, TEST_WIN_TITLE))
    @launched_test_app = Window.new handle
  end

  def close_test_app(app = @launched_test_app)
    while app and app.respond_to? :handle and find_window(nil, TEST_WIN_TITLE)
      post_message(app.handle, WM_SYSCOMMAND, SC_CLOSE, 0)
      sleep TEST_SLEEP_DELAY
    end
    @launched_test_app = nil
  end

  # Creates test app object and yields it back to the block
  def test_app
    app = launch_test_app

    def app.textarea #define singleton method retrieving app's text area
      Window.new find_window_ex(self.handle, 0, TEST_TEXTAREA_CLASS, nil)
    end

    yield app
    close_test_app
  end

  def commands_should_show_window *cmds, tests
    cmds.each do |cmd|
      test_app do |app|
        show_window(app.handle, cmd)
        tests.each{|test, result| send(test.to_sym, app.handle).should == result}

        hide_window(app.handle) # hiding window first
        show_window(app.handle, cmd)
        tests.each{|test, result| send(test.to_sym, app.handle).should == result}

        show_window(app.handle, SW_MAXIMIZE) # now maximizing window
        show_window(app.handle, cmd)
        tests.each{|test, result| send(test.to_sym, app.handle).should == result}

        show_window(app.handle, SW_MINIMIZE) # now minimizing window
        show_window(app.handle, cmd)
        tests.each{|test, result| send(test.to_sym, app.handle).should == result}
      end
    end
  end


  describe Win::Window, ' defines a set user32 API functions related to Window manipulation' do
    describe '#window?' do
      spec{ use{ IsWindow(any_handle) }}
      spec{ use{ is_window(any_handle) }}
      spec{ use{ window?(any_handle) }}

      it 'returns true if window exists' do
        window?(any_handle).should == true
      end

      it 'returns false for invalid window handle' do
        window?(not_a_handle).should == false
      end

      it 'changes from true to false when existing window is closed' do
        test_app do |app|
          @app_handle = app.handle
          @ta_handle = app.textarea.handle
          window?(@app_handle).should == true
          window?(@ta_handle).should == true
        end
        window?(@app_handle).should == false
        window?(@ta_handle).should == false
      end
    end

    describe '#window_visible?' do
      spec{ use{ IsWindowVisible(any_handle) }}
      spec{ use{ is_window_visible(any_handle) }}
      spec{ use{ window_visible?(any_handle) }}
      spec{ use{ visible?(any_handle) }}

      it 'returns true when window is visible, false when window is hidden' do
        test_app do |app|
          visible?(app.handle).should == true
          window_visible?(app.handle).should == true
          window_visible?(app.textarea.handle).should == true
          hide_window(app.handle)
          visible?(app.handle).should == false
          window_visible?(app.handle).should == false
          window_visible?(app.textarea.handle).should == false
        end
      end
    end

    describe '#maximized?' do
      spec{ use{ IsZoomed(any_handle) }}
      spec{ use{ is_zoomed(any_handle) }}
      spec{ use{ zoomed?(any_handle) }}
      spec{ use{ maximized?(any_handle) }}

      it 'returns true if the window is maximized, false otherwise' do
        test_app do |app|
          zoomed?(app.handle).should == false
          maximized?(app.handle).should == false
          show_window(app.handle, SW_MAXIMIZE)
          maximized?(app.handle).should == true
          zoomed?(app.handle).should == true
        end
      end
    end

    describe '#minimized?' do
      spec{ use{ IsIconic(any_handle) }}
      spec{ use{ is_iconic(any_handle) }}
      spec{ use{ iconic?(any_handle) }}
      spec{ use{ minimized?(any_handle) }}

      it 'returns true if the window is minimized, false otherwise' do
        test_app do |app|
          iconic?(app.handle).should == false
          minimized?(app.handle).should == false
          show_window(app.handle, SW_MINIMIZE)
          iconic?(app.handle).should == true
          minimized?(app.handle).should == true
        end
      end
    end

    describe '#child?' do
      spec{ use{ IsChild(parent_handle = any_handle, handle = any_handle) }}
      spec{ use{ is_child(parent_handle = any_handle, handle = any_handle) }}
      spec{ use{ child?(parent_handle = any_handle, handle = any_handle) }}

      it 'returns true if the window is a child of given parent, false otherwise' do
        test_app do |app|
          child?(app.handle, app.textarea.handle).should == true
          child?(app.handle, any_handle).should == false
        end
      end
    end

    describe '#find_window(w)' do
      spec{ use{ FindWindow(class_name = nil, win_name = nil) }}
      spec{ use{ find_window(class_name = nil, win_name = nil) }}
      # Widebyte (unicode) version
      spec{ use{ FindWindowW(class_name = nil, win_name = nil) }}
      spec{ use{ find_window_w(class_name = nil, win_name = nil) }}

      it 'returns either Integer Window handle or nil' do
        find_window(nil, nil).should be_a_kind_of Integer
        find_window(TEST_IMPOSSIBLE, nil).should == nil
      end

      it 'returns nil if Window is not found' do
        find_window(TEST_IMPOSSIBLE, nil).should == nil
        find_window(nil, TEST_IMPOSSIBLE).should == nil
        find_window(TEST_IMPOSSIBLE, TEST_IMPOSSIBLE).should == nil
        find_window_w(TEST_IMPOSSIBLE, nil).should == nil
        find_window_w(nil, TEST_IMPOSSIBLE).should == nil
        find_window_w(TEST_IMPOSSIBLE, TEST_IMPOSSIBLE).should == nil
      end

      it 'finds at least one window if both args are nils' do
        find_window(nil, nil).should_not == nil
        find_window_w(nil, nil).should_not == nil
      end

      it 'finds top-level window by window class or title' do
        test_app do |app|
          find_window(TEST_WIN_CLASS, nil).should == app.handle
          find_window(nil, TEST_WIN_TITLE).should == app.handle
          find_window_w(TEST_WIN_CLASS.to_w, nil).should == app.handle
          find_window_w(nil, TEST_WIN_TITLE.to_w).should == app.handle
        end
      end
    end

    describe '#find_window_ex' do
      spec{ use{ FindWindowEx(parent = any_handle, after_child = 0, win_class = nil, win_title = nil) }}
      spec{ use{ find_window_ex(parent = any_handle, after_child = 0, win_class = nil, win_title = nil) }}

      it 'returns nil if wrong control is given' do
        parent_handle = any_handle
        find_window_ex(parent_handle, 0, TEST_IMPOSSIBLE, nil).should == nil
        find_window_ex(parent_handle, 0, nil, TEST_IMPOSSIBLE).should == nil
      end

      it 'finds child window/control by class' do
        test_app do |app|
          ta_handle = find_window_ex(app.handle, 0, TEST_TEXTAREA_CLASS, nil)
          ta_handle.should_not == nil
          ta_handle.should == app.textarea.handle
        end
      end

      it 'finds child window/control by text/title' do
        pending 'Identify appropriate (short name) control'
        test_app do |app|
          keystroke(VK_CONTROL, 'A'.ord)
          keystroke('1'.ord, '2'.ord)
          ta_handle = find_window_ex(app.handle, 0, nil, '12')
          ta_handle.should_not == 0
          ta_handle.should == app.textarea.handle
        end
      end
    end

    describe '#get_foreground_window' do
      # ! Different from GetActiveWindow !
      spec{ use{ handle = GetForegroundWindow() }}
      spec{ use{ handle = get_foreground_window }}
      spec{ use{ handle = foreground_window }}

      it 'returns handle to window that is currently in foreground' do
        test_app do |app|
          @app_handle = app.handle
          fg1 = foreground_window
          @app_handle.should == fg1
        end
        fg2 = foreground_window
        @app_handle.should_not == fg2
      end

      it 'defines #foreground? test function ' do
        test_app do |app|
          @app_handle = app.handle
          foreground?(@app_handle).should == true
        end
        foreground?(@app_handle).should == false
      end
    end

    describe '#get_active_window' do
      # ! Different from GetForegroundWindow !
      spec{ use{ handle = GetActiveWindow() }}
      spec{ use{ handle = get_active_window }}
      spec{ use{ handle = active_window }}

      it 'returns handle to the active window attached to the calling thread`s message queue' do
        pending 'No idea how to test it'
        test_app do |app|
          @app_handle = app.handle
          fg1 = active_window
          @app_handle.should == fg1
        end
        fg2 = active_window
        @app_handle.should_not == fg2
      end
    end

    describe '#get_window_text(w)' do
      spec{ use{ GetWindowText(any_handle, buffer = "\00"* 1024, buffer.size)}}
      # Improved with block to accept window handle as a single arg and return (rstripped) text string
      spec{ use{ text = get_window_text(handle = 0)}}
      spec{ use{ text = window_text(handle = 0)}}
      # Unicode version of get_window_text (strings returned encoded as utf-8)
      spec{ use{ GetWindowTextW(any_handle, buffer = "\00"* 1024, buffer.size)}}
      spec{ use{ text = get_window_text_w(any_handle)}} # result encoded as utf-8
      spec{ use{ text = window_text_w(handle = 0)}}

      it 'returns nil if incorrect window handle given' do
        get_window_text(not_a_handle).should == nil
        get_window_text_w(not_a_handle).should == nil
      end

      it 'returns correct window text' do
        test_app do |app|
          get_window_text(app.handle).should == TEST_WIN_TITLE
          get_window_text_w(app.handle).should == TEST_WIN_TITLE
          window_text(app.handle).should == TEST_WIN_TITLE
          window_text_w(app.handle).should == TEST_WIN_TITLE
        end
      end
    end

    describe '#get_class_name(w)' do
      spec{ use{ GetClassName(any_handle, buffer = "\00"* 1024, buffer.size)}}
      # Improved with block to accept window handle as a single arg and return class name string
      spec{ use{ class_name = get_class_name(any_handle)}}
      spec{ use{ class_name = class_name(any_handle)}}
      # Unicode version of get_class_name (strings returned encoded as utf-8)
      spec{ use{ GetClassNameW(any_handle, buffer = "\00"* 1024, buffer.size)}}
      spec{ use{ class_name = get_class_name_w(handle = 0)}} # result encoded as utf-8
      spec{ use{ class_name = class_name_w(any_handle)}}

      it 'returns correct window class name' do
        test_app do |app|
          get_class_name(app.handle).should == TEST_WIN_CLASS
          get_class_name_w(app.handle).should == TEST_WIN_CLASS
          class_name(app.handle).should == TEST_WIN_CLASS
          class_name_w(app.handle).should == TEST_WIN_CLASS
        end
      end
    end

    describe '#get_window_thread_process_id' do
      spec{ use{ thread = GetWindowThreadProcessId(any_handle, process_buffer = [1].pack('L')) }}
      spec{ use{ thread, process = get_window_thread_process_id(any_handle) }}
      # Improved with block to accept window handle as a single arg and return a pair of [thread, process]

      it 'returns a pair of nonzero Integer ids (thread and process) for valid window' do
        thread, process = get_window_thread_process_id(any_handle)
        thread.should be_a_kind_of Integer
        thread.should be > 0
        process.should be_a_kind_of Integer
        process.should be > 0
      end

      it 'returns a pair of nils (thread and process) for invalid window' do
        thread, process = get_window_thread_process_id(not_a_handle)
        thread.should == nil
        process.should == nil
      end
    end

    describe '#get_window_rect' do
      spec{ use{ success = GetWindowRect(any_handle, rectangle = [0, 0, 0, 0].pack('L*'))}}
      spec{ use{ left, top, right, bottom = get_window_rect(any_handle)}}

      it 'returns array of nils for invalid window' do
        get_window_rect(not_a_handle).should == [nil, nil, nil, nil]
      end

      it 'returns window`s border rectangle' do
        test_app do |app|
          get_window_rect(app.handle).should == TEST_WIN_RECT
        end
      end
    end

    describe '#show_window ', 'LI', 'I' do
      spec{ use{ was_visible = show_window(handle = any_handle, cmd = SW_SHOWNA) }}

      it 'was_visible = hide_window(handle = any_handle)  # derived method (not a separate API function)' do
        test_app do |app|
          use{ @was_visible = hide_window(app.handle) }
          @was_visible.should == true
          visible?(app.handle).should == false
          hide_window(app.handle).should == false
          visible?(app.handle).should == false
        end
      end

      it 'returns true if the window was PREVIOUSLY visible, false otherwise' do
        test_app do |app|
          show_window(app.handle, SW_HIDE).should == true
          show_window(app.handle, SW_HIDE).should == false
        end
      end

      it 'hides window with SW_HIDE command ' do
        test_app do |app|
          show_window(app.handle, SW_HIDE)
          visible?(app.handle).should == false
        end
      end

      it 'shows hidden window with SW_SHOW command' do
        test_app do |app|
          hide_window(app.handle)
          show_window(app.handle, SW_SHOW)
          visible?(app.handle).should == true
        end
      end

      it 'SW_MAXIMIZE, SW_SHOWMAXIMIZED maximize window and activate it' do
        commands_should_show_window SW_MAXIMIZE, SW_SHOWMAXIMIZED,
                                    :minimized? => false, :maximized? => true, :visible? => true, :foreground? => true
      end

      it 'SW_MINIMIZE minimizes window and activates the next top-level window in the Z order' do
        commands_should_show_window SW_MINIMIZE,
                                    :minimized? => true, :maximized? => false, :visible? => true, :foreground? => false
      end

      it 'SW_SHOWMINNOACTIVE, SW_SHOWMINIMIZED displays the window as a minimized foreground window' do
        commands_should_show_window SW_SHOWMINNOACTIVE, SW_SHOWMINIMIZED,
                                    :minimized? => true, :maximized? => false, :visible? => true, :foreground? => true
      end

      it 'SW_SHOWNORMAL, SW_RESTORE, SW_SHOWNOACTIVATE activate/display a window(if min/maximized it is restored' do
        commands_should_show_window SW_SHOWNORMAL, SW_RESTORE, SW_SHOWNOACTIVATE,
                                    :minimized? => false, :maximized? => false, :visible? => true, :foreground? => true
      end

      it 'SW_SHOWNA displays the window in its current size and position (similar to SW_SHOW, but window is not activated)'
      it 'SW_SHOWDEFAULT sets the show state based on the SW_ value specified in the STARTUPINFO structure passed to the CreateProcess function by the program that started the application'
      it 'SW_FORCEMINIMIZE minimizes a window, even if the thread that owns the window is not responding - only Win2000/XP'
    end

    describe '#keydb_event' do
      spec{ use{ keybd_event(vkey = 0, bscan = 0, flags = 0, extra_info = 0) }}
      # vkey (I) - Specifies a virtual-key code. The code must be a value in the range 1 to 254. For a complete list, see msdn:Virtual Key Codes.
      # bscan (I) - Specifies a hardware scan code for the key.
      # flags (L) - Specifies various aspects of function operation. This parameter can be one or more of the following values.
      #   KEYEVENTF_EXTENDEDKEY - If specified, the scan code was preceded by a prefix byte having the value 0xE0 (224).
      #   KEYEVENTF_KEYUP - If specified, the key is being released. If not specified, the key is being depressed.
      # extra_info (L) - Specifies an additional value associated with the key stroke.
      # no return value

      it 'synthesizes a numeric keystrokes, emulating keyboard driver' do
        test_app do |app|
          text = '123 456'
          text.upcase.each_byte do |b| # upcase needed since user32 keybd_event expects upper case chars
            keybd_event(b.ord, 0, KEYEVENTF_KEYDOWN, 0)
            sleep TEST_KEY_DELAY
            keybd_event(b.ord, 0, KEYEVENTF_KEYUP, 0)
            sleep TEST_KEY_DELAY
          end
          app.textarea.text.should =~ Regexp.new(text)
          7.times {keystroke(VK_CONTROL, 'Z'.ord)} # dirty hack!
        end
      end

      it 'synthesizes a letter keystroke, emulating keyboard driver'
    end

    describe '#post_message' do
      spec{ use{ success = post_message(handle = 0, msg = 0, w_param = 0, l_param = 0) }}
      # handle (L) - Handle to the window whose window procedure will receive the message.
      #   If this parameter is HWND_BROADCAST, the message is sent to all top-level windows in the system, including disabled or
      #   invisible unowned windows, overlapped windows, and pop-up windows; but the message is not sent to child windows.
      # msg (L) - Specifies the message to be posted.
      # w_param (L) - Specifies additional message-specific information.
      # l_param (L) - Specifies additional message-specific information.
      # returns (L) - Nonzero if success, zero if function failed. To get extended error information, call GetLastError.

      it 'places (posts) a message in the message queue associated with the thread that created the specified window'
      it 'returns without waiting for the thread to process the message'
    end

    describe '#send_message' do
      spec{ use{ success = send_message(handle = 0, msg = 0, w_param = 1024, l_param = "\x0"*1024) }}
      # handle (L) - Handle to the window whose window procedure is to receive the message. The following values have special meanings.
      #   HWND_BROADCAST - The message is posted to all top-level windows in the system, including disabled or invisible unowned windows,
      #     overlapped windows, and pop-up windows. The message is not posted to child windows.
      #   NULL - The function behaves like a call to PostThreadMessage with the dwThreadId parameter set to the identifier of the current thread.
      # msg (L) - Specifies the message to be posted.
      # w_param (L) - Specifies additional message-specific information.
      # l_param (L) - Specifies additional message-specific information.
      # return (L) - Nonzero if success, zero if function failed. To get extended error information, call GetLastError.

      it 'sends the specified message to a window or windows'
      it 'calls the window procedure and does not return until the window procedure has processed the message'
    end

    describe '#get_dlg_item' do
      spec{ use{ control_handle = get_dlg_item(handle = 0, item_id = 1) }}
      # handle (L) - Handle of the dialog box that contains the control.
      # item_id (I) - Specifies the identifier of the control to be retrieved.
      # Returns (L) - handle of the specified control if success or nil for invalid dialog box handle or a nonexistent control.
      #   To get extended error information, call GetLastError.
      #   You can use the GetDlgItem function with any parent-child window pair, not just with dialog boxes. As long as the handle
      #   parameter specifies a parent window and the child window has a unique id (as specified by the hMenu parameter in the
      #   CreateWindow or CreateWindowEx function that created the child window), GetDlgItem returns a valid handle to the child window.

      it 'returns handle to correctly specified control'
    end

    describe '#enum_windows' do
      before(:all){@app = launch_test_app}
      after(:all){close_test_app}

      spec{ use{ handles = enum_windows(value = 13)   }}
      spec{ use{ enum_windows do |handle, message|
      end  }}

      it 'iterates through all the top-level windows, passing each top level window handle and value to a given block' do
        enum_windows(13) do |handle, message|
          handle.should be_an Integer
          handle.should be > 0
          message.should == 13
        end
      end

      it 'returns an array of top-level window handles if block is not given' do
        enum = enum_windows(13)
        enum.should be_a_kind_of Array
        enum.should_not be_empty
        enum.should have_at_least(50).elements # typical number of top windows in WinXP system?
        enum.each do |handle|
          handle.should be_an Integer
          handle.should be > 0
        end
        enum.any?{|handle| handle == @app.handle}.should == true
      end

      it 'returned array that contains handle of launched test app' do
        enum = enum_windows(13)
        enum.any?{|handle| handle == @app.handle}.should == true
      end

      it 'defaults message to 0 if it is omitted from method call' do
        enum_windows do |handle, message|
          message.should == 0
        end
      end
    end

    describe '#enum_child_windows' do
      before(:all){@app = launch_test_app}
      after(:all){close_test_app}

      spec{ use{ enum_child_windows(parent = any_handle, value = 13) }}

      it 'return an array of child window handles if block is not given' do
        enum = enum_child_windows(@app.handle, 13)
        enum.should be_a_kind_of Array
        enum.should have(2).elements
        class_name(enum.first).should == TEST_STATUSBAR_CLASS
        class_name(enum.last).should == TEST_TEXTAREA_CLASS
      end

      it 'loops through all children of given window, passing each found window handle and a message to a given block' do
        enum = []
        enum_child_windows(@app.handle, 13) do |handle, message|
          enum << handle
          message.should == 13
        end
        enum.should have(2).elements
        class_name(enum.first).should == TEST_STATUSBAR_CLASS
        class_name(enum.last).should == TEST_TEXTAREA_CLASS
      end

      it 'breaks loop if given block returns false' do
        enum = []
        enum_child_windows(@app.handle) do |handle, message|
          enum << handle
          false
        end
        enum.should have(1).element
        class_name(enum.first).should == TEST_STATUSBAR_CLASS
      end

      it 'defaults message to 0 if it is omitted from method call' do
        enum_child_windows(@app.handle) do |handle, message|
          message.should == 0
        end
      end

    end

  end
end