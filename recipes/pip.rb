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
# Note: nose is deprecated - use pytest instead
# Note: awscli v2 is recommended and should be installed via brew (awscli)
pip_packages = {
  'requests' => '2.32.5',
  'pytest' => '8.3.4',
  'boto3' => '1.35.0'
}

pip_packages.each do |package, version|
  execute "install #{package}" do
    command "pip3 install #{package}==#{version}"
    not_if "pip3 freeze | grep -w '^#{package}==#{version}$'"
  end
end