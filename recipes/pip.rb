#
# Cookbook Name:: brew-mac
# Recipe:: pip
#
# Copyright (c) 2025 Karthik Muthupalaniappan, All Rights Reserved.

# Install pip using the recommended get-pip.py method
remote_file '/tmp/get-pip.py' do
  source 'https://bootstrap.pypa.io/get-pip.py'
  mode '0755'
  action :create
  notifies :run, 'execute[install_pip]', :immediately
end

execute 'install_pip' do
  command 'python3 /tmp/get-pip.py'
  action :nothing
end

file '/tmp/get-pip.py' do
  action :delete
end

# Install useful pip packages with version pinning
pip_packages = {
  'requests' => '2.31.0',
  'nose' => '1.3.7',
  'awscli' => '1.29.0'
}

pip_packages.each do |package, version|
  execute "install #{package}" do
    command "pip3 install #{package}==#{version}"
    not_if "pip3 freeze | grep -w '^#{package}==#{version}$'"
  end
end