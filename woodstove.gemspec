Gem::Specification.new do |s|
  s.name        = 'woodstove'
  s.version     = '0.0.4'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'A simple package manager powered by github repositories.'
  s.description = 'A simple package manager powered by github repositories. See http://github.com/fur-cade/woodstove'
  s.authors     = ["the Furry Entertainment Project"]
  s.email       = 'soaproap@gmail.com'
  s.files       = ["lib/woodstove.rb",
                   "lib/woodstove/argmanager.rb",
                   "lib/woodstove/helpcommand.rb",
                   "lib/woodstove/packagecommands.rb",
                   "lib/woodstove/packagemanager.rb"]
  s.executables << 'woodstove'
  s.homepage    =
    'http://github.com/fur-cade/woodstove'
  s.license       = 'MIT'
end
