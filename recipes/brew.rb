#
# Cookbook Name:: brew-mac
# Recipe:: brew
#
# Copyright (c) 2025 Karthik Muthupalaniappan, All Rights Reserved.

# Productivity tools
productivity_packages = %w(
  ack
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
  jq
  git
)

productivity_packages.each do |package|
  homebrew_package package do
    action :install
  end
end

# Utility packages
utility_packages = %w(
  tree
  htop
  git-extras
  httpie
  jq
  ncdu
  fzf
  jid
)

utility_packages.each do |package|
  homebrew_package package do
    action :install
  end
end

# Install Homebrew Cask
homebrew_tap 'homebrew/cask'
homebrew_tap 'homebrew/cask-versions'

# QuickLook plugins
quicklook_plugins = %w(
  qlcolorcode
  qlstephen
  qlmarkdown
  quicklook-json
  qlprettypatch
  quicklook-csv
  betterzip
  webpquicklook
  suspicious-package
)

quicklook_plugins.each do |plugin|
  homebrew_cask plugin do
    action :install
  end
end

# Applications
applications = %w(
  flux
  cheatsheet
  authy
  docker
  spotify
  sequel-pro
  postman
  google-backup-and-sync
  dropbox
  1password
  1password-cli
  visual-studio-code
)

applications.each do |app|
  homebrew_cask app do
    action :install
  end
end

# Development tools
dev_packages = {
  'vim' => nil,
  'rbenv' => nil,
  'maven' => nil,
  'kafka' => nil,
  'zookeeper' => nil,
  'ruby-build' => nil,
  'mysql' => nil,
  'npm' => nil,
  'openjdk' => '@17'  # Install latest LTS Java version
}

dev_packages.each do |package, version|
  homebrew_package package do
    version version if version
    action :install
  end
end