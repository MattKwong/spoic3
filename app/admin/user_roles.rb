ActiveAdmin.register UserRole do
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  menu :if => proc{ can?(:read, UserRole) }, :parent => "Configuration"

   show :title => :name
end
