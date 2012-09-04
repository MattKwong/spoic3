class Vendor < ActiveRecord::Base
  attr_accessible :name, :address, :city, :state, :zip, :contact, :phone, :notes, :site_id

  validates :name,  :presence => true,
                    :length => { :within => 6..45}
  validates :address, :presence => true
  validates :city, :presence => true
  validates_inclusion_of :state, :in => State::STATE_ABBREVIATIONS, :message => 'Invalid state.'
  validates :zip, :presence => true, :length => { :maximum => 10, :minimum => 5 }
  validates :phone, :length => { :maximum => 20 }

  before_validation do
    self.phone = phone.gsub(/[^0-9]/, "")
  end

  belongs_to :site
  has_many :purchases

  def to_s
    name
  end
end