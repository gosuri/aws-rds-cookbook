actions :create
default_action :create

attribute :id                           , kind_of: String                 , name_attribute: true
attribute :aws_access_key               , kind_of: String                 
attribute :aws_secret_access_key        , kind_of: String                 
attribute :allocated_storage            , kind_of: Integer                , required: true
attribute :auto_minor_version_upgrade   , kind_of: [TrueClass,FalseClass] , default: true
attribute :availability_zone            , kind_of: String
attribute :region                       , kind_of: String                 
attribute :backup_retention_period      , kind_of: Integer
attribute :character_set_name           , kind_of: String
attribute :db_instance_class            , kind_of: String                 , required: true
attribute :db_instance_identifier       , kind_of: String
attribute :db_name                      , kind_of: String
attribute :db_parameter_group_name      , kind_of: String
attribute :db_subnet_group_name         , kind_of: String
attribute :db_security_groups           , kind_of: Array
attribute :engine                       , kind_of: String                 , required: true , default: 'postgres'
attribute :engine_version               , kind_of: String
attribute :iops                         , kind_of: Integer
attribute :license_model                , kind_of: String
attribute :master_user_password         , kind_of: String                 , required: true
attribute :master_username              , kind_of: String                 , required: true
attribute :multi_az                     , kind_of: [TrueClass,FalseClass] , default: false
attribute :option_group_name            , kind_of: String
attribute :port                         , kind_of: Integer
attribute :preferred_backup_window      , kind_of: String
attribute :preferred_maintenance_window , kind_of: String
attribute :publicly_accessible          , kind_of: [TrueClass,FalseClass] , default: false
attribute :tags                         , kind_of: Array
attribute :vpc_security_group_ids       , kind_of: Array

attr_accessor :exists
