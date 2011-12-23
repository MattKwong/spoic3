class Reminder < ActiveRecord::Base
  attr_accessible :active, :first_line, :name, :second_line, :name, :seq_number

  validates :name, :first_line, :second_line,
                    :length => { :within => 6..40}
  validates :name,:uniqueness => true, :allow_blank => false
  validates :first_line, :presence => true
  validates_numericality_of :seq_number,  :allow_blank => false, :only_integer =>  true, :less_than => 100,
                              :greater_than_or_equal_to => 0

end
