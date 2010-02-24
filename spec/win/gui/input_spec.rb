require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'
#require 'win/gui/window'

module WinWindowTest

  include WinTestApp
  include Win::GUI::Input

  describe Win::GUI::Input do

    describe '#keydb_event' do
      spec{ use{ keybd_event(vkey = 0, bscan = 0, flags = 0, extra_info = 0) }}

      it 'synthesizes a numeric keystrokes, emulating keyboard driver' do
        test_app do |app|
          text = '123 456'
          text.upcase.each_byte do |b| # upcase needed since user32 keybd_event expects upper case chars
            keybd_event(b.ord, 0, KEYEVENTF_KEYDOWN, 0)
            sleep TEST_KEY_DELAY
            keybd_event(b.ord, 0, KEYEVENTF_KEYUP, 0)
            sleep TEST_KEY_DELAY
          end
          text(app.textarea).should =~ Regexp.new(text)
          7.times {keystroke(VK_CONTROL, 'Z'.ord)} # dirty hack!
        end
      end
    end
    
    describe '#mouse_event' do
      spec { use {mouse_event( flags = MOUSEEVENTF_ABSOLUTE , dx = 0, dy = 0, data=0, extra_info=0 )}}
      it 'Emulates Mouse clicks'
    end

    describe '#set_cursor_pos' do
      spec { use {success = set_cursor_pos(x=0, y=0)}}
      it 'how to test set_cursor_pos?'
    end
  end

  describe Win::GUI::Input, ' defines convenience/service methods on top of Windows API' do
    describe '#keystroke' do
      spec{ use{ keystroke( vkey = 30, vkey = 30) }}

      it 'emulates combinations of keys pressed (Ctrl+Alt+P+M, etc)' do
        test_app do |app|
          keystroke(VK_CONTROL, 'A'.ord)
          keystroke(VK_SPACE)
          text(app.textarea).should.should == ' '
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
          text(app.textarea).should =~ Regexp.new(text)
          5.times {keystroke(VK_CONTROL, 'Z'.ord)} # dirty hack!
        end
      end
    end
  end
end

