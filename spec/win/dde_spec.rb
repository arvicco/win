require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'win/dde'

module WinDDETest
  include WinTest
  include Win::DDE

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
    describe 'register_clipboard_format' do
      spec{ use{ RegisterClipboardFormat(format_name = "XlTable") }}
      spec{ use{ register_clipboard_format(format_name = "XlTable") }}

      it 'returns format id (int) if successfully registered format' do
        id = register_clipboard_format("XlTable")
        id.should_not == 0
        id.should_not == nil
      end

      it 'returns same format id for already registered format' do
        id1 = register_clipboard_format("XlTable")
        id2 = register_clipboard_format("XlTable")
        id1.should == id2
      end

      it 'returns nil if not able to register format' do
        register_clipboard_format("").should == nil
      end
    end

    describe 'dde_initialize' do
      after(:each) {dde_uninitialize(@instance_id) if @instance_id}

      spec{ use{ status = DdeInitialize( zero_id, dde_callback, dde_cmd, unused = 0)}}
      spec{ use{ id, status = dde_initialize( instance_id = 0, dde_cmd) do|*args|
      end }}

      it 'with zero instance_id, returns integer id and DMLERR_NO_ERROR if initialization successful' do
        @instance_id, status = dde_initialize(0, APPCLASS_STANDARD) {|*args| }
        @instance_id.should be_an Integer
        @instance_id.should_not == 0
        status.should == DMLERR_NO_ERROR
      end

      it 'with nil instance_id, returns integer id and DMLERR_NO_ERROR if initialization successful' do
        @instance_id, status = dde_initialize(nil, APPCLASS_STANDARD) {|*args| }
        @instance_id.should be_an Integer
        @instance_id.should_not == 0
        status.should == DMLERR_NO_ERROR
      end

      it 'with omitted instance_id, returns integer id and DMLERR_NO_ERROR if initialization successful' do
        @instance_id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }
        @instance_id.should be_an Integer
        @instance_id.should_not == 0
        status.should == DMLERR_NO_ERROR
      end

      it 'returns error status if initialization unsuccessful' do
        @instance_id, status = dde_initialize(12345, APPCLASS_STANDARD) {|*args| }
        status.should == DMLERR_INVALIDPARAMETER
        @instance_id.should == nil
      end

      it 'is able to reinitialize with correct id' do
        @instance_id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }
        new_id, status = dde_initialize(@instance_id, APPCLASS_STANDARD) {|*args| }
        status.should == DMLERR_NO_ERROR
        new_id.should == @instance_id
      end
    end

    context 'after initialization:' do
      before(:each) {@instance_id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }}
      after(:each) {dde_uninitialize(@instance_id) if @instance_id}

      describe '#dde_uninitialize' do

        spec{ use{ status = DdeUninitialize( @instance_id ) }}
        spec{ use{ id, status = dde_uninitialize( @instance_id) }}

        it 'returns true if uninitialization successful' do
          res = dde_uninitialize(@instance_id)
          res.should == true
        end

        it 'returns false if initialization unsuccessful' do
          res = dde_uninitialize(12345)
          res.should == false
        end
      end # describe '#dde_uninitialize'

      describe '#dde_create_string_handle' do
        after(:each) {dde_free_string_handle(@instance_id, @string_handle) if @string_handle}

        spec{ use{ @string_handle = DdeCreateStringHandle(instance_id=0, string_pointer, code_page_id=CP_WINANSI) }}
        spec{ use{ @string_handle = dde_create_string_handle(instance_id=0, string='Any String', code_page_id=CP_WINANSI)}}

        it 'returns nonzero Integer handle to a string (passable to other DDEML functions)' do
          @string_handle = dde_create_string_handle(@instance_id, 'My String', CP_WINANSI)
          @string_handle.should be_an Integer
          @string_handle.should_not == 0
        end

        it 'creates handle even if code_page is omitted' do
          @string_handle = dde_create_string_handle(@instance_id, 'My String')
          @string_handle.should be_an Integer
          @string_handle.should_not == 0
        end

        it 'creating two handles for the SAME string (inside one instance) USUALLY returns same handle' do
          @string_handle = dde_create_string_handle(@instance_id, 'My String')
          10.times do
            string_handle1 = dde_create_string_handle(@instance_id, 'My String')
            string_handle1.should == @string_handle
            dde_free_string_handle(@instance_id, string_handle1)
          end
        end

        it 'created different handles for two different strings ' do
          @string_handle = dde_create_string_handle(@instance_id, 'My String')
          string_handle1 = dde_create_string_handle(@instance_id, 'My String1')
          string_handle1.should_not == @string_handle
          dde_free_string_handle(@instance_id, string_handle1)
        end

        it 'returns nil if unable to register handle to a string' do
          @string_handle = dde_create_string_handle(@instance_id, "", CP_WINANSI)
          @string_handle.should == nil
        end
      end # describe '#dde_create_string_handle'

      context "with dde string handle to 'My String 2'" do
        before(:each) {@string_handle = dde_create_string_handle(@instance_id, 'My String 2', CP_WINANSI)}
        after(:each) {dde_free_string_handle(@instance_id, @string_handle)}

        describe '#dde_query_string' do

          spec{ use{ string = DdeQueryString(@instance_id, @string_handle, buffer, buffer.size, code_page=CP_WINANSI)}}
          spec{ use{ string = dde_query_string(@instance_id, @string_handle, code_page=CP_WINANSI )}}

          it 'retrieves string that given string handle refers to' do
            string = dde_query_string(@instance_id, @string_handle)
            string.should == 'My String 2'
          end

          it 'retrieves string even if code_page is omitted' do
            string = dde_query_string(@instance_id, @string_handle)
            string.should == 'My String 2'
          end

          it 'returns nil attempting to retrieve invalid handle' do
            string = dde_query_string(@instance_id, 12345)
            string.should == nil
          end
        end # describe '#dde_query_string'

        describe '#dde_free_string_handle' do

          spec{ use{ success = DdeFreeStringHandle( @instance_id, @string_handle)}}
          spec{ use{ success = dde_free_string_handle( @instance_id, @string_handle )}}

          it 'returns true when freeing string handle registered with DDEML' do
            res = dde_free_string_handle(@instance_id, @string_handle)
            res.should == true
          end

          it 'returns false attempting to free unregistered handle' do
            res = dde_free_string_handle(@instance_id, 12345)
            res.should == false
          end

          it 'keeps string accessible if there are more handles to it around' do
            string_handle_1 = dde_create_string_handle(@instance_id, 'My String 2', CP_WINANSI)

            dde_free_string_handle(@instance_id, @string_handle)

            dde_query_string(@instance_id, @string_handle).should == 'My String 2'
            dde_free_string_handle(@instance_id, string_handle_1)
          end

          it 'makes string inaccessible once its last handle is freed' do
            dde_free_string_handle(@instance_id, @string_handle)

            dde_query_string(@instance_id, @string_handle).should == nil
          end
        end # describe '#dde_free_string_handle'

        describe '#dde_name_service' do
          spec{ use{ success = dde_name_service(@instance_id, @string_handle, cmd=DNS_UNREGISTER ) }}
          spec{ use{ success = DdeNameService(@instance_id, @string_handle, reserved=0, cmd=DNS_UNREGISTER) }}

          it 'registers or unregisters the service names that DDE server supports' do
            success = dde_name_service( @instance_id, @string_handle, DNS_REGISTER )
            success.should == true

            success = dde_name_service( @instance_id, @string_handle, DNS_UNREGISTER )
            success.should == true
          end
        end # describe '#dde_name_service'

        describe '#dde_get_last_error' do
          spec{ use{ error_code = DdeGetLastError( @instance_id) }}
          spec{ use{ error_code = dde_get_last_error( @instance_id) }}

          it 'original API returns DMLERR_NO_ERROR if there is no last DDE error for given app instance' do
            DdeGetLastError( @instance_id).should == DMLERR_NO_ERROR
          end

          it 'snake_case API returns nil if there is no last DDE error for given app instance' do
            dde_get_last_error( @instance_id).should == nil
          end

          it 'returns error code of last DDE error for given app instance' do
            dde_name_service( @instance_id, 1234, DNS_REGISTER )
            dde_get_last_error( @instance_id).should == DMLERR_INVALIDPARAMETER
          end
        end # describe '#dde_get_last_error'

      end # context "with dde string handle to 'My String'"
    end # context 'after initialization:'

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
      
      describe '#dde_connect' do
        after(:each) { dde_disconnect(@conv_handle) if @conv_handle}
        spec{ use{ @conv_handle = DdeConnect( instance_id=0, service=0, topic=0, context=nil) }}
        spec{ use{ @conv_handle = dde_connect( instance_id=0, service=0, topic=0, context=nil) }}

        it 'connects to existing DDE server (self in this case)' do
          @conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)

          @server_calls.first[0].should == 'XTYP_CONNECT'
          @server_calls.first[3].should == 'topic 2'
          @server_calls.first[4].should == 'service 2'
          @server_calls[1][0].should == 'XTYP_CONNECT_CONFIRM'
          @server_calls[1][3].should == 'topic 2'
          @server_calls[1][4].should == 'service 2'
          dde_disconnect(@server_conv).should == true
          dde_disconnect(@conv_handle).should == true
          
          p @server_calls, @client_calls, @conv_handle, @server_conv
          p ERRORS[dde_get_last_error(@server_id)]
          p ERRORS[dde_get_last_error(@client_id)]
        end
        
        it 'connects to existing DDE server (NOT self)' do
          pending 'something is wrong when connecting to separate service instance, uninitialize fails'
          conv_handle = dde_connect( @client_id, @service_handle, @topic_handle, context=nil)
          puts conv_handle
          p @server_calls, @client_calls, @server_conv
          p dde_disconnect(@server_conv) #conv_handle)
#          p @server_calls, @client_calls
        end
      end # describe '#dde_connect'

      describe '#dde_disconnect' do
        spec{ use{ success = DdeDisconnect(conversation_handle=0) }}
        spec{ use{ success = dde_disconnect(conversation_handle=0) }}

        it 'fails to disconnect if not valid conversation handle given' do
          dde_disconnect(12345).should == false
        end

        it 'disconnects from existing DDE server' do
          pending 'XTYP_DISCONNECT is not received by server callback for some reason'
        end
      end # describe '#dde_disconnect'

      describe "#dde_client_transaction" do
        after(:each) do
          p @server_calls, @client_calls, @server_conv
          p ERRORS[dde_get_last_error(@server_id)]
          p ERRORS[dde_get_last_error(@client_id)]
        end

        spec{ use{ res = DdeClientTransaction(data=nil, size=0, conv=0, item=0, format=0, type=0, timeout=0, result=nil) }}
        spec{ use{ res = dde_client_transaction(data=nil, size=0, conv=0, item=0, format=0, type=0, timeout=0, result=nil) }}

        it "original api is used by CLIENT to begins a data transaction with server" do
#          pending 'weird error - wrong number of arguments (8 for 0)'
          p @conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
          str = FFI::MemoryPointer.from_string "Poke_string\n\x00\x00"
#          res = DdeClientTransaction(str, str.size, @conv_handle, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)
          begin
          res = DdeClientTransaction(str, str.size, @conv_handle, @topic_handle, 0, XTYP_EXECUTE, 1000, nil)
          p res
          rescue => e
            puts e.backtrace
            raise e
          end
        end

        it "snake_case api begins a data transaction between a client and a server. Only a Dynamic Data Exchange (DDE) client " do
          pending
          success = dde_client_transaction(p_data=0, cb_data=0, h_conv=0, hsz_item=0, w_fmt=0, w_type=0, dw_timeout=0, pdw_result=0)
        end
      end # describe dde_client_transaction

      describe '#dde_get_data' do
        spec{ use{ buffer, success = dde_get_data( data_handle = 123, max = 1073741823, offset = 0) }}
        spec{ use{ length = DdeGetData( data_handle = 123, nil, 0, 0) }} # returns dde data set length
        spec{ use{ length = DdeGetData( data_handle = 123, FFI::MemoryPointer.new(:char, 1024), max = 1024, offset = 0) }}

        it 'original API returns 0 if trying to address invalid dde data handle' do
          DdeGetData( data_handle = 123, nil, 0, 0).should == 0
        end

        it 'snake_case API returns nil if trying to address invalid dde data handle' do
          dde_get_data( data_handle = 123, 3741823, 0).should == nil
        end

        it 'original API returns 1 if connect successful' do
          pending
          DdeGetData( data_handle = 123, nil, 0, 0).should == 0
        end

        it 'snake_case API returns returns true if connect successful' do
          pending
          dde_get_data( data_handle = 123, 3741823, 0).should == nil
        end

      end # describe '#dde_get_data'

    end # context 'with synthetic DDE server'
  end
end