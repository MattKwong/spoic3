class Session < ActiveRecord::Base

  belongs_to :site
  belongs_to :period
  belongs_to :session_type
  belongs_to :payment_schedule
  belongs_to :program
  has_many :scheduled_groups
  accepts_nested_attributes_for :scheduled_groups

  attr_accessible :name, :period_id, :site_id, :payment_schedule_id, :session_type_id, :program_id

  def scheduled_adults
    (self.scheduled_groups.map &:current_counselors).sum
  end

  def scheduled_youth
    (self.scheduled_groups.map &:current_youth).sum
  end

  def scheduled_total
    scheduled_adults + scheduled_youth
  end
  def purchased_during
    program.purchases.where('date >= ? AND date < ?', period.start_date, period.end_date).inject(0) { |t, p| t += p.total }
  end

  def days
    end_date - start_date + 1
  end

  def volunteer_days
    days * total
  end

  def cost_per_day
    if volunteer_days != 0
      total_cost / volunteer_days
    else
      0
    end
  end

  def total_cost
    (start_date..end_date).inject(0) do |sum, date|
      inventory = program.food_inventories.after(date).order('date ASC').first
      if inventory
        sum + inventory.daily_cost
      else
        sum
      end
    end
  end

end
