$LOAD_PATH.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |spec|
  spec.name        = 'pronto-eslinter'
  spec.version     = '0.1.0'
  spec.authors     = ['Kristupas Gaidys', 'Ugnius Pacauskas', 'Andrius Prudnikovas']
  spec.email       = ['kristupas.gaidys@vinted.com', 'ugnius.pacauskas@vinted.com']
  spec.summary     = %q(Eslint runner for Pronto)
  spec.description = %q(Eslint runner for Pronto which generates code change suggestions based on eslint errors.)
  spec.homepage    = 'https://github.com/kristupas-g/pronto-eslinter'
  spec.license     = 'MIT'

  spec.files = []

  spec.required_ruby_version = '>= 3.1.3'
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.require_paths = ['lib']
end
