class ChangeHistory < ActiveRecord::Base
    attr_accessible :created_at, :group_id, :new_counselors, :old_counselors, :new_youth, :old_youth,
      :new_total, :old_total, :updated_by, :updated_at, :new_site, :old_site, :new_week, :old_week,
      :new_session, :old_session, :site_change, :week_change, :count_change, :notes

  validates :group_id, :updated_by, :presence => true

    with_options :if => :count_change? do |change_history|
      change_history.validates_presence_of :new_counselors, :old_counselors, :new_youth, :old_youth,
        :new_total, :old_total
      change_history.validates_numericality_of :new_counselors, :old_counselors, :new_youth, :old_youth,
        :new_total, :old_total, :only_integer => true, :greater_than => 0, :message => "must be valid number"
  end
end
