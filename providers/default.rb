include Overclock::Aws::RDS

def whyrun_supported?
  true
end

action :create do
  if @current_resource.exists
    Chef::Log.info "#{@new_resource} already exists - nothing to do."
    set_node_attrs
    Chef::Log.info "#{@new_resource} update instance values if is required"
    update_instance
  else
    converge_by "Create #{@new_resource}" do
      Chef::Log.info "Creating #{new_resource}. This could take up to 10 minutes"
      create_instance(@new_resource.id)
      Chef::Log.info "Created #{@new_resource}"
      set_node_attrs
    end
  end
end

action :delete do
  if @current_resource.exists
    converge_by "Deleting #{@new_resource}" do
      Chef::Log.info "Deleting #{@new_resource}"
      delete_instance(@new_resource.id, new_resource.skip_final_snapshot)
      Chef::Log.info "Deleted #{@new_resource}"
    end
  else
    Chef::Log.info "#{new_resource} does not exist - nothing to do."
  end
end


def load_current_resource
  @current_resource = Chef::Resource::AwsRds.new(new_resource.id)
  @current_resource.exists = instance.exists?
end
