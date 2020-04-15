class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:phone]

  validates :username, :phone, presence: true
  validates :phone, uniqueness: true

  before_validation :assign_password, on: :create

  def assign_password
    self.password = "111111"
    self.password_confirmation = "111111"
  end

  def email_required?
    false
  end

end
