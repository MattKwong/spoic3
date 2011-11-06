class ChurchType < ActiveRecord::Base
  belongs_to :conference
  belongs_to :denomination
  belongs_to :organization
end
