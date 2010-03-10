require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'win/dde'

module WinDDETest
  include WinTest
  include Win::DDE
  include Win::GUI::Message

  def dde_cmd
    APPCLASS_STANDARD
  end

  def dde_callback
    ->{}
  end

  def zero_id
    FFI::MemoryPointer.new(:long).write_long(0)
  end

  def buffer
    FFI::MemoryPointer.new(:char, 1024)
  end

  def string_pointer
    FFI::MemoryPointer.from_string("Pointer_string")
  end

  def extract_values(*args)
    type, format, conv, hsz1, hsz2, data, data1, data2 = *args
    @server_conv = conv
    [Win::DDE::TYPES[type], format, conv,
     dde_query_string(@client_id, hsz1),
     dde_query_string(@client_id, hsz2),
     data, data1, data2]
  end

  describe Win::DDE, ' contains a set of pre-defined Windows API functions' do

    context 'with synthetic DDE client/server' do
      before(:each) do
        @client_calls = []
        @server_calls = []
        @client_id, status = dde_initialize(APPCLASS_STANDARD) {|*args| @client_calls << extract_values(*args); 1}
        @server_id, status = dde_initialize(APPCLASS_STANDARD) {|*args| @server_calls << extract_values(*args); 1}
        @service_handle = dde_create_string_handle(@server_id, 'service 2', CP_WINANSI)
        @topic_handle = dde_create_string_handle(@client_id, 'topic 2', CP_WINANSI)
        dde_name_service(@server_id, @service_handle, DNS_REGISTER)
      end

      after(:each) do
#        p @server_calls, @client_calls, @server_conv
#        p ERRORS[dde_get_last_error(@server_id)]
#        p ERRORS[dde_get_last_error(@client_id)]

        dde_name_service(@server_id, @service_handle, DNS_UNREGISTER)
        dde_free_string_handle(@server_id, @service_handle)
        dde_free_string_handle(@client_id, @topic_handle)
        dde_uninitialize(@client_id)
        dde_uninitialize(@server_id)
      end

      describe "#dde_client_transaction" do
        after(:each) do
          p @server_calls, @client_calls, @server_conv
          p ERRORS[dde_get_last_error(@server_id)]
          p ERRORS[dde_get_last_error(@client_id)]
        end

        it "original api is used by CLIENT to begins a data transaction with server" do
#          pending 'weird error - wrong number of arguments (8 for 0)'
          $debugme = true
          p @conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
          str = FFI::MemoryPointer.from_string "Poke_string\n\x00\x00"
#          res = DdeClientTransaction(str, str.size, @conv_handle, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)
          begin
            get_message() if peek_message()
            res = dde_client_transaction(str, str.size, @conv_handle, @topic_handle, 0, XTYP_EXECUTE, 1000, nil)
            p res
            $debugme = false
          rescue => e
            puts e.backtrace, e.class, e
            $debugme = false
            raise e
          end
        end
      end
    end
  end
end

