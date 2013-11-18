module Overclock
  module Aws
    module RDS

      def create_if_missing
        if instance = rds.db_instances[new_resource.id]
          if instance.exists?
            node.override[:aws_rds][new_resource.id] = hash(rds.db_instances[new_resource.id])
          else
            create
          end
        end
      end

      def create(nr = new_resource)
        Chef::Log.info "creating AWS RDS instance with id: #{nr.id}. This could take a while."
        if instance = rds.db_instances.create(nr.id, params)
          while (instance.status != 'available') do
            sleep 2
          end
          set_endpoint(instance.endpoint_address)
        end
        Chef::Log.info "created AWS RDS instance with id: #{nr.id}"
      end

      def rds(nr = new_resource)
        begin 
          require 'aws-sdk'
        rescue LoadError
          Chef::Log.error("Missing gem 'aws-sdk'. Use the default aws-rds recipe to install it first.")
        end
        @rds ||= AWS::RDS.new(access_key_id: nr.aws_access_key, secret_access_key: nr.aws_secret_access_key)
      end

      private

      def new_instance?
        begin
          if instance = rds.db_instances[new_resource.id]
            if instance.endpoint_address
              false
            end
          end
        rescue AWS::RDS::Errors::DBInstanceNotFound
          return true
        end
      end

      def set_endpoint(addr)
        node.override[:endpoint_address] = addr
      end

      def params(nr = new_resource)
        result = {}
        attrs.each do | key |
          if value = new_resource.send(key)
            result[key] = value
          end
        end
        result
      end

      def hash(instance)
        result = {}
        s_attrs = attrs - [:availability_zone, :db_parameter_group_name, :db_security_groups, :master_user_password, :option_group_name, :port, :vpc_security_group_ids]
        s_attrs += [:endpoint_address]
        s_attrs.each do |attr|
          result[attr] = instance.send(attr)
        end
        result
      end

      def attrs
        [
          :allocated_storage            ,
          :auto_minor_version_upgrade   ,
          :availability_zone            ,
          :backup_retention_period      ,
          :availability_zone            ,
          :character_set_name           ,
          :db_instance_class            ,
          :db_instance_identifier       ,
          :db_name                      ,
          :db_parameter_group_name      ,
          :db_security_groups           ,
          :engine                       ,
          :engine_version               ,
          :iops                         ,
          :license_model                ,
          :master_user_password         ,
          :master_username              ,
          :multi_az                     ,
          :option_group_name            ,
          :port                         ,
          :preferred_backup_window      ,
          :preferred_maintenance_window ,
          :vpc_security_group_ids
        ]
      end
    end
  end
end
