require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/convenience'

module WinGuiTest
  include WinTestApp
  include Win::Gui::Window
  include Win::Gui::Input
  include Win::Gui::Convenience

  describe Win::Gui::Convenience, ' defines convenience/service methods on top of Windows API' do
    describe '#keystroke' do
      spec{ use{ keystroke( vkey = 30, vkey = 30) }}

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

      it 'types text message into the window holding the focus' do
        test_app do |app|
          text = '12 34'
          type_in(text)
          app.textarea.text.should =~ Regexp.new(text)
          5.times {keystroke(VK_CONTROL, 'Z'.ord)} # dirty hack!
        end
      end
    end

    describe 'dialog' do
      spec{ use{ dialog( title ='Dialog Title', timeout_sec = 0.001, &any_block)  }}

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

  describe Win::Gui::Convenience::WrapWindow, ' thin wrapper class around window handle' do
    before(:each) { @app = launch_test_app }
    after(:each){ close_test_app }

    context 'creating' do
      it 'can be wrapped around any existing window' do
        any_handle = find_window(nil, nil)
        use{ WrapWindow.new any_handle }
      end

      it 'can be wrapped around specific window' do
        use{ WrapWindow.new @app.handle }
      end
    end

    context 'manipulating' do

      it 'has handle property equal to underlying window handle' do
        any_handle = find_window(nil, nil)
        any = WrapWindow.new any_handle
        any.handle.should == any_handle
      end

      it 'has text property equal to underlying window text(title)' do
        @app.text.should == TEST_WIN_TITLE
      end

      it 'closes when asked nicely' do
        @app.close
        sleep TEST_SLEEP_DELAY # needed to ensure window had enough time to close down
        find_window(nil, TEST_WIN_TITLE).should == nil #!!!!!
      end

      it 'waits f0r window to disappear (NB: this happens before handle is released!)' do
        start = Time.now
        @app.close
        @app.wait_for_close
        (Time.now - start).should be <= Win::Gui::Convenience::CLOSE_TIMEOUT
        window_visible?(@app.handle).should be false
      end
    end

    context '.top_level class method' do
      it 'finds any top-level window (title = nil) and wraps it in a Window object' do
        use { @win = WrapWindow.top_level(title = nil, timeout_sec = 3) }
        @win.should be_a_kind_of WrapWindow
      end

      it 'finds top-level window by title and wraps it in a Window object' do
        win = WrapWindow.top_level( TEST_WIN_TITLE, 1)
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
