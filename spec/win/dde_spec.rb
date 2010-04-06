require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'win/dde'

module WinDdeTest
  include WinTest
  include Win::Dde
  include Win::Gui::Message

  POKE_STRING = "Poke_string"

  def dde_cmd
    APPCLASS_STANDARD
  end

  def dde_callback
    ->(*args){}
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
    [Win::Dde::TYPES[type], format, conv,
     dde_query_string(@client_id, hsz1),
     dde_query_string(@client_id, hsz2),
     data, data1, data2]
  end

  def setup_server(&server_block)
    @client_calls = []
    @server_calls = []
    @client_id, st = dde_initialize(APPCLASS_STANDARD) {|*args| @client_calls << extract_values(*args); DDE_FACK}
    @server_id, st = dde_initialize(APPCLASS_STANDARD,
                                    &server_block || proc {|*args| @server_calls << extract_values(*args); DDE_FACK} )
    @service_handle = dde_create_string_handle(@server_id, 'service 2', CP_WINANSI)
    @topic_handle = dde_create_string_handle(@server_id, 'topic 2', CP_WINANSI)
    dde_name_service(@server_id, @service_handle, DNS_REGISTER)
  end

  def teardown_server
    if @print
      p @server_calls, @client_calls
      p @server_conv
      p ERRORS[dde_get_last_error(@server_id)]
      p ERRORS[dde_get_last_error(@client_id)]
      @print = nil
    end
    dde_name_service(@server_id, @service_handle, DNS_UNREGISTER) if @server_id && @service_handle
    dde_free_string_handle(@server_id, @service_handle) if @server_id && @service_handle
    dde_free_string_handle(@server_id, @topic_handle) if @server_id && @topic_handle
    dde_uninitialize(@server_id) if @server_id
    dde_uninitialize(@client_id) if @client_id
    if @conv_handle
      dde_disconnect(@conv_handle)
      @conv_handle = nil
    end
    @data = nil
  end

  describe Win::Dde, ' contains a set of pre-defined Windows API functions' do

    describe '#register_clipboard_format' do
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

    describe '#dde_initialize' do
      after(:each) {dde_uninitialize(@id) if @id}

      spec{ use{ status = DdeInitialize( id = zero_id, dde_callback, dde_cmd, unused=0); @id = id.read_long}}
      spec{ use{ @id, status = dde_initialize(@id=0, dde_cmd, &dde_callback) }}

      it 'with zero instance_id, returns integer id and DMLERR_NO_ERROR if initialization successful' do
        @id, status = dde_initialize(0, APPCLASS_STANDARD) {|*args| }
        @id.should be_an Integer
        @id.should_not == 0
        status.should == DMLERR_NO_ERROR
      end

      it 'with nil instance_id, returns integer id and DMLERR_NO_ERROR if initialization successful' do
        @id, status = dde_initialize(nil, APPCLASS_STANDARD) {|*args| }
        @id.should be_an Integer
        @id.should_not == 0
        status.should == DMLERR_NO_ERROR
      end

      it 'with omitted instance_id, returns integer id and DMLERR_NO_ERROR if initialization successful' do
        @id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }
        @id.should be_an Integer
        @id.should_not == 0
        status.should == DMLERR_NO_ERROR
      end

      it 'returns error status if initialization unsuccessful' do
        @id, status = dde_initialize(12345, APPCLASS_STANDARD) {|*args| }
        status.should == DMLERR_INVALIDPARAMETER
        @id.should == nil
      end

      it 'is able to reinitialize with correct id' do
        @id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }
        new_id, status = dde_initialize(@id, APPCLASS_STANDARD) {|*args| }
        status.should == DMLERR_NO_ERROR
        new_id.should == @id
      end
    end # describe 'dde_initialize'

    context 'after initialization:' do
      before(:each) {@id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }}
      after(:each) {dde_uninitialize(@id) if @id}

      describe '#dde_uninitialize' do

        spec{ use{ status = DdeUninitialize( @id ) }}
        spec{ use{ id, status = dde_uninitialize( @id) }}

        it 'returns true if uninitialization successful' do
          res = dde_uninitialize(@id)
          res.should == true
        end

        it 'returns false if initialization unsuccessful' do
          res = dde_uninitialize(12345)
          res.should == false
        end
      end # describe '#dde_uninitialize'

      describe '#dde_create_string_handle' do
        after(:each) {dde_free_string_handle(@id, @string_handle) if @string_handle}

        spec{ use{ @string_handle = DdeCreateStringHandle(id=0, string_pointer, code_page_id=CP_WINANSI) }}
        spec{ use{ @string_handle = dde_create_string_handle(id=0, string='Any String', code_page_id=CP_WINANSI)}}

        it 'returns nonzero Integer handle to a string (passable to other DDEML functions)' do
          @string_handle = dde_create_string_handle(@id, 'My String', CP_WINANSI)
          @string_handle.should be_an Integer
          @string_handle.should_not == 0
        end

        it 'creates handle even if code_page is omitted' do
          @string_handle = dde_create_string_handle(@id, 'My String')
          @string_handle.should be_an Integer
          @string_handle.should_not == 0
        end

        it 'creating two handles for the SAME string (inside one instance) USUALLY returns same handle' do
          @string_handle = dde_create_string_handle(@id, 'My String')
          10.times do
            string_handle1 = dde_create_string_handle(@id, 'My String')
            string_handle1.should == @string_handle
            dde_free_string_handle(@id, string_handle1)
          end
        end

        it 'created different handles for two different strings ' do
          @string_handle = dde_create_string_handle(@id, 'My String')
          string_handle1 = dde_create_string_handle(@id, 'My String1')
          string_handle1.should_not == @string_handle
          dde_free_string_handle(@id, string_handle1)
        end

        it 'returns nil if unable to register handle to a string' do
          @string_handle = dde_create_string_handle(@id, "", CP_WINANSI)
          @string_handle.should == nil
        end
      end # describe '#dde_create_string_handle'

      context "with dde string handle to 'My String 2'" do
        before(:each) {@string_handle = dde_create_string_handle(@id, 'My String 2', CP_WINANSI)}
        after(:each) {dde_free_string_handle(@id, @string_handle)}

        describe '#dde_query_string' do

          spec{ use{ string = DdeQueryString(@id, @string_handle, buffer, buffer.size, code_page=CP_WINANSI)}}
          spec{ use{ string = dde_query_string(@id, @string_handle, code_page=CP_WINANSI )}}

          it 'retrieves string that given string handle refers to' do
            num_chars = DdeQueryString(@id, @string_handle, buf = buffer, buf.size, CP_WINANSI)
            num_chars.should == 11
            buf.read_string.should == 'My String 2'
          end

          it 'retrieves string that given string handle refers to' do
            string = dde_query_string(@id, @string_handle, CP_WINANSI)
            string.should == 'My String 2'
          end

          it 'retrieves string even if code_page is omitted' do
            string = dde_query_string(@id, @string_handle)
            string.should == 'My String 2'
          end

          it 'returns nil attempting to retrieve invalid handle' do
            string = dde_query_string(@id, 12345)
            string.should == nil
          end
        end # describe '#dde_query_string'

        describe '#dde_free_string_handle' do

          spec{ use{ success = DdeFreeStringHandle( @id, @string_handle)}}
          spec{ use{ success = dde_free_string_handle( @id, @string_handle )}}

          it 'returns true when freeing string handle registered with DDEML' do
            res = dde_free_string_handle(@id, @string_handle)
            res.should == true
          end

          it 'returns false attempting to free unregistered handle' do
            res = dde_free_string_handle(@id, 12345)
            res.should == false
          end

          it 'keeps string accessible while references to it still exist' do
            # creates second handle to 'My String 2'
            string_handle_1 = dde_create_string_handle(@id, 'My String 2', CP_WINANSI)

            dde_free_string_handle(@id, @string_handle)
            dde_query_string(@id, @string_handle).should == 'My String 2'

            dde_free_string_handle(@id, string_handle_1)
            dde_query_string(@id, @string_handle).should == nil
          end

          it 'makes string inaccessible once its last handle is freed' do
            dde_free_string_handle(@id, @string_handle)
            dde_query_string(@id, @string_handle).should == nil
          end
        end # describe '#dde_free_string_handle'

        describe '#dde_get_last_error' do
          spec{ use{ error_code = DdeGetLastError(@id) }}
          spec{ use{ error_code = dde_get_last_error(@id) }}

          it 'original API returns DMLERR_NO_ERROR if there is no last DDE error for given app instance' do
            DdeGetLastError(@id).should == DMLERR_NO_ERROR
          end

          it 'snake_case API returns nil if there is no last DDE error for given app instance' do
            dde_get_last_error(@id).should == nil
          end

          it 'returns error code of last DDE error for given app instance' do
            dde_name_service(@id, 1234, DNS_REGISTER )
            dde_get_last_error(@id).should == DMLERR_INVALIDPARAMETER
          end
        end # describe '#dde_get_last_error'

      end # context "with dde string handle to 'My String'"
    end # context 'after initialization:'

    context 'with synthetic DDE client/server' do
      before(:each){ setup_server }
      after(:each) { teardown_server}

      describe '#dde_name_service' do
        spec{ use{ success = dde_name_service(@server_id, @service_handle, cmd=DNS_UNREGISTER ) }}
        spec{ use{ success = DdeNameService(@server_id, @service_handle, reserved=0, cmd=DNS_UNREGISTER) }}

        it 'registers or unregisters the service names that DDE server supports' do
          pending 'Register/Unregister messages don`t show up in @server_calls :('
          success = dde_name_service(@server_id, @service_handle, DNS_REGISTER )
          success.should == true
          success = dde_name_service(@server_id, @service_handle, DNS_UNREGISTER )
          success.should == true
        end
      end # describe '#dde_name_service'

      describe '#dde_connect' do
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
        end

        it 'connects to existing DDE server (from @client, NOT self)' do
          pending 'something is wrong when connecting to separate service instance, uninitialize fails'
          @conv_handle = dde_connect( @client_id, @service_handle, @topic_handle, context=nil)
          puts @conv_handle
        end
      end # describe '#dde_connect'

      describe '#dde_disconnect' do
        spec{ use{ success = DdeDisconnect(conversation_handle=0) }}
        spec{ use{ success = dde_disconnect(conversation_handle=0) }}

        it 'fails to disconnect if not valid conversation handle given' do
          dde_disconnect(12345).should == false
        end

        it 'disconnects from existing (self) DDE server' do
          conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
          dde_disconnect(conv_handle).should == true
        end

        it 'disconnects from existing (self) DDE server' do
          pending 'XTYP_DISCONNECT is not received by server callback (since we are disconnecting from self?)'
          conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
          dde_disconnect(conv_handle).should == true
          @server_calls.last[0].should == "XTYP_DISCONNECT"
          p @server_calls, @client_calls, @server_conv
          p ERRORS[dde_get_last_error(@server_id)]
          p ERRORS[dde_get_last_error(@client_id)]
        end
      end # describe '#dde_disconnect'
    end # context 'with synthetic DDE server'

    describe "#dde_client_transaction" do
      before(:each) do
        setup_server do |*args|
          @server_calls << extract_values(*args)
          @data_out, size = dde_get_data(args[5]) if args.first == XTYP_POKE || args.first == XTYP_EXECUTE
          DDE_FACK
        end
        @conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
        @data_in = FFI::MemoryPointer.from_string POKE_STRING
      end
      after(:each) { teardown_server}

      spec{ use{ DdeClientTransaction(data=nil, size=0, conv=0, item=0, format=0, type=0, timeout=0, result=nil) }}
      spec{ use{ dde_client_transaction(data=nil, size=0, conv=0, item=0, format=0, type=0, timeout=0, result=nil) }}


      it "returns 0/nil if initiated transaction unsuccessful" do
        res = DdeClientTransaction(@data_in, @data_in.size, 1234, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)
        res.should == 0     # wrong conversation handle
        res = dde_client_transaction(@data_in, @data_in.size, 1234, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)
        res.should == nil   # wrong conversation handle
        res = dde_client_transaction(@data_in, @data_in.size, @conv_handle, 0, CF_TEXT, XTYP_POKE, 1000, nil)
        res.should == nil   # wrong item handle (cannot be NULL in XTYP_POKE transaction)
        @server_calls.any? {|call| call[0] == 'XTYP_POKE'}.should be_false
      end

      it "original api is used by CLIENT to begins a data transaction with server" do
        res = DdeClientTransaction(@data_in, @data_in.size, @conv_handle, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)
        res.should == 1
        @server_calls.any? {|call| call[0] == 'XTYP_POKE'}.should be_true
        @data_out.read_string.should == POKE_STRING.rstrip
      end

      it "snake_case api begins a data transaction between a client and a server" do
        res = dde_client_transaction(@data_in, @data_in.size, @conv_handle, 0, 0, XTYP_EXECUTE, 1000, nil)
        res.should be_true
        @server_calls.any? {|call| call[0] == 'XTYP_EXECUTE'}.should be_true
        @data_out.read_string.should == POKE_STRING.rstrip
      end
    end # describe dde_client_transaction

    describe '#dde_get_data' do
      after(:each) { teardown_server}

      spec{ use{ data_pointer, size = dde_get_data( data_handle = 123, max = 1073741823, offset = 0) }}
      spec{ use{ size = DdeGetData( data_handle = 123, nil, 0, 0) }} # returns dde data set size in bytes
      spec{ use{ size = DdeGetData( data_handle = 123, FFI::MemoryPointer.new(:char, 1024), max = 1024, offset = 0) }}

      it 'original API returns 0 if trying to address invalid dde data handle' do
        DdeGetData( data_handle = 123, nil, 0, 0).should == 0
      end

      it 'snake_case API returns [nil, 0] if trying to address invalid dde data handle' do
        data, size = dde_get_data( data_handle = 123, 3741823, 0)
        data.should == nil
      end

      it 'returns dde data if used inside dde callback block' do
        setup_server do |*args|
          @server_calls << extract_values(*args);
          if args[0] == XTYP_POKE
            data_handle = args[5]
            data, size = dde_get_data(data_handle)
            data.should be_an FFI::MemoryPointer
            data.read_string.should == POKE_STRING.rstrip
            size.should == 12
            DdeGetData(data_handle, nil, 0, 0).should == 12
            data = FFI::MemoryPointer.new(:char, 1024)
            DdeGetData(data_handle, data, data.size, 0).should == 12
            data.read_string.should == POKE_STRING.rstrip
          end
          DDE_FACK
        end
        @conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
        str = FFI::MemoryPointer.from_string POKE_STRING
        dde_client_transaction(str, str.size, @conv_handle, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)
      end

      it 'dde data handle expires once transaction is finished (DDE_FACK)' do
        setup_server do |*args|
          @server_calls << extract_values(*args);
          DDE_FACK
        end
        @conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
        str = FFI::MemoryPointer.from_string POKE_STRING
        dde_client_transaction(str, str.size, @conv_handle, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)

        # only inside callback block dde data handle is valid (while transaction still in progress)
        data, size = dde_get_data(@server_calls.last[5])
        data.should == nil
        size.should == 0
      end

    end # describe '#dde_get_data'

    describe "#dde_access_data" do
      after(:each) { teardown_server}

      spec{ use{ success = DdeAccessData(data_handle = 123, data_size=zero_id) }}
      spec{ use{ data_pointer, size = dde_access_data(data_handle = 123) }}

      it "provides access to the data in the specified DDE data handle (both inside and outside of callback)" do
        setup_server do |*args|
          @server_calls << extract_values(*args)
          if args[0] == XTYP_POKE
            data_handle = args[5]
            data, size = dde_access_data(data_handle)
            data.should be_kind_of FFI::Pointer
            data.read_string.should == POKE_STRING.rstrip
            size.should == 12
            buf = FFI::MemoryPointer.new(:int16)
            data = DdeAccessData(data_handle, buf)
            buf.get_int16(0).should == 12
            data.should be_kind_of FFI::Pointer
            data.read_string.should == POKE_STRING.rstrip
            dde_unaccess_data(data_handle)
          end
          DDE_FACK
        end
        @conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
        str = FFI::MemoryPointer.from_string POKE_STRING
        dde_client_transaction(str, str.size, @conv_handle, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)
      end

      it 'dde data handle expires once transaction is finished (DDE_FACK)' do
        setup_server do |*args|
          @server_calls << extract_values(*args);
          DDE_FACK
        end
        @conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
        str = FFI::MemoryPointer.from_string POKE_STRING
        dde_client_transaction(str, str.size, @conv_handle, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)

        # only inside callback block dde data handle is valid (while transaction still in progress)
        data, size = dde_access_data(@server_calls.last[5])
        data.should == nil
        size.should == 0
      end
    end # describe dde_access_data

    describe "#dde_unaccess_data" do
      spec{ use{ success = DdeUnaccessData(data_handle = 123) }}
      spec{ use{ success = dde_unaccess_data(data_handle = 123) }}

      it "returns 0/false if given invalid DDE data handle " do
        DdeUnaccessData(data_handle = 123).should == 0
        dde_unaccess_data(data_handle = 123).should == false
      end

      it "unaccesses a DDE data handle that was previously accessed" do
        setup_server do |*args|
          @server_calls << extract_values(*args);
          if args[0] == XTYP_POKE
            data_handle = args[5]
            dde_unaccess_data(data_handle).should == true

            data, size = dde_access_data(data_handle)
            data.should be_kind_of FFI::Pointer
            data.read_string.should == POKE_STRING.rstrip

            dde_unaccess_data(data_handle).should == true
          end
          DDE_FACK
        end
        @conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
        str = FFI::MemoryPointer.from_string POKE_STRING
        dde_client_transaction(str, str.size, @conv_handle, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)
      end

      it 'dde data handle expires once transaction is finished (DDE_FACK)' do
        setup_server do |*args|
          @server_calls << extract_values(*args);
          DDE_FACK
        end
        @conv_handle = dde_connect( @server_id, @service_handle, @topic_handle, context=nil)
        str = FFI::MemoryPointer.from_string POKE_STRING
        dde_client_transaction(str, str.size, @conv_handle, @topic_handle, CF_TEXT, XTYP_POKE, 1000, nil)

        # only inside callback block dde data handle is valid (while transaction still in progress)
        dde_unaccess_data(@server_calls.last[5]).should == false
      end

    end # describe dde_unaccess_data
  end
end