
require 'rake'

namespace :gem do
  desc "Install the gem locally"
  task :install do
    puts "Building gem"
    `gem build level3-api.gemspec`
    puts "Installing gem"
    `sudo gem install ./level3-api-*.gem`
    puts "Removing built gem"
    `rm level3-api-*.gem`
  end

  desc "Push gem upstream"
  task :push do
    version = `awk -F \\\" ' /version/ { print $2 } ' level3-api.gemspec`
    version.chomp!
    puts "Building level3-api gem"
    system "gem build level3-api.gemspec"
    puts "Pushing level3-api gem version: #{version}"
    system "gem push level3-api-#{version}.gem"
    puts "Cleaning up level3-api-#{version}.gem"
    File.delete "level3-api-#{version}.gem"
    # To yank:
    #gem yank level3-api -v ${VERSION}
  end
end

namespace :git do
  desc "make a git tag"
  task :tag do
    version = `awk -F \\\" ' /version/ { print $2 } ' level3-api.gemspec`
    version.chomp!
    puts "Tagging git with version=#{version}"
    system "git tag #{version}"
    system "git push --tags"
  end
end

