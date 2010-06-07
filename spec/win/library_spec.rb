require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'win/library'

module WinLibraryTest

  include WinTest

  module MyLib # namespace for defined functions
    extend Win::Library
  end
  include MyLib

  def should_be symbol, api
    case symbol
      when :find_window
        api.dll.should == ["user32", "kernel32"] # The name of the DLL that exports the API function
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
          expect {send method, *rights}.to_not raise_error
        else
          args = (1..n).map {wrongs[rand(wrongs.size)]}
          expect {send method, *args}.
                  to raise_error "wrong number of arguments (#{args.size} for #{rights.size})"
        end
      end
    end
  end

  def any_handle
    MyLib.function :FindWindow, 'PP', 'L' unless respond_to? :find_window
    find_window(nil, nil)
  end

  def redefined_methods
    [:FindWindow, :IsWindow, :EnumWindows, :GetComputerName, :GetForegroundWindow, :keybd_event]
  end

  def hide_method(*names) # hide original method(s) if it is defined
    names.map(&:to_s).each do |name|
      MyLib.module_eval do
        aliases = generate_names(name).flatten + [name]
        aliases.map(&:to_s).each do |ali|
          if method_defined? ali
            alias_method "original_#{ali}".to_sym, ali
            remove_method ali
          end
        end
      end
    end
  end

  def restore_method(*names) # restore original method if it was hidden
    names.map(&:to_s).each do |name|
      MyLib.module_eval do
        aliases = generate_names(name).flatten + [name]
        aliases.map(&:to_s).each do |ali|
          temp = "original_#{ali}".to_sym
          if method_defined? temp
            alias_method ali, temp
            remove_method temp
          end
        end
      end
    end
  end

  shared_examples_for 'defining macro with options' do
    context 'basic behavior' do
      it 'defines new instance methods with appropriate names' do
        MyLib.function :FindWindow, 'PP', 'L', &@def_block
        MyLib.respond_to?(:FindWindow).should be_true
        respond_to?(:FindWindow).should be_true
        MyLib.respond_to?(:find_window).should be_true
        respond_to?(:find_window).should be_true
      end

      it 'returns underlying Win32::API object' do
        FWAPI = MyLib.function :FindWindow, 'PP', 'L', &@def_block
        should_be :find_window, FWAPI
      end
    end

    context 'renaming and aliasing' do
      it ':snake_name option overrides default snake_case name for defined method but leaves CamelCase intact' do
        MyLib.function :FindWindow, 'PP', 'L', snake_name: 'my_own_find', &@def_block
        expect {find_window(nil, nil)}.to raise_error NoMethodError
        expect {FindWindow(nil, nil)}.to_not raise_error
        expect {my_own_find(nil, nil)}.to_not raise_error
      end

      it ':camel_name option overrides default CamelCase name for attached function but leaves snake_case intact' do
        MyLib.function :FindWindow, 'PP', 'L', camel_name: 'MyOwnName', &@def_block
        expect {find_window(nil, nil)}.to_not raise_error
        expect {FindWindow(nil, nil)}.to raise_error NoMethodError
        expect {MyOwnName(nil, nil)}.to_not raise_error
      end

      it 'both :snake_name and :camel_name option can be used in one declaration' do
        MyLib.function :FindWindow, 'PP', 'L', camel_name: 'MyOwnName', snake_name: 'my_own_find', &@def_block
        expect {find_window(nil, nil)}.to raise_error NoMethodError
        expect {my_own_find(nil, nil)}.to_not raise_error
        expect {FindWindow(nil, nil)}.to raise_error NoMethodError
        expect {MyOwnName(nil, nil)}.to_not raise_error
      end

      it 'automatically adds Rubyesque alias to IsXxx API test function' do
        MyLib.function 'IsWindow', 'L', 'B', &@def_block
        respond_to?(:window?).should be_true
        respond_to?(:is_window).should be_true
      end

      it 'automatically adds Rubyesque alias to GetXxx API getter function' do
        MyLib.function 'GetComputerName', 'PP', 'I', :dll=> 'kernel32', &@def_block
        respond_to?(:get_computer_name).should be_true
        respond_to?(:computer_name).should be_true
      end

      it ':alias option adds alias for defined snake_case method' do
        MyLib.function( :FindWindow, 'PP', 'L', :alias => 'my_own_find', &@def_block)
        expect {find_window(nil, nil)}.to_not raise_error
        expect {my_own_find(nil, nil)}.to_not raise_error
      end

      it ':aliases option adds aliases for defined snake_case method' do
        MyLib.function :FindWindow, 'PP', 'L', :aliases => ['my_own_find', 'my_own_find1'], &@def_block
        expect {find_window(nil, nil)}.to_not raise_error
        expect {my_own_find(nil, nil)}.to_not raise_error
        expect {my_own_find1(nil, nil)}.to_not raise_error
      end
    end

    context ':boolean option converts result to boolean' do
      before(:each) { MyLib.function :FindWindow, 'PP', 'L', :boolean => true, &@def_block }

      it 'defines new instance method' do
        respond_to?(:find_window).should be_true
        respond_to?(:FindWindow).should be_true
      end

      it 'defined snake_case method returns false/true instead of zero/non-zero' do
        find_window(nil, nil).should == true
        find_window(nil, IMPOSSIBLE).should == false
      end

      it 'defined CamelCase method still returns zero/non-zero' do
        FindWindow(nil, nil).should_not == true
        FindWindow(nil, nil).should_not == 0
        FindWindow(nil, IMPOSSIBLE).should == 0
      end
    end

    context 'defining API with :zeronil option converts zero result to nil' do
      before(:each) {MyLib.function :FindWindow, 'PP', 'L', :zeronil => true, &@def_block}

      it 'defines new instance method' do
        respond_to?(:find_window).should be_true
        respond_to?(:FindWindow).should be_true
      end

      it 'defined CamelCase method still returns zero/non-zero' do
        FindWindow(nil, nil).should_not == true
        FindWindow(nil, nil).should_not == 0
        FindWindow(nil, IMPOSSIBLE).should == 0
      end

      it 'defined method returns nil (but NOT false) instead of zero' do
        find_window(nil, IMPOSSIBLE).should_not == false
        find_window(nil, IMPOSSIBLE).should == nil
      end

      it 'defined method does not return true when result is non-zero' do
        find_window(nil, nil).should_not == true
        find_window(nil, nil).should_not == 0
      end
    end

    context 'using DLL other than default user32 with :dll option' do
      it 'defines new instance method with appropriate name' do
        MyLib.function 'GetComputerName', 'PP', 'I', :dll=> 'kernel32', &@def_block
        respond_to?(:GetComputerName).should be_true
        respond_to?(:get_computer_name).should be_true
        respond_to?(:computer_name).should be_true
      end

      it 'returns expected result' do
        MyLib.function 'GetComputerName', ['P', 'P'], 'I', :dll=> 'kernel32', &@def_block
        hostname = `hostname`.strip.upcase
        name = " " * 128
        get_computer_name(name, "128")
        name.unpack("A*").first.should == hostname
      end
    end
  end

  describe Win::Library, ' defines wrappers for Win32::API functions' do

    before(:each) { hide_method *redefined_methods } # hide original methods if  defined
    after(:each) { restore_method *redefined_methods } # restore original methods if hidden

    describe '::attach_function - delegates to FFI::Library::attach_function' do
      it 'can be used to attach same function with different signatures' do
        MyLib.attach_function :send_one, :SendMessageA, [:ulong, :uint, :uint, :long], :int
        MyLib.attach_function :send_two, :SendMessageA, [:ulong, :uint, :uint, :pointer], :int
        respond_to?(:send_one).should be_true
        respond_to?(:send_two).should be_true
        MyLib.respond_to?(:send_one).should be_true
        MyLib.respond_to?(:send_two).should be_true
      end
    end

    describe '::function - attaches external API function and defines enhanced snake_case method on top of it' do
      spec{ use{ MyLib.function(:FindWindow, 'PP', 'l', aliases: nil, boolean: nil, zeronil: nil, &any_block) }}

      context 'defining enhanced API function without defenition block (using defaults)' do
        it_should_behave_like 'defining macro with options'

        it 'constructs argument prototype from uppercase string, enforces the args count' do
          expect { MyLib.function :FindWindow, 'PP', 'L' }.to_not raise_error
          should_count_args :find_window, :FindWindow, [nil, nil], [nil, IMPOSSIBLE, 'cmd']
        end

        it 'constructs argument prototype from (mixed) array, enforces the args count' do
          expect { MyLib.function :FindWindow, [:pointer, 'P'], 'L' }.to_not raise_error
          should_count_args :find_window, :FindWindow, [nil, nil], [nil, IMPOSSIBLE, 'cmd']
        end

        it 'defined snake_case method returns expected value when called' do
          MyLib.function :FindWindow, 'PP', 'L'
          find_window(nil, nil).should_not == 0
          find_window(nil, IMPOSSIBLE).should == 0
          find_window(IMPOSSIBLE, nil).should == 0
          find_window(IMPOSSIBLE, IMPOSSIBLE).should == 0
        end

        it 'defined CamelCase method returns expected value when called' do
          MyLib.function :FindWindow, 'PP', 'L'
          FindWindow(nil, nil).should_not == 0
          FindWindow(nil, IMPOSSIBLE).should == 0
          FindWindow(IMPOSSIBLE, nil).should == 0
          FindWindow(IMPOSSIBLE, IMPOSSIBLE).should == 0
        end

#      it 'returns underlying Win32::API object if defined method is called with (:api) argument ' do
#        MyLib.function :FindWindow, 'PP', 'L'
#        expect {find_window(:api)}.to_not raise_error
#        should_be :find_window, find_window(:api)
#      end

      end

      context 'defining API function using explicit definition block' do
        before(:each) do
          @def_block = lambda{|api, *args| api.call(*args)}  # Trivial define_block for shared examples
        end

        it_should_behave_like 'defining macro with options'

        it 'does not enforce argument count outside of block' do
          MyLib.function( :FindWindow, 'PP', 'L' ){|api, *args|}
          expect { find_window }.to_not raise_error
          expect { find_window(nil) }.to_not raise_error
          expect { find_window(nil, 'Str', 1) }.to_not raise_error
        end

        it 'returns block return value when defined method is called' do
          MyLib.function( :FindWindow, 'PP', 'L' ){|api, *args| 'Value'}
          find_window(nil).should == 'Value'
        end

        it 'passes arguments and underlying Win32::API object to the block' do
          MyLib.function( :FindWindow, 'PP', 'L' ) do |api, *args|
            @api = api
            @args = args
          end
          expect {find_window(1, 2, 3) }.to_not raise_error
          @args.should == [1, 2, 3]
          should_be :find_window, @api
        end
      end

      context 'trying to define an invalid API function' do
        it 'raises error when trying to define function with a wrong function name' do
          expect { MyLib.function 'FindWindowImpossible', 'PP', 'L' }.
                  to raise_error( /Function 'FindWindowImpossible' not found/ )
        end
      end

      context 'calling defined methods with attached block to preprocess the API function results' do
        it 'defined method yields raw result to block attached to its invocation' do
          MyLib.function :FindWindow, 'PP', 'L', zeronil: true
          find_window(nil, IMPOSSIBLE) {|result| result.should == 0 }
        end

        it 'defined method returns result of block attached to its invocation' do
          MyLib.function :FindWindow, 'PP', 'L', zeronil: true
          return_value = find_window(nil, IMPOSSIBLE) {|result| 'Value'}
          return_value.should == 'Value'
        end

        it 'defined method transforms result of block before returning it' do
          MyLib.function :FindWindow, 'PP', 'L', zeronil: true
          return_value = find_window(nil, IMPOSSIBLE) {|result| 0 }
          return_value.should_not == 0
          return_value.should == nil
        end
      end

      context 'defining API function without arguments - f(VOID)' do
        it 'should enforce argument count to 0, NOT 1' do
          MyLib.function :GetForegroundWindow, [], 'L', zeronil: true
          should_count_args :GetForegroundWindow, :get_foreground_window, :foreground_window, [], [nil, 0, 123]
        end
      end

      context 'defining API function that has snake_case name' do
        it 'should define original function in (generated) CamelCase' do
          MyLib.function :keybd_event, [:char, :char, :ulong, :ulong], :void
          expect {KeybdEvent(Win::Gui::Input::VK_CONTROL, 0, Win::Gui::Input::KEYEVENTF_KEYDOWN, 0)}.to_not raise_error
          expect {keybd_event(Win::Gui::Input::VK_CONTROL, 0, Win::Gui::Input::KEYEVENTF_KEYDOWN, 0)}.to_not raise_error
        end
      end
    end

    context '::callback defining API callback TYPES' do
      it '#callback macro defines a valid callback TYPE' do
        expect { MyLib.callback :MyEnumWindowsProc, [:HWND, :long], :bool}.to_not raise_error
      end

      it 'pre-definsed callback type can be used to define API functions (expecting callback)' do
        expect {MyLib.function :EnumWindows, [:MyEnumWindowsProc, :long], :long}.to_not raise_error
        expect {MyLib.function :EnumWindows, [:UndefinedProc, :long], :long}.to raise_error TypeError
      end

      it 'API function expecting callback accept lambdas representing callback' do
        MyLib.function :EnumWindows, [:MyEnumWindowsProc, :long], :long
        expect { enum_windows(lambda{|handle, message| true }, 0) }.to_not raise_error
      end
    end

    context '::try_function - possibly defines API functions that are platform-specific' do
      if xp?
        it 'silently fails to define function not present on current platform' do
          expect {MyLib.function :GetErrorMode, [], :UINT}.to raise_error /Function 'GetErrorMode' not found/
          expect {MyLib.try_function :GetErrorMode, [], :UINT}.to_not raise_error
          expect { GetErrorMode() }.to raise_error /undefined method `GetErrorMode'/
          expect { get_error_mode() }.to raise_error /undefined method `get_error_mode'/
        end
      end
    end
  end
end