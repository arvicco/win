## Dependencies in this Gemfile are managed through the gemspec. Add/remove
## dependencies there, rather than editing this file
#
require 'pathname'
NAME = 'win'
BASE_PATH = Pathname.new(__FILE__).dirname
GEMSPEC_PATH = BASE_PATH + "#{NAME}.gemspec"

source :gemcutter

gemspec = eval(GEMSPEC_PATH.read)
gemspec.dependencies.each do |dep|
  group = dep.type == :development ? :development : :default
  gem dep.name, dep.requirement, :group => group
end

