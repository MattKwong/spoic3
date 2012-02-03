ActiveAdmin.register LiaisonType do
  controller.authorize_resource
  menu :if => proc{ can?(:read, LiaisonType) }, :parent => "Configuration"

  show :title => :name
end
