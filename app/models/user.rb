class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[kakao], authentication_keys: [:phone]

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


  has_many :identities, dependent: :destroy


  validates_presence_of :phone, :gym, message: "내용을 입력하셔야 합니다."
  validates_uniqueness_of :phone, message: "이미 가입된 전화번호입니다."
  validates :phone, length: {
    minimum: 10,
    maximum: 11,
    too_short: "유효하지 않은 전화번호입니다.",
    too_long: "유효하지 않은 전화번호입니다."
  }

  enum gender: [:man, :woman]
  enum user_type: [:usual, :manager, :fit_table]

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

  def self.generate_fit_table_users

    user_info = [
      ["수연", 49, "2020-12-11", 950, 100, 50, 40],
      ["mmmmm", 45, "2021-03-29", 1200, 120, 80, 45],
      ["햄휴먼", 52, "2020-12-17", 950, 100, 50, 40],
      ["채원", 63, "2021-02-28", 950, 95, 55, 40],
      ["유닫", 60, "2020-11-28", 950, 100, 50, 40],
      ["윰뭄", 54, "2020-12-21", 1050, 100, 55, 50],
      ["토리", 47, "2021-02-28", 1440, 175, 60, 55],
      ["지녜", 57, "2020-12-31", 1290, 120, 80, 53],
      ["후이", 75, "2020-12-31", 950, 100, 50, 40],
      ["헬스", 50, "2020-12-21", 950, 85, 55, 44],
      ["아미맘", 47, "2021-04-01", 950, 90, 50, 40],
      ["지민", 57, "2021-01-01", 950, 80, 50, 50],
      ["현지", 59, "2020-12-25", 1050, 100, 50, 45],
      ["개구리발가락", 58, "2021-01-04", 1000, 105, 50, 45],
      ["숭구", 47, "2021-01-04", 950, 100, 50, 50],
      ["베일리", 45, "2021-01-10", 950, 100, 50, 40],
      ["하나", 43, "2021-01-04", 1500, 170, 95, 50],
      ["까비", 68, "2021-03-15", 1100, 110, 60, 45],
      ["유나", 59, "2021-06-28", 1300, 140, 60, 50],
      ["이쁜똥꼬님", 52, "2021-02-01", 1050, 110, 60, 41],
      ["코코", 65, "2021-06-30", 1400, 180, 60, 50],
      ["마다", 53, "2021-02-28", 1050, 110, 50, 45]
    ]

    user_info.each do |name, target_weight, target_date, ideal_kcal, ideal_carbo, ideal_protein, ideal_fat|
      User.create!(name: name, target_weight: target_weight, target_date: target_date, ideal_kcal: ideal_kcal, ideal_carbo: ideal_carbo, ideal_protein: ideal_protein, ideal_fat: ideal_fat, user_type: :fit_table, gym: Gym.first, phone: srand.to_s.last(11))
    end
  end

end
