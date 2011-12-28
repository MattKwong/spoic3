class RosterItem < ActiveRecord::Base

  attr_accessible :id, :roster_id, :first_name, :last_name, :address1, :address2, :city, :state, :zip,
    :group_id, :male, :youth, :shirt_size, :email, :grade_in_fall

  belongs_to :roster

  validates :roster_id, :first_name, :last_name, :address1, :city, :state, :group_id,
    :shirt_size, :grade_in_fall, :presence => true

  validates :state, :presence => true,
                    :length => { :is => 2}
  validates_inclusion_of :state, :in => State::STATE_ABBREVIATIONS, :message => 'Invalid state.'
  validates :zip,   :presence => true,
                    :length => { :is => 5},
                    :numericality => true
  #TODO: Conditional validations of email and grade in fall
  validates_format_of :email,
            :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message => 'Email appears to be invalid.', :allow_blank => true#, :if => :youth?

  validates_format_of :email,
            :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message => 'Email appears to be invalid.', :allow_blank => false#, :if => !:youth?
  validates :grade_in_fall, :presence => true#,:if => :youth




end
