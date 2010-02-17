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
      spec{ use{ status = DdeInitialize( id = [0].pack('L'), dde_callback, dde_cmd, unused = 0)}}
      spec{ use{ id, status = dde_initialize( id = 0, dde_cmd) do|*args|
      end }}

      it 'returns integer id and DMLERR_NO_ERROR if initialization successful' do
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

    describe '#dde_create_string_handle' do
      spec{ use{ string_handle = DdeCreateStringHandle(instance_id=0, string='Any String', code_page_id=CP_WINANSI) }}
      spec{ use{ string_handle = dde_create_string_handle(instance_id=0, string='Any String', code_page_id=CP_WINANSI)}}

      it 'returns nonzero Integer handle to a string (passable to other DDEML functions)' do
        id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }

        string_handle = dde_create_string_handle(id, 'My String', CP_WINANSI)
        string_handle.should be_an Integer
        string_handle.should_not == 0
      end

    end

    describe '#dde_name_service' do
      spec{ use{ success = dde_name_service( instance_id=0, string_handle=0, cmd=DNS_UNREGISTER ) }}
      spec{ use{ success = DdeNameService( instance_id=0, string_handle=0, reserved=0, cmd=DNS_UNREGISTER) }}

      it 'registers or unregisters the service names that DDE server supports' do
        id, status = dde_initialize(APPCLASS_STANDARD) {|*args| }
        name_handle = dde_create_string_handle(id, 'MyServer', CP_WINANSI)

        success = dde_name_service( id, name_handle, DNS_REGISTER )
        success.should == true

        success = dde_name_service( id, name_handle, DNS_UNREGISTER )
        success.should == true
      end

    end

  end
end
