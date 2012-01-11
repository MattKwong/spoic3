ActiveAdmin::Dashboards.build do
#  if @current_admin_user.can? :read
     section "Recent System Activity" do
      table_for Activity.order("activity_date") do
        column :activity_date, :format => :long
        column :user_name
        column :activity_type
        column :activity_details
      end
    end
#  end
end
