ActiveAdmin.register SpecialNeed do
  controller.authorize_resource
  menu :if => proc{ can?(:read, UserRole) }, :parent => "Configuration"
end
