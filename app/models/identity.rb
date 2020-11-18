class Identity < ApplicationRecord
  belongs_to :user
  validates :uid, presence: true
  validates :provider, presence: true
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
