ActiveAdmin.register Denomination do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Denomination) }, :parent => "Configuration"

  show :title => :name
end
