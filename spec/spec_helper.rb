$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'spec'
require 'spec/autorun'

$debug = true

# Customize RSpec with my own extensions
module SpecMacros

  # wrapper for it method that extracts description from example source code, such as:
  # spec { use{    function(arg1 = 4, arg2 = 'string')  }}
  def spec &block
#    p (block.methods-Object.methods).sort; exit
    if RUBY_PLATFORM =~ /java/
      it 'dummy JRuby description', &block
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

Spec::Runner.configure { |config| config.extend(SpecMacros) }

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

  def use
    lambda{yield}.should_not raise_error
  end

  def any_block
    lambda{|*args| args}
  end

  def any_handle
    unless respond_to? :find_window
      require 'win/window'
      include Win::Window
    end
    find_window(nil, nil)
  end

  def not_a_handle
    123
  end
end