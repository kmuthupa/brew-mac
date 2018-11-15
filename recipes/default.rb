#
# Cookbook Name:: brew-mac
# Recipe:: default
#
# Copyright (c) 2016 Karthik Muthupalaniappan, All Rights Reserved.


include_recipe 'brew-mac::brew'
include_recipe 'brew-mac::gems'
include_recipe 'brew-mac::pip'
include_recipe 'brew-mac::utilities'
include_recipe 'brew-mac::npm-packages'
include_recipe 'brew-mac::dotfiles'


