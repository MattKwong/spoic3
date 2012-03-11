class Vendor < ActiveRecord::Base
  attr_accessible :name, :address, :city, :state, :zip, :contact, :phone, :notes

  validates :name,  :presence => true,
                    :length => { :within => 6..45}
  validates :address, :presence => true
  validates :city, :presence => true
  validates_inclusion_of :state, :in => State::STATE_ABBREVIATIONS, :message => 'Invalid state.'
  validates :zip, :presence => true, :length => { :maximum => 10, :minimum => 5 }
  validates :phone, :length => { :maximum => 20 }


  belongs_to :site
#  has_many :purchases

  def before_validation
    self.phone = phone.gsub(/[^0-9]/, "")
  end

  def to_s
    name
  end
end