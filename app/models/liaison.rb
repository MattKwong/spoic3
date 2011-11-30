class Liaison < ActiveRecord::Base
  scope :senior_high_only, where(:liaison_type_id => 1)
  scope :junior_high_only, where(:liaison_type_id => 2)
  scope :both, where(:liaison_type_id => 3)
  scope :for_registered_groups, where(:liaison_type_id => '')

 #TODO Change the :churches belongs_to relation to has_many and test
  belongs_to :church
  belongs_to :liaison_type

  attr_accessible :active, :address1, :address2, :city, :state, :zip, :first_name,
        :last_name, :name, :email1, :email2, :cell_phone, :home_phone, :work_phone,
        :fax, :liaison_type, :title, :church_id, :liaison_type_id, :id

  before_save :create_name

  validates :title, :last_name, :first_name, :address1, :city, :church_id, :presence => true

  validates :state, :presence => true,
                    :length => { :is => 2}
  validates_inclusion_of :state, :in => State::STATE_ABBREVIATIONS, :message => 'Invalid state.'
  validates :zip,   :presence => true,
                    :length => { :is => 5},
                    :numericality => true
  validates_format_of :email1,
            :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message => 'Email appears to be invalid.', :allow_blank => false

  validates_format_of :email2,
            :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message => 'Email appears to be invalid.', :allow_blank => true

  validates_format_of :work_phone, :home_phone, :cell_phone, :fax, :with => /\A[0-9]{3}-[0-9]{3}-[0-9]{4}/,
                      :message => 'Please enter phone numbers in the 123-456-7890 format.'
private

  def create_name
    self.name = self.first_name + ' ' + self.last_name
  end
end
