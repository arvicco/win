require 'spec_helper'
require 'win/library'
require 'win/gui/message'

module LibraryTest
#  include my_lib
#  include WinTest


  shared_examples_for 'defining macro with options' do

    context 'basic behavior' do
      it 'defines new instance methods with appropriate names' do
        @my_lib.function :FindWindow, 'PP', 'L', &@def_block
        @my_lib.respond_to?(:FindWindow).should be_true
        @my_lib.respond_to?(:find_window).should be_true
      end

      it 'returns underlying Win32::API object' do
        FWAPI = @my_lib.function :FindWindow, 'PP', 'L', &@def_block
        should_be :find_window, FWAPI
      end
    end

    context 'renaming and aliasing' do
      it ':camel_name option overrides default CamelCase name for attached function but leaves snake_case intact' do
        @my_lib.function :FindWindow, 'PP', 'L', camel_name: 'MyOwnName', &@def_block
        expect { @my_lib.find_window(nil, nil) }.to_not raise_error
        expect { @my_lib.FindWindow(nil, nil) }.to raise_error NoMethodError
        expect { @my_lib.MyOwnName(nil, nil) }.to_not raise_error
      end

      it ':snake_name option overrides default snake_case name for defined method but leaves CamelCase intact' do
        @my_lib.function :FindWindow, 'PP', 'L', snake_name: 'my_own_find', &@def_block
        expect { @my_lib.find_window(nil, nil) }.to raise_error NoMethodError
        expect { @my_lib.FindWindow(nil, nil) }.to_not raise_error
        expect { @my_lib.my_own_find(nil, nil) }.to_not raise_error
      end

      it 'both :snake_name and :camel_name option can be used in one declaration' do
        @my_lib.function :FindWindow, 'PP', 'L', camel_name: 'MyOwnName', snake_name: 'my_own_find', &@def_block
        expect { @my_lib.find_window(nil, nil) }.to raise_error NoMethodError
        expect { @my_lib.my_own_find(nil, nil) }.to_not raise_error
        expect { @my_lib.FindWindow(nil, nil) }.to raise_error NoMethodError
        expect { @my_lib.MyOwnName(nil, nil) }.to_not raise_error
      end

      it ':camel_only option means no snake_case method will be defined' do
        @my_lib.function :FindWindow, 'PP', 'L', camel_only: true, &@def_block
        expect { @my_lib.find_window(nil, nil) }.to raise_error NoMethodError
        expect { @my_lib.FindWindow(nil, nil) }.to_not raise_error
      end

      it 'automatically adds Rubyesque alias to IsXxx API test function' do
        @my_lib.function 'IsWindow', 'L', 'B', &@def_block
        @my_lib.respond_to?(:window?).should be_true
        @my_lib.respond_to?(:is_window).should be_true
      end

      it 'automatically adds Rubyesque alias to GetXxx API getter function' do
        @my_lib.function 'GetForegroundWindow', [], 'L', &@def_block
        @my_lib.respond_to?(:get_foreground_window).should be_true
        @my_lib.respond_to?(:foreground_window).should be_true
      end

      it ':alias option adds alias for defined snake_case method' do
        @my_lib.function(:FindWindow, 'PP', 'L', :alias => 'my_own_find', &@def_block)
        expect { @my_lib.find_window(nil, nil) }.to_not raise_error
        expect { @my_lib.my_own_find(nil, nil) }.to_not raise_error
      end

      it ':aliases option adds aliases for defined snake_case method' do
        @my_lib.function :FindWindow, 'PP', 'L', :aliases => ['my_own_find', 'my_own_find1'], &@def_block
        expect { @my_lib.find_window(nil, nil) }.to_not raise_error
        expect { @my_lib.my_own_find(nil, nil) }.to_not raise_error
        expect { @my_lib.my_own_find1(nil, nil) }.to_not raise_error
      end
    end

    context ':boolean option converts result to boolean' do
      before(:each) { @my_lib.function :FindWindow, 'PP', 'L', :boolean => true, &@def_block }

      it 'defines new method on @my_lib' do
        @my_lib.respond_to?(:find_window).should be_true
        @my_lib.respond_to?(:FindWindow).should be_true
      end

      it 'defined snake_case method returns false/true instead of zero/non-zero' do
        @my_lib.find_window(nil, nil).should == true
        @my_lib.find_window(nil, IMPOSSIBLE).should == false
      end

      it 'defined CamelCase method still returns zero/non-zero' do
        @my_lib.FindWindow(nil, nil).should_not == true
        @my_lib.FindWindow(nil, nil).should_not == 0
        @my_lib.FindWindow(nil, IMPOSSIBLE).should == 0
      end
    end

    context 'defining API with :fails option converts zero result to nil' do
      before(:each) { @my_lib.function :FindWindow, 'PP', 'L', fails: 0, &@def_block }

      it 'defines new instance method' do
        @my_lib.respond_to?(:find_window).should be_true
        @my_lib.respond_to?(:FindWindow).should be_true
      end

      it 'defined CamelCase method still returns zero/non-zero' do
        @my_lib.FindWindow(nil, nil).should_not == true
        @my_lib.FindWindow(nil, nil).should_not == 0
        @my_lib.FindWindow(nil, IMPOSSIBLE).should == 0
      end

      it 'defined method returns nil (but NOT false) instead of zero' do
        @my_lib.find_window(nil, IMPOSSIBLE).should_not == false
        @my_lib.find_window(nil, IMPOSSIBLE).should == nil
      end

      it 'defined method does not return true when result is non-zero' do
        @my_lib.find_window(nil, nil).should_not == true
        @my_lib.find_window(nil, nil).should_not == 0
      end
    end

    context 'using DLL other than default user32, kernel32 with :dll option' do
      before(:each) { @my_lib.function 'GetUserName', 'PP', 'I', :dll=> 'advapi32', &@def_block }

      it 'defines new instance method with appropriate name' do
        @my_lib.respond_to?(:GetUserName).should be_true
        @my_lib.respond_to?(:get_user_name).should be_true
        @my_obj.respond_to?(:user_name).should be_true
        @my_lib.respond_to?(:user_name).should be_true
      end

      it 'returns expected result' do
        username = ENV['USERNAME'].strip
        name_ptr = FFI::MemoryPointer.from_string(" " * 128)
        size_ptr = FFI::MemoryPointer.new(:long).write_int(name_ptr.size)
        @my_lib.get_user_name(name_ptr, size_ptr)
        name_ptr.read_string.strip.should == username
      end
    end
  end

  describe Win::Library, ' defines wrappers for Win32::API functions' do
    def should_be symbol, api
      case symbol
        when :find_window
          api.dll.should include "user32" # The name of the DLL that exports the API function
          api.effective_function_name.should == :FindWindowA # Actual function: 'GetUserName' ->'GetUserNameA' or 'GetUserNameW'
          api.function_name.should == :FindWindow # The name of the function passed to the constructor
          api.prototype.should == [:pointer, :pointer] # The prototype, returned as an array of characters
          api.return_type.should == :ulong # The prototype, returned as an array of characters
      end
    end

    def should_count_args(*methods, rights, wrongs)
      rights = [rights].flatten
      wrongs = [wrongs].flatten
      methods.each do |method|
        (0..8).each do |n|
          if n == rights.size
            expect { @my_lib.send method, *rights }.to_not raise_error
          else
            args = (1..n).map { wrongs[rand(wrongs.size)] }
            expect { @my_lib.send method, *args }.
                to raise_error "wrong number of arguments (#{args.size} for #{rights.size})"
          end
        end
      end
    end

    def any_handle
      @my_lib.function :FindWindow, 'PP', 'L' unless respond_to? :find_window
      @my_lib.find_window(nil, nil)
    end

    def recreate_library
      @my_lib = Module.new
      @my_lib.extend Win::Library
      @my_class = Class.new
      @my_class.send :include, @my_lib
      @my_obj = @my_class.new
    end

    before(:each) { recreate_library }

    describe '::attach_function - delegates to FFI::Library::attach_function' do
      it 'can be used to attach same function with different signatures' do
        @my_lib.attach_function :send_one, :SendMessageA, [:ulong, :uint, :uint, :long], :int
        @my_lib.attach_function :send_two, :SendMessageA, [:ulong, :uint, :uint, :pointer], :int
        @my_lib.respond_to?(:send_one).should be_true
        @my_lib.respond_to?(:send_two).should be_true
        @my_obj.respond_to?(:send_one).should be_true
        @my_obj.respond_to?(:send_two).should be_true
      end
    end

    describe '::function - attaches external API function and defines enhanced snake_case method on top of it' do
      spec { use { @my_lib.function(:FindWindow, 'PP', 'l', aliases: nil, boolean: nil, fails: 0, &any_block) } }

      context 'defining enhanced API function without definition block (using defaults)' do
        it_should_behave_like 'defining macro with options'

        it 'constructs argument prototype from uppercase string, enforces the args count' do
          expect { @my_lib.function :FindWindow, 'PP', 'L' }.to_not raise_error
          should_count_args :find_window, :FindWindow, [nil, nil], [nil, IMPOSSIBLE, 'cmd']
        end

        it 'constructs argument prototype from (mixed) array, enforces the args count' do
          expect { @my_lib.function :FindWindow, [:pointer, 'P'], 'L' }.to_not raise_error
          should_count_args :find_window, :FindWindow, [nil, nil], [nil, IMPOSSIBLE, 'cmd']
        end

        it 'defined snake_case method returns expected value when called' do
          @my_lib.function :FindWindow, 'PP', 'L'
          @my_lib.find_window(nil, nil).should_not == 0
          @my_lib.find_window(nil, IMPOSSIBLE).should == 0
          @my_lib.find_window(IMPOSSIBLE, nil).should == 0
          @my_lib.find_window(IMPOSSIBLE, IMPOSSIBLE).should == 0
        end

        it 'defined CamelCase method returns expected value when called' do
          @my_lib.function :FindWindow, 'PP', 'L'
          @my_lib.FindWindow(nil, nil).should_not == 0
          @my_lib.FindWindow(nil, IMPOSSIBLE).should == 0
          @my_lib.FindWindow(IMPOSSIBLE, nil).should == 0
          @my_lib.FindWindow(IMPOSSIBLE, IMPOSSIBLE).should == 0
        end
      end

      context 'defining API function using explicit definition block' do
        before(:each) do
          @def_block = lambda { |api, *args| api.call(*args) } # Trivial define_block for shared examples
        end

        it_should_behave_like 'defining macro with options'

        it 'does not enforce argument count outside of block' do
          @my_lib.function(:FindWindow, 'PP', 'L') { |api, *args|}
          expect { @my_lib.find_window }.to_not raise_error
          expect { @my_lib.find_window(nil) }.to_not raise_error
          expect { @my_lib.find_window(nil, 'Str', 1) }.to_not raise_error
        end

        it 'returns block return value when defined method is called' do
          @my_lib.function(:FindWindow, 'PP', 'L') { |api, *args| 'Value' }
          @my_lib.find_window(nil).should == 'Value'
        end

        it 'passes arguments and underlying Win32::API object to the block' do
          @my_lib.function(:FindWindow, 'PP', 'L') do |api, *args|
            @api  = api
            @args = args
          end
          expect { @my_lib.find_window(1, 2, 3) }.to_not raise_error
          @args.should == [1, 2, 3]
          should_be :find_window, @api
        end
      end

      context 'defining API function with alternative signature' do
        before(:each) do
          @def_block = nil
          @my_lib.function :SendMessage, [:ulong, :uint, :uint, :pointer], :int,
                         alternative: [[:ulong, :uint, :uint, :long], :int,
                                       ->(*args){ Integer === args.last }]
        end

        it 'defines camel and snake methods (as well as hidden Original/Alternative methods)' do
          expect { @my_lib.send_message(any_handle, Win::Gui::Message::WM_GETTEXT,
                                      buffer.size, buffer) }.to_not raise_error
          expect {
            @my_lib.send_message(any_handle, Win::Gui::Message::WM_GETTEXT, buffer.size, buffer.address)
          }.to_not raise_error
        end

        it 'defines camel and snake methods that work with both signatures' do
          @my_obj.respond_to?(:SendMessage).should be_true
          @my_obj.respond_to?(:send_message).should be_true
          @my_obj.respond_to?(:SendMessageOriginal).should be_true
          @my_obj.respond_to?(:SendMessageAlternative).should be_true
          @my_lib.respond_to?(:SendMessage).should be_true
          @my_lib.respond_to?(:send_message).should be_true
          @my_lib.respond_to?(:SendMessageOriginal).should be_true
          @my_lib.respond_to?(:SendMessageAlternative).should be_true
        end
      end

      context 'trying to define an invalid API function' do
        it 'raises error when trying to define function with a wrong function name' do
          expect { @my_lib.function 'FindWindowImpossible', 'PP', 'L' }.
              to raise_error(/Function 'FindWindowImpossible' not found/)
        end
      end

      context 'calling defined methods with attached block to preprocess the API function results' do
        it 'defined method yields raw result to block attached to its invocation' do
          @my_lib.function :FindWindow, 'PP', 'L', fails: 0
          @my_obj.find_window(nil, IMPOSSIBLE) { |result| result.should == 0 }
        end

        it 'defined method returns result of block attached to its invocation' do
          @my_lib.function :FindWindow, 'PP', 'L', fails: 0
          return_value = @my_obj.find_window(nil, IMPOSSIBLE) { |result| 'Value' }
          return_value.should == 'Value'
        end

        it 'defined method transforms result of block before returning it' do
          @my_lib.function :FindWindow, 'PP', 'L', fails: 0
          return_value = @my_obj.find_window(nil, IMPOSSIBLE) { |result| 0 }
          return_value.should_not == 0
          return_value.should == nil
        end
      end

      context 'defining API function without arguments - f(VOID)' do
        it 'should enforce argument count to 0, NOT 1' do
          @my_lib.function :GetForegroundWindow, [], 'L', fails: 0
          p (@my_lib.methods-Win::Library.methods).sort
          p (@my_obj.methods-Win::Library.methods).sort
          should_count_args :GetForegroundWindow, :get_foreground_window, :foreground_window, [], [nil, 0, 123]
        end
      end

      context 'defining API function that has original snake_case name' do
        it 'should define original function in (generated) CamelCase' do
          @my_lib.function :keybd_event, [:char, :char, :ulong, :ulong], :void
          expect {
            @my_obj.KeybdEvent(Win::Gui::Input::VK_CONTROL, 0, Win::Gui::Input::KEYEVENTF_KEYDOWN, 0)
          }.to_not raise_error
          expect {
            @my_obj.keybd_event(Win::Gui::Input::VK_CONTROL, 0, Win::Gui::Input::KEYEVENTF_KEYUP, 0)
          }.to_not raise_error
        end
      end
    end

    context '::callback defining API callback TYPES' do
      it '#callback macro defines a valid callback TYPE' do
        expect { @my_lib.callback :MyEnumWindowsProc, [:HWND, :long], :bool }.to_not raise_error
      end

      it 'pre-defined callback type can be used to define API functions (expecting callback)' do
        @my_lib.callback :MyEnumWindowsProc, [:HWND, :long], :bool
        expect { @my_lib.function :EnumWindows, [:MyEnumWindowsProc, :long], :long }.to_not raise_error
        expect { @my_lib.function :EnumWindows, [:UndefinedProc, :long], :long }.to raise_error TypeError
      end

      it 'API function expecting callback accept lambdas representing callback' do
        @my_lib.callback :MyEnumWindowsProc, [:HWND, :long], :bool
        @my_lib.function :EnumWindows, [:MyEnumWindowsProc, :long], :long
        expect { @my_obj.enum_windows(lambda { |handle, message| true }, 0) }.to_not raise_error
      end
    end

    context '::try_function - possibly defines API functions that are platform-specific' do
      if os_xp?
        it 'silently fails to define function not present on current platform' do
          expect { @my_lib.function :GetErrorMode, [], :UINT }.to raise_error /Function 'GetErrorMode' not found/
          expect { @my_lib.try_function :GetErrorMode, [], :UINT }.to_not raise_error
          expect { @my_obj.GetErrorMode() }.to raise_error /undefined method `GetErrorMode'/
          expect { @my_obj.get_error_mode() }.to raise_error /undefined method `get_error_mode'/
        end
      end
    end
  end
end