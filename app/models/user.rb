class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:phone]

  #모어박스 쇼핑몰 형태
  # has_many :orders, dependent: :destroy
  # has_many :comments, dependent: :destroy
  #
  # # validates :username, :phone, presence: true
  # validates :phone, uniqueness: true
  #
  # before_validation :assign_password, on: :create
  #
  # def assign_password
  #   self.password = "111111"
  #   self.password_confirmation = "111111"
  # end
  #
  # def email_required?
  #   false
  # end
  ######################

  has_many :orders, dependent: :destroy
  has_many :line_items, through: :orders

  belongs_to :gym, optional: true
  belongs_to :item, optional: true

  validates_presence_of :phone, :gym, message: "내용을 입력하셔야 합니다."
  validates_uniqueness_of :phone, message: "이미 가입된 전화번호입니다."
  validates :phone, length: {
    minimum: 11,
    maximum: 11,
    too_short: "유효하지 않은 전화번호입니다.",
    too_long: "유효하지 않은 전화번호입니다."
  }

  before_validation :assign_password, on: :create

  def assign_password
    self.password = "111111"
    self.password_confirmation = "111111"
  end

  def image_url
    image.url.present? ? image.url(:square) : '/logo.png'
  end

  def email_required?
    false
  end

end
