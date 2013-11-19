#
# Cookbook Name:: aws-rds
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

chef_gem "aws-sdk" do
  version node[:aws_sdk_version]
  action :install
end
