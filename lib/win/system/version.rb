require 'win/library'

module Win
  module System

    # Contains constants, Win32 API functions and convenience methods
    # related to operating system version.
    module Version
      extend Win::Library

      # Processor info constants (obsolete):

      PROCESSOR_INTEL_386     = 386
      PROCESSOR_INTEL_486     = 486
      PROCESSOR_INTEL_PENTIUM = 586
      PROCESSOR_INTEL_IA64    = 2200
      PROCESSOR_AMD_X8664     = 8664

      VER_SERVER_NT                      = 0x80000000
      VER_WORKSTATION_NT                 = 0x40000000

      # wSuiteMask mask constants:

      # Microsoft Small Business Server was once installed on the system, but may have been upgraded to
      # another version of Windows. Refer to the Remarks section for more information about this bit flag.
      VER_SUITE_SMALLBUSINESS            = 0x00000001
      # Windows Server 2008 Enterprise, Windows Server 2003, Enterprise Edition, or Windows 2000 Advanced
      # Server is installed. Refer to the Remarks section for more information about this bit flag.
      VER_SUITE_ENTERPRISE               = 0x00000002
      # Microsoft BackOffice components are installed.
      VER_SUITE_BACKOFFICE               = 0x00000004
      VER_SUITE_COMMUNICATIONS           = 0x00000008
      # Terminal Services is installed. This value is always set. If VER_SUITE_TERMINAL is set but
      # VER_SUITE_SINGLEUSERTS is not set, the system is running in application server mode.
      VER_SUITE_TERMINAL                 = 0x00000010
      # Microsoft Small Business Server is installed with the restrictive client license in force. Refer to
      # the Remarks section for more information about this bit flag.
      VER_SUITE_SMALLBUSINESS_RESTRICTED = 0x00000020
      # Windows XP Embedded is installed.
      VER_SUITE_EMBEDDEDNT               = 0x00000040
      # Windows Server 2008 Datacenter, Windows Server 2003, Datacenter Edition, or Windows 2000 Datacenter Server is installed.
      VER_SUITE_DATACENTER               = 0x00000080
      # Remote Desktop is supported, but only one interactive session is supported. This value is set unless
      # the system is running in application server mode.
      VER_SUITE_SINGLEUSERTS             = 0x00000100
      # Windows Vista Home Premium, Windows Vista Home Basic, or Windows XP Home Edition is installed.
      VER_SUITE_PERSONAL                 = 0x00000200
      # Windows Server 2003, Web Edition is installed.
      VER_SUITE_BLADE                    = 0x00000400
      VER_SUITE_EMBEDDED_RESTRICTED      = 0x00000800
      VER_SUITE_SECURITY_APPLIANCE       = 0x00001000
      # Windows Storage Server 2003 R2 or Windows Storage Server 2003is installed.
      VER_SUITE_STORAGE_SERVER           = 0x00002000
      # Windows Server 2003, Compute Cluster Edition is installed.
      VER_SUITE_COMPUTE_SERVER           = 0x00004000
      # Windows Home Server is installed.
      VER_SUITE_WH_SERVER                = 0x00008000

      # wProductType mask constants:

      # The operating system is Windows Vista, Windows XP Professional, Windows XP Home Edition, or Windows 2000 Pro
      VER_NT_WORKSTATION       = 0x0000001
      # The system is a domain controller and the operating system is Windows Server 2008, Windows Server
      # 2003, or Windows 2000 Server.
      VER_NT_DOMAIN_CONTROLLER = 0x0000002
      # The operating system is Windows Server 2008, Windows Server 2003, or Windows 2000 Server.
      # Note that a server that is also a domain controller is reported as VER_NT_DOMAIN_CONTROLLER, not VER_NT_SERVER.
      VER_NT_SERVER            = 0x0000003

      # Platform definitions:

      VER_PLATFORM_WIN32s        = 0
      VER_PLATFORM_WIN32_WINDOWS = 1
      VER_PLATFORM_WIN32_NT      = 2

      # *Version* info type masks (used by VerSetConditionMask and VerifyVersionInfo):
      VER_MINORVERSION     = 0x0000001
      VER_MAJORVERSION     = 0x0000002
      VER_BUILDNUMBER      = 0x0000004
      VER_PLATFORMID       = 0x0000008
      VER_SERVICEPACKMINOR = 0x0000010
      VER_SERVICEPACKMAJOR = 0x0000020
      VER_SUITENAME        = 0x0000040
      VER_PRODUCT_TYPE     = 0x0000080

      # *Condition* masks masks (used by VerSetConditionMask):
      # The current value must be equal to the specified value.
      VER_EQUAL         = 1
      # The current value must be greater than the specified value.
      VER_GREATER       = 2
      # The current value must be greater than or equal to the specified value.
      VER_GREATER_EQUAL = 3
      # The current value must be less than the specified value.
      VER_LESS          = 4
      # The current value must be less than or equal to the specified value.
      VER_LESS_EQUAL    = 5
      # All product suites specified in the wSuiteMask member must be present in the current system.
      VER_AND           = 6
      # At least one of the specified product suites must be present in the current system.
      VER_OR            = 7

      class << self
        # Macros defined in windef.h. TODO: put them into some kind of helper?

        def MAKEWORD(a, b)
          ((a & 0xff) | (b & 0xff)) << 8
        end

        def MAKELONG(a, b)
          ((a & 0xffff) | (b & 0xffff)) << 16
        end

        def LOWORD(l)
          l & 0xffff
        end

        def HIWORD(l)
          l >> 16
        end

        def LOBYTE(w)
          w & 0xff
        end

        def HIBYTE(w)
          w >> 8
        end
      end

      # OSVERSIONINFOEX Structure. Contains operating system version information. The information includes major and
      # minor version numbers, a build number, a platform identifier, and information about product suites and the
      # latest Service Pack installed on the system. This structure is used with the GetVersionEx and
      # VerifyVersionInfo functions.
      #
      # [*Typedef*] struct { DWORD dwOSVersionInfoSize; DWORD dwMajorVersion; DWORD dwMinorVersion; DWORD
      #             dwBuildNumber; DWORD dwPlatformId; TCHAR szCSDVersion[128]; WORD wServicePackMajor; WORD
      #             wServicePackMinor; WORD wSuiteMask; BYTE wProductType; BYTE wReserved;
      #             } OSVERSIONINFOEX;
      #
      # dwOSVersionInfoSize:: The size of this data structure, in bytes. Set this member to sizeof(OSVERSIONINFOEX).
      # dwMajorVersion:: Major version number of the operating system. This member can be one of the following:
      #                  - 5 The operating system is Windows Server 2003 (also R2), Windows XP, or Windows 2000.
      #                  - 6 The operating system is Windows Vista or Windows Server 2008.
      # dwMinorVersion:: Minor version number of the operating system. This member can be one of the following:
      #                  - 0 The operating system is Windows Server 2008, Windows Vista, or Windows 2000.
      #                  - 1 The operating system is Windows XP.
      #                  - 2 The operating system is Windows Server 2003 (also R2) or Windows XP Professional x64
      # dwBuildNumber:: The build number of the operating system.
      # dwPlatformId:: The operating system platform. This member can be VER_PLATFORM_WIN32_NT (2).
      # szCSDVersion:: A null-terminated string, such as "Service Pack 3", that indicates the latest Service Pack
      #                installed on the system. If no Service Pack has been installed, the string is empty.
      # wServicePackMajor:: The major version number of the latest Service Pack installed on the system. For example,
      #                     for Service Pack 3, major version number is 3. If no Service Pack has been installed,
      #                     the value is zero.
      # wServicePackMinor:: The minor version number of the latest Service Pack installed on the system. For example,
      #                     for Service Pack 3, the minor version number is 0.
      # wSuiteMask:: A bit mask that identifies the product suites available on the system. This member can be a
      #              combination of the following values:
      #              VER_SUITE_BACKOFFICE, VER_SUITE_BLADE, VER_SUITE_COMPUTE_SERVER, VER_SUITE_DATACENTER,
      #              VER_SUITE_ENTERPRISE, VER_SUITE_EMBEDDEDNT, VER_SUITE_PERSONAL, VER_SUITE_SINGLEUSERTS,
      #              VER_SUITE_SMALLBUSINESS, VER_SUITE_SMALLBUSINESS_RESTRICTED, VER_SUITE_STORAGE_SERVER,
      #              VER_SUITE_TERMINAL, VER_SUITE_WH_SERVER
      # wProductType:: Any additional information about the system. This member can be one of the following values:
      #                VER_NT_DOMAIN_CONTROLLER, VER_NT_SERVER, VER_NT_WORKSTATION
      # wReserved:: Reserved for future use.
      # ---
      # *Remarks*:
      # Relying on version information is not the best way to test for a feature. Instead, refer to the
      # documentation for the feature of interest. For more information on common techniques for feature
      # detection, {see Operating System Version}[http://msdn.microsoft.com/en-us/library/ms724832%28v=VS.85%29.aspx].
      # If you must require a particular operating system, be sure to use it as a minimum supported version,
      # rather than design the test for the one operating system. This way, your detection code will continue
      # to work on future versions of Windows.
      #
      # If compatibility mode is in effect, the OSVERSIONINFOEX structure contains information about the
      # operating system that is selected for {application compatibility}[http://msdn.microsoft.com/en-us/library/bb757005.aspx].
      #
      # The GetSystemMetrics function provides the following additional information about the current
      # Windows Server 2003 R2:: SM_SERVERR2
      # Windows XP Media Center Edition:: SM_MEDIACENTER
      # Windows XP Starter Edition:: SM_STARTER
      # Windows XP Tablet PC Edition:: SM_TABLETPC
      # The following table summarizes the values returned by supported versions of Windows.
      # Use this information to distinguish between operating systems with identical version numbers.
      # Windows 7::  6.1  OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION
      # Windows Server 2008 R2::  6.1  OSVERSIONINFOEX.wProductType != VER_NT_WORKSTATION
      # Windows Server 2008::  6.0  OSVERSIONINFOEX.wProductType != VER_NT_WORKSTATION
      # Windows Vista:: 6.0  OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION
      # Windows Server 2003 R2::  5.2  GetSystemMetrics(SM_SERVERR2) != 0
      # Windows Home Server::  5.2  OSVERSIONINFOEX.wSuiteMask & VER_SUITE_WH_SERVER
      # Windows Server 2003::  5.2  GetSystemMetrics(SM_SERVERR2) == 0
      # Windows XP Professional x64 Ed::  5.2  (OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION) && (SYSTEM_INFO.wProcessorArchitecture==PROCESSOR_ARCHITECTURE_AMD64)
      # Windows XP::  5.1
      # Windows 2000::  5.0
      # To determine whether a Win32-based application is running on WOW64, call the IsWow64Process function.
      # To determine whether the system is running a 64-bit version of Windows, call the GetNativeSystemInfo.
      #
      class OSVERSIONINFOEX < FFI::Struct
        layout :dw_os_version_info_size, :uint32,
               :dw_major_version, :uint32,
               :dw_minor_version, :uint32,
               :dw_build_number, :uint32,
               :dw_platform_id, :uint32,
               :sz_csd_version, [:char, 128],
               :w_service_pack_major, :uint16,
               :w_service_pack_minor, :uint16,
               :w_suite_mask, :uint16,
               :w_product_type, :uchar,
               :w_reserved, :uchar,
      end

      ##
      # GetVersion Function retrieves the version number of the current operating system.
      # *Note*:  This function has been superseded by GetVersionEx. New applications should use GetVersionEx or
      # VerifyVersionInfo.
      #
      # [*Syntax*] DWORD WINAPI GetVersion( void );
      #
      # This function has no parameters.
      #
      # *Returns*:: If the function succeeds, the return value includes the major and minor version numbers of
      #             the operating system in the low-order word, and information about the operating system
      #             platform in the high-order word.
      #             For all platforms, the low-order word contains the version number of the operating system. The
      #             low-order byte of this word specifies the major version number, in hexadecimal notation. The
      #             high-order byte specifies the minor version (revision) number, in hexadecimal notation. The
      #             high-order bit is zero, the next 7 bits represent the build number, and the low-order byte is 5.
      # ---
      # *Remarks*:
      # The GetVersionEx function was developed because many existing applications err when examining the
      # packed DWORD value returned by GetVersion, transposing the major and minor version numbers.
      # GetVersionEx forces applications to explicitly examine each element of version information.
      # VerifyVersionInfo eliminates further potential for error by comparing the required system version with
      # the current system version for you.
      # ---
      # *Requirements*:
      # Client Requires Windows Vista, Windows XP, or Windows 2000 Professional.
      # Server Requires Windows Server 2008, Windows Server 2003, or Windows 2000 Server.
      # Header Declared in Winbase.h; include Windows.h.
      # Library Use Kernel32.lib.
      # ---
      # *See* *Also*:
      # GetVersionEx
      # VerifyVersionInfo
      # {Operating System Version}[http://msdn.microsoft.com/en-us/library/ms724832%28v=VS.85%29.aspx]
      #
      # ---
      # <b>Enhanced (snake_case) API: Returns an Array with 3 version numbers: major, minor and build. </b>
      #
      # :call-seq:
      #  major, minor, build = [get_]version()
      #
      function :GetVersion, [], :uint32,
               &->(api) {
               version = api.call
               major = LOBYTE(LOWORD(version))
               minor = HIBYTE(LOWORD(version))
               build = version < 0x80000000 ? HIWORD(version) : 0
               [major, minor, build] }

      ##
      # GetVersionEx Function retrieves information about the current operating system.
      #
      # [*Syntax*] BOOL WINAPI GetVersionEx( LPOSVERSIONINFO lpVersionInfo );
      #
      # lpVersionInfo:: <in, out> An OSVERSIONINFO or OSVERSIONINFOEX structure that receives the operating system
      #                 information. Before calling the GetVersionEx function, set the dwOSVersionInfoSize member of
      #                 the structure as appropriate to indicate which data structure is being passed to this function.
      #
      # *Returns*:: If the function succeeds, the return value is a nonzero value. If the function fails, it is zero.
      #             To get extended error information, call GetLastError. The function fails if you specify an invalid
      #             value for the dwOSVersionInfoSize member of the OSVERSIONINFO or OSVERSIONINFOEX structure.
      # ---
      # *Remarks*:
      # Identifying the current operating system is usually not the best way to determine whether a particular
      # operating system feature is present. This is because the operating system may have had new features
      # added in a redistributable DLL. Rather than using GetVersionEx to determine the operating system
      # platform or version number, test for the presence of the feature itself. For more information, see
      # {Operating System Version}[http://msdn.microsoft.com/en-us/library/ms724832%28v=VS.85%29.aspx].
      #
      # The GetSystemMetrics function provides additional information about the current operating system.
      # To check for specific operating systems or operating system features, use the IsOS function. The
      # GetProductInfo function retrieves the product type.
      #
      # To retrieve information for the operating system on a remote computer, use the NetWkstaGetInfo
      # function, the Win32_OperatingSystem WMI class, or the OperatingSystem property of the IADsComputer
      # interface.
      #
      # To compare the current system version to a required version, use the VerifyVersionInfo function
      # instead of using GetVersionEx to perform the comparison yourself.
      # If compatibility mode is in effect, the GetVersionEx function reports the operating system as it
      # identifies itself, which may not be the operating system that is installed. For example, if
      # compatibility mode is in effect, GetVersionEx reports the operating system that is selected for
      # application compatibility.
      #
      # When using the GetVersionEx function to determine whether your application is running on a particular
      # version of the operating system, check for version numbers that are greater than or equal to the
      # desired version numbers. This ensures that the test succeeds for later versions of the operating system.
      # ---
      # *Requirements*
      # Windows 2000 Professional +, or Windows 2000 Server +
      # Header:: Winbase.h (include Windows.h)
      # Library:: Kernel32.lib
      # Unicode and ANSI names:: GetVersionExW (Unicode) and GetVersionExA (ANSI)
      # ---
      # *See* *Also*
      # GetVersion
      # VerifyVersionInfo
      # OSVERSIONINFO
      # OSVERSIONINFOEX
      # {Operating System Version}[http://msdn.microsoft.com/en-us/library/ms724832%28v=VS.85%29.aspx]
      #
      # ---
      # <b>Enhanced (snake_case) API: Takes OSVERSIONINFOEX struct as optional argument, returns
      # filled OSVERSIONINFOEX struct. You can address members of the struct like this:
      # version_info[:dw_major_version]. If function fails, it returns nil. </b>
      #
      # :call-seq:
      #  version_info = [get_]version_ex(lp_version_info=OSVERSIONINFOEX.new)
      #
      function :GetVersionEx, [:pointer], :int8,
               &->(api, version_info = OSVERSIONINFOEX.new) {
               version_info[:dw_os_version_info_size] = version_info.size
               api.call(version_info.to_ptr) == 0 ? nil : version_info }

      ##
      # VerifyVersionInfo Function. Compares a set of operating system version requirements to the corresponding
      # values for the currently running version of the system.
      #
      # [*Syntax*] BOOL VerifyVersionInfo( LPOSVERSIONINFOEX lpVersionInfo, DWORD dwTypeMask, DWORDLONG
      #            dwlConditionMask );
      #
      # lpVersionInfo:: A pointer to an OSVERSIONINFOEX structure containing the operating system version requirements
      #                 to compare. The dwTypeMask parameter indicates the members of this structure that contain
      #                 information to compare. You must set the dwOSVersionInfoSize member of this structure to
      #                 sizeof(OSVERSIONINFOEX). You must also specify valid data for the members indicated by
      #                 dwTypeMask. The function ignores structure members for which the corresponding dwTypeMask
      #                 bit is not set.
      # dwTypeMask:: Mask that indicates the members of the OSVERSIONINFOEX structure to be tested. This parameter can
      #              be one or more of the following values: VER_BUILDNUMBER, VER_MAJORVERSION, VER_MINORVERSION,
      #              VER_PLATFORMID, VER_SERVICEPACKMAJOR, VER_SERVICEPACKMINOR, VER_SUITENAME, VER_PRODUCT_TYPE
      #              If you are testing the major version, you must also test the minor version and the service pack
      #              major and minor versions.
      # dwlConditionMask:: The type of comparison to be used for each lpVersionInfo member being compared. To build
      #                    this value, call the VerSetConditionMask function or the VER_SET_CONDITION macro once for
      #                    each OSVERSIONINFOEX member being compared.
      #
      # *Returns*:: If the currently running operating system satisfies the specified requirements, the return
      #             value is a nonzero value. If the current system does not satisfy the requirements, the return
      #             value is zero and GetLastError returns ERROR_OLD_WIN_VERSION. If the function fails, the return
      #             value is zero and GetLastError returns an error code other than ERROR_OLD_WIN_VERSION.
      # ---
      # *Remarks*:
      # The VerifyVersionInfo function retrieves version information about the currently running operating
      # system and compares it to the valid members of the lpVersionInfo structure. This enables you to easily
      # determine the presence of a required set of operating system version conditions. It is preferable to
      # use VerifyVersionInfo rather than calling the GetVersionEx function to perform your own comparisons.
      # Typically, VerifyVersionInfo returns a nonzero value only if all specified tests succeed. However,
      # major, minor, and service pack versions are tested in a hierarchical manner because the operating
      # system version is a combination of these values. If a condition exists for the major version, it
      # supersedes the conditions specified for minor version and service pack version. (You cannot test for
      # major version greater than 5 and minor version less than or equal to 1. If you specify such a test,
      # the function will change the request to test for a minor version greater than 1 because it is
      # performing a greater than operation on the major version.)
      #
      # The function tests these values in this order: major version, minor version, and service pack version.
      # The function continues testing values while they are equal, and stops when one of the values does not
      # meet the specified condition. For example, if you test for a system greater than or equal to version
      # 5.1 service pack 1, the test succeeds if the current version is 6.0. (The major version is greater
      # than the specified version, so the testing stops.) In the same way, if you test for a system greater
      # than or equal to version 5.1 service pack 1, the test succeeds if the current version is 5.2. (The
      # minor version is greater than the specified versions, so the testing stops.) However, if you test for
      # a system greater than or equal to version 5.1 service pack 1, the test fails if the current version is
      # 5.0 service pack 2. (The minor version is not greater than the specified version, so the testing stops.)
      #
      # To verify a range of system versions, you must call VerifyVersionInfo twice. For example, to verify
      # that the system version is greater than 5.0 but less than or equal to 5.1, first call
      # VerifyVersionInfo to test that the major version is 5 and the minor version is greater than 0, then
      # call VerifyVersionInfo again to test that the major version is 5 and the minor version is less than or
      # equal to 1.
      #
      # Identifying the current operating system is usually not the best way to determine whether a particular
      # operating system feature is present. This is because the operating system may have had new features
      # added in a redistributable DLL. Rather than using GetVersionEx to determine the operating system
      # platform or version number, test for the presence of the feature itself. For more information,
      # {see Operating System Version}[http://msdn.microsoft.com/en-us/library/ms724832%28v=VS.85%29.aspx].
      # To verify whether the current operating system is either the Media Center or Tablet PC version of
      # Windows, call GetSystemMetrics.
      # ---
      # *Requirements*
      # Client Requires Windows Vista, Windows XP, or Windows 2000 Professional.
      # Server Requires Windows Server 2008, Windows Server 2003, or Windows 2000 Server.
      # Header Declared in Winbase.h; include Windows.h.
      # Library Use Kernel32.lib.
      # Unicode Implemented as VerifyVersionInfoW (Unicode) and VerifyVersionInfoA (ANSI).
      # ---
      # *See* *Also*
      # GetVersionEx
      # VerSetConditionMask
      # OSVERSIONINFOEX
      # VER_SET_CONDITION
      # {Operating System Version}[http://msdn.microsoft.com/en-us/library/ms724832%28v=VS.85%29.aspx]
      #
      # ---
      # <b>Enhanced (snake_case) API: </b>
      #
      # :call-seq:
      #  success = verify_version_info(lp_version_info, dw_type_mask, dwl_condition_mask)
      #
      function :VerifyVersionInfo, [:pointer, :uint32, :uint64], :int8, boolean: true

      ##
      # VerSetConditionMask Function
      # Sets the bits of a 64-bit value to indicate the comparison operator to use for a specified operating
      # system version attribute. This function is used to build the dwlConditionMask parameter of the
      # VerifyVersionInfo function.
      #
      # [*Syntax*] ULONGLONG WINAPI VerSetConditionMask( ULONGLONG dwlConditionMask, DWORD dwTypeBitMask,
      #            BYTE dwConditionMask );
      #
      # dwlConditionMask:: A value to be passed as the dwlConditionMask parameter of the VerifyVersionInfo function.
      #                    The function stores the comparison information in the bits of this variable.
      #                    Before the first call to VerSetCondition, initialize this variable to zero. For subsequent
      #                    calls, pass in the variable used in the previous call.
      # dwTypeBitMask:: A mask that indicates the member of the OSVERSIONINFOEX structure whose comparison operator is
      #                 being set. This value corresponds to one of the bits specified in the dwTypeMask parameter for
      #                 the VerifyVersionInfo function. This parameter can be one of the following values:
      #                 VER_BUILDNUMBER:: dwBuildNumber
      #                 VER_MAJORVERSION:: dwMajorVersion
      #                 VER_MINORVERSION:: dwMinorVersion
      #                 VER_PLATFORMID:: dwPlatformId
      #                 VER_PRODUCT_TYPE:: wProductType
      #                 VER_SERVICEPACKMAJOR:: wServicePackMajor
      #                 VER_SERVICEPACKMINOR:: wServicePackMinor
      #                 VER_SUITENAME:: wSuiteMask
      # dwConditionMask:: The operator to be used for the comparison. The VerifyVersionInfo function uses this operator
      #                   to compare a specified attribute value to the corresponding value for the currently running
      #                   system. For all values of dwTypeBitMask other than VER_SUITENAME, this parameter can be one
      #                   of the following:
      #                   VER_EQUAL:: The current value must be equal to the specified value.
      #                   VER_GREATER:: The current value must be greater than the specified value.
      #                   VER_GREATER_EQUAL:: The current value must be greater than or equal to the specified value.
      #                   VER_LESS:: The current value must be less than the specified value.
      #                   VER_LESS_EQUAL:: The current value must be less than or equal to the specified value.
      #                   If dwTypeBitMask is VER_SUITENAME, this parameter can be one of the following values:
      #                   VER_AND:: All product suites specified in the wSuiteMask member must be present in the system.
      #                   VER_OR:: At least one of the specified product suites must be present in the current system.
      #
      # *Returns*:: The function returns the condition mask value.
      # ---
      # *Remarks*:
      # Call this function once for each bit set in the dwTypeMask parameter of the VerifyVersionInfo function.
      # ---
      # *Requirements*:
      # Client Requires Windows Vista, Windows XP, or Windows 2000 Professional.
      # Server Requires Windows Server 2008, Windows Server 2003, or Windows 2000 Server.
      # Header Declared in Winnt.h; include Windows.h.
      # Library Use Kernel32.lib.
      # DLL Requires Kernel32.dll.
      # ---
      # *See* *Also*:
      # {Operating System Version}[http://msdn.microsoft.com/en-us/library/ms724832%28v=VS.85%29.aspx]
      # OSVERSIONINFOEX
      # VerifyVersionInfo
      #
      # ---
      # <b>Enhanced (snake_case) API: dwl_condition_mask defaults to 0, you can send in an Array of type/condition
      # pairs instead of single dw_type_bit_mask/dw_condition_mask pair</b>
      #
      # :call-seq:
      #  mask = ver_set_condition_mask(previous_mask=0, type_bit_mask, condition_mask)
      #
      function :VerSetConditionMask, [:uint64, :uint32, :uchar], :uint64,
               &->(api, *args) {
               case args.last
                 when Array
                   mask = args.size == 2 ? args.shift : 0
                   args.last.flatten.each_slice(2) {|pair| mask = api.call(mask, *pair) }
                   mask
                 else
                   mask = args.size == 3 ? args.shift : 0
                   api.call mask, *args
               end }

      # Convenience methods:

      # Returns true if the current platform is Windows 2000: major version 6, minor version 0.
      #
      def windows_2000?
        major, minor = get_version()
        major == 5 && minor == 0
      end

      # Returns true if the current platform is Windows Vista (any variant)
      # or Windows Server 2008: major version 6, minor version 0.
      #
      def windows_vista?
        major, minor = get_version()
        major == 6 && minor == 0
      end

      # Returns true if the current platform is Windows 7
      # or Windows Server 2008 R2: major version 6, minor version 1.
      #
      def windows_7?
        major, minor = get_version()
        major == 6 && minor == 1
      end

      # Returns true if the current platform is Windows XP or Windows XP Pro:
      # major version 5, minor version 1 (or 2 in the case of a 64-bit Windows XP Pro).
      #--
      # Because of the exception for a 64-bit Windows XP Pro, we have to
      # do things the hard way. For version 2 we look for any of the suite
      # masks that might be associated with Windows 2003. If we don't find
      # any of them, assume it's Windows XP.
      #
      def windows_xp?
        ver_info = get_version_ex()

        major = ver_info[:dw_major_version]
        minor = ver_info[:dw_minor_version]
        suite = ver_info[:w_suite_mask]

        # Make sure we detect a 64-bit Windows XP Pro
        if major == 5
          if minor == 1
            true
          elsif minor == 2
            if (suite & VER_SUITE_BLADE == 0)          &&
                    (suite & VER_SUITE_COMPUTE_SERVER == 0) &&
                    (suite & VER_SUITE_DATACENTER == 0)     &&
                    (suite & VER_SUITE_ENTERPRISE == 0)     &&
                    (suite & VER_SUITE_STORAGE_SERVER == 0)
            then
              true
            end
          end
        end || false
      end

      # Returns true if the current platform is Windows 2003 (any version).
      # i.e. major version 5, minor version 2.
      #--
      # Because of the exception for a 64-bit Windows XP Pro, we have to
      # do things the hard way. For version 2 we look for any of the suite
      # masks that might be associated with Windows 2003. If we find any
      # of them, assume it's Windows 2003.
      #
      def windows_2003?
        ver_info = get_version_ex()

        major = ver_info[:dw_major_version]
        minor = ver_info[:dw_minor_version]
        suite = ver_info[:w_suite_mask]

        # Make sure we exclude a 64-bit Windows XP Pro
        if major == 5 && minor == 2
          if (suite & VER_SUITE_BLADE > 0)          ||
                  (suite & VER_SUITE_COMPUTE_SERVER > 0) ||
                  (suite & VER_SUITE_DATACENTER > 0)     ||
                  (suite & VER_SUITE_ENTERPRISE > 0)     ||
                  (suite & VER_SUITE_STORAGE_SERVER > 0)
          then
            true
          end
        end || false
      end
    end
  end
end