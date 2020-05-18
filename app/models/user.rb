class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:phone]

  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy

  # validates :username, :phone, presence: true
  validates :phone, uniqueness: true

  #카카오페이 전환 구조
  belongs_to :gym, optional: true
  belongs_to :item, optional: true
  ################

  before_validation :assign_password, on: :create

  def assign_password
    self.password = "111111"
    self.password_confirmation = "111111"
  end

  def email_required?
    false
  end

end
