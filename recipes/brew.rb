#
# Cookbook Name:: brew-mac
# Recipe:: default
#
# Copyright (c) 2016 Karthik Muthupalaniappan, All Rights Reserved.


# productivity
%w(ack
   archey
   autoconf
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

# development
%w(vim
   rbenv
   kafka
   zookeeper
   ruby-build
   mysql
   npm).each do |package|
     homebrew_package package
   end

# cask packages
homebrew_package 'cask'

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
%w(flux
   cheatsheet
   atom
   ).each do |package|
     homebrew_cask package
   end


