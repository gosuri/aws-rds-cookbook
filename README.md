# AWS RDS cookbook

This cookbook provides libraries, resources and providers to configure and manage Amazon Relational Database Service (Amazon RDS) with the EC2 API.

# Requirements

Requires Chef 0.7.10 or higher for Lightweight Resource and Provider support. Chef 0.8+ is recommended. 

An Amazon Web Services account is required. The Access Key and Secret Access Key are used to authenticate with AWS.

# Resources/Providers

The `aws_rds` LWRP manages a RDS instance

## Actions

- `:create`: creates a new RDS instance

## Attribute Parameters

- `allocated_storage`:  required - (Integer) The amount of storage (in gigabytes) to be initially allocated for the database instance.
- `auto_minor_version_upgrade`: (Boolean) Indicates that minor engine upgrades will be applied automatically to the DB Instance during the maintenance window. Default: true
- `availability_zone`: (String) The EC2 Availability Zone that the database instance will be created in.
- `backup_retention_period`: (Integer) The number of days for which automated backups are retained. Setting this parameter to a positive number enables backups. Setting this parameter to 0 disables automated backups.
- `character_set_name`: (String) For supported engines, indicates that the DB Instance should be associated with the specified CharacterSet.
- `db_instance_class`: required - (String) The compute and memory capacity of the DB Instance.
- `db_name`: (String) The name of the database to create when the DB Instance is created. If this parameter is not specified, no database is created in the DB Instance.
- `db_parameter_group_name`: (String) The name of the database parameter group to associate with this DB instance. If this argument is omitted, the default DBParameterGroup for the specified engine will be used.
- `db_security_groups`: (Array) A list of DB Security Groups to associate with this DB Instance.
- `db_subnet_group_name`: (String) A DB Subnet Group to associate with this DB Instance. If there is no DB Subnet Group, then it is a non-VPC DB instance.
- `engine`: required - (String) The name of the database engine to be used for this instance.
- `engine_version`: (String) The version number of the database engine to use. Example: 5.1.42
- `iops`: (Integer) The amount of provisioned input/output operations per second to be initially allocated for the database instance. Constraints: Must be an integer Type: Integer
- `license_model`: (String) License model information for this DB Instance. Valid values: license-included | bring-your-own-license | general-public-license
- `master_user_password`: required - (String) The password for the master DB Instance user.
- `master_username`: required - (String) The name of master user for the client DB Instance.
- `multi_az`: (Boolean) Specifies if the DB Instance is a Multi-AZ deployment. You cannot set the AvailabilityZone parameter if the MultiAZ parameter is set to true .
- `option_group_name`: (String) Indicates that the DB Instance should be associated with the specified option group.
- `port`: (Integer) The port number on which the database accepts connections.
- `preferred_backup_window`: (String) The daily time range during which automated backups are created if automated backups are enabled, as determined by the BackupRetentionPeriod.
- `preferred_maintenance_window`: (String) The weekly time range (in UTC) during which system maintenance can occur.
- `publicly_accessible`: (Boolean) Specifies the accessibility options for the DB Instance. A value of true specifies an Internet-facing instance with a publicly resolvable DNS name, which resolves to a public IP address. A value of false specifies an internal instance with a DNS name that resolves to a private IP address. Default: The default behavior varies depending on whether a VPC has been requested or not. The following list shows the default behavior in each case.
- `tags`: (Array) A list of tags to associate with this DB Instance. For example [{:key => 'bod', :value => "#{DateTime.now.to_s[0..18]}"}
- - Default VPC: true
- - VPC: false If no DB subnet group has been specified as part of the request and the PubliclyAccessible value has not been set, the DB instance will be publicly accessible. If a specific DB subnet group has been specified as part of the request and the PubliclyAccessible value has not been set, the DB instance will be private.
- `vpc_security_group_ids`: (Array) A list of Ec2 Vpc Security Groups to associate with this DB Instance. Default: The default Ec2 Vpc Security Group for the DB Subnet group's Vpc.

# Usage

In `metadata.rb` you should declare a dependency on this cookbook. For example:

```
depends 'aws-rds'
```

A recipe using this LWRP may look like this:

```ruby
db_info = {
  name:     'myappdb',
  username: 'test_user',
  password: 'test-password'
}

# Creates an instance with id 'myappdb'

aws_rds db_info[:name] do
  # will use the iam role if available
  # optionally place the keys
  # see http://docs.aws.amazon.com/AWSSdkDocsRuby/latest/DeveloperGuide/ruby-dg-roles.html
  # aws_access_key        'YOUR_AWS_ACCESS_KEY'
  # aws_secret_access_key 'YOUR_AWS_SECRET'
  engine                'postgres'
  db_instance_class     'db.t1.micro'
  allocated_storage     5
  master_username       db_info[:username]
  master_user_password  db_info[:password]
end

# Instance information will be available in the node object `node[:aws_rds]['myappdb']`
# Since this attribute is set during the `execution` phase of the cookbook,
# you'll need to use Lazy Attribute Evaluation to set the template variable during `execute` phase using `lazy` block

template "/tmp/database.yml" do
  variables lazy {
    {
      host:     node[:aws_rds][db_info[:name]][:endpoint_address],
      adapter:  'postgresql',
      encoding: 'unicode',
      database: db_info[:name],
      username: db_info[:username],
      password: db_info[:password]
    }
  }
end
```

For a more detailed example. See https://github.com/gosuri/rails-app-cookbook for a complete application using this cookbook

# Attributes

- aws_rds['aws_sdk_version']: `aws-sdk` RubyGem version. Default `1.11.1`

# Recipes

## default.rb

The default recipe installs the `aws-sdk` RubyGem, which this cookbook requires in order to work with the EC2 API. Make sure that the aws_rds recipe is in the node or role `run_list` before any resources from this cookbook are used.

```
"run_list": [
  "recipe[aws_sdk]"
]
```

The `gem_package` is created as a Ruby Object and thus installed during the Compile Phase of the Chef run.

# Contributing & Development

## Development Requirements

- Ruby 1.9.2+
- AWS Account

### Non-Gem Dependencies

- Git
- [Vagrant 1.3.5+](http://www.vagrantup.com)
- [vagrant-berkshelf 1.3.4](https://github.com/berkshelf/vagrant-berkshelf): install using `vagrant plugin install vagrant-berkshelf`
- [vagrant-omnibus 1.1.2](https://github.com/schisamo/vagrant-omnibus): install using `vagrant plugin install vagrant-omnibus`

### Runtime Rubygem Dependencies

First you'll need bundler which can be installed with a simple `gem install bundler`. Afterwords, do the following:

```
bundle install
```

## Contributing

1. Fork the project on github
2. Commit your changes to your fork
3. Send a pull request

# License & Author

Author:: Greg Osuri (<gosuri@gmail.com>)
Author:: Florin STAN (<florin.stan@gmail.com>)
Author:: Clif Smith (<clif@spanning.com>)

Copyright (c) 2013 Greg Osuri 

Licensed under the MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
