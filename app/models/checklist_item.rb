class ChecklistItem < ActiveRecord::Base
  attr_accessible :name, :due_date, :notes, :seq_number, :description

  validates :name, :notes, :presence => true,
                    :length => { :within => 6..40},
                    :uniqueness => true
    validates_numericality_of :seq_number,  :allow_blank => false, :only_integer =>  true, :less_than => 100,
                              :greater_than_or_equal_to => 0
  validates :due_date, :presence => true
end
