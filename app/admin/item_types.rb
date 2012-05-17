ActiveAdmin.register ItemType do
  controller.authorize_resource
  menu :if => proc{ can?(:read, ItemType) }, :parent => "Items"
  show :title => :name
end
