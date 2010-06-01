require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/window'

module WinWindowTest

  include WinTestApp
  include Win::Gui::Window

  def window_should_be(handle, tests)
    tests.each{|test, result| send(test.to_sym, handle).should == result}
  end

  def commands_should_show_window( *cmds, tests)
    cmds.each do |cmd|
      test_app do |app|
        show_window(app.handle, cmd)
        window_should_be app.handle, tests

        hide_window(app.handle) # hiding window first
        show_window(app.handle, cmd)
        window_should_be app.handle, tests

        show_window(app.handle, SW_MAXIMIZE) # now maximizing window
        show_window(app.handle, cmd)
        window_should_be app.handle, tests

        show_window(app.handle, SW_MINIMIZE) # now minimizing window
        show_window(app.handle, cmd)
        window_should_be app.handle, tests
      end
    end
  end

  describe Win::Gui::Window, ' defines a set of API functions related to Window manipulation' do
    context 'ensuring test app closes' do
      after(:each){close_test_app if @launched_test_app}

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
            @ta_handle = app.textarea
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
            window_visible?(app.textarea).should == true
            hide_window(app.handle)
            visible?(app.handle).should == false
            window_visible?(app.handle).should == false
            window_visible?(app.textarea).should == false
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
            iconic?(app.handle).should == true # !
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
            child?(app.handle, app.textarea).should == true
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
          find_window(IMPOSSIBLE, nil).should == nil
        end

        it 'returns nil if Window is not found' do
          find_window(IMPOSSIBLE, nil).should == nil
          find_window(nil, IMPOSSIBLE).should == nil
          find_window(IMPOSSIBLE, IMPOSSIBLE).should == nil
          find_window_w(IMPOSSIBLE, nil).should == nil
          find_window_w(nil, IMPOSSIBLE).should == nil
          find_window_w(IMPOSSIBLE, IMPOSSIBLE).should == nil
        end

        it 'finds at least one window if both args are nils' do
          find_window(nil, nil).should_not == nil
          find_window_w(nil, nil).should_not == nil
        end

        it 'finds top-level window by window class or title' do
          test_app do |app|
            find_window(WIN_CLASS, nil).should == app.handle
            find_window(nil, WIN_TITLE).should == app.handle
            find_window_w(WIN_CLASS.to_w, nil).should == app.handle
            find_window_w(nil, WIN_TITLE.to_w).should == app.handle
          end
        end
      end

      describe '#find_window_ex' do
        spec{ use{ FindWindowEx(parent = any_handle, after_child = 0, win_class = nil, win_title = nil) }}
        spec{ use{ find_window_ex(parent = any_handle, after_child = 0, win_class = nil, win_title = nil) }}

        it 'returns nil if wrong control is given' do
          parent_handle = any_handle
          find_window_ex(parent_handle, 0, IMPOSSIBLE, nil).should == nil
          find_window_ex(parent_handle, 0, nil, IMPOSSIBLE).should == nil
        end

        it 'finds child window/control by class' do
          test_app do |app|
            ta_handle = find_window_ex(app.handle, 0, TEXTAREA_CLASS, nil)
            ta_handle.should_not == nil
            ta_handle.should == app.textarea
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

      describe "#set_foreground_window" do
        spec{ use{ success = SetForegroundWindow(handle=0) }}
        spec{ use{ success = set_foreground_window(handle=0) }}

        it "puts the thread that created the specified window into the foreground and activates the window" do
          test_app do |app|
            set_foreground_window(any_handle).should be_true
            foreground?(app.handle).should be_false
            success = set_foreground_window(app.handle)
            foreground?(app.handle).should be_true
          end
        end

        it "returns false/0 if operation failed" do
            set_foreground_window(not_a_handle).should == false
            SetForegroundWindow(not_a_handle).should == 0
        end
      end # describe set_foreground_window

      describe '#get_foreground_window' do
        # ! Different from GetActiveWindow !
        spec{ use{ handle = GetForegroundWindow() }}
        spec{ use{ handle = get_foreground_window }}
        spec{ use{ handle = foreground_window }}

        it 'returns handle to window that is currently in foreground' do
          test_app do |app|
            @app_handle = app.handle
            fg1 = get_foreground_window
            @app_handle.should == fg1
          end
          fg2 = get_foreground_window
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
        spec{ use{ GetWindowText(any_handle, buffer, buffer.size)}}
        # Improved with block to accept window handle as a single arg and return (rstripped) text string
        spec{ use{ text = get_window_text(handle = 0)}}
        spec{ use{ text = window_text(handle = 0)}}
        # Unicode version of get_window_text (strings returned encoded as utf-8)
        spec{ use{ GetWindowTextW(any_handle, buffer, buffer.size)}}
        spec{ use{ text = get_window_text_w(any_handle)}} # result encoded as utf-8
        spec{ use{ text = window_text_w(handle = 0)}}

        it 'returns nil if incorrect window handle given' do
          get_window_text(not_a_handle).should == nil
          get_window_text_w(not_a_handle).should == nil
        end

        it 'returns correct window text' do
          test_app do |app|
            get_window_text(app.handle).should == WIN_TITLE
            get_window_text_w(app.handle).should == WIN_TITLE
            window_text(app.handle).should == WIN_TITLE
            window_text_w(app.handle).should == WIN_TITLE
          end
        end
      end

      describe '#get_class_name(w)' do
        spec{ use{ GetClassName(any_handle, buffer, buffer.size)}}
        # Improved with block to accept window handle as a single arg and return class name string
        spec{ use{ class_name = get_class_name(any_handle)}}
        spec{ use{ class_name = class_name(any_handle)}}
        # Unicode version of get_class_name (strings returned encoded as utf-8)
        spec{ use{ GetClassNameW(any_handle, buffer, buffer.size)}}
        spec{ use{ class_name = get_class_name_w(handle = 0)}} # result encoded as utf-8
        spec{ use{ class_name = class_name_w(any_handle)}}

        it 'returns correct window class name' do
          test_app do |app|
            get_class_name(app.handle).should == WIN_CLASS
            class_name(app.handle).should == WIN_CLASS
            class_name_w(app.handle).should == WIN_CLASS  #!!!!!!!!!!! nil?
            get_class_name_w(app.handle).should == WIN_CLASS #!!!!!! nil?
          end
        end
      end

      describe '#get_window_thread_process_id' do
        spec{ use{ thread = GetWindowThreadProcessId(any_handle, process = FFI::MemoryPointer.new(:long).write_long(1)) }}
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
        spec{ use{ success = GetWindowRect(any_handle, rectangle = FFI::MemoryPointer.new(:long, 4))}}
        spec{ use{ left, top, right, bottom = get_window_rect(any_handle)}}

        it 'returns array of nils for invalid window' do
          get_window_rect(not_a_handle).should == [nil, nil, nil, nil]
        end

        it 'returns window`s border rectangle' do
          test_app do |app|
            get_window_rect(app.handle).should == WIN_RECT
          end
        end
      end

      describe '#show_window' do
        spec{ use{ was_visible = ShowWindow(handle = any_handle, cmd = SW_SHOW) }}
        spec{ use{ was_visible = show_window(handle = any_handle) }}

        it 'defaults to SW_SHOW if no command given' do
          test_app do |app|
            hide_window(app.handle)
            use{show_window(app.handle)}
            visible?(app.handle).should == true
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
          commands_should_show_window SW_SHOWMINNOACTIVE, SW_SHOWMINIMIZED, #!
                                      :minimized? => true, :maximized? => false, :visible? => true, :foreground? => true
        end

        it 'SW_SHOWNORMAL, SW_RESTORE, SW_SHOWNOACTIVATE activate/display a window(if min/maximized it is restored' do
          commands_should_show_window SW_SHOWNORMAL, SW_RESTORE, SW_SHOWNOACTIVATE,
                                      :minimized? => false, :maximized? => false, :visible? => true, :foreground? => true
        end

        # what about SW_SHOWNA, SW_SHOWDEFAULT, SW_FORCEMINIMIZE ?
      end

      describe '#close_window' do
        spec{ use{ success = CloseWindow(handle = any_handle) }}
        spec{ use{ success = close_window(handle = any_handle) }}

        it 'minimizes (but does not destroy!) the specified window' do
          test_app do |app|
            close_window(app.handle).should == true
            window_should_be app.handle,
                             :minimized? => true, :maximized? => false, :visible? => true, :foreground? => true
          end
        end
      end

      describe 'destroy_window' do
        spec{ use{ success = DestroyWindow(handle = 0) }}
        spec{ use{ success = destroy_window(handle = 0) }}

        it 'destroys window created by current thread'

        it 'cannot destroy window created by other thread' do
          test_app do |app|
            destroy_window(app.handle).should == false
            window?(app.handle).should == true
          end
        end
      end # describe 'destroy_window'


    end # context 'ensuring test app closes'

    context 'with single test app' do
      before(:all){@app = launch_test_app}
      after(:all){close_test_app}

      describe "#get_parent" do
        spec{ use{ parent = GetParent(any_handle) }}
        spec{ use{ parent = get_parent(any_handle) }}

        it "retrieves a handle to the specified window's parent or owner." do
          child = find_window_ex(@app.handle, 0, nil, nil)
          parent1 = GetParent(child)
          parent2 = get_parent(child)
          parent1.should == parent2
          parent1.should == @app.handle
        end

        it "returns 0/nil if the specified window has no parent or owner." do
          GetParent(@app.handle).should == 0
          get_parent(@app.handle).should == nil
        end
      end # describe get_parent

      describe "#get_ancestor" do
        spec{ use{ ancestor = GetAncestor(any_handle, ga_flags=0) }}
        spec{ use{ ancestor = get_ancestor(any_handle, ga_flags=0) }}

        context 'GA_PARENT - Retrieves parent window. Unlike GetParent function, this does NOT include the owner.' do
          it "retrieves a handle to the specified window's parent" do
            child = find_window_ex(@app.handle, 0, nil, nil)
            parent1 = GetAncestor(child, GA_PARENT)
            parent2 = get_ancestor(child, GA_PARENT)
            parent1.should == parent2
            parent1.should == @app.handle
          end

          it "returns desktop handle for top-level window" do
            parent = get_ancestor(@app.handle, GA_PARENT)
            class_name(parent).should == DESKTOP_CLASS
          end

          it "returns 0/nil if the specified window is a desktop (has REALLY no parent)" do
            desktop = get_ancestor(@app.handle, GA_PARENT)
            GetAncestor(desktop, GA_PARENT).should == 0
            get_ancestor(desktop, GA_PARENT).should == nil
          end
        end # context GA_PARENT

        #           GA_ROOT - Retrieves the root window by walking the chain of parent windows.
        #           GA_ROOTOWNER - Retrieves the owned root window by walking the chain of parent and owner windows
        #                          returned by GetParent.
        it "original api retrieves the handle to the ancestor of the specified window. " do
          pending
          success = GetAncestor(hwnd=0, ga_flags=0)
        end

        it "snake_case api retrieves the handle to the ancestor of the specified window. " do
          pending
          success = get_ancestor(hwnd=0, ga_flags=0)
        end

      end # describe get_ancestor

      describe "#get_window" do
        spec{ use{ handle = GetWindow(any_handle, command=0) }}
        spec{ use{ handle = get_window(any_handle, command=0) }}

        context "GW_CHILD retrieves a window handle to a first (top of the Z order) child of given window" do
          before(:all) do
            #        GW_CHILD - The retrieved handle identifies the child window at the top of the Z order, if the specified
            @child1 = GetWindow(@app.handle, GW_CHILD)
            @child2 = get_window(@app.handle, GW_CHILD)
          end

          it 'returns active window handle' do
            window?(@child1).should == true
          end
          it 'returns the same value for original and snake case API' do
            @child1.should == @child2
          end
          it 'returns first direct child of a given window' do
            @child1.should == find_window_ex(@app.handle, 0, nil, nil)
          end
          it 'returns nil/0 if no children for a given window' do
            GetWindow(@child1, GW_CHILD).should == 0
            get_window(@child1, GW_CHILD).should == nil
          end
        end # context GW_CHILD

        context "GW_OWNER - retrieves a handle to an owner of a given Window" do
          #        GW_OWNER - The retrieved handle identifies the specified window's owner window, if any. For more

          it 'returns owner (but NOT parent!) of a given window' do
            pending

            child = find_window_ex(@app.handle, 0, nil, nil)
            p owner1 = GetWindow(child, GW_OWNER)
            p owner2 = get_window(child, GW_OWNER)
            owner1.should == owner2
            owner1.should == @app.handle
          end

          it 'returns nil/0 if no owner for a given window' do
            GetWindow(@app.handle, GW_OWNER).should == 0
            get_window(@app.handle, GW_OWNER).should == nil
          end

        end

        it "GW_OWNER - retrieves a handle to a window that has the specified relationship to given Window" do
          pending
          #        GW_ENABLEDPOPUP - Windows 2000/XP: The retrieved handle identifies the enabled popup window owned by
          #        GW_HWNDFIRST - The retrieved handle identifies the window of the same type that is highest in Z order.
          #        GW_HWNDLAST -  The retrieved handle identifies the window of the same type that is lowest in the Z order.
          #        GW_HWNDNEXT -  The retrieved handle identifies the window below the specified window in the Z order.
          #        GW_HWNDPREV -  The retrieved handle identifies the window above the specified window in the Z order.
          #        GW_OWNER - The retrieved handle identifies the specified window's owner window, if any. For more
        end
      end # describe get_window

      describe '#enum_windows' do
#        before(:each){@app = launch_test_app}
#        after(:each){close_test_app}

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
#          p enum
          enum.should be_a_kind_of Array
          enum.should_not be_empty
          enum.should have_at_least(5).elements # typical number of top windows in WinXP system?
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

      describe '#enum_desktop_windows' do
        spec{ use{ handles = enum_desktop_windows(0, value = 13)   }}
        spec{ use{ enum_desktop_windows(0) {|handle, message|} }}

        it 'iterates through all the top-level windows for a given desktop'
      end

      describe '#enum_child_windows' do
        spec{ use{ enum_child_windows(parent = any_handle, value = 13) }}

        it 'return an array of child window handles if block is not given' do
          enum = enum_child_windows(@app.handle, 13)
          enum.should be_a_kind_of Array
          enum.should have(2).elements
          class_name(enum.first).should == STATUSBAR_CLASS
          class_name(enum.last).should == TEXTAREA_CLASS
        end

        it 'loops through all children of given window, passing each found window handle and a message to a given block' do
          enum = []
          enum_child_windows(@app.handle, 13) do |handle, message|
            enum << handle
            message.should == 13
          end
          enum.should have(2).elements
          class_name(enum.first).should == STATUSBAR_CLASS
          class_name(enum.last).should == TEXTAREA_CLASS
        end

        it 'breaks loop if given block returns false' do
          enum = []
          enum_child_windows(@app.handle) do |handle, message|
            enum << handle
            false
          end
          enum.should have(1).element
          class_name(enum.first).should == STATUSBAR_CLASS
        end

        it 'defaults message to 0 if it is omitted from method call' do
          enum_child_windows(@app.handle) do |handle, message|
            message.should == 0
          end
        end
      end

    end # context 'with single test app'
  end # Win::Gui::Window, ' defines a set user32 API functions related to Window manipulation'

  describe Win::Gui::Window, ' defines convenience/service methods on top of Windows API' do
    after(:each){close_test_app if @launched_test_app}

    describe '#foreground?' do
      spec{ use{ foreground?( any_handle) }}

      it 'tests if the given window is foreground' do
        foreground?(foreground_window).should == true
        foreground?(any_handle).should == false
      end
    end

    describe '#hide_window' do
      spec{ use{ was_visible = hide_window(any_handle) }}

      it 'hides window: same as show_window(handle, SW_HIDE)' do
        test_app do |app|
          was_visible = hide_window(app.handle)
          was_visible.should == true      #!
          visible?(app.handle).should == false
          hide_window(app.handle).should == false
          visible?(app.handle).should == false
        end
      end
    end

    describe '#shut_window' do
      spec{ use{ success = shut_window(handle=0) }}

      it 'destroys window in another thread by sending WM_SYSCOMMAND, SC_CLOSE message to it' do
        app = launch_test_app

        shut_window(app.handle).should == true
        sleep SLEEP_DELAY

        window?(app.handle).should == false
      end
    end

    describe '#text' do
      spec{ use{ text = text(any_handle, buffer_size=1024) }}

      it 'returns text associated with window by sending WM_GETTEXT message to it' do
        test_app do |app|

          text(app.handle).should == WIN_TITLE
          text(app.textarea).should =~ /Welcome to Steganos LockNote/
        end
      end
    end # describe '#text'
  end # Win::Gui::Window, ' defines convenience/service methods on top of Windows API'
end
