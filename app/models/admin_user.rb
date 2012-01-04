class AdminUser < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :site

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :user_role, :first_name, :last_name,
                  :liaison_id, :password, :password_confirmation, :remember_me

#  validates :email, :uniqueness => true
#  validates :first_name, :last_name, :user_role, :presence => true
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

  private

  def create_name
    self.name = self.first_name + ' ' + self.last_name
  end

end
