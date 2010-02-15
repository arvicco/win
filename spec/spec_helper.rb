$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'spec'
require 'spec/autorun'
require 'win/gui'

$debug = true

# Customize RSpec with my own extensions
module ClassMacros

  # wrapper for it method that extracts description from example source code, such as:
  # spec { use{    function(arg1 = 4, arg2 = 'string')  }}
  def spec &block
    if RUBY_PLATFORM =~ /java/
      it 'not able to extract description', &block
    else
      it description_from(*block.source_location), &block
    end
  end

  # reads description line from source file and drops external brackets (like its{}, use{}
  def description_from(file, line)
    File.open(file) do |f|
      f.lines.to_a[line-1].gsub( /(spec.*?{)|(use.*?{)|}/, '' ).strip
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
end

module WinTest

  TEST_KEY_DELAY = 0.001
  TEST_IMPOSSIBLE = 'Impossible'
  TEST_CONVERSION_ERROR = /Can.t convert/
  TEST_SLEEP_DELAY = 0.01
  TEST_APP_PATH = File.join(File.dirname(__FILE__), "test_apps/locknote/LockNote.exe" )
  TEST_APP_START = 'start "" "' + TEST_APP_PATH + '"'
  TEST_WIN_TITLE = 'LockNote - Steganos LockNote'
  TEST_WIN_CLASS = 'ATL:00434098'
  TEST_WIN_RECT = [710, 400, 1210, 800]
  TEST_STATUSBAR_CLASS = 'msctls_statusbar32'
  TEST_TEXTAREA_CLASS = 'ATL:00434310'

  def any_handle
    find_window(nil, nil)
  end

  def not_a_handle
    123
  end
end

module WinTestApp

  include WinTest
  include Win::Gui
  include Win::Gui::Convenience

  def launch_test_app
    system TEST_APP_START
    sleep TEST_SLEEP_DELAY until (handle = find_window(nil, TEST_WIN_TITLE))

    @launched_test_app = WrapWindow.new handle
#    app = "Test app"    #need to get rid of Window for JRuby
#    class << app; self; end.send( :define_method, :handle, &lambda {handle})
#    @launched_test_app = app
  end

  def close_test_app(app = @launched_test_app)
    while app and app.respond_to? :handle and find_window(nil, TEST_WIN_TITLE)
      post_message(app.handle, WM_SYSCOMMAND, SC_CLOSE, 0)
      sleep TEST_SLEEP_DELAY
    end
    @launched_test_app = nil
  end

  # Creates test app object and yields it back to the block
  def test_app
    app = launch_test_app

    def app.textarea #define singleton method retrieving app's text area
      WrapWindow.new find_window_ex(self.handle, 0, TEST_TEXTAREA_CLASS, nil)
    end

    yield app
    close_test_app app
  end

end