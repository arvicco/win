require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'
#require 'win/gui/window'

module WinWindowTest

  include WinTestApp
  include Win::Gui::Dialog

  describe Win::Gui::Dialog do

    describe '#get_dlg_item' do
      spec{ use{ control_handle = get_dlg_item(handle = 0, item_id = 1) }}

      it 'returns handle to correctly specified control'

      it 'does something else' do
        pending
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

    describe Win::Gui::Dialog, ' defines convenience/service methods on top of Windows API' do
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
  end
end

