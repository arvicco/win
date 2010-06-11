require 'win/library'

module Win
  module System

    # Contains constants and Win32 API functions related to dialog manipulation.
    # Windows dialog basics can be found here:
    # http://msdn.microsoft.com/en-us/library/ms644996#init_box
    module Info
      extend Win::Library

      # Enum COMPUTER_NAME_FORMAT (for GetComputerNameEx)

      ComputerNameNetBIOS                    = 0
      ComputerNameDnsHostname                = 1
      ComputerNameDnsDomain                  = 2
      ComputerNameDnsFullyQualified          = 3
      ComputerNamePhysicalNetBIOS            = 4
      ComputerNamePhysicalDnsHostname        = 5
      ComputerNamePhysicalDnsDomain          = 6
      ComputerNamePhysicalDnsFullyQualified  = 7
      ComputerNameMax                        = 8

      class << self
        # Helper method that creates def_block returning (possibly encoded) string as a result of
        # api function call or nil if api call was not successful. TODO: put this into some kind of helper?
        #
        def return_sized_string( encode = nil )  #:nodoc:
          lambda do |api, *args|
            namespace.enforce_count( args, api.prototype, -2)
            buffer = FFI::MemoryPointer.new :char, 1024
            size = FFI::MemoryPointer.new(:long).write_long(buffer.size)
            args += [buffer, size]
            success = api.call(*args)
            return nil unless success
            num_chars = size.read_long
            if encode
              string = buffer.get_bytes(0, num_chars*2)
              string = string.force_encoding('utf-16LE').encode(encode)
            else
              string = buffer.get_bytes(0, num_chars)
            end
            string.rstrip
          end
        end

        private :return_sized_string
      end

      ##
      # GetComputerName Function.
      # Retrieves the NetBIOS name of the local computer. This name is established at system startup, when the
      # system reads it from the registry.
      # GetComputerName retrieves only the NetBIOS name of the local computer. To retrieve the DNS host name,
      # DNS domain name, or the fully qualified DNS name, call the GetComputerNameEx function. Additional
      # information is provided by the IADsADSystemInfo interface.
      # The behavior of this function can be affected if the local computer is a node in a cluster. For more
      # information, see ResUtilGetEnvironmentWithNetName and UseNetworkName.
      #
      # [*Syntax*] BOOL GetComputerName( LPTSTR lpBuffer, LPDWORD lpnSize );
      #
      # lpBuffer:: A pointer to a buffer that receives the computer name or the cluster virtual server name. The buffer
      #            size should be large enough to contain MAX_COMPUTERNAME_LENGTH + 1 characters.
      # lpnSize:: On input, specifies the size of the buffer, in TCHARs. On output, the number of TCHARs copied to the
      #           destination buffer, not including the terminating null character.
      #           If the buffer is too small, the function fails and GetLastError returns ERROR_BUFFER_OVERFLOW. The
      #           lpnSize parameter specifies the size of the buffer required, not including the terminating null char.
      #
      # *Returns*:: If the function succeeds, the return value is a nonzero value.
      #             If the function fails, the return value is zero. To get extended error info, call GetLastError.
      # ---
      # *Remarks*:
      # The GetComputerName function retrieves the NetBIOS name established at system startup. Name changes
      # made by the SetComputerName or SetComputerNameEx functions do not take effect until the user restarts
      # the computer.
      # If the caller is running under a client session, this function returns the server name. To retrieve
      # the client name, use the WTSQuerySessionInformation function.
      # DLL Requires Kernel32.dll.
      # Unicode Implemented as GetComputerNameW (Unicode) and GetComputerNameA (ANSI).
      # ---
      # *See* *Also*
      # Computer Names
      # GetComputerNameEx
      # SetComputerName
      # SetComputerNameEx
      # System Information Functions
      #
      # ---
      # <b>Enhanced (snake_case) API: no arguments needed</b>
      #
      # :call-seq:
      #  name = [get_]computer_name()
      #
      function :GetComputerName, [:pointer, :pointer], :int8, &return_sized_string

      ##
      # GetUserName Function.
      # Retrieves the name of the user associated with the current thread.
      # Use the GetUserNameEx function to retrieve the user name in a specified format. Additional information
      # is provided by the IADsADSystemInfo interface.
      #
      # [*Syntax*] BOOL WINAPI GetUserName( LPTSTR lpBuffer, LPDWORD lpnSize );
      #
      # lpBuffer:: A pointer to the buffer to receive the user's logon name. If this buffer is not large enough to
      #            contain the entire user name, the function fails. A buffer size of (UNLEN + 1) characters will hold
      #            the maximum length user name including the terminating null character. UNLEN is defined in Lmcons.h.
      # lpnSize:: On input, this variable specifies the size of the lpBuffer buffer, in TCHARs. On output, the variable
      #           receives the number of TCHARs copied to the buffer, including the terminating null character.
      #           If lpBuffer is too small, the function fails and GetLastError returns ERROR_INSUFFICIENT_BUFFER. This
      #           parameter receives the required buffer size, including the terminating null character.
      #           If it is greater than 32767, function fails and GetLastError returns ERROR_INSUFFICIENT_BUFFER.
      #
      # *Returns*:: If the function succeeds, the return value is a nonzero value, and the variable pointed to
      #             by lpnSize contains the number of TCHARs copied to the buffer specified by lpBuffer,
      #             including the terminating null character. If the function fails, the return value is zero.
      #             To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # If the current thread is impersonating another client, the GetUserName function returns the user name
      # of the client that the thread is impersonating.
      # Example Code
      # For an example, see Getting System Information.
      # Requirements
      # Client Requires Windows Vista, Windows XP, or Windows 2000 Professional.
      # Server Requires Windows Server 2008, Windows Server 2003, or Windows 2000 Server.
      # Header Declared in Winbase.h; include Windows.h.
      # Library Use Advapi32.lib.
      # DLL Requires Advapi32.dll.
      # Unicode Implemented as GetUserNameW (Unicode) and GetUserNameA (ANSI).
      # ---
      # *See* *Also*:
      # GetUserNameEx
      # LookupAccountName
      # System Information Functions
      #
      # ---
      # <b>Enhanced (snake_case) API: no arguments needed</b>
      #
      # :call-seq:
      #  username = [get_]user_name()
      #
      function :GetUserName, [:pointer, :pointer], :int8, :dll=> 'advapi32', &return_sized_string

      # Untested

      ##
      function :GetComputerNameEx, 'PPP', :int8, boolean: true
      ##
      function :GetUserNameEx, 'LPP', :int8, boolean: true, dll: 'secur32'
      ##
      function :ExpandEnvironmentStrings, 'PPL', :long
      ##
      function :GetSystemInfo, 'P', :void
      ##
      function :GetWindowsDirectory, 'PI', :int
      ##
      # XP or later
      try_function :GetSystemWow64Directory, 'PI', :int

    end
  end
end

