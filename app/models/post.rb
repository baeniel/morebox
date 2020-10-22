class Post < ApplicationRecord
  enum gender: %i(여 남)
  enum activity: %i(대부분앉아있는다 조금활동적인편이다 돌아다닐일이많다 많이활동한다 매우메우활동적이다)
  enum lunch: %i(안먹는다 간단하게 평균적으로 푸짐하게)
  enum work_strength: %i(저강도 중강도 고강도)
  enum post_type: %i(인스타 트레이너)
end
