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
      # Unicode version of get_window_text (strings returned encoded as utf-8)
      spec{ use{ GetWindowTextW(any_handle, buffer = "\00"* 1024, buffer.size)}}
      spec{ use{ text = get_window_text_w(any_handle)}} # result encoded as utf-8

      it 'returns nil if incorrect window handle given' do
        get_window_text(not_a_handle).should == nil
        get_window_text_w(not_a_handle).should == nil
      end

      it 'returns correct window text' do
        test_app do |app|
          get_window_text(app.handle).should == TEST_WIN_TITLE
          get_window_text_w(app.handle).should == TEST_WIN_TITLE
        end
      end
    end

    describe '#get_class_name(w)' do
      spec{ use{ GetClassName(any_handle, buffer = "\00"* 1024, buffer.size)}}
      # Improved with block to accept window handle as a single arg and return class name string
      spec{ use{ class_name = get_class_name(any_handle)}}
      # Unicode version of get_class_name (strings returned encoded as utf-8)
      spec{ use{ GetClassNameW(any_handle, buffer = "\00"* 1024, buffer.size)}}
      spec{ use{ class_name = get_class_name_w(handle = 0)}} # result encoded as utf-8

      it 'returns correct window class name' do
        test_app do |app|
          get_class_name(app.handle).should == TEST_WIN_CLASS
          get_class_name_w(app.handle).should == TEST_WIN_CLASS
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

  end
end