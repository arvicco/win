require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'
#require 'win/gui/window'

module WinGUIMessageTest

  include WinTestApp
  include Win::GUI::Message
  include Win::GUI::Window
  include Win::GUI::Input

  def msg
    @msg ||=Win::GUI::Message::Msg.new
  end

  def should_have msg, members
    members.each do |member, value|
      case member
        when :l_param
          msg[member].address.should == value
        when :time
          msg[member].should be > value
        else
          msg[member].should == value
      end
    end
  end

  describe Win::GUI::Message, ' defines a set of API functions related to Window messaging'  do
    after(:each){close_test_app if @launched_test_app}

    describe '#post_message' do
      it 'places (posts) a message in the message queue associated with the thread that created the specified window' do
        app = launch_test_app
        post_message(app.handle, WM_SYSCOMMAND, SC_CLOSE, nil).should == true
        sleep TEST_SLEEP_DELAY
        window?(app.handle).should == false
      end

      it 'places (posts) a message into current thread`s queue if first arg is 0' do
        post_message(0, WM_USER, 33, nil).should == true
        msg = get_message()
        should_have msg, hwnd: 0, message: WM_USER, w_param: 33, l_param: 0
      end

      it 'returns without waiting for the thread to process the message'

      spec{ use{ success = PostMessage(handle = 0, msg = 0, w_param = 0, l_param = nil) }}
      spec{ use{ success = post_message(handle = 0, msg = 0, w_param = 0, l_param = nil) }}
    end # describe '#post_message'

    describe '#send_message' do
      spec{ use{ success = SendMessage(handle = 0, msg = 0, w_param = 1024, l_param = "\x0"*1024) }}
      spec{ use{ success = send_message(handle = 0, msg = 0, w_param = 1024, l_param = "\x0"*1024) }}

      it 'directly sends the specified message to a window or windows' do
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

    describe "#get_message" do
      # Get rid of 2 dummy messages already in message queue (posted by describe '#post_message'):
      spec{ use{ res = GetMessage(msg, handle=0, msg_filter_min=0, msg_filter_max=0) }}
      spec{ use{ message = get_message(msg, handle=0, msg_filter_min=0, msg_filter_max=0) }}

      it "original api retrieves a message from the calling thread's message queue" do
        set_cursor_pos(x=0, y=0)
        post_message(0, WM_USER+1, 33, nil)
        res = GetMessage(msg, handle=0, msg_filter_min=0, msg_filter_max=0)
        res.should == 1
        # p msg[:hwnd], msg[:message], msg[:w_param], msg[:l_param], msg[:time], msg[:x], msg[:y]
        should_have msg, hwnd: 0, message: WM_USER+1, w_param: 33, x: 0, y: 0, l_param: 0, time: 1000000
      end

      it "original api returns -1 if there is an error (wrong handle, in this case)" do
        res = GetMessage(msg, not_a_handle, msg_filter_min=0, msg_filter_max=0)
        res.should == -1
      end

      it "original api returns 0 if WM_QUIT was posted to thread`s message queue" do
        post_message(0, WM_QUIT, 13, nil)
        res = GetMessage(msg, 0, msg_filter_min=0, msg_filter_max=0)
        res.should == 0
      end

      it "snake_case api returns a message struct retrieved from the calling thread's message queue " do
        set_cursor_pos(x=99, y=99)
        post_message(0, WM_USER+2, 33, nil)
        msg = get_message()
        should_have msg, hwnd: 0, message: WM_USER+2, w_param: 33, x: 99, y: 99, l_param: 0, time: 1000000
      end

      it "snake_case api returns nil if there is an error (wrong handle, in this case)" do
        get_message(msg, not_a_handle).should == nil
      end

      it "snake_case api returns false if WM_QUIT was posted to thread`s message queue" do
        post_message(0, WM_QUIT, 13, nil)
        get_message.should == false
      end
    end # describe get_message


    describe "#peek_message" do
      before(:all){set_cursor_pos(x=0, y=0); post_message(0, WM_USER+2, 13, nil)}
      spec{ use{ success = PeekMessage(msg, h_wnd=0, filter_min=0, filter_max=0, remove_msg=0) }}
      spec{ use{ success = peek_message(msg, h_wnd=0, filter_min=0, filter_max=0, remove_msg=0) }}

      it "original api checks the thread message queue for a posted message, retrieves it without removing" do
        10.times do
          res = PeekMessage(msg, h_wnd=0, filter_min=0, filter_max=0, remove_msg=0)
          res.should == 1
          should_have msg, hwnd: 0, message: WM_USER+2, w_param: 13, x: 0, y: 0, l_param: 0, time: 1000000
        end
      end

      it "snake_case api checks the thread message queue for a posted message, returns it without removing" do
        10.times do
          msg = peek_message()
          should_have msg, hwnd: 0, message: WM_USER+2, w_param: 13, x: 0, y: 0, l_param: 0, time: 1000000
        end
      end

      it "original api returns 0 if no message in queue" do
        get_message
        PeekMessage(msg, h_wnd=0, filter_min=0, filter_max=0, remove_msg=0).should == 0
      end

      it "snake_case api returns nil if no message in queue" do
        peek_message.should == nil
      end
    end # describe peek_message

    describe "#translate_message" do
      spec{ use{ success = TranslateMessage(msg) }}
      spec{ use{ success = translate_message(msg) }}

      it "translates virtual-key message into character message which is then posted to the thread's message queue"

      it "returns zero/false if no translation took place" do
        TranslateMessage(msg).should == 0
        translate_message(msg).should == false
      end
    end # describe translate_message

    describe "#dispatch_message" do
      spec{ use{ res = DispatchMessage(msg) }} #return value is normally ignored
      spec{ use{ res = dispatch_message(msg) }} #return value is normally ignored

      it "dispatches a message to a window procedure. Typically used to dispatch a message retrieved by GetMessage" do
        pending
        res = DispatchMessage(msg)
      end

    end # describe dispatch_message

  end # Win::GUI::Message, ' defines a set of API functions related to Window messaging'
end


