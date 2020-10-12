class SubItem < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  belongs_to :category, optional: true
  belongs_to :food, optional: true
  has_and_belongs_to_many :gyms, join_table: :gyms_sub_items
  has_many :points, dependent: :nullify

  enum sub_item_type: %i(normal food)
  # accepts_nested_attributes_for :gyms

  def self.generate_food_sub_items
    sub_item_info = [[["계란스크램블(2)", 136], ["케첩", 30], ["올리브유", 80], ["샐러드 100g", 30], ["샐러드 드레싱 25g", 88], ["저지방우유", 96]],
                      [["식빵2",	222], ["계란",	68], ["버터(15g)",	120], ["딸기잼(30g)",	72], ["저지방우유",	96]],
                      [["닭가슴살",	110], ["고구마(180g)",	223.2], ["샐러드 100g",	30], ["샐러드 드레싱 30g",	132]],
                      [["밥1공기",	308.7], ["제육볶음(200)",	380], ["김치(100)",	30]],
                      [["밥1공기",	308.7], ["돈까스",	511.2], ["치즈 ",	80]],
                      [["밥1공기",	308.7], ["불고기",	370], ["김치(100)",	30]],
                      [["목살 180g",	565.2], ["밥1공기",	308.7]],
                      [["밥1공기",	308.7], ["등심스테이크",	436], ["올리브유",	100], ["스테이크 소스",	100]]]

    [{title: "스크램블에그, 샐러드,우유", food_type: :morning, kcal: 460, target_calorie: 500},
      {title: "에그토스트 우유", food_type: :morning, kcal: 578, target_calorie: 600},
      {title: "닭가슴살, 고구마, 샐러드1끼", food_type: :main, kcal: 495.2, target_calorie: 500},
      {title: "제육 볶음 백반", food_type: :main, kcal: 718.7, target_calorie: 700},
      {title: "치즈돈까스", food_type: :main, kcal: 899.9, target_calorie: 700},
      {title: "불고기 정식", food_type: :main, kcal: 708.7, target_calorie: 900},
      {title: "돼지 목살 구이", food_type: :main, kcal: 873.9, target_calorie: 900},
      {title: "등심스테이크", food_type: :main, kcal: 944.7, target_calorie: 900}].each_with_index do |food_info, index|
      food = Food.create food_info
      sub_item_info[index].each do |title, calorie|
        food.sub_items << SubItem.create(title: title, calorie: calorie, sub_item_type: :food)
      end
    end

  end
  
  
end
