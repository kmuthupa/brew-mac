#
# Cookbook Name:: brew-mac
# Recipe:: gems
#
# Copyright (c) 2025 Karthik Muthupalaniappan, All Rights Reserved.

# Install latest stable Ruby version
RUBY_VERSION = '3.2.2'

execute "install Ruby #{RUBY_VERSION}" do
  command "rbenv install #{RUBY_VERSION}"
  not_if "rbenv versions | grep #{RUBY_VERSION}"
end

execute "set global Ruby version to #{RUBY_VERSION}" do
  command "rbenv global #{RUBY_VERSION}"
  not_if "rbenv version | grep #{RUBY_VERSION}"
end

# Install essential gems with version pinning
gems = {
  'bundler' => '~> 2.4.0',
  'rails' => '~> 7.0.0',
  'pry' => '~> 0.14.0'
}

gems.each do |gem_name, version|
  script "install #{gem_name}" do
    interpreter 'bash'
    code <<-EOH
      source ~/.rbenv/shims/ruby
      gem install #{gem_name} -v '#{version}'
    EOH
    not_if "gem list | grep '^#{gem_name} ' | grep '#{version}'"
  end
end