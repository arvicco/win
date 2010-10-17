require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/system/info'

module WinSystemInfoTest

  include WinTestApp
  include Win::System::Info

  describe Win::System::Info do
    describe "#get_computer_name" do
      spec{ use{ success = GetComputerName(buf = buffer, pointer.write_long(buf.size)) }}
      spec{ use{ name = get_computer_name() }}

      it "original api retrieves the NetBIOS name of the local computer " do
        name_ptr = FFI::MemoryPointer.from_string(" " * 128)
        size_ptr = FFI::MemoryPointer.new(:long).write_int(name_ptr.size)
        success = GetComputerName(name_ptr, size_ptr)
        success.should_not == 0
        name_ptr.read_string.should == `hostname`.strip.upcase
      end

      it "snake api retrieves the NetBIOS name of the local computer" do
        get_computer_name.strip.should == `hostname`.strip.upcase
      end
    end # describe get_computer_name

    describe "#get_user_name" do
      spec{ use{ success = GetUserName(buf = buffer, pointer.write_long(buf.size)) }}
      spec{ use{ username = get_user_name() }}

      it "original api to retrieve the user name in a specified format. Additional information " do
        username = ENV['USERNAME'].strip
        name_ptr = FFI::MemoryPointer.from_string(" " * 128)
        size_ptr = FFI::MemoryPointer.new(:long).write_int(name_ptr.size)
        success = GetUserName(name_ptr, size_ptr)
        success.should_not == 0
        name_ptr.read_string.strip.should == username
      end

      it "snake_case api to retrieve the user name in a specified format. Additional information " do
        username = ENV['USERNAME'].strip
        get_user_name.strip.should == username
      end
    end # describe get_user_name

  end
end