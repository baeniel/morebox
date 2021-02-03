class Card < ApplicationRecord
  validates :description, presence: true
  # validates :importance, presence: true
  validates :category, presence: true

  enum importance: %i(빠르게가능합니다(하루) 시간이좀걸려요(일주일) 시간이많이걸립니다ㅠ(한달) 할지안할지논의가필요해요)
  enum category: %i(핏테이블기능(개발) 디자인 핏테이블상담 마케팅 기타)
  enum status: %i(ready complete)
end
