require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/system/version'

module WinSystemInfoTest

  include WinTestApp
  include Win::System::Version

  def should_be_correct_os(type= :info, object)
    case type
      when :info
        object.should be_an OSVERSIONINFOEX
        major = object[:dw_major_version]
      when :version
        object.should be_an Array
        major = object.first
    end
    major.should == 5 if os_xp? || os_2000?
    major.should == 6 if os_vista? || os_7?
  end

  describe Win::System::Version do
    before(:each) do
      @ver_info = OSVERSIONINFOEX.new
      @ver_info[:dw_os_version_info_size] = @ver_info.size
    end

    describe "#get_version" do
      spec{ use{ success = GetVersion() }}
      spec{ use{ version = get_version() }}

      it "original api retrieves information about the current operating system (in a cryptic Integer)" do
        GetVersion().should be_an Integer
        GetVersion().should be > 0
      end

      it "snake_case api returns an Array [major, minor, build] of OS version numbers" do
        version = get_version()
        version.should be_an Array
        version.should have_exactly(3).numbers
        should_be_correct_os :version, version
      end
    end # describe get_version

    describe "#get_version_ex" do
      spec{ use{ success = GetVersionEx(@ver_info.to_ptr) }}
      spec{ use{ ver_info = get_version_ex() }}

      it "original api returns success code (0/1) and fills supplied OSVERSIONINFOEX struct" do
        GetVersionEx(@ver_info.to_ptr).should_not == 0
        should_be_correct_os :info, @ver_info
      end

      it "snake_case api returns fills given OSVERSIONINFOEX struct and returns it" do
        info = get_version_ex(@ver_info)
        info.should == @ver_info
        should_be_correct_os :info, info
      end

      it "snake_case api returns filled OSVERSIONINFOEX struct if no arg given" do
        info = get_version_ex()
        should_be_correct_os :info, info
      end
    end # describe get_version_ex

    describe "#verify_version_info" do
      spec{ pending; use{ success = VerifyVersionInfo(@ver_info.to_ptr, dw_type_mask=0, dwl_condition_mask=0) }}
      spec{ pending; use{ success = verify_version_info(@ver_info.to_ptr, dw_type_mask=0, dwl_condition_mask=0) }}

      it "original api ignores structure " do
        pending
        success = VerifyVersionInfo(lp_version_info=0, dw_type_mask=0, dwl_condition_mask=0)
      end

      it "snake_case api ignores structure " do
        pending
        success = verify_version_info(lp_version_info=0, dw_type_mask=0, dwl_condition_mask=0)
      end
    end # describe verify_version_info


  end
end