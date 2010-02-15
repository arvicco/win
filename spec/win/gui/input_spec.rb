require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'
#require 'win/gui/window'

module WinWindowTest

  include WinTestApp
  include Win::Gui::Input

  describe Win::Gui::Input do

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
          app.textarea.text.should =~ Regexp.new(text)
          7.times {keystroke(VK_CONTROL, 'Z'.ord)} # dirty hack!
        end
      end
    end
    
    describe '#mouse_event' do
      it 'Emulates Mouse clicks'
    end

    describe '#set_cursor_pos' do
      it 'how to test set_cursor_pos?'
    end
  end
end

