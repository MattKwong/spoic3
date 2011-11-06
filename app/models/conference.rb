class Conference < ActiveRecord::Base
  has_many :church_type
  attr_accessible :name

end
