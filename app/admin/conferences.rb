ActiveAdmin.register Conference do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Conference) }, :parent => "Configuration"

  show :title => :name
end
