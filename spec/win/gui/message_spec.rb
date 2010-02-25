require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'
#require 'win/gui/window'

module WinGUIMessageTest

  include WinTestApp
  include Win::GUI::Message
  include Win::GUI::Window

  describe Win::GUI::Message, ' defines a set of API functions related to Window messaging'  do
    after(:each){close_test_app if @launched_test_app}

    describe '#post_message' do
      spec{ use{ success = PostMessage(handle = 0, msg = 0, w_param = 0, l_param = nil) }}
      spec{ use{ success = post_message(handle = 0, msg = 0, w_param = 0, l_param = nil) }}

      it 'places (posts) a message in the message queue associated with the thread that created the specified window' do
        app = launch_test_app
        post_message(app.handle, WM_SYSCOMMAND, SC_CLOSE, nil)
        sleep TEST_SLEEP_DELAY
        window?(app.handle).should == false
      end

      it 'returns without waiting for the thread to process the message'
    end # describe '#post_message'

    describe '#send_message' do
      spec{ use{ success = SendMessage(handle = 0, msg = 0, w_param = 1024, l_param = "\x0"*1024) }}
      spec{ use{ success = send_message(handle = 0, msg = 0, w_param = 1024, l_param = "\x0"*1024) }}

      it 'sends the specified message to a window or windows' do
        app = launch_test_app
        buffer = FFI::MemoryPointer.new :char, 1024
        num_chars = send_message app.handle, WM_GETTEXT, buffer.size, buffer
        buffer.get_bytes(0, num_chars).should == "LockNote - Steganos LockNote"

        num_chars = send_message app.textarea, WM_GETTEXT, buffer.size, buffer
        buffer.get_bytes(0, num_chars).should =~ /Welcome to Steganos LockNote/

        send_message(app.handle, WM_SYSCOMMAND, SC_CLOSE, nil)
        sleep TEST_SLEEP_DELAY
        window?(app.handle).should == false
      end
    end # describe '#send_message'
  end # Win::GUI::Message, ' defines a set of API functions related to Window messaging'
end


