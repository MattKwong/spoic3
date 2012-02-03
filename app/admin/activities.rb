ActiveAdmin.register Activity do
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
  menu :if => proc{ can?(:read, Activity) },:parent => "Users and Logs"
end