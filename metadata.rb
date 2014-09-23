name             'aws-rds'
maintainer       'Greg Osuri'
maintainer_email 'gosuri@gmail.com'
license          'MIT'
description      'Provides libraries, resources and providers to configure and manage Amazon Relational Database Service (Amazon RDS) with the EC2 API'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.4.1'
recipe           "aws-rds", "installs the aws-sdk gem during compile time"
attribute        'aws_sdk_version', description: "aws-sdk gem version", type: "string"

depends 'build-essential'
supports 'ubuntu'
