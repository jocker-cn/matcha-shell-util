Gem::Specification.new do |spec|
  spec.name          = "matcha"
  spec.version       = "1.0.0"
  spec.authors       = ["JokerCN"]
  spec.email         = ["joker00647@gmail.com"]
  spec.description   = "shell script common"
  spec.summary       = "shell-manager"
  spec.homepage      = "https://github.com/jocker-cn"
  spec.license       = "Apache-2.0"
  spec.require_paths = ["src"]
  spec.files         = Dir["src/**/*", "bin/**/*", "README.md", "LICENSE"]
  spec.executables   = ["matcha"]

  # spec.add_development_dependency "rake"
end
