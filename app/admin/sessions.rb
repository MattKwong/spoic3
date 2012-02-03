ActiveAdmin.register Session do
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  menu :if => proc{ can?(:read, Session) }, :parent => "Configuration"

  show :title => :name
end
