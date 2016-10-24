#
# Cookbook Name:: brew-mac
# Recipe:: default
#
# Copyright (c) 2016 Karthik Muthupalaniappan, All Rights Reserved.


# productivity
homebrew_package 'ack'
homebrew_package 'archey'
homebrew_package 'autoconf'
homebrew_package 'autojump'
homebrew_package 'the_silver_searcher'
homebrew_package 'tig'
homebrew_package 'tmux'
homebrew_package 'jsonpp'

# utilities
homebrew_package 'tree'
homebrew_package 'htop'
homebrew_package 'git-extras'
homebrew_package 'jq'

# development
homebrew_package 'vim'
homebrew_package 'rbenv'
homebrew_package 'ruby-build'
homebrew_package 'mysql'

# cask packages
homebrew_package 'cask'
homebrew_package 'cask'

# install oh-my-zsh
# https://github.com/robbyrussell/oh-my-zsh
execute 'install oh-my-zsh' do
  command 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'
end

# install ruby 2.3.0
execute 'install ruby 2.0.0' do
  command 'rbenv install 2.0.0-p648'
  not_if 'rbenv versions | grep 2.0.0'
end

# gems
['bundler', 'rails'].each do |gem_name|
  script "install #{gem_name}" do
    interpreter 'bash'
    code "gem install #{gem_name}"
  end
end

