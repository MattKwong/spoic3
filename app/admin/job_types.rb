ActiveAdmin.register JobType do
  controller.authorize_resource
  menu :if => proc{ can?(:read, JobType) }, :parent => "Configuration"
  show :title => :name
  
end
