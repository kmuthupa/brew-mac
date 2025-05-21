require 'spec_helper'

describe 'brew-mac::default' do
  platform 'mac_os_x'
  
  context 'When all attributes are default' do
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes all required recipes' do
      expect(chef_run).to include_recipe('brew-mac::brew')
      expect(chef_run).to include_recipe('brew-mac::gems')
      expect(chef_run).to include_recipe('brew-mac::pip')
      expect(chef_run).to include_recipe('brew-mac::utilities')
      expect(chef_run).to include_recipe('brew-mac::npm-packages')
      expect(chef_run).to include_recipe('brew-mac::dotfiles')
    end
  end

  context 'brew recipe' do
    it 'installs required homebrew packages' do
      %w(vim rbenv maven kafka zookeeper ruby-build mysql npm).each do |package|
        expect(chef_run).to install_homebrew_package(package)
      end
    end
  end

  context 'gems recipe' do
    it 'installs specified Ruby version' do
      expect(chef_run).to run_execute('install Ruby 3.2.2')
    end

    it 'installs required gems' do
      %w(bundler rails pry).each do |gem|
        expect(chef_run).to run_script("install #{gem}")
      end
    end
  end

  context 'pip recipe' do
    it 'installs pip properly' do
      expect(chef_run).to create_remote_file('/tmp/get-pip.py')
      expect(chef_run).to run_execute('install_pip')
    end
  end

  context 'utilities recipe' do
    it 'installs oh-my-zsh' do
      expect(chef_run).to create_remote_file('/tmp/install-oh-my-zsh.sh')
    end

    it 'configures autoenv' do
      expect(chef_run).to run_ruby_block('configure_autoenv')
    end

    it 'configures rbenv' do
      expect(chef_run).to run_ruby_block('configure_rbenv')
    end
  end
end