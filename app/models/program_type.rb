class ProgramType < ActiveRecord::Base
  attr_accessible :name, :description, :position

  validates :name, :description, :position, :presence => true
  validates :name, :uniqueness => true

  has_many :programs

#  acts_as_list

  default_scope :order => :position

  before_destroy :reassign_programs

  def abbr_name
    (name.split.collect { |i| i[0..1] }).join
  end

end
