require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/window'
require 'win/window/extra'

module WinWindowTest
  include WinTest
  include Win::Window

  describe Win::Window, ' extra convenience/service methods' do
    describe '#keystroke' do
      spec{ use{ keystroke( vkey = 30, vkey = 30) }}
      # this service method emulates combinations of (any amount of) keys pressed one after another (Ctrl+Alt+P) and then released
      # vkey (int) - Specifies a virtual-key code. The code must be a value in the range 1 to 254. For a complete list, see msdn:Virtual Key Codes.

      it 'emulates combinations of keys pressed (Ctrl+Alt+P+M, etc)' do
        test_app do |app|
          keystroke(VK_CONTROL, 'A'.ord)
          keystroke(VK_SPACE)
          app.textarea.text.should == ' '
          2.times {keystroke(VK_CONTROL, 'Z'.ord)} # dirty hack!
        end
      end
    end

    describe '#type_in' do
      spec{ use{ type_in(message = '') }}
      # this service method types text message into window holding the focus

      it 'types text message into window holding the focus' do
        test_app do |app|
          text = '123 456'
          type_in(text)
          app.textarea.text.should =~ Regexp.new(text)
          7.times {keystroke(VK_CONTROL, 'Z'.ord)} # dirty hack!
        end
      end
    end

    describe 'dialog' do
      spec{ use{ dialog( title ='Dialog Title', timeout_sec = 0.001, &any_block)  }}
      # me od finds top-level dialog window by title and yields found dialog window to block if given

      it 'finds top-level dialog window by title' do
        pending 'Some problems (?with timeouts?) leave window open ~half of the runs'
        test_app do |app|
          keystroke(VK_ALT, 'F'.ord, 'A'.ord)
          @found = false
          dialog('Save As', 0.5) do |dialog_window|
            @found = true
            keystroke(VK_ESCAPE)
            dialog_window
          end
          @found.should == true
        end
      end
      it 'yields found dialog window to a given block'
    end

  end

  describe Win::Window::Window, ' wrapper class for window handle' do
    before(:each) { @app = launch_test_app }
    after(:each){ close_test_app }

    context 'creating' do
      it 'can be wrapped around any existing window' do
        any_handle = find_window(nil, nil)
        use{ Window.new any_handle }
      end

      it 'can be wrapped around specific window' do
        use{ Window.new @app.handle }
      end
    end

    context 'manipulating' do

      it 'has handle property equal to underlying window handle' do
        any_handle = find_window(nil, nil)
        any = Window.new any_handle
        any.handle.should == any_handle
      end

      it 'has text property equal to underlying window text(title)' do
        @app.text.should == TEST_WIN_TITLE
      end

      it 'closes when asked nicely' do
        @app.close
        sleep TEST_SLEEP_DELAY # needed to ensure window had enough time to close down
        find_window(nil, TEST_WIN_TITLE).should == nil #!!!!
      end

      it 'waits f0r window to disappear (NB: this happens before handle is released!)' do
        start = Time.now
        @app.close
        @app.wait_for_close
        (Time.now - start).should be <= Win::Window::CLOSE_TIMEOUT
        window_visible?(@app.handle).should be false
      end
    end

    context '.top_level class method' do
      it 'finds any top-level window (title = nil) and wraps it in a Window object' do
        use { @win = Window.top_level(title = nil, timeout_sec = 3) }
        Window.should === @win
      end

      it 'finds top-level window by title and wraps it in a Window object' do
        win = Window.top_level( TEST_WIN_TITLE, 1)
        win.handle.should == @app.handle
      end
    end

    context '#child' do
      spec { use { @control = @app.child(title_class_id = nil)  }}

      it 'finds any child window(control) if given nil' do
        @app.child(nil).should_not == nil
      end

      it 'finds child window(control) by class' do
        @app.child(TEST_TEXTAREA_CLASS).should_not == nil
      end

      it 'finds child window(control) by name' do
        pending 'Need to find control with short name'
        @app.child(TEST_TEXTAREA_TEXT).should_not == nil
      end

      it 'finds child window(control) by control ID' do
        pending 'Need to find some control ID'
        @app.child(TEST_TEXTAREA_ID).should_not == nil
      end

      it 'raises error if wrong control is given' do
        expect { @app.child('Impossible Control')}.to raise_error "Control 'Impossible Control' not found"
      end
      it 'substitutes & for _ when searching by title ("&Yes" type controls)'

    end

    context '#children' do
      spec { use { children = @app.children  }}

      it 'returns an array' do
        @app.children.should be_a_kind_of(Array)
      end

      it 'returns an array of all child windows to the given window ' do
        children = @app.children
        children.should be_a_kind_of Array
        children.should_not be_empty
        children.should have(2).elements
        children.each{|child| child?(@app.handle, child.handle).should == true }
        get_class_name(children.last.handle).should == TEST_TEXTAREA_CLASS
      end

#      it 'finds child window(control) by name' do
#        pending 'Need to find control with short name'
#        @app.child(TEST_TEXTAREA_TEXT).should_not == nil
#      end
#
#      it 'finds child window(control) by control ID' do
#        pending 'Need to find some control ID'
#        @app.child(TEST_TEXTAREA_ID).should_not == nil
#      end
#
#      it 'raises error if wrong control is given' do
#        expect { @app.child('Impossible Control')}.to raise_error "Control 'Impossible Control' not found"
#      end
#      it 'substitutes & for _ when searching by title ("&Yes" type controls)'

    end

    context '#click' do
      it 'emulates clicking of the control identified by id'
    end
  end

end
