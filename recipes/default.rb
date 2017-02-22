#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'base_config'

package 'java-1.8.0-openjdk-devel'

group 'tomcat' do
  action :create
end
#
user 'tomcat' do
  manage_home false
  shell '/bin/nologin'
  group 'tomcat'
  home '/opt/tomcat'
end

directory '/opt/tomcat' do
  action :create
end

cookbook_file '/home/vagrant/apache-tomcat-8.5.9.tar.gz' do
  source 'apache-tomcat-8.5.9.tar.gz'
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  action :create
end

execute 'sudo tar xvf /home/vagrant/apache-tomcat-8.5.9.tar.gz -C /opt/tomcat --strip-components=1'
execute 'sudo chgrp -R tomcat /opt/tomcat'
execute 'sudo chmod -R g+r /opt/tomcat/conf'

directory '/opt/tomcat/conf' do
  mode '0750'
end

execute 'sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

execute 'sudo systemctl daemon-reload'

service 'tomcat' do
  action [:start, :enable]
end
