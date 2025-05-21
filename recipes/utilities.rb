#
# Cookbook Name:: brew-mac
# Recipe:: utilities
#
# Copyright (c) 2025 Karthik Muthupalaniappan, All Rights Reserved.

# Install oh-my-zsh with proper error handling and verification
OH_MY_ZSH_SCRIPT = 'https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
OH_MY_ZSH_CHECKSUM = 'SHA256_CHECKSUM'  # Replace with actual checksum

remote_file '/tmp/install-oh-my-zsh.sh' do
  source OH_MY_ZSH_SCRIPT
  mode '0755'
  action :create
  notifies :run, 'execute[verify_oh_my_zsh_script]', :immediately
end

execute 'verify_oh_my_zsh_script' do
  command "echo '#{OH_MY_ZSH_CHECKSUM} /tmp/install-oh-my-zsh.sh' | sha256sum -c"
  action :nothing
  notifies :run, 'execute[install_oh_my_zsh]', :immediately
end

execute 'install_oh_my_zsh' do
  command 'sh /tmp/install-oh-my-zsh.sh'
  not_if { ::Dir.exist?(::File.expand_path('~/.oh-my-zsh')) }
  action :nothing
end

# Clean up installation script
file '/tmp/install-oh-my-zsh.sh' do
  action :delete
end

# Configure autoenv
ruby_block 'configure_autoenv' do
  block do
    rc_file = ::File.expand_path('~/.zshrc')
    autoenv_source = 'source $(brew --prefix autoenv)/activate.sh'
    
    unless ::File.readlines(rc_file).grep(/#{Regexp.escape(autoenv_source)}/).any?
      ::File.open(rc_file, 'a') do |file|
        file.puts "\n# Autoenv configuration"
        file.puts autoenv_source
      end
    end
  end
end

# Configure rbenv
ruby_block 'configure_rbenv' do
  block do
    rc_file = ::File.expand_path('~/.zshrc')
    rbenv_init = 'eval "$(rbenv init - zsh)"'
    
    unless ::File.readlines(rc_file).grep(/#{Regexp.escape(rbenv_init)}/).any?
      ::File.open(rc_file, 'a') do |file|
        file.puts "\n# rbenv configuration"
        file.puts "export PATH=\"$HOME/.rbenv/bin:$PATH\""
        file.puts rbenv_init
      end
    end
  end
end

# Install and configure SDKMAN
SDKMAN_SCRIPT = 'https://get.sdkman.io'
SDKMAN_CHECKSUM = 'SHA256_CHECKSUM'  # Replace with actual checksum

remote_file '/tmp/sdkman.sh' do
  source SDKMAN_SCRIPT
  mode '0755'
  action :create
  notifies :run, 'execute[verify_sdkman_script]', :immediately
end

execute 'verify_sdkman_script' do
  command "echo '#{SDKMAN_CHECKSUM} /tmp/sdkman.sh' | sha256sum -c"
  action :nothing
  notifies :run, 'execute[install_sdkman]', :immediately
end

execute 'install_sdkman' do
  command 'bash /tmp/sdkman.sh'
  not_if { ::Dir.exist?(::File.expand_path('~/.sdkman')) }
  action :nothing
end

file '/tmp/sdkman.sh' do
  action :delete
end

# Install Tmux Plugin Manager
git 'clone tpm' do
  repository 'https://github.com/tmux-plugins/tpm'
  destination '~/.tmux/plugins/tpm'
  action :checkout
  not_if { ::Dir.exist?(::File.expand_path('~/.tmux/plugins/tpm')) }
end

# Install Vim configuration
git 'clone vim config' do
  repository 'https://github.com/pivotal/vim-config.git'
  destination '~/.vim'
  action :checkout
  not_if { ::Dir.exist?(::File.expand_path('~/.vim')) }
  notifies :run, 'execute[install_vim_plugins]', :immediately
end

execute 'install_vim_plugins' do
  command '~/.vim/bin/install'
  action :nothing
end