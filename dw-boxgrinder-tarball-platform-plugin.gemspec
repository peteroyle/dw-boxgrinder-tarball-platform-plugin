Gem::Specification.new do |s|
  s.name = %q{dw-boxgrinder-tarball-platform-plugin}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pete Royle"]
  s.date = %q{2012-05-21}
  s.description = %q{BoxGrinder Build Tarball Platform Plugin}
  s.email = %q{howardmoon@screamingcoder.com}
  s.extra_rdoc_files = ["CHANGELOG", "lib/dw-boxgrinder-tarball-platform-plugin.rb", "lib/dw-boxgrinder-tarball-platform-plugin/tarball_plugin.rb"]
  s.files = ["CHANGELOG", "Rakefile", "lib/dw-boxgrinder-tarball-platform-plugin.rb", "lib/dw-boxgrinder-tarball-platform-plugin/tarball_plugin.rb", "dw-boxgrinder-tarball-platform-plugin.gemspec"]
  s.homepage = %q{http://www.digitalworx.com.au}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "dw-boxgrinder-tarball-platform-plugin"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{BoxGrinder Build}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Tarball Platform Plugin}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<boxgrinder-build>, [">= 0.5.0"])
      s.add_runtime_dependency(%q<minitar>, [">= 0.5.3"])
    else
      s.add_dependency(%q<boxgrinder-build>, [">= 0.5.0"])
      s.add_dependency(%q<minitar>, [">= 0.5.3"])
    end
  else
    s.add_dependency(%q<boxgrinder-build>, [">= 0.5.0"])
    s.add_dependency(%q<minitar>, [">= 0.5.3"])
  end
end
