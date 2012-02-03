ActiveAdmin.register ChurchType do
  controller.authorize_resource
  menu :if => proc{ can?(:read, ChurchType) }, :parent => "Configuration"
  show :title => :name
end
