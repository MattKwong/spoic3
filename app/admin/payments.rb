ActiveAdmin.register Payment do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Payment) }, :priority => 2, :label => "Payments", :parent => "Groups"
end
