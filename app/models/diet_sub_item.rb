class DietSubItem < ApplicationRecord
  belongs_to :diet, optional: true
  belongs_to :sub_item, optional: true


  def self.generate_diet_sub_items
    # 모든 답변 알고리즘 답변에 적용
    # - 단백질 식이 정도에 따라 -  low = 포켓프로틴/ high = 밀스라이트  추천 
    # - 700kal:경우 포켓프로틴, 닭가슴살, 고구마만 제한으로 추천 
    # - 200~600kal: 700kal의 추천제품 + 쿠키, 프로틴바, 파워쉐이크, 슬림시즌 추천

    # Diet.where(protein: :low)
    # Diet.where(protein: :high)

  end
  
  
end
