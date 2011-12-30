class Adjustment < ActiveRecord::Base
  attr_accessible :id, :amount, :reason_code,
                  :note, :group_id, :updated_by

  belongs_to :scheduled_group

  validates :amount, :reason_code, :presence => true
  validates_numericality_of :amount

end
