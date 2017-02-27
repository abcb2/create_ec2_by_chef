# 概要
knife ec2 pluginを用いてchef-tutorial用のec2を作成する

```
$ knife ec2 server create \
      --node-name chef-workstation-taro \
      --subnet subnet-7dfe830b \
      --associate-public-ip \
      --security-group-id sg-75b6de12 \
      --region ap-northeast-1 \
      --image ami-1d4d0f7a \
      --server-connect-attribute public_ip_address \
      --flavor t2.nano \
      --ssh-user ec2-user \
      --ssh-key chef-tutorial \
      --private-ip-address 10.0.2.11 \
      --identity-file ~/.ssh/chef-tutorial.pem \
      --run-list 'role[chef-tutorial-base]'
```

下記のネットワーク構成

```
10.0.1.0/24 chef-gateway
10.0.2.0/24 taro
10.0.3.0/24 tom

.11 chef-workstation-{name}
.21 chef-server-{name}
.31 chef-node-{name}
.32 chef-node-{name}
```