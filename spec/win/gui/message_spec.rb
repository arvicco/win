require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'
#require 'win/gui/window'

module WinGuiMessageTest

  include WinTestApp
  include Win::Gui::Message

  describe Win::Gui::Message do

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
  end
end


