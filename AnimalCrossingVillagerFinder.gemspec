require_relative 'lib/AnimalCrossingVillagerFinder/version'

Gem::Specification.new do |spec|
  spec.name          = "AnimalCrossingVillagerFinder"
  spec.version       = AnimalCrossingVillagerFinder::VERSION
  spec.authors       = ["ReginaF2012"]
  spec.email         = ["skritschy@gmail.com"]

  spec.summary       = %q{"List of Animal Crossing Characters"}
  spec.description   = %q{""}
  spec.homepage      = "https://github.com/ReginaF2012/AnimalCrossingVillagerFinder-"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ReginaF2012/AnimalCrossingVillagerFinder-"
  #? I don't know what is supposed to go here so I just put the same url to the github repository
  spec.metadata["changelog_uri"] = "https://github.com/ReginaF2012/AnimalCrossingVillagerFinder-"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
