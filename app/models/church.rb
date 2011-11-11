class Church < ActiveRecord::Base
  belongs_to :liaison
  belongs_to :church_type
  scope :inactive, where(:active => 'f')
  scope :unregistered, where(:registered => 'f')
  scope :active, where(:active => 't')
  scope :registered, where(:registered => 't')

    attr_accessible :name, :active, :address1, :address2, :city, :email1, :fax,
                    :church_type_id, :liaison_id, :office_phone, :state, :zip,
                    :registered

  validates :name,  :presence => true,
                    :length => { :within => 6..40},
                    :uniqueness => true

end
