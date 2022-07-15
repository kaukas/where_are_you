# frozen_string_literal: true

require_relative "lib/where_are_you/version"

Gem::Specification.new do |spec|
  spec.name = "where_are_you"
  spec.version = WhereAreYou::VERSION
  spec.authors = ["Linas Juškevičius"]
  spec.email = ["linas@prodigi.to"]

  spec.summary = "Find those pesky invaders."
  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    file_reject_regexp =
      %r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)}

    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(file_reject_regexp)
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
