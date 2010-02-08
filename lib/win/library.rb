require 'ffi'
require 'win/extensions'

module Win

  class NotFoundError < NameError
    def initialize(name=nil, libs=nil)
      super %Q[Function #{name ? "'#{name}' ": ""}not found#{libs ? " in #{libs}" : ""}"]
    end
  end

  module Library

    # Class Win::Library::API mimics Win32::API
    class API

      # The name of the DLL that exports the API function
      attr_reader :dll_name

      # Ruby (library) module to which this function is attached
      attr_reader :lib_module

      # The name of the function passed to the constructor
      attr_reader :function_name

      # The name of the actual function that is returned by the constructor.
      # For example, if you passed 'GetUserName' to the constructor, then the
      # effective function name would be either 'GetUserNameA' or 'GetUserNameW'.
      attr_accessor :effective_function_name

      # The prototype, returned as an array of FFI types
      attr_reader :prototype

      # The return type (:void for no return value)
      attr_reader :return_type

      def initialize( lib_module, function, effective_function_name, prototype, return_type )
        @lib_module = lib_module
        @function_name = function
        @effective_function_name = effective_function_name
        @prototype = prototype
        @return_type = return_type
      end

      def call( *args )
        @lib_module.send(@effective_function_name.to_sym, *args)
      end
    end

    # Contains class methods (macros) to be used in Win::Libraries
    module ClassMethods
      TYPES = {
              V: :void, # For functions that return nothing (return type void).
              v: :void, # For functions that return nothing (return type void).
              C: :uchar, #– 8-bit unsigned character (byte)
              c: :char, # 8-bit character (byte)
              # :int8 – 8-bit signed integer
              # :uint8 – 8-bit unsigned integer
              S: :ushort, # – 16-bit unsigned integer (Win32API: used for string)
              s: :short, # – 16-bit signed integer
              # :uint16 – 16-bit unsigned integer
              # :int16 – 16-bit signed integer
              I: :uint, # 32-bit unsigned integer
              i: :int, # 32-bit signed integer
              # :uint32 – 32-bit unsigned integer
              # :int32 – 32-bit signed integer
              L: :ulong, # unsigned long int – platform-specific size
              l: :long, # long int – platform-specific size (http://groups.google.com/group/ruby-ffi/browse_thread/thread/4762fc77130339b1)
              # :int64 – 64-bit signed integer
              # :uint64 – 64-bit unsigned integer
              # :long_long – 64-bit signed integer
              # :ulong_long – 64-bit unsigned integer
              F: :float, # 32-bit floating point
              D: :double, # 64-bit floating point (double-precision)
              P: :pointer, # pointer – platform-specific size
              p: :string, # C-style (NULL-terminated) character string (Win32API: S)
              B: :bool # (?? 1 byte in C++)
              #For function argument type only:
              # :buffer_in – Similar to :pointer, but optimized for Buffers that the function can only read (not write).
              # :buffer_out – Similar to :pointer, but optimized for Buffers that the function can only write (not read).
              # :buffer_inout – Similar to :pointer, but may be optimized for Buffers.
              # :varargs – Variable arguments
      }

      ##
      # Defines new method wrappers for Windows API function call:
      #   - Defines method with original (CamelCase) API function name and original signature (matches MSDN description)
      #   - Defines method with snake_case name (converted from CamelCase function name) with enhanced API signature
      #       When the defined wrapper method is called, it checks the argument count, executes underlying API
      #       function call and (optionally) transforms the result before returning it. If block is attached to
      #       method invocation, raw result is yielded to this block before final transformations
      #   - Defines aliases for enhanced method with more Rubyesque names for getters, setters and tests:
      #       GetWindowText -> window_test, SetWindowText -> window_text=, IsZoomed -> zoomed?
      #
      # You may modify default behavior of defined method by providing optional &define_block to def_api.
      #   If you do so, instead of directly calling API function, defined method just yields callable api
      #   object, arguments and (optional) runtime block to your &define_block and returns result coming out of it.
      #   So, &define_block should define all the behavior of defined method. You can use define_block to:
      #   - Change original signature of API function, provide argument defaults, check argument types
      #   - Pack arguments into strings for [in] or [in/out] parameters that expect a pointer
      #   - Allocate string buffers for pointers required by API functions [out] parameters
      #   - Unpack [out] and [in/out] parameters returned as pointers
      #   - Explicitly return results of API call that are returned in [out] and [in/out] parameters
      #   - Convert attached runtime blocks into callback functions and stuff them into [in] callback parameters
      #
      # Accepts following options:
      #   :dll:: Use this dll instead of default 'user32'
      #   :rename:: Use this name instead of standard (conventional) function name
      #   :alias(es):: Provides additional alias(es) for defined method
      #   :boolean:: Forces method to return true/false instead of nonzero/zero
      #   :zeronil:: Forces method to return nil if function result is zero
      #
      def function(function, params, returns, options={}, &define_block)
        method_name, effective_names, aliases = generate_names(function, options)
        boolean = options[:boolean]
        zeronil = options[:zeronil]
        params = params.split(//) if params.respond_to?(:split) # Convert params string into array
#puts "#{method_name}, #{effective_names}, #{aliases}"
        params.map! {|param| TYPES[param.to_sym] || param} # Convert chars into FFI type symbols
        returns = TYPES[returns.to_sym] || returns # Convert chars into FFI type symbols

        effective = effective_names.inject(nil) do |func, ename|
          func || begin
#p ename, params, returns
            attach_function(ename, params.dup, returns)
            ename
          rescue FFI::NotFoundError
            nil
          end
        end

        raise Win::NotFoundError.new(function, ffi_libraries.map(&:name)) unless effective

        api = API.new(self, function, effective, params, returns)

        define_method(function) {|*args| api.call(*args)} # define CamelCase method wrapper for api call

        if define_block
          define_method(method_name) do |*args, &runtime_block|
            define_block[api, *args, &runtime_block]
          end
        else
          define_method(method_name) do |*args, &runtime_block|    # define snake_case method with enhanced api
            namespace.enforce_count(args, params)
            result = api.call(*args)
            result = runtime_block[result] if runtime_block
            return result != 0 if boolean         # Boolean function returns true/false instead of nonzero/zero
            return nil if zeronil && result == 0  # Zeronil function returns nil instead of zero
            result
          end
        end
        aliases.each {|ali| alias_method ali, method_name }        # define aliases
        api  # return API object
      end

      # Generates possible effective names for function in Win32 dll (function+A/W),
      # Rubyesque name and aliases for method(s) defined based on function name,
      # sets boolean flag for test functions (Is...)
      #
      def generate_names(function, options={})
        effective_names = [function]
        effective_names += ["#{function}A", "#{function}W"] unless function =~ /[WA]$/
        aliases = ([options[:alias]] + [options[:aliases]]).flatten.compact
        method_name = options[:rename] || function.snake_case
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

      # Ensures that args count is equal to params count plus diff
      #
      def enforce_count(args, params, diff = 0)
        num_args = args.size
        num_params = params.size + diff #params == 'V' ? 0 : params.size + diff
        if num_args != num_params
          raise ArgumentError, "wrong number of arguments (#{num_args} for #{num_params})"
        end
      end
    end

    #extend ClassMethods

    def self.included(klass)
      klass.extend ClassMethods
      klass.extend FFI::Library
      klass.ffi_lib 'user32', 'kernel32'  # Default libraries
      klass.ffi_convention :stdcall
      klass.class_eval "def namespace; #{klass}; end"
    end
  end
end