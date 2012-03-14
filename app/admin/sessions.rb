ActiveAdmin.register Session do
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  menu :if => proc{ can?(:read, Session) }, :parent => "Configuration"

  show :title => :name

  index do
    column "Session Name", :name
    default_actions
  end
end
