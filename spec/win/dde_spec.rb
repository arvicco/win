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
      spec{ use{ status = DdeInitialize( zero_id, dde_callback, dde_cmd, unused = 0)}}
      spec{ use{ id, status = dde_initialize( instance_id = 0, dde_cmd) do|*args|
      end }}

      it 'with zero instance_id, returns integer id and DMLERR_NO_ERROR if initialization successful' do
        id, status = dde_initialize(0, APPCLASS_STANDARD) {|*args| }
        id.should be_an Integer
        id.should_not == 0
        status.should == DMLERR_NO_ERROR
      end

      it 'with nil instance_id, returns integer id and DMLERR_NO_ERROR if initialization successful' do
        id, status = dde_initialize(nil, APPCLASS_STANDARD) {|*args| }
        id.should be_an Integer
        id.should_not == 0
        status.should == DMLERR_NO_ERROR
      end

      it 'with omitted instance_id, returns integer id and DMLERR_NO_ERROR if initialization successful' do
        id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }
        id.should be_an Integer
        id.should_not == 0
        status.should == DMLERR_NO_ERROR
      end

      it 'returns error status if initialization unsuccessful' do
        id, status = dde_initialize(1, APPCLASS_STANDARD) {|*args| }
        status.should == DMLERR_INVALIDPARAMETER
        id.should == nil
      end

      it 'is able to reinitialize with correct id' do
        id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }
        new_id, status = dde_initialize(id, APPCLASS_STANDARD) {|*args| }
        status.should == DMLERR_NO_ERROR
        new_id.should == id
      end
    end

    context 'after initialization:' do
      before(:each) {@instance_id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }}
      after(:each) {dde_uninitialize(@instance_id)}

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
      end

      describe '#dde_create_string_handle' do
        spec{ use{ string_handle = DdeCreateStringHandle(instance_id=0, string='Any String', code_page_id=CP_WINANSI) }}
        spec{ use{ string_handle = dde_create_string_handle(instance_id=0, string='Any String', code_page_id=CP_WINANSI)}}

        it 'returns nonzero Integer handle to a string (passable to other DDEML functions)' do
          string_handle = dde_create_string_handle(@instance_id, 'My String', CP_WINANSI)
          string_handle.should be_an Integer
          string_handle.should_not == 0
        end

        it 'creates handle even if code_page is omitted' do
          string_handle = dde_create_string_handle(@instance_id, 'My String')
          string_handle.should be_an Integer
          string_handle.should_not == 0
        end

        it 'creating two handles for the SAME string (inside one instance) USUALLY returns same handle' do
          string_handle1 = dde_create_string_handle(@instance_id, 'My String')
          10.times do
            string_handle2 = dde_create_string_handle(@instance_id, 'My String')
            string_handle1.should == string_handle2
          end
        end

        it 'returns nil if unable to register handle to a string' do
          string_handle = dde_create_string_handle(@instance_id, "", CP_WINANSI)
          string_handle.should == nil
        end

      end

      context "with dde string handle to 'My String':" do
        before(:each) {@string_handle = dde_create_string_handle(@instance_id, 'My String', CP_WINANSI)}
        after(:each) {dde_free_string_handle(@instance_id, @string_handle)}

        describe '#dde_query_string' do

          spec{ use{ string = DdeQueryString(@instance_id, @string_handle, buffer, buffer.size, code_page=CP_WINANSI)}}
          spec{ use{ string = dde_query_string(@instance_id, @string_handle, code_page=CP_WINANSI )}}

          it 'retrieves string that given string handle refers to' do
            string = dde_query_string(@instance_id, @string_handle)
            string.should == 'My String'
          end

          it 'retrieves string even if code_page is omitted' do
            string = dde_query_string(@instance_id, @string_handle)
            string.should == 'My String'
          end

          it 'returns nil attempting to retrieve invalid handle' do
            string = dde_query_string(@instance_id, 12345)
            string.should == nil
          end
        end

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
        end

        describe '#dde_name_service' do
          spec{ use{ success = dde_name_service(@instance_id, @string_handle, cmd=DNS_UNREGISTER ) }}
          spec{ use{ success = DdeNameService(@instance_id, @string_handle, reserved=0, cmd=DNS_UNREGISTER) }}

          it 'registers or unregisters the service names that DDE server supports' do

            success = dde_name_service( @instance_id, @string_handle, DNS_REGISTER )
            success.should == true

            success = dde_name_service( @instance_id, @string_handle, DNS_UNREGISTER )
            success.should == true
          end
        end

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
        end

      end

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

      end

      describe '#dde_connect' do
        it 'connects to existing DDE server'
      end

    end
  end
end
