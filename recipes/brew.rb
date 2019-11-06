#
# Cookbook Name:: brew-mac
# Recipe:: default
#
# Copyright (c) 2016 Karthik Muthupalaniappan, All Rights Reserved.


# productivity
%w(ack
   archey
   autoconf
   autoenv
   autojump
   the_silver_searcher
   tig
   tmux
   fd
   diff-so-fancy
   bat
   jsonpp
   git).each do |package|
     homebrew_package package
   end

# utilities
%w(tree
   htop
   git-extras
   httpie
   jq
   ncdu
   fzf
   jid).each do |package|
     homebrew_package package
   end

# cask packages
homebrew_package 'cask'

homebrew_tap 'homebrew/cask-versions'

# cask quick look plugins
%w(
   qlcolorcode
   qlstephen
   qlmarkdown
   quicklook-json
   qlprettypatch
   quicklook-csv
   betterzip
   webpquicklook
   suspicious-package
   ).each do |package|
     homebrew_cask package
   end

# cask applications
# TODO: get Java8 working
%w(flux
   cheatsheet
   authy
   docker
   spotify
   sequel-pro
   postman
   google-backup-and-sync
   dropbox
   duet
   1password
   1password-cli
   atom
   ).each do |package|
     homebrew_cask package
   end

# development
%w(vim
   rbenv
   maven
   kafka
   zookeeper
   ruby-build
   mysql
   npm).each do |package|
     homebrew_package package
   end


