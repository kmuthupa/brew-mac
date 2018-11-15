#
# Cookbook Name:: brew-mac
# Recipe:: default
#
# Copyright (c) 2016 Karthik Muthupalaniappan, All Rights Reserved.


# install pip
execute 'install pip' do
  user 'root'
  command 'easy_install pip'
end

# useful pip packages
# %w[requests
   # nose
   # awscli].each do |package|
  # script "install #{package}" do
    # interpreter 'bash'
    # code "pip install #{package}"
  # end
# end

