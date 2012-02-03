ActiveAdmin.register SessionType do
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  menu :if => proc{ can?(:read, SessionType) }, :parent => "Configuration"

  show :title => :name
end
