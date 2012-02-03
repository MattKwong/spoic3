ActiveAdmin.register Site do
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  menu :if => proc{ can?(:read, Site) }, :parent => "Configuration"

  show :title => :name
end
