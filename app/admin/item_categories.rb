ActiveAdmin.register ItemCategory do
  controller.authorize_resource
  menu :if => proc{ can?(:read, ItemCategory) }, :parent => "Items"
  show :title => :name
end
