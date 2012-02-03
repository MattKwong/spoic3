ActiveAdmin.register Organization do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Organization) }, :parent => "Configuration"

  show :title => :name
end
