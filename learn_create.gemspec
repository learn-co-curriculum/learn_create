Gem::Specification.new do |s|
  s.name = 'learn_create'
  s.version = '0.0.20'
  s.date = '2018-11-20'
  s.authors = ['flatironschool']
  s.email = 'maxwell@flatironschool.com'
  s.license = 'MIT'
  s.summary = 'learn_create is a tool for creating learn.co lessons on github'
  s.files = Dir.glob('{bin,lib}/**/*') + %w[LICENSE.md README.md CONTRIBUTING.md Rakefile Gemfile]
  s.require_paths = ['lib']
  s.homepage = 'https://github.com/learn-co-curriculum/learn_create'
  s.executables << 'learn_create'
  s.add_runtime_dependency 'faraday', '~> 0.15'
end
