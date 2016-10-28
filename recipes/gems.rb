#
# Cookbook Name:: brew-mac
# Recipe:: default
#
# Copyright (c) 2016 Karthik Muthupalaniappan, All Rights Reserved.

# install ruby 2.3.0
execute 'install ruby 2.0.0' do
  command 'rbenv install 2.0.0-p648'
  not_if 'rbenv versions | grep 2.0.0'
end

# gems
%w[bundler
   rails
   pry].each do |gem_name|
  script "install #{gem_name}" do
    interpreter 'bash'
    code "gem install #{gem_name}"
  end
end

