class Card < ApplicationRecord
  validates :description, presence: true
  validates :importance, presence: true
  validates :category, presence: true

  enum importance: %i(아이디어제안 빠른시일내에반영됐으면좋겠어요 급합니다ㅠㅠ)
  enum category: %i(개발 디자인 코칭 마케팅 기타)
  enum status: %i(ready complete)
end
