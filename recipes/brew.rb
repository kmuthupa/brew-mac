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
   jsonpp
   git).each do |package|
     homebrew_package package
   end

# utilities
%w(tree
   htop
   git-extras
   jq).each do |package|
     homebrew_package package
   end

# development
%w(vim
   rbenv
   ruby-build
   mysql
   npm).each do |package|
     homebrew_package package
   end

# cask packages
homebrew_package 'cask'

