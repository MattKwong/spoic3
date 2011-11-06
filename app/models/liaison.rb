class Liaison < ActiveRecord::Base
  scope :senior_high_only, where(:liaison_type_id => 1)
  scope :junior_high_only, where(:liaison_type_id => 2)
  scope :both, where(:liaison_type_id => 3)
  scope :for_registered_groups, where(:liaison_type_id => '')

  belongs_to :church
  belongs_to :liaison_type

  attr_accessible :active, :address1, :address2, :city, :state, :zip, :first_name,
        :last_name, :name, :email1, :email2, :cell_phone, :home_phone, :work_phone,
        :fax, :liaison_type, :title, :church_id, :liaison_type_id

  before_save :create_name

private

  def create_name
    self.name = self.first_name + ' ' + self.last_name
  end
end
