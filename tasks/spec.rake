desc 'Alias to spec:spec'
task :spec => 'spec:spec'

namespace :spec do
  require 'spec/rake/spectask'

  desc "Run all specs"
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_opts = ['--options', %Q{"#{BASE_PATH}/spec/spec.opts"}]
    t.spec_files = FileList['spec/**/*_spec.rb']
  end

  desc "Run specs with RCov"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec']
  end
end
