class AdminUser < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable,  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :confirmable, :rememberable, :trackable, :validatable

  belongs_to :site

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :user_role, :first_name, :last_name, :site_id,
                  :liaison_id, :password, :password_confirmation, :remember_me

  validates :email, :uniqueness => true
  validates :first_name, :last_name, :user_role, :presence => true
#  validates_inclusion_of :user_role, :in => UserRole.all.map {|i| i.role_name}

  before_save :create_name

  scope :admin, where(:user_role == 'Admin')
  scope :liaison, where(:user_role == 'Liaison')

    def admin?
      self.user_role == "Admin"
    end

    def liaison?
      self.user_role == "Liaison"
    end

    def food_admin?
      self.user_role == "Food Admin"
    end

    def construction_admin?
      self.user_role == "Construction Admin"
    end

  def password_required?
  # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end
  # new function to set the password without knowing the current password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end
# new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

# new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    unless_confirmed {yield}
  end

  private
  def create_name
    self.name = self.first_name + ' ' + self.last_name
  end

end
