require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'
#require 'win/gui/window'

module WinWindowTest

  include WinTestApp
  include Win::Gui::Dialog

  describe Win::Gui::Dialog do

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

  end
end

