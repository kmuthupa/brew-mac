#
# Cookbook Name:: brew-mac
# Recipe:: default
#
# Copyright (c) 2016 Karthik Muthupalaniappan, All Rights Reserved.

account = node['github-user']['account']
dotfiles_repository = node['github-user']['dotfiles_repository']
tmp_dir = node['github-user']['tmp_dir']

execute 'clean temporary directory' do
  command 'rm -rf ' + tmp_dir
end

execute 'clone and copy dotfiles repository' do
  command <<-EOC
    git clone https://github.com/#{account}/#{dotfiles_repository}.git #{tmp_dir}
  EOC
end
