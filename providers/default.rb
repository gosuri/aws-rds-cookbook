include Overclock::Aws::RDS

def whyrun_supported?
  true
end

action :create do
  Chef::Log.info("--> DEBUG: #{new_resource.name}")
  # do 
end

action :create_if_missing do
  create_if_missing
end

