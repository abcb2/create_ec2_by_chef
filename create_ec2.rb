# -*- coding: utf-8 -*-
require 'pp'
require 'optparse'
require 'yaml'
require 'pathname'

class CommandFactory
  def initialize(base_dir, opt)
    @base_dir = base_dir
    @opt = opt
    @user = opt[:user]
    @config_path = Pathname.new(base_dir).join('config.yaml')
    @config = YAML.load_file(@config_path)

    if opt[:debug]
      self.debug()
      exit
    end
  end

  def create()
    cfg = @config
    user = cfg[@user]
    for srv in user['servers'] do
      next unless srv['create']

      command = "knife ec2 server create --node-name %s " +
          "--subnet %s --associate-public-ip --security-group-id %s " +
          "--region %s --image %s --server-connect-attribute %s " +
          "--flavor %s --ssh-user %s --ssh-key %s --private-ip-address %s " +
          "--identity-file ~/.ssh/chef-tutorial.pem --run-list 'role[chef-tutorial-base]'"
      convert = [
          srv['name'], user['subnet'], cfg['security_group_id'],
          cfg['region'], cfg['image'], cfg['server_connect_attribute'],
          srv['flavor'], cfg['ssh_user'], cfg['ssh_key'],
          srv['private_ip_address'],
      ]
      puts(command % convert)
    end
  end

  def debug()
    #@@data[@user.to_sym]
    pp(@opt)
    puts("----------------")
    pp(@config_path)
    puts("----------------")
    pp(@config)
    puts("----------------")
  end
end

if __FILE__ == $0
  option = {}
  OptionParser.new do |opt|
    # opt.on('-a',         '1文字オプション 引数なし')         {|v| option[:a] = v}
    # opt.on('-b VALUE',   '1文字オプション 引数あり（必須）')   {|v| option[:b] = v}
    # opt.on('-c [VALUE]', '1文字オプション 引数あり（省略可能）'){|v| option[:c] = v}
    opt.on('-u', '--user=USER', 'ユーザー(taro, tom)') { |v| option[:user] = v }
    opt.on('-d', '--debug', 'デバッグ') { |v| option[:debug] = v }
    opt.parse!(ARGV)
  end

  base_dir = File.dirname(File.absolute_path(__FILE__))
  f = CommandFactory.new(base_dir, option)
  f.create()
end

=begin
knife ec2 pluginを用いてchef-tutorial用のec2を作成する

$ knife ec2 server create --node-name ec2-node01 --subnet=subnet-7dfe830b --associate-public-ip --security-group-id=sg-75b6de12 --region=ap-northeast-1 --image=ami-1d4d0f7a --server-connect-attribute=public_ip_address --flavor=t2.nano --ssh-user=ec2-user --ssh-key=chef-tutorial --private-ip-address 10.0.2.11


10.0.1.0/24 chef-gateway
10.0.2.0/24 taro
10.0.3.0/24 tom

.11 chef-workstation-{name}
.21 chef-server-{name}
.31 chef-node-{name}
.32 chef-node-{name}

=end