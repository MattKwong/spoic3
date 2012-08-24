class ScheduledGroup < ActiveRecord::Base

  attr_accessible :name, :comments, :current_counselors, :current_youth,
                  :current_total, :liaison_id, :scheduled_priority,
                  :session_id, :church_id, :registration_id, :group_type_id, :second_payment_date,
                  :second_payment_total
  default_scope :include => :church, :order => 'churches.name'
  scope :active, where('current_total > ?', 0)
  has_many :payments
  has_many :change_histories
  has_many :adjustments
  belongs_to :church
  belongs_to :liaison
  belongs_to :session
  belongs_to :session_type, :foreign_key => :group_type_id
  has_one :roster

  validates :name, :liaison_id, :session_id, :church_id, :registration_id, :group_type_id, :presence => true
  validates_numericality_of :liaison_id, :session_id, :church_id, :registration_id, :group_type_id,
                            :second_payment_total, :only_integer => true
  validates_numericality_of :scheduled_priority, :greater_than => 0,
                            :less_than_or_equal_to => 10,
                            :only_integer => true
  validates_numericality_of :current_youth, :greater_than_or_equal_to => 0,
                            :only_integer => true
  validates_numericality_of :current_counselors, :greater_than_or_equal_to => 0,
                            :only_integer => true
  def senior_high?
     session_type.name.include?("Senior High")
  end

  def junior_high?
     session_type.name.include?("Junior High")
  end

end
