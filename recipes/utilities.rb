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

# install vim config and plugins
# https://github.com/pivotal/vim-config.git ~/.vim
# unless Dir.exist? '~/.vim'
  # p "Vim config doesn't exist! Cloning and installing.."
  # execute 'clone and copy pivotal vim config repository' do
    # command 'git clone https://github.com/pivotal/vim-config.git ~/.vim'
  # end
  # execute 'install vim plugins' do
    # command '~/.vim/bin/install'
  # end
# else
  # p "Vim config exists already! Skipping.."
# end

