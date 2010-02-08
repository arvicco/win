require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'win/library'

module WinTest

  module MyLib # namespace for defined functions
    include Win::Library
  end
  include MyLib

  def should_be symbol, api
    case symbol
      when :find_window
        #api.dll_name.should == 'user32' # The name of the DLL that exports the API function
        api.effective_function_name.should == 'FindWindowA' # Actual function returned by the constructor: 'GetUserName' ->'GetUserNameA' or 'GetUserNameW'
        api.function_name.should == 'FindWindow' # The name of the function passed to the constructor
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
    MyLib.function 'FindWindow', 'PP', 'L' unless respond_to? :find_window
    find_window(nil, nil)
  end

  def not_a_handle
    123
  end

  def redefined_methods
    [:FindWindow, :IsWindow, :EnumWindows, :GetComputerName, :GetForegroundWindow]
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

  describe Win::Library, ' defines wrappers for Win32::API functions' do

    before(:each) { hide_method *redefined_methods } # hide original methods if  defined
    after(:each) { restore_method *redefined_methods } # restore original methods if hidden

    context 'defining enhanced API function method' do
      spec{ use{ MyLib.function('FindWindow', 'PP', 'l', rename: nil, aliases: nil, boolean: nil, zeronil: nil, &any_block) }}

      it 'defines new instance methods with appropriate names' do
        MyLib.function 'FindWindow', 'PP', 'L'
        respond_to?(:FindWindow).should be_true
        respond_to?(:find_window).should be_true
      end

      it 'constructs argument prototype from uppercase string, enforces the args count' do
        expect { MyLib.function 'FindWindow', 'PP', 'L' }.to_not raise_error
        should_count_args :find_window, :FindWindow, [nil, nil], [nil, TEST_IMPOSSIBLE, 'cmd']
      end

      it 'constructs argument prototype from (mixed) array, enforces the args count' do
        expect { MyLib.function 'FindWindow', [:pointer, 'P'], 'L' }.to_not raise_error
        should_count_args :find_window, :FindWindow, [nil, nil], [nil, TEST_IMPOSSIBLE, 'cmd']
      end

      it 'with :rename option, overrides snake_case name for defined method but leaves CamelCase intact' do
        MyLib.function 'FindWindow', 'PP', 'L', :rename=> 'my_own_find'
        expect {find_window(nil, nil)}.to raise_error NoMethodError
        expect {FindWindow(nil, nil)}.to_not raise_error
        expect {my_own_find(nil, nil)}.to_not raise_error
      end

      it 'defined snake_case method returns expected value when called' do
        MyLib.function 'FindWindow', 'PP', 'L'
        find_window(nil, nil).should_not == 0
        find_window(nil, TEST_IMPOSSIBLE).should == 0
        find_window(TEST_IMPOSSIBLE, nil).should == 0
        find_window(TEST_IMPOSSIBLE, TEST_IMPOSSIBLE).should == 0
      end

      it 'defined CamelCase method returns expected value when called' do
        MyLib.function 'FindWindow', 'PP', 'L'
        FindWindow(nil, nil).should_not == 0
        FindWindow(nil, TEST_IMPOSSIBLE).should == 0
        FindWindow(TEST_IMPOSSIBLE, nil).should == 0
        FindWindow(TEST_IMPOSSIBLE, TEST_IMPOSSIBLE).should == 0
      end

#      it 'returns underlying Win32::API object if defined method is called with (:api) argument ' do
#        MyLib.function 'FindWindow', 'PP', 'L'
#        expect {find_window(:api)}.to_not raise_error
#        should_be :find_window, find_window(:api)
#      end

      it 'returns underlying Win32::API object' do
        FWAPI = MyLib.function 'FindWindow', 'PP', 'L'
        should_be :find_window, FWAPI
      end
    end

    context 'defining aliases' do
      it 'adds alias for defined method with :alias option' do
        MyLib.function( 'FindWindow', 'PP', 'L', :alias => 'my_own_find')
        expect {find_window(nil, nil)}.to_not raise_error
        expect {my_own_find(nil, nil)}.to_not raise_error
      end

      it 'adds aliases for defined method with :aliases option' do
        MyLib.function 'FindWindow', 'PP', 'L', :aliases => ['my_own_find', 'my_own_find1']
        expect {find_window(nil, nil)}.to_not raise_error
        expect {my_own_find(nil, nil)}.to_not raise_error
        expect {my_own_find1(nil, nil)}.to_not raise_error
      end

      it 'adds Rubyesque alias to IsXxx API test function' do
        MyLib.function 'IsWindow', 'L', 'B'
        respond_to?(:window?).should be_true
        respond_to?(:is_window).should be_true
      end

      it 'adds Rubyesque alias to GetXxx API getter function' do
        MyLib.function 'GetComputerName', 'PP', 'I', :dll=> 'kernel32'
        respond_to?(:get_computer_name).should be_true
        respond_to?(:computer_name).should be_true
      end
    end

    context 'auto-defining Ruby-like boolean methods if API function name starts with "Is_"' do
      before(:each) {MyLib.function 'IsWindow', 'L', 'L'}

      it 'defines new instance method name dropping Is_ and adding ?' do
        respond_to?(:window?).should be_true
        respond_to?(:is_window).should be_true
        respond_to?(:IsWindow).should be_true
      end

      it 'defined CamelCase method returns zero/non-zero as expected' do
        IsWindow(any_handle).should_not == true
        IsWindow(any_handle).should_not == 0
        IsWindow(not_a_handle).should == 0
      end

      it 'defined snake_case method returns false/true instead of zero/non-zero' do
        window?(any_handle).should == true
        window?(not_a_handle).should == false
        is_window(any_handle).should == true
        is_window(not_a_handle).should == false
      end

      it 'defined methods enforce the argument count' do
        should_count_args :window?, :is_window, :IsWindow,  [not_a_handle], [nil, not_a_handle, any_handle]
      end
    end

    context 'defining API with :boolean option converts result to boolean' do
      before(:each) { MyLib.function 'FindWindow', 'PP', 'L', :boolean => true }

      it 'defines new instance method' do
        respond_to?(:find_window).should be_true
        respond_to?(:FindWindow).should be_true
      end

      it 'defined snake_case method returns false/true instead of zero/non-zero' do
        find_window(nil, nil).should == true
        find_window(nil, TEST_IMPOSSIBLE).should == false
      end

      it 'defined CamelCase method still returns zero/non-zero' do
        FindWindow(nil, nil).should_not == true
        FindWindow(nil, nil).should_not == 0
        FindWindow(nil, TEST_IMPOSSIBLE).should == 0
      end

      it 'defined methods enforce the argument count' do
        should_count_args :find_window, :FindWindow, [nil, nil], [nil, TEST_IMPOSSIBLE, 'cmd']
      end
    end

    context 'defining API with :zeronil option converts zero result to nil' do
      before(:each) {MyLib.function 'FindWindow', 'PP', 'L', :zeronil => true}

      it 'defines new instance method' do
        respond_to?(:find_window).should be_true
        respond_to?(:FindWindow).should be_true
      end

      it 'defined CamelCase method still returns zero/non-zero' do
        FindWindow(nil, nil).should_not == true
        FindWindow(nil, nil).should_not == 0
        FindWindow(nil, TEST_IMPOSSIBLE).should == 0
      end

      it 'defined method returns nil (but NOT false) instead of zero' do
        find_window(nil, TEST_IMPOSSIBLE).should_not == false
        find_window(nil, TEST_IMPOSSIBLE).should == nil
      end

      it 'defined method does not return true when result is non-zero' do
        find_window(nil, nil).should_not == true
        find_window(nil, nil).should_not == 0
      end

      it 'defined methods enforce the argument count' do
        should_count_args :find_window, :FindWindow, [nil, nil], [nil, TEST_IMPOSSIBLE, 'cmd']
      end
    end

    context 'using DLL other than default user32 with :dll option' do
      before(:each) {MyLib.function 'GetComputerName', 'PP', 'I', :dll=> 'kernel32'}

      it 'defines new instance method with appropriate name' do
        respond_to?(:GetComputerName).should be_true
        respond_to?(:get_computer_name).should be_true
        respond_to?(:computer_name).should be_true
      end

      it 'returns expected result' do
        MyLib.function 'GetComputerName', ['P', 'P'], 'I', :dll=> 'kernel32'
        hostname = `hostname`.strip.upcase
        name = " " * 128
        get_computer_name(name, "128")
        name.unpack("A*").first.should == hostname
      end
    end

    context 'trying to define an invalid API function' do
      it 'raises error when trying to define function with a wrong function name' do
        expect { MyLib.function 'FindWindowImpossible', 'PP', 'L' }.
                to raise_error( /Function 'FindWindowImpossible' not found/ )
      end
    end

    context 'defining API function using definition block' do
      it 'defines new instance method' do
        MyLib.function( 'FindWindow', 'PP', 'L' ){|api, *args|}
        respond_to?(:find_window).should be_true
        respond_to?(:FindWindow).should be_true
      end

      it 'does not enforce argument count outside of block' do
        MyLib.function( 'FindWindow', 'PP', 'L' ){|api, *args|}
        expect { find_window }.to_not raise_error
        expect { find_window(nil) }.to_not raise_error
        expect { find_window(nil, 'Str', 1) }.to_not raise_error
      end

      it 'returns block return value when defined method is called' do
        MyLib.function( 'FindWindow', 'PP', 'L' ){|api, *args| 'Value'}
        find_window(nil).should == 'Value'
      end

      it 'passes arguments and underlying Win32::API object to the block' do
        MyLib.function( 'FindWindow', 'PP', 'L' ) do |api, *args|
          @api = api
          @args = args
        end
        expect {find_window(1, 2, 3) }.to_not raise_error
        @args.should == [1, 2, 3]
        should_be :find_window, @api
      end

      it ':rename option overrides standard name for defined method' do
        MyLib.function( 'FindWindow', 'PP', 'L', :rename => 'my_own_find' ){|api, *args|}
        expect {find_window(nil, nil, nil)}.to raise_error
        expect {my_own_find(nil, nil)}.to_not raise_error
      end

      it 'adds alias for defined method with :alias option' do
        MyLib.function( 'FindWindow', 'PP', 'L', :alias => 'my_own_find' ){|api, *args|}
        expect {find_window(nil, nil)}.to_not raise_error
        expect {my_own_find(nil, nil)}.to_not raise_error
      end

      it 'adds aliases for defined method with :aliases option' do
        MyLib.function( 'FindWindow', 'PP', 'L', :aliases => ['my_own_find', 'my_own_find1'] ) {|api, *args|}
        expect {find_window(nil, nil)}.to_not raise_error
        expect {my_own_find(nil, nil)}.to_not raise_error
        expect {my_own_find1(nil, nil)}.to_not raise_error
      end
    end

    context 'calling defined methods with attached block to preprocess the API function results' do
      it 'defined method yields raw result to block attached to its invocation' do
        MyLib.function 'FindWindow', 'PP', 'L', zeronil: true
        find_window(nil, TEST_IMPOSSIBLE) {|result| result.should == 0 }
      end

      it 'defined method returns result of block attached to its invocation' do
        MyLib.function 'FindWindow', 'PP', 'L', zeronil: true
        return_value = find_window(nil, TEST_IMPOSSIBLE) {|result| 'Value'}
        return_value.should == 'Value'
      end

      it 'defined method transforms result of block before returning it' do
        MyLib.function 'FindWindow', 'PP', 'L', zeronil: true
        return_value = find_window(nil, TEST_IMPOSSIBLE) {|result| 0 }
        return_value.should_not == 0
        return_value.should == nil
      end
    end

    context 'defining API function without arguments - f(VOID)' do
      it 'should enforce argument count to 0, NOT 1' do
        MyLib.function 'GetForegroundWindow', [], 'L', zeronil: true
        should_count_args :GetForegroundWindow, :get_foreground_window, :foreground_window, [], [nil, 0, 123]
      end
   end

    context 'working with API function callbacks' do
      it '#callback method creates a valid callback object' do
        pending 'What about callbacks?'
        expect { @callback = WinGui.callback('LP', 'I') {|handle, message| true} }.to_not raise_error
        @callback.should be_a_kind_of(Win32::API::Callback)
      end

      it 'created callback object can be used as a valid arg of API function expecting callback' do
        pending 'What about callbacks?'
        WinGui.def_api 'EnumWindows', 'KP', 'L'
        @callback = WinGui.callback('LP', 'I'){|handle, message| true }
        expect { enum_windows(@callback, 'Message') }.to_not raise_error
      end

      it 'defined API functions expecting callback convert given block into callback' do
        pending 'What about callbacks?'
        pending ' What about prototype!? API is not exactly clear atm (.with_callback method?)'
        WinGui.def_api 'EnumWindows', 'KP', 'L'
        expect { enum_windows('Message'){|handle, message| true } }.to_not raise_error
      end
    end

  end
end
