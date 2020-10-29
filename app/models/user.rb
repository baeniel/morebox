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

  belongs_to :gym, optional: true
  has_many :orders, dependent: :destroy
  has_many :points, dependent: :destroy
  has_many :assisted_orders, foreign_key: "trainer_id", class_name: "Order", dependent: :nullify


  validates_presence_of :phone, :gym, message: "내용을 입력하셔야 합니다."
  validates_uniqueness_of :phone, message: "이미 가입된 전화번호입니다."
  validates :phone, length: {
    minimum: 10,
    maximum: 11,
    too_short: "유효하지 않은 전화번호입니다.",
    too_long: "유효하지 않은 전화번호입니다."
  }

  enum gender: [:man, :woman]
  enum user_type: [:usual, :manager]

  before_validation :assign_password, on: :create

  def self.set_new_user_password
    User.all.each do |user|
      user.update password: SecureRandom.base64(6)
    end
  end

  def assign_password
    # @rand_password = ('0'..'z').to_a.shuffle.first(8).join
    # self.password = @rand_password
    # self.password_confirmation = @rand_password
    random_pw = SecureRandom.base64(6)
    self.password = random_pw
    self.password_confirmation = random_pw
  end

  def remained_point
    self.points.charged.sum(:amount) - self.points.used.sum(:amount)
  end

  def image_url
    image.url.present? ? image.url(:square) : '/logo.png'
  end

  def email_required?
    false
  end


end
