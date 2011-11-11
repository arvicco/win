# Gemspecs should not be generated, but edited directly.
# Refer to: http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended/

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |gem|
  gem.name        = "win"
  gem.version     = File.open('VERSION').read.strip
  gem.summary     = %q{Rubyesque interfaces and wrappers for Windows API functions pre-defined using FFI}
  gem.description = %q{Rubyesque interfaces and wrappers for Windows API functions pre-defined using FFI}
  gem.authors     = ["arvicco"]
  gem.email       = "arvitallian@gmail.com"
  gem.homepage    = %q{http://github.com/arvicco/win}
  gem.platform    = Gem::Platform::RUBY
  gem.date        = Time.now.strftime "%Y-%m-%d"

  # Files setup
  versioned         = `git ls-files -z`.split("\0")
  gem.files         = Dir['{bin,lib,man,spec,features,tasks}/**/*', 'Rakefile', 'README*', 'LICENSE*',
                      'VERSION*', 'CHANGELOG*', 'HISTORY*', 'ROADMAP*', '.gitignore'] & versioned
  gem.executables   = (Dir['bin/**/*'] & versioned).map{|file|File.basename(file)}
  gem.test_files    = Dir['spec/**/*'] & versioned
  gem.require_paths = ["lib"]

  # RDoc setup
  gem.has_rdoc = true
  gem.rdoc_options.concat %W{--charset UTF-8 --main README.rdoc --title win}
  gem.extra_rdoc_files = ["LICENSE", "HISTORY", "README.rdoc"]

  # Dependencies
  gem.add_development_dependency 'rspec', [">= 2.0.9"]
  gem.add_dependency 'bundler', [">= 1.0.13"]
  gem.add_dependency 'ffi', ["= 1.0.9"] # 1.0.10 has problems on Win32
end

