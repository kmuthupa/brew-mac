#
# Cookbook Name:: brew-mac
# Recipe:: default
#
# Copyright (c) 2016 Karthik Muthupalaniappan, All Rights Reserved.


include_recipe 'brew-mac::brew'
include_recipe 'brew-mac::gems'
include_recipe 'brew-mac::utilities'


