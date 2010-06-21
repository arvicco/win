$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'spec'
require 'spec/autorun'
require 'win/gui'

$debug = false

# Customize RSpec with my own extensions
module ClassMacros

  # wrapper for it method that extracts description from example source code, such as:
  # spec { use{    function(arg1 = 4, arg2 = 'string')  }}
  def spec &block
    it description_from(caller[0]), &block # it description_from(*block.source_location), &block
  end

  # reads description line from source file and drops external brackets like its{}, use{}
  # accepts as arguments either file name and line or call stack member (caller[0])
  def description_from(*args)
    case args.size
      when 1
        file, line = args.first.scan(/\A(.*?):(\d+)/).first
      when 2
        file, line = args
    end
    File.open(file) do |f|
      f.lines.to_a[line.to_i-1].gsub( /(spec.*?{)|(use.*?{)|}/, '' ).strip
    end
  end
end

# Customize RSpec with my own extensions
module InstanceMacros
  def use
    lambda{yield}.should_not raise_error
  end

  def any_block
    lambda{|*args| args}
  end
end

Spec::Runner.configure do |config|
  config.extend(ClassMacros)
  config.include(InstanceMacros)

#  class << Spec::ExampleGroup
##    def spoc &block
##      it description_from(caller[0]), &block
##    end
#  end
end

# Global test methods
def cygwin?
  @cygwin_flag ||= `ruby -v` =~ /cygwin/
end

def os
  @os_flag ||= cygwin? ? `cmd /c ver` : `ver`
end

def os_2000?
  os =~ /Version 5.0/
end

def os_xp?
  os =~ /XP/
end

def os_vista?
  os =~ /Version 6.0/
end

def os_7?
  os =~ /Version 6.1/
end

module WinTest

  KEY_DELAY = 0.001
  IMPOSSIBLE = 'Impossible'
  CONVERSION_ERROR = /Can.t convert/
  SLEEP_DELAY = 0.02
  APP_PATH = File.join(File.dirname(__FILE__), "../misc/locknote/LockNote.exe" )
  APP_START = cygwin? ? "cmd /c start `cygpath -w #{APP_PATH}`" : 'start "" "' + APP_PATH + '"'
  WIN_TITLE = 'LockNote - Steganos LockNote'
  WIN_RECT = [710, 400, 1210, 800]
  WIN_CLASS = 'ATL:00434098'
  STATUSBAR_CLASS = 'msctls_statusbar32'
  TEXTAREA_CLASS = 'ATL:00434310'
  DESKTOP_CLASS = '#32769'
  MENU_CLASS = '#32768'

  def any_handle
    find_window(nil, nil)
  end

  def not_a_handle
    123
  end

  def buffer
    FFI::MemoryPointer.new(:char, 1024)
  end

  def pointer(type=:long, num=1)
    FFI::MemoryPointer.new(type, num)
  end
end

module WinTestApp

  include WinTest
  include Win::Gui
  #include Win::Gui::Convenience

  def launch_test_app
    system APP_START
    sleep SLEEP_DELAY until (handle = find_window(nil, WIN_TITLE))

    textarea = find_window_ex(handle, 0, TEXTAREA_CLASS, nil)
    app = "Locknote" # App identifier

    eigen_class = class << app;
      self;
    end      # Extracting app's eigenclass
    eigen_class.class_eval do                  # Defining singleton methods on app
      define_method(:handle) {handle}
      define_method(:textarea) {textarea}
    end

    @launched_test_app = app
  end

  def close_test_app
    while @launched_test_app && find_window(nil, WIN_TITLE)
      shut_window @launched_test_app.handle
      sleep SLEEP_DELAY
      if dialog = find_window(nil, "Steganos Locknote") # Dealing with closing modal dialog
        set_foreground_window(dialog)
        keystroke('N')
      end
    end
    @launched_test_app = nil
  end

  # Creates test app object and yields it back to the block
  def test_app
    app = launch_test_app
    yield app
    close_test_app
  end

  def test_app_with_dialog(type=:close)
    test_app do |app|
      case type
        when :close
          keystroke('A')
          shut_window app.handle
          sleep 0.01 until dialog = find_window(nil, "Steganos Locknote")
        when :save
          keystroke(VK_ALT, 'F', 'A')
          sleep 0.01 until dialog = find_window(nil, "Save As")
      end
      yield app, dialog
      set_foreground_window(dialog)
      keystroke(VK_ESCAPE)
    end
  end

  # Emulates combinations of (any amount of) keys pressed one after another (Ctrl+Alt+P) and then released
  # *keys should be a sequence of a virtual-key codes. These codes must be a value in the range 1 to 254.
  # For a complete list, see msdn:Virtual Key Codes.
  # If alphanumerical char is given instead of virtual key code, only lowercase letters result (no VK_SHIFT!).
  def keystroke(*keys)
    return if keys.empty?
    key = String === keys.first ? keys.first.upcase.ord : keys.first.to_i
    keybd_event key, 0, KEYEVENTF_KEYDOWN, 0
    sleep KEY_DELAY
    keystroke *keys[1..-1]
    sleep KEY_DELAY
    keybd_event key, 0, KEYEVENTF_KEYUP, 0
  end
end