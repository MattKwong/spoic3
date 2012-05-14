ActiveAdmin.register Job do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Job) }, :parent => "Configuration"
  show :title => :name
end
