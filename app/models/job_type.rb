class JobType < ActiveRecord::Base
  attr_accessible :name

  has_many :jobs

  def construction?
    name == 'Construction'
  end

  def cook?
    name == "Cook" || "Food"
  end

  def slc?
    name == "SLC"
  end

  def sd?
    name == "Site Director"
  end

  def other?
    slc? || sd?
  end

end
