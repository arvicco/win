require 'ffi'
require 'win/extensions'

# Related Windows API functions are grouped by topic and defined in separate namespaces (modules),
# that also contain related constants and convenience methods. For example, Win::DDE module
# contains only functions related to DDE protocol such as DdeInitialize() as well as constants
# such as DMLERR_NO_ERROR, APPCLASS_STANDARD, etc. So if you need only DDE-related functions,
# there is no need to load all the other modules, clogging your namespaces - just require 'win/dde'
# and be done with it. Win is just a top level namespace (container) that holds all the other modules. 
module Win

  module Errors                         # :nodoc:
    class NotFoundError < NameError     # :nodoc:
      def initialize(name=nil, libs=nil)
        super %Q[Function #{name ? "'#{name}' ": ""}not found#{libs ? " in #{libs}" : ""}"]
      end
    end
  end

  # WIN::Library is a module that extends FFI::Library and is used to connect to Windows API functions
  # and wrap them into Ruby methods using 'function' declaration. If you do not see your favorite Windows
  # API functions among those already defined, you can easily 'include Win::Library’ into your module
  # and declare them using ‘function’ class method (macro) - it does a lot of heavy lifting for you and
  # can be customized with options and code blocks to give you reusable API wrapper methods with the exact
  # behavior you need.
  module Library

    # Win::Library::API is a wrapper for callable function API object that mimics Win32::API
    class API

      # The name of the DLL(s) that export this API function
      attr_reader :dll_name

      # Ruby namespace (module) where this API function is attached
      attr_reader :namespace

      # The name of the function passed to the constructor
      attr_reader :function_name

      # The name of the actual Windows API function. For example, if you passed 'GetUserName' to the
      # constructor, then the effective function name would be either 'GetUserNameA' or 'GetUserNameW'.
      attr_accessor :effective_function_name

      # The prototype, returned as an array of FFI types
      attr_reader :prototype

      # The return type (:void for no return value)
      attr_reader :return_type

      def initialize( namespace, function_name, effective_function_name, prototype, return_type, dll_name )
        @namespace = namespace
        @function_name = function_name
        @effective_function_name = effective_function_name
        @prototype = prototype
        @return_type = return_type
        @dll_name = dll_name
      end

      # Calls underlying CamelCase Windows API function with supplied args
      def call( *args )
        @namespace.send(@function_name.to_sym, *args)
      end

      alias_method :[], :call
    end

    # Contains class methods (macros) that can be used in any module mixing in Win::Library
    module ClassMethods

      # Mapping of Windows API types and one-letter shortcuts into FFI types.
      # Like :ATOM => :ushort, :LPARAM => :long, :c => :char, :i => :int
      TYPES = {
              # FFI type shortcuts
              C:  :uchar, #– 8-bit unsigned character (byte)
              c:  :char, # 8-bit character (byte)
              #   :int8       – 8-bit signed integer
              #   :uint8      – 8-bit unsigned integer
              S:  :ushort, # – 16-bit unsigned integer (Win32API: used for string)
              s:  :short, # – 16-bit signed integer
              #   :uint16     – 16-bit unsigned integer
              #   :int16      – 16-bit signed integer
              I:  :uint, # 32-bit unsigned integer
              i:  :int, # 32-bit signed integer
              #   :uint32     – 32-bit unsigned integer
              #   :int32      – 32-bit signed integer
              L:  :ulong, # unsigned long int – platform-specific size
              l:  :long, # long int – platform-specific size. For discussion of platforms, see:
              #                (http://groups.google.com/group/ruby-ffi/browse_thread/thread/4762fc77130339b1)
              #   :int64      – 64-bit signed integer
              #   :uint64     – 64-bit unsigned integer
              #   :long_long  – 64-bit signed integer
              #   :ulong_long – 64-bit unsigned integer
              F:  :float, # 32-bit floating point
              D:  :double, # 64-bit floating point (double-precision)
              P:  :pointer, # pointer – platform-specific size
              p:  :string, # C-style (NULL-terminated) character string (Win32API: S)
              B:  :bool, # (?? 1 byte in C++)
              V:  :void, # For functions that return nothing (return type void).
              v:  :void, # For functions that return nothing (return type void).
              # For function argument type only:
              # :buffer_in    – Similar to :pointer, but optimized for Buffers that the function can only read (not write).
              # :buffer_out   – Similar to :pointer, but optimized for Buffers that the function can only write (not read).
              # :buffer_inout – Similar to :pointer, but may be optimized for Buffers.
              # :varargs      – Variable arguments

              # Windows-specific typedefs:
              ATOM:      :ushort, # Atom ~= Symbol: Atom table stores strings and corresponding identifiers. Application
              # places a string in an atom table and receives a 16-bit integer, called an atom, that
              # can be used to access the string. Placed string is called an atom name.
              # See: http://msdn.microsoft.com/en-us/library/ms648708%28VS.85%29.aspx
              BOOL:      :bool,
              BOOLEAN:   :bool,
              BYTE:      :uchar, # Byte (8 bits). Declared as unsigned char
              #CALLBACK:  K,       # Win32.API gem-specific ?? MSDN: #define CALLBACK __stdcall
              CHAR:      :char, # 8-bit Windows (ANSI) character. See http://msdn.microsoft.com/en-us/library/dd183415%28VS.85%29.aspx
              COLORREF:  :uint32, # Red, green, blue (RGB) color value (32 bits). See COLORREF for more info.
              DWORD:     :uint32, # 32-bit unsigned integer. The range is 0 through 4,294,967,295 decimal.
              DWORDLONG: :uint64, # 64-bit unsigned integer. The range is 0 through 18,446,744,073,709,551,615 decimal.
              DWORD_PTR: :ulong, # Unsigned long type for pointer precision. Use when casting a pointer to a long type
              # to perform pointer arithmetic. (Also commonly used for general 32-bit parameters that have
              # been extended to 64 bits in 64-bit Windows.)  BaseTsd.h: #typedef ULONG_PTR DWORD_PTR;
              DWORD32:   :uint32,
              DWORD64:   :uint64,
              HALF_PTR:  :int, # Half the size of a pointer. Use within a structure that contains a pointer and two small fields.
              # BaseTsd.h: #ifdef (_WIN64) typedef int HALF_PTR; #else typedef short HALF_PTR;
              HACCEL:    :ulong, # (L) Handle to an accelerator table. WinDef.h: #typedef HANDLE HACCEL;
              # See http://msdn.microsoft.com/en-us/library/ms645526%28VS.85%29.aspx
              HANDLE:    :ulong, # (L) Handle to an object. WinNT.h: #typedef PVOID HANDLE;
              HBITMAP:   :ulong, # (L) Handle to a bitmap: http://msdn.microsoft.com/en-us/library/dd183377%28VS.85%29.aspx
              HBRUSH:    :ulong, # (L) Handle to a brush. http://msdn.microsoft.com/en-us/library/dd183394%28VS.85%29.aspx
              HCOLORSPACE: :ulong, # (L) Handle to a color space. http://msdn.microsoft.com/en-us/library/ms536546%28VS.85%29.aspx
              HCURSOR:   :ulong, # (L) Handle to a cursor. http://msdn.microsoft.com/en-us/library/ms646970%28VS.85%29.aspx
              HCONV:     :ulong, # (L) Handle to a dynamic data exchange (DDE) conversation.
              HCONVLIST: :ulong, # (L) Handle to a DDE conversation list. HANDLE - L ?
              HDDEDATA:  :ulong, # (L) Handle to DDE data (structure?)
              HDC:       :ulong, # (L) Handle to a device context (DC). http://msdn.microsoft.com/en-us/library/dd183560%28VS.85%29.aspx
              HDESK:     :ulong, # (L) Handle to a desktop. http://msdn.microsoft.com/en-us/library/ms682573%28VS.85%29.aspx
              HDROP:     :ulong, # (L) Handle to an internal drop structure.
              HDWP:      :ulong, # (L) Handle to a deferred window position structure.
              HENHMETAFILE: :ulong, #(L) Handle to an enhanced metafile. http://msdn.microsoft.com/en-us/library/dd145051%28VS.85%29.aspx
              HFILE:     :uint, # (I) Special file handle to a file opened by OpenFile, not CreateFile.
              # WinDef.h: #typedef int HFILE;
              HFONT:     :ulong, # (L) Handle to a font. http://msdn.microsoft.com/en-us/library/dd162470%28VS.85%29.aspx
              HGDIOBJ:   :ulong, # (L) Handle to a GDI object.
              HGLOBAL:   :ulong, # (L) Handle to a global memory block.
              HHOOK:     :ulong, # (L) Handle to a hook. http://msdn.microsoft.com/en-us/library/ms632589%28VS.85%29.aspx
              HICON:     :ulong, # (L) Handle to an icon. http://msdn.microsoft.com/en-us/library/ms646973%28VS.85%29.aspx
              HINSTANCE: :ulong, # (L) Handle to an instance. This is the base address of the module in memory.
              # HMODULE and HINSTANCE are the same today, but were different in 16-bit Windows.
              HKEY:      :ulong, # (L) Handle to a registry key.
              HKL:       :ulong, # (L) Input locale identifier.
              HLOCAL:    :ulong, # (L) Handle to a local memory block.
              HMENU:     :ulong, # (L) Handle to a menu. http://msdn.microsoft.com/en-us/library/ms646977%28VS.85%29.aspx
              HMETAFILE: :ulong, # (L) Handle to a metafile. http://msdn.microsoft.com/en-us/library/dd145051%28VS.85%29.aspx
              HMODULE:   :ulong, # (L) Handle to an instance. Same as HINSTANCE today, but was different in 16-bit Windows.
              HMONITOR:  :ulong, # (L) Рandle to a display monitor. WinDef.h: if(WINVER >= 0x0500) typedef HANDLE HMONITOR;
              HPALETTE:  :ulong, # (L) Handle to a palette.
              HPEN:      :ulong, # (L) Handle to a pen. http://msdn.microsoft.com/en-us/library/dd162786%28VS.85%29.aspx
              HRESULT:   :long, # Return code used by COM interfaces. For more info, Structure of the COM Error Codes.
              # To test an HRESULT value, use the FAILED and SUCCEEDED macros.
              HRGN:      :ulong, # (L) Handle to a region. http://msdn.microsoft.com/en-us/library/dd162913%28VS.85%29.aspx
              HRSRC:     :ulong, # (L) Handle to a resource.
              HSZ:       :ulong, # (L) Handle to a DDE string.
              HWINSTA:   :ulong, # (L) Handle to a window station. http://msdn.microsoft.com/en-us/library/ms687096%28VS.85%29.aspx
              HWND:      :ulong, # (L) Handle to a window. http://msdn.microsoft.com/en-us/library/ms632595%28VS.85%29.aspx
              INT:       :int, # 32-bit signed integer. The range is -2147483648 through 2147483647 decimal.
              INT_PTR:   :int, # Signed integer type for pointer precision. Use when casting a pointer to an integer
              # to perform pointer arithmetic. BaseTsd.h:
              #if defined(_WIN64) typedef __int64 INT_PTR; #else typedef int INT_PTR;
              INT32:    :int32, # 32-bit signed integer. The range is -2,147,483,648 through +...647 decimal.
              INT64:    :int64, # 64-bit signed integer. The range is –9,223,372,036,854,775,808 through +...807
              LANGID:   :ushort, # Language identifier. For more information, see Locales. WinNT.h: #typedef WORD LANGID;
              # See http://msdn.microsoft.com/en-us/library/dd318716%28VS.85%29.aspx
              LCID:     :uint32, # Locale identifier. For more information, see Locales.
              LCTYPE:   :uint32, # Locale information type. For a list, see Locale Information Constants.
              LGRPID:   :uint32, # Language group identifier. For a list, see EnumLanguageGroupLocales.
              LONG:     :long, # 32-bit signed integer. The range is -2,147,483,648 through +...647 decimal.
              LONG32:   :long, # 32-bit signed integer. The range is -2,147,483,648 through +...647 decimal.
              LONG64:   :int64, # 64-bit signed integer. The range is –9,223,372,036,854,775,808 through +...807
              LONGLONG: :int64, # 64-bit signed integer. The range is –9,223,372,036,854,775,808 through +...807
              LONG_PTR: :long, # Signed long type for pointer precision. Use when casting a pointer to a long to
              # perform pointer arithmetic. BaseTsd.h:
              #if defined(_WIN64) typedef __int64 LONG_PTR; #else typedef long LONG_PTR;
              LPARAM:   :long, # Message parameter. WinDef.h as follows: #typedef LONG_PTR LPARAM;
              LPBOOL:   :pointer, # Pointer to a BOOL. WinDef.h as follows: #typedef BOOL far *LPBOOL;
              LPBYTE:   :pointer, # Pointer to a BYTE. WinDef.h as follows: #typedef BYTE far *LPBYTE;
              LPCOLORREF: :pointer, # Pointer to a COLORREF value. WinDef.h as follows: #typedef DWORD *LPCOLORREF;
              LPCSTR:   :pointer, # Pointer to a constant null-terminated string of 8-bit Windows (ANSI) characters.
              # See Character Sets Used By Fonts. http://msdn.microsoft.com/en-us/library/dd183415%28VS.85%29.aspx
              LPCTSTR:  :pointer, # An LPCWSTR if UNICODE is defined, an LPCSTR otherwise.
              LPCVOID:  :pointer, # Pointer to a constant of any type. WinDef.h as follows: typedef CONST void *LPCVOID;
              LPCWSTR:  :pointer, # Pointer to a constant null-terminated string of 16-bit Unicode characters.
              LPDWORD:  :pointer, # Pointer to a DWORD. WinDef.h as follows: typedef DWORD *LPDWORD;
              LPHANDLE: :pointer, # Pointer to a HANDLE. WinDef.h as follows: typedef HANDLE *LPHANDLE;
              LPINT:    :pointer, # Pointer to an INT.
              LPLONG:   :pointer, # Pointer to an LONG.
              LPSTR:    :pointer, # Pointer to a null-terminated string of 8-bit Windows (ANSI) characters.
              LPTSTR:   :pointer, # An LPWSTR if UNICODE is defined, an LPSTR otherwise.
              LPVOID:   :pointer, # Pointer to any type.
              LPWORD:   :pointer, # Pointer to a WORD.
              LPWSTR:   :pointer, # Pointer to a null-terminated string of 16-bit Unicode characters.
              LRESULT:  :long, # Signed result of message processing. WinDef.h: typedef LONG_PTR LRESULT;
              PBOOL:    :pointer, # Pointer to a BOOL.
              PBOOLEAN: :pointer, # Pointer to a BOOL.
              PBYTE:    :pointer, # Pointer to a BYTE.
              PCHAR:    :pointer, # Pointer to a CHAR.
              PCSTR:    :pointer, # Pointer to a constant null-terminated string of 8-bit Windows (ANSI) characters.
              PCTSTR:   :pointer, # A PCWSTR if UNICODE is defined, a PCSTR otherwise.
              PCWSTR:    :pointer, # Pointer to a constant null-terminated string of 16-bit Unicode characters.
              PDWORD:    :pointer, # Pointer to a DWORD.
              PDWORDLONG: :pointer, # Pointer to a DWORDLONG.
              PDWORD_PTR: :pointer, # Pointer to a DWORD_PTR.
              PDWORD32:  :pointer, # Pointer to a DWORD32.
              PDWORD64:  :pointer, # Pointer to a DWORD64.
              PFLOAT:    :pointer, # Pointer to a FLOAT.
              PHALF_PTR: :pointer, # Pointer to a HALF_PTR.
              PHANDLE:   :pointer, # Pointer to a HANDLE.
              PHKEY:     :pointer, # Pointer to an HKEY.
              PINT:      :pointer, # Pointer to an INT.
              PINT_PTR:  :pointer, # Pointer to an INT_PTR.
              PINT32:    :pointer, # Pointer to an INT32.
              PINT64:    :pointer, # Pointer to an INT64.
              PLCID:     :pointer, # Pointer to an LCID.
              PLONG:     :pointer, # Pointer to a LONG.
              PLONGLONG: :pointer, # Pointer to a LONGLONG.
              PLONG_PTR: :pointer, # Pointer to a LONG_PTR.
              PLONG32:   :pointer, # Pointer to a LONG32.
              PLONG64:   :pointer, # Pointer to a LONG64.
              POINTER_32: :pointer, # 32-bit pointer. On a 32-bit system, this is a native pointer. On a 64-bit system, this is a truncated 64-bit pointer.
              POINTER_64: :pointer, # 64-bit pointer. On a 64-bit system, this is a native pointer. On a 32-bit system, this is a sign-extended 32-bit pointer.
              POINTER_SIGNED:   :pointer, # A signed pointer.
              POINTER_UNSIGNED: :pointer, # An unsigned pointer.
              PSHORT:     :pointer, # Pointer to a SHORT.
              PSIZE_T:    :pointer, # Pointer to a SIZE_T.
              PSSIZE_T:   :pointer, # Pointer to a SSIZE_T.
              PSTR:       :pointer, # Pointer to a null-terminated string of 8-bit Windows (ANSI) characters. For more information, see Character Sets Used By Fonts.
              PTBYTE:     :pointer, # Pointer to a TBYTE.
              PTCHAR:     :pointer, # Pointer to a TCHAR.
              PTSTR:      :pointer, # A PWSTR if UNICODE is defined, a PSTR otherwise.
              PUCHAR:     :pointer, # Pointer to a UCHAR.
              PUHALF_PTR: :pointer, # Pointer to a UHALF_PTR.
              PUINT:      :pointer, # Pointer to a UINT.
              PUINT_PTR:  :pointer, # Pointer to a UINT_PTR.
              PUINT32:    :pointer, # Pointer to a UINT32.
              PUINT64:    :pointer, # Pointer to a UINT64.
              PULONG:     :pointer, # Pointer to a ULONG.
              PULONGLONG: :pointer, # Pointer to a ULONGLONG.
              PULONG_PTR: :pointer, # Pointer to a ULONG_PTR.
              PULONG32:   :pointer, # Pointer to a ULONG32.
              PULONG64:   :pointer, # Pointer to a ULONG64.
              PUSHORT:    :pointer, # Pointer to a USHORT.
              PVOID:      :pointer, # Pointer to any type.
              PWCHAR:     :pointer, # Pointer to a WCHAR.
              PWORD:      :pointer, # Pointer to a WORD.
              PWSTR:      :pointer, # Pointer to a null- terminated string of 16-bit Unicode characters.
              # For more information, see Character Sets Used By Fonts.
              SC_HANDLE:  :ulong, # (L) Handle to a service control manager database.
              # See SCM Handles http://msdn.microsoft.com/en-us/library/ms685104%28VS.85%29.aspx
              SC_LOCK:    :pointer, # Lock to a service control manager database. For more information, see SCM Handles.
              SERVICE_STATUS_HANDLE: :ulong, # (L) Handle to a service status value. See SCM Handles.
              SHORT:     :short, # A 16-bit integer. The range is –32768 through 32767 decimal.
              SIZE_T:    :ulong, #  The maximum number of bytes to which a pointer can point. Use for a count that must span the full range of a pointer.
              SSIZE_T:   :long, # Signed SIZE_T.
              TBYTE:     :short, # A WCHAR if UNICODE is defined, a CHAR otherwise.TCHAR:
              TCHAR:     :short, # A WCHAR if UNICODE is defined, a CHAR otherwise.TCHAR:
              UCHAR:     :uchar, # Unsigned CHAR (8 bit)
              UHALF_PTR: :uint, # Unsigned HALF_PTR. Use within a structure that contains a pointer and two small fields.
              UINT:      :uint, # Unsigned INT. The range is 0 through 4294967295 decimal.
              UINT_PTR:  :uint, # Unsigned INT_PTR.
              UINT32:    :uint32, # Unsigned INT32. The range is 0 through 4294967295 decimal.
              UINT64:    :uint64, # Unsigned INT64. The range is 0 through 18446744073709551615 decimal.
              ULONG:     :ulong, # Unsigned LONG. The range is 0 through 4294967295 decimal.
              ULONGLONG: :ulong_long, # 64-bit unsigned integer. The range is 0 through 18446744073709551615 decimal.
              ULONG_PTR: :ulong, # Unsigned LONG_PTR.
              ULONG32:   :uint32, # Unsigned INT32. The range is 0 through 4294967295 decimal.
              ULONG64:   :uint64, # Unsigned LONG64. The range is 0 through 18446744073709551615 decimal.
              UNICODE_STRING: :pointer, # Pointer to some string structure??
              USHORT:    :ushort, # Unsigned SHORT. The range is 0 through 65535 decimal.
              USN:    :ulong_long, # Update sequence number (USN).
              VOID:   [], # Any type ? Only use it to indicate no arguments or no return value
              WCHAR:  :ushort, # 16-bit Unicode character. For more information, see Character Sets Used By Fonts.
              # In WinNT.h: typedef wchar_t WCHAR;
              #WINAPI: K,      # Calling convention for system functions. WinDef.h: define WINAPI __stdcall
              WORD: :ushort, # 16-bit unsigned integer. The range is 0 through 65535 decimal.
              WPARAM: :uint    # Message parameter. WinDef.h as follows: typedef UINT_PTR WPARAM;
      }

      ##
      # Defines new method wrappers for Windows API function call:
      #   - Defines method with original (CamelCase) API function name and original signature (matches MSDN description)
      #   - Defines method with snake_case name (converted from CamelCase function name) with enhanced API signature
      #       When defined snake_case method is called, it converts the arguments you provided into ones required by
      #       original API (adding defaults, mute and transitory args as necessary), executes API function call
      #       and (optionally) transforms the result before returning it. If a block is attached to
      #       method invocation, raw result is yielded to this block before final transformation take place
      #   - Defines aliases for enhanced method with more Rubyesque names for getters, setters and tests:
      #       GetWindowText -> window_test, SetWindowText -> window_text=, IsZoomed -> zoomed?
      #
      # You may modify default behavior of defined method by providing optional &def_block to function.
      #   If you do so, snake_case method is defined based on your def_block. It receives callable API
      #   object for function being defined, arguments and (optional) runtime block with which the method
      #   will be called. Results coming from &def_block are then transformed and returned.
      #   So, your &def_block should define all the behavior of defined method. You can use define_block to:
      #   - Change original signature of API function, provide argument defaults, check argument types
      #   - Pack arguments into strings/structs for [in] or [in/out] parameters that expect a pointer
      #   - Allocate buffers/structs for pointers required by API functions [out] parameters
      #   - Unpack [out] and [in/out] parameters returned as pointers
      #   - Explicitly return results of API call that are returned in [out] and [in/out] parameters
      #   - Convert attached runtime blocks into callback functions and stuff them into [in] callback parameters
      #   - do other stuff that you think is appropriate to make Windows API function behavior more Ruby-like
      #
      # Accepts following options:
      #   :dll:: Use this dll instead of default 'user32'
      #   :rename:: Use this name instead of standard (conventional) function name
      #   :alias(es):: Provides additional alias(es) for defined method
      #   :boolean:: Forces method to return true/false instead of nonzero/zero
      #   :zeronil:: Forces method to return nil if function result is zero
      #
      def function(name, params, returns, options={}, &def_block)
        method_name, effective_names, aliases = generate_names(name, options)
        params, returns = generate_signature(params, returns)
        libs = ffi_libraries.map(&:name)
        boolean = options[:boolean]
        zeronil = options[:zeronil]

        effective_name = effective_names.inject(nil) do |func, ename|
          func || begin
            attach_function(name, ename, params.dup, returns) # creates basic CamelCase method via FFI
            ename
          rescue FFI::NotFoundError
            nil
          end
        end

        raise Win::Errors::NotFoundError.new(name, libs) unless effective_name

        # Create API object that holds information about function names, params, etc
        api = API.new(namespace, name, effective_name, params, returns, libs)

        method_body = if def_block
          if zeronil
            ->(*args, &block){ (res = def_block.(api, *args, &block)) != 0 ? res : nil }
          elsif boolean
            ->(*args, &block){ def_block.(api, *args, &block) != 0 }
          else
            ->(*args, &block){ def_block.(api, *args, &block) }
          end
        else
          if zeronil
            ->(*args, &block){ (res = block ? block[api[*args]] : api[*args]) != 0 ? res : nil }
          elsif boolean
            ->(*args, &block){ block ? block[api[*args]] : api[*args] != 0 }
          else
            ->(*args, &block){ block ? block[api[*args]] : api[*args] }
          end
        end

        define_method method_name, &method_body       # define snake_case method

        aliases.each {|ali| alias_method ali, method_name }  # define aliases
        api   #return api object from function declaration
      end

      ##
      # Generates possible effective names for function in Win32 dll (name+A/W),
      # Rubyesque name and aliases for method(s) defined based on function name,
      # sets boolean flag for test functions (Is...)
      #
      def generate_names(name, options={})
        effective_names = [name]
        effective_names += ["#{name}A", "#{name}W"] unless name =~ /[WA]$/
        aliases = ([options[:alias]] + [options[:aliases]]).flatten.compact
        method_name = options[:rename] || name.snake_case
        case method_name
          when /^is_/
            aliases << method_name.sub(/^is_/, '') + '?'
            options[:boolean] = true
          when /^set_/
            aliases << method_name.sub(/^set_/, '')+ '='
          when /^get_/
            aliases << method_name.sub(/^get_/, '')
        end
        [method_name, effective_names, aliases]
      end

      ##
      # Generates params and returns (signature) containing only FFI-compliant types
      #
      def generate_signature(params, returns)
        params = params.split(//) if params.respond_to?(:split) # Convert params string into array
        params.map! {|param| TYPES[param.to_sym] || param} # Convert chars into FFI type symbols
        returns = TYPES[returns.to_sym] || returns # Convert chars into FFI type symbols
        [params, returns]
      end

      ##
      # Wrapper for FFI::Library#callback() that converts Win32/shortcut types into FFI format
      #
      def callback(name, params, returns)
        params, returns = generate_signature(params, returns)
        ffi_callback name.to_sym, params, returns
      end

      ##
      # Ensures that args count is equal to params count plus diff
      #
      def enforce_count(args, params, diff = 0)
        num_args = args.size
        num_params = params.size + diff #params == 'V' ? 0 : params.size + diff
        if num_args != num_params
          raise ArgumentError, "wrong number of arguments (#{num_args} for #{num_params})"
        end
      end

      ##
      # Returns string buffer - used to supply string pointer reference to API functions
      #
      def buffer(size = 1024, code = "\x00")
        code * size
      end

      ##
      # :method: namespace
      # This method is meta-generated when Win::Library module is included into other module/class
      # It returns reference to including (host) module for use by Win::Library::API and class methods.

      ##
      # Returns array of given args if none of them is zero,
      # if any arg is zero, returns array of nils
      #
      def nonzero_array(*args)
        args.any?{|arg| arg == 0 } ? args.map{||nil} : args
      end


    end

    ##
    # Hook executed when Win::Library is included into class or module. It extends host class/module
    # with both FFI::Library methods and Win::Library macro methods like 'function'.
    def self.included(klass)
      klass.extend FFI::Library

      eigenklass = class << klass; self; end  # Extracting host class's eigenclass
      eigenklass.class_eval "
        alias_method :ffi_callback, :callback
        def namespace; #{klass}; end"

      klass.extend ClassMethods
      klass.ffi_lib 'user32', 'kernel32'  # Default libraries
      klass.ffi_convention :stdcall
    end

  end
end