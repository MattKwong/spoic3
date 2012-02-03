ActiveAdmin.register ScheduledHistory do
# The authorization is done using the AdminAbility class
  controller.authorize_resource
  menu :if => proc{ can?(:read, ScheduledHistory) },  :priority => 2, :label => "History", :parent => "Groups"

end
