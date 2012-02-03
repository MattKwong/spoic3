ActiveAdmin.register Reminder do
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  menu :if => proc{ can?(:read, Reminder) }, :parent => "Configuration"

  show :title => :name
end
