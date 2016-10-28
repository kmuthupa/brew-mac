#
# Cookbook Name:: brew-mac
# Recipe:: default
#
# Copyright (c) 2016 Karthik Muthupalaniappan, All Rights Reserved.

# npm packages
%w[todo].each do |npm_package|
  script "install #{npm_package}" do
    interpreter 'bash'
    code "npm install #{npm_package} -g"
  end
end

