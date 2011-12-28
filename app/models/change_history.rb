class ChangeHistory < ActiveRecord::Base
    attr_accessible :created_at, :group_id, :new_counselors, :old_counselors, :new_youth, :old_youth,
      :new_total, :old_total, :updated_by, :updated_at, :new_site, :old_site, :new_week, :old_week,
      :new_session, :old_session, :site_change, :week_change, :count_change

  validates :group_id, :new_counselors, :old_counselors, :new_youth, :old_youth,
      :new_total, :old_total, :updated_by, :new_site, :old_site, :new_week, :old_week,
      :new_session, :old_session, :presence => true
end
