class Post < ApplicationRecord
  enum gender: %i(여 남)
  enum activity: %i(대부분앉아있는다 조금활동적인편이다 돌아다닐일이많다 많이활동한다 매우메우활동적이다)
  enum lunch: %i(안먹는다 조금먹는다 평균으로먹는다 푸짐하게먹는다)
end
