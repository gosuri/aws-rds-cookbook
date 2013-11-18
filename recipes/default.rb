#
# Cookbook Name:: aws-rds
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#


chef_gem "aws-sdk" do
  version node[:aws_rds][:aws_sdk_version]
  action :install
end

aws_rds "testdb3" do
  aws_access_key "AKIAI6FKGWMCRBGVCMNA"
  aws_secret_access_key "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"
  engine 'MySql'
  db_instance_class 'db.t1.micro'
  allocated_storage 5
  master_username 'test_user'
  master_user_password "test-password"
  notifies :run, "template[tmp/db_config]", :immediately
end

template "tmp/db_config"
