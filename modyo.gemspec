# -*- encoding : utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'modyo/version'

Gem::Specification.new do |s|
  s.name = "modyo"
  s.summary = "Modyo SDK"
  s.description = "Modyo Platform SDK for Ruby"
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = Modyo::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Ivan Gonzalez <itech>", "Toño Silva Portell <jcode>"]
  s.email = ["support@modyo.com"]
  s.homepage = "http://www.modyo.com"
  s.summary = "modyo-#{s.version}"


  s.add_dependency "oauth", ">= 0.4.2", "< 0.6.0"
  s.add_dependency "rack-p3p"
  s.add_dependency "nokogiri"

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]


end


