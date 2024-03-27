Gem::Specification.new do |spec|
  spec.name        = "pronto_eslinter"
  spec.version     = "0.1.0"
  spec.authors     = ["Kristupas Gaidys" "Ugnius Pacauskas"]
  spec.email       = ["kristupas.gaidys@vinted.com", "ugnius.pacauskas@vinted.com"]
  spec.summary     = %q{Eslint runner for Pronto}
  spec.description = %q{Eslint runner for Pronto which generates code change suggestions based on eslint errors.}
  spec.homepage    = "https://github.com/kristupas-g/pronto-eslinter"
  spec.license     = "MIT"

  spec.files = []

  spec.required_ruby_version = ">= 3.1.3"

  spec.add_development_dependency "pronto", "~> 0.11.0"
  spec.add_development_dependency "rubocop", "~> 1.22"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "rspec-its", "~> 1.3"
end
