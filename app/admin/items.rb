ActiveAdmin.register Item do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Item) }, :parent => "Items"
  show :title => :name
end
