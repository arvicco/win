require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'win/error'
require 'win/gui/window'

module WinErrorTest
  include WinTest
  include Win::Error
  include Win::GUI::Window

  def buffer
    FFI::MemoryPointer.new(:char, 1024)
  end

  describe Win::Error, ' contains a set of pre-defined Windows API functions' do
    describe "#get_last_error" do
      spec{ use{ err_code = GetLastError() }}
      spec{ use{ err_message = get_last_error() }}

      it "original api retrieves the calling thread's last-error code value" do
        find_window(TEST_IMPOSSIBLE, TEST_IMPOSSIBLE)
        GetLastError().should == ERROR_FILE_NOT_FOUND
        window_text(0)
        GetLastError().should == ERROR_INVALID_WINDOW_HANDLE
      end

      it "enhanced api retrieves the message corresponding to last error code" do
        find_window(TEST_IMPOSSIBLE, TEST_IMPOSSIBLE)
        get_last_error.should == "The system cannot find the file specified."
        window_text(0)
        get_last_error.should == "Invalid window handle."
      end

    end # describe "#get_last_error"

    describe "#format_message" do
      spec{ use{ num_chars = FormatMessage(dw_flags=0, lp_source=nil, dw_message_id=0, dw_language_id=0, buffer, buffer.size, :int, 0) }}
      spec{ use{ message = format_message(dw_flags=0, lp_source=nil, dw_message_id=0, dw_language_id=0, :int, 0) }}

      it "original api Formats a message string. The function requires a message definition as input. The message definition " do
        pending
        num_chars = FormatMessage(dw_flags=0, nil, dw_message_id=0, dw_language_id=0, buffer, buffer.size, :int, 0)
      end

      it "snake_case api Formats a message string. The function requires a message definition as input. The message definition " do
        pending
        message = format_message(dw_flags=0, nil, dw_message_id=0, dw_language_id=0, lp_buffer=0, n_size=0,:int, 0)
      end

    end # describe format_message


  end # describe Win::Error
end
