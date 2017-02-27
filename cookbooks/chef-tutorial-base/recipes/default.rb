#
# Cookbook:: chef-tutorial-base
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.fatal("hello2")
Chef::Log.fatal(node['ipaddress'])
Chef::Log.fatal(node['hostname'])
Chef::Log.fatal(node['machinename'])
Chef::Log.fatal(node['fqdn'])
Chef::Log.fatal(node['domain'])

hostname = {
    "10.0.2.11" => "chef-workstation-taro.localdomain",
    "10.0.2.21" => "chef-server-taro.localdomain",
    "10.0.2.31" => "chef-node-taro-1.localdomain",
    "10.0.2.32" => "chef-node-taro-2.localdomain",

    "10.0.3.11" => "chef-workstation-tom.localdomain",
    "10.0.3.21" => "chef-server-tom.localdomain",
    "10.0.3.31" => "chef-node-tom-1.localdomain",
    "10.0.3.32" => "chef-node-tom-2.localdomain",
}

template "/etc/hosts" do
  source "hosts"
  owner "root"
  group "root"
  mode 0644
end

template "/etc/sysconfig/network" do
  source "network"
  owner "root"
  group "root"
  mode 0644
  variables(
      :hostname => hostname[node['ipaddress']]
  )
end

template "/home/ec2-user/.ssh/chef-tutorial.pem" do
  source "chef-tutorial.pem"
  owner "ec2-user"
  group "ec2-user"
  mode 0600
end

template "/root/.ssh/chef-tutorial.pem" do
  source "chef-tutorial.pem"
  owner "root"
  group "root"
  mode 0600
end