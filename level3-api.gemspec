Gem::Specification.new do |s|
  s.name = "level3-api"
  s.version = "0.1.1"
  s.license = 'MIT'
  s.email = "david-vv@nicklay.com"
  s.homepage = "https://github.com/venturaville/level3-gem"
  s.authors = ["David Nicklay"]
  s.summary = "Level3 API Gem"
  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.description = "Level 3 API gem"
  s.bindir = "bin"
  s.executables = %w{ level3_rtm_stats }
  %w{ xml-simple rest-client ruby-hmac }.each do |d|
    s.add_dependency d
  end
end

