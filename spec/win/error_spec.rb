require 'spec_helper'
require 'win/error'
require 'win/gui/window'

include WinTest
include Win::Error
include Win::Gui::Window

def buffer
  FFI::MemoryPointer.new(:char, 260)
end

def sys_flags
  FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_ARGUMENT_ARRAY
end

describe Win::Error, ' contains a set of pre-defined Windows API functions' do
  describe "#get_last_error" do
    spec { use { err_code = GetLastError() } }
    spec { use { err_message = get_last_error() } }

    it "original api retrieves the calling thread's last-error code value" do
      find_window(IMPOSSIBLE, IMPOSSIBLE)
      GetLastError().should == ERROR_FILE_NOT_FOUND
      window_text(0)
      GetLastError().should == ERROR_INVALID_WINDOW_HANDLE
    end

    it "enhanced api retrieves the message corresponding to last error code" do
      find_window(IMPOSSIBLE, IMPOSSIBLE)
      get_last_error.should == "The system cannot find the file specified."
      window_text(0)
      get_last_error.should == "Invalid window handle."
    end
  end # describe "#get_last_error"

  describe "#format_message" do
    spec { use { num_chars = FormatMessage(sys_flags, source=nil, message_id=0, language_id=0, buffer, buffer.size, :int, 0) } }
    spec { use { message = format_message(sys_flags, source=nil, message_id=0, language_id=0, :int, 0) } }

    it "original api formats a message string - system message" do
      find_window(IMPOSSIBLE, IMPOSSIBLE)
      message_id = GetLastError()
      buf        = buffer()
      num_chars  = FormatMessage(sys_flags, nil, message_id, dw_language_id=0, buf, buf.size, :int, 0)
      buf.get_bytes(0, num_chars).strip.should == "The system cannot find the file specified."
    end

    it "snake_case api Formats a message string - system message" do
      find_window(IMPOSSIBLE, IMPOSSIBLE)
      message = format_message(sys_flags, nil, dw_message_id=GetLastError())
      message.should == "The system cannot find the file specified."
    end
  end # describe format_message

  describe "#set_last_error" do
    spec { use { SetLastError(err_code=0) } }
    spec { use { set_last_error(err_code=0) } }

    it "original api sets the last-error code for the calling thread." do
      SetLastError(dw_err_code=0xF000)
      GetLastError().should == ERROR_USER_DEFINED_BASE
    end

    it "snake_case api also sets the last-error code for the calling thread." do
      set_last_error(3000)
      get_last_error.should == "The specified print monitor is unknown."
    end
  end # describe set_last_error

  if os_xp? || os_vista? # This function works only on XP++
    describe "#set_last_error_ex" do
      spec { use { SetLastErrorEx(dw_err_code=0, dw_type=0) } }
      spec { use { set_last_error_ex(dw_err_code=0, dw_type=0) } }

      it "original api sets the last-error code for the calling thread." do
        SetLastErrorEx(dw_err_code=0xF000, dw_type=0)
        GetLastError().should == ERROR_USER_DEFINED_BASE
      end

      it "snake_case api also sets the last-error code for the calling thread." do
        set_last_error_ex(3000, 0)
        get_last_error.should == "The specified print monitor is unknown."
      end
    end # describe set_last_error_ex
  end

  if os_vista? || os_7? # This function works only on Vista++
    describe "#get_error_mode" do
      spec { use { mode = GetErrorMode() } }
      spec { use { mode = get_error_mode() } }

      it "original api retrieves the error mode for the current process." do
        p mode = GetErrorMode()
      end

      it "snake_case api also retrieves the error mode for the current process." do
        p mode = get_error_mode()
      end
    end # describe get_error_mode
  end

  describe "#set_error_mode" do
    spec { use { success = SetErrorMode(u_mode=0) } }
    spec { use { success = set_error_mode(u_mode=0) } }

    it "controls whether the system OR process will handle the specified types of serious errors"
  end # describe set_error_mode

end # describe Win::Error
