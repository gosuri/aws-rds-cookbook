# Copyright (c) 2013 Greg Osuri <gosuri@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

module Overclock
  module Aws
    module RDS
      SERIALIZE_ATTRS = [
        :allocated_storage            ,
        :auto_minor_version_upgrade   ,
        :availability_zone            ,
        :backup_retention_period      ,
        :character_set_name           ,
        :db_instance_class            ,
        :db_instance_identifier       ,
        :db_name                      ,
        :db_parameter_group_name      ,
        :db_subnet_group_name         ,
        :db_security_groups           ,
        :db_subnet_group_name         ,
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
        :publicly_accessible          ,
        :tags                         ,
        :vpc_security_group_ids
      ]

      DESERIALIZE_ATTRS = [
        :allocated_storage            ,
        :auto_minor_version_upgrade   ,
        :backup_retention_period      ,
        :character_set_name           ,
        :db_instance_class            ,
        :db_instance_identifier       ,
        :db_name                      ,
        :engine                       ,
        :engine_version               ,
        :iops                         ,
        :license_model                ,
        :master_username              ,
        :multi_az                     ,
        :preferred_backup_window      ,
        :preferred_maintenance_window ,
        :endpoint_address
      ]

      def instance(id = new_resource.id)
        @instance ||= rds.db_instances[id]
      end

      def rds(key = new_resource.aws_access_key, secret = new_resource.aws_secret_access_key)
        begin 
          require 'aws-sdk'
        rescue LoadError
          Chef::Log.error("Missing gem 'aws-sdk'. Use the default aws-rds recipe to install it first.")
        end
        @rds ||= AWS::RDS.new(access_key_id: key, secret_access_key: secret, region: region)
      end

      def create_instance(id = new_resource.id)
        if @instance = rds.db_instances.create(id, serialize_attrs)
          while (instance.status != 'available') do
            sleep 1
          end
        end
      end

      def update_instance(id = new_resource.id)
        # placeholder for update instance 
      end

      def set_node_attrs
        node.override[:aws_rds][new_resource.id] = deserialize_attrs
      end

      def region
        new_resource.region || determine_region
      end

private

      # Determine the current region or fail gracefully
      def determine_region
        `curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | grep -Po "(us|sa|eu|ap)-(north|south)?(east|west)?-[0-9]+"`.strip
      rescue
        nil
      end

      def serialize_attrs
        SERIALIZE_ATTRS.inject({}) do | result, key |
          if value = new_resource.send(key)
            result[key] = value
          end
          result
        end
      end

      def deserialize_attrs
        DESERIALIZE_ATTRS.inject({}) do |result, attr|
          result[attr] = instance.send(attr)
          result
        end
      end
    end
  end
end
