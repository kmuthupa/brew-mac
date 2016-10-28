#
# Cookbook Name:: brew-mac
# Recipe:: default
#
# Copyright (c) 2016 Karthik Muthupalaniappan, All Rights Reserved.

# install oh-my-zsh
# https://github.com/robbyrussell/oh-my-zsh
execute 'install oh-my-zsh' do
  command 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'
end


