require_relative './version'

Gem::Specification.new do |spec|
  spec.name = "matcha"
  spec.version = matcha_version
  spec.authors = ["JokerCN"]
  spec.email = ["joker00647@gmail.com"]
  spec.description = "shell script common"
  spec.summary = "shell-manager"
  spec.homepage = "https://github.com/jocker-cn"
  spec.license = "Apache-2.0"
  spec.require_paths = ["src"]
  spec.files = Dir["src/**/*", "bin/**/*", "README.md", "LICENSE","vendor/**/*"]
  spec.executables = ["matcha"]

  spec.add_runtime_dependency 'ruby_expect', '~> 1.7.5'
  spec.add_runtime_dependency 'ed25519', '~> 1.3.0'
  spec.add_runtime_dependency 'bcrypt_pbkdf', '~> 1.1.0'
  spec.add_runtime_dependency 'net-ssh', '~> 7.1.0'
  spec.add_runtime_dependency 'net-scp', '~> 4.0.0'
  spec.add_runtime_dependency 'psych', '~> 3.0'

  spec.add_development_dependency "rspec", '~> 3.12.0'
  spec.add_development_dependency "bundler", '~>  2.4.8'

end
