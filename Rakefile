require 'pathname'
NAME = 'win'
BASE_PATH = Pathname.new(__FILE__).dirname
LIB_PATH =  BASE_PATH + 'lib'
PKG_PATH =  BASE_PATH + 'pkg'
DOC_PATH =  BASE_PATH + 'rdoc'

$LOAD_PATH.unshift LIB_PATH.to_s
require 'version'

CLASS_NAME = Win
VERSION = CLASS_NAME::VERSION

begin
  require 'rake'
rescue LoadError
  require 'rubygems'
  gem 'rake', '~> 0.8.3.1'
  require 'rake'
end

# Load rakefile tasks
Dir['tasks/*.rake'].sort.each { |file| load file }

