ActiveAdmin::Dashboards.build do

  # The authorization is done using the AdminAbility class

  if proc{ @current_admin_user.admin? } #@current_admin_user.can? :read
     section "Recent System Activity" do
      table_for Activity.order("activity_date desc" ) do
        column :activity_date, :format => :long
        column :user_name
        column :activity_type
        column :activity_details
      end
      strong { link_to "View All Activity", admin_activities_path }
    end
  end
end
