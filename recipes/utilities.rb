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

# activate autoenv
execute 'activate autoenv' do
  command 'echo "source $(brew --prefix autoenv)/activate.sh" >> ~/.bash_profile'
end

# activate rbenv
execute 'activate rbenv' do
  command 'export PATH="$HOME/.rbenv/bin:$PATH" >> ~/.bash_profile'
end

# install skdman
execute 'install sdkman' do
  command 'curl -s "https://get.sdkman.io" | zsh'
end

# source skdman
execute 'install sdkman' do
  command 'source "$HOME/.sdkman/bin/sdkman-init.sh"'
end

# install sdks
# execute 'install sdks' do
  # command <<-EOC
    # sdk install maven && sdk install gradle && sdk install scala && sdk install sbt && sdk install crash
  # EOC
# end

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

