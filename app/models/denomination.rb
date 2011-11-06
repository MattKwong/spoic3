class Denomination < ActiveRecord::Base
  has_many :church_type
end
