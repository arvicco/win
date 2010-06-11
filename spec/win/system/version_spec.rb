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
        minor = object[:dw_minor_version]
        build = object[:dw_build_number]
      when :version
        object.should be_an Array
        major = object[0]
        minor = object[1]
        build = object[2]
    end
    os_major, os_minor, os_build = os_version_numbers
    major.should == os_major
    minor.should == os_minor
    build.should == os_build
  end

  def os_version_numbers
    os_ver = os.match(/Version ([\d]{1,2})\.([\d]{1,2})\.([\d]{1,5})/  )
    os_ver.captures.map(&:to_i)
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

    describe "#ver_set_condition_mask" do
      spec{ use{ mask = VerSetConditionMask(dwl_condition_mask=0, dw_type_bit_mask=0, dw_condition_mask=0) }}
      spec{ use{ mask = ver_set_condition_mask(dwl_condition_mask=0, dw_type_bit_mask=0, dw_condition_mask=0) }}

      it "is used to build the dwlConditionMask parameter for the VerifyVersionInfo function" do
        mask1 = VerSetConditionMask(0, VER_MAJORVERSION, VER_EQUAL)
        mask2 = ver_set_condition_mask(0, VER_MAJORVERSION, VER_EQUAL)
        mask1.should be_an Integer
        mask1.should == mask2
      end
    end # describe ver_set_condition_mask

    describe "#verify_version_info" do
      before(:each) do
        # Preparing condition mask
        @mask_equal = ver_set_condition_mask(0, VER_MAJORVERSION, VER_EQUAL)
        @mask_equal = ver_set_condition_mask(@mask_equal, VER_MINORVERSION, VER_EQUAL)

        # Preparing expected version info
        @expected = OSVERSIONINFOEX.new
        @expected[:dw_os_version_info_size] = @expected.size
        @expected[:dw_major_version] = os_version_numbers[0]
        @expected[:dw_minor_version] = os_version_numbers[1]
      end

      spec{ use{ verified = VerifyVersionInfo(@expected.to_ptr, dw_type_mask=VER_MAJORVERSION, dwl_condition_mask=@mask_equal) }}
      spec{ use{ verified = verify_version_info(@expected.to_ptr, dw_type_mask=VER_MAJORVERSION, dwl_condition_mask=@mask_equal) }}

      it "checks if current OS features are in line with expected features " do
        VerifyVersionInfo(@expected.to_ptr, VER_MAJORVERSION | VER_MINORVERSION, @mask_equal).should == 1
        verify_version_info(@expected.to_ptr, VER_MAJORVERSION | VER_MINORVERSION, @mask_equal).should == true
      end
    end # describe verify_version_info
  end
end