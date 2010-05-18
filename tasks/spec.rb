require 'spec/rake/spectask'

desc "Run all examples"
Spec::Rake::SpecTask.new do |t|
  t.libs << 'lib'
  t.libs << 'spec'
  t.spec_opts << "--color"
end

namespace 'spec' do

  desc "Run all examples with rcov"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.libs << 'lib'
    t.libs << 'spec'
    t.spec_files = FileList[ 'spec/**/*.rb' ]
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec,/Library/.*,/Users/.*']
  end

end
