# -*- mode:ruby; -*-


HOME    = File.expand_path(File.dirname(__FILE__))

desc "Hit the restart button for apache/passenger, pow servers"
task :restart do
  sh "touch #{HOME}/tmp/restart.txt"
end

# Build local bundled Gems; 

desc "Gem bundles"
task :bundle do
  sh "rm -rf #{HOME}/bundle #{HOME}/.bundle #{HOME}/Gemfile.lock"
  sh "mkdir -p #{HOME}/bundle"
  sh "cd #{HOME}; bundle --gemfile Gemfile install --path bundle"
end


desc "deploy to darchive's production site (viruscheck.fda.fcla.edu)"
task :darchive do
    sh "cap deploy -S target=darchive.fcla.edu:/opt/web-services/sites/viruscheck -S who=daitss:daitss"
end

desc "deploy to development site (viruscheck.retsina.fcla.edu)"
task :retsina do
    sh "cap deploy -S target=retsina.fcla.edu:/opt/web-services/sites/viruscheck -S who=daitss:daitss"
end

desc "deploy to ripple's test site (viruscheck.ripple.fcla.edu)"
task :ripple do
    sh "cap deploy -S target=ripple.fcla.edu:/opt/web-services/sites/viruscheck -S who=daitss:daitss"
end

desc "deploy to tarchive's coop (viruscheck.tarchive.fcla.edu?)"
task :tarchive_coop do
    sh "cap deploy -S target=tarchive.fcla.edu:/opt/web-services/sites/coop/viruscheck -S who=daitss:daitss"
end

defaults = [:restart]

task :default => defaults
