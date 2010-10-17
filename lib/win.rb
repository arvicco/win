require 'version'
require 'extension'

module Win

  # Requires ruby source file(s). Accepts either single filename/glob or Array of filenames/globs.
  # Accepts following options:
  # :*file*:: Lib(s) required relative to this file - defaults to __FILE__
  # :*dir*:: Required lib(s) located under this dir name - defaults to gem name
  #
  def self.require_libs( libs, opts={} )
    file = Pathname.new(opts[:file] || __FILE__)
    [libs].flatten.each do |lib|
      name = file.dirname + (opts[:dir] || file.basename('.*')) + lib.gsub(/(?<!.rb)$/, '.rb')
      Pathname.glob(name.to_s).sort.each {|rb| require rb}
    end
  end
end  # module WinGui

# Require all ruby source files located under directory lib/win_gui
# If you need files in specific order, you should specify it here before the glob
Win.require_libs %W[**/*]

