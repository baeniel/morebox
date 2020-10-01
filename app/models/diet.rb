class Diet < ApplicationRecord
  has_many :diet_sub_items
  has_many :sub_items, through: :diet_sub_items, dependent: :destroy

  enum purpose: %i(bulk_up slim)
  enum protein: %i(low high)

  accepts_nested_attributes_for :sub_items, allow_destroy: true


  def self.generate_diets
    # 칼로리가 +, - 100 정도의 차이
    # => 점점 더 원하는 모습으로 변하고 있으시네요. 당신의 여정을 앞으로도 쭉 응원합니다:)
    Diet.create start_calorie: -100, end_calorie: 100, body: "점점 더 원하는 모습으로 변하고 있으시네요.<br>당신의 여정을 앞으로도 쭉 응원합니다:)"
    
    
    # 칼로리 오버 (운동 목적이 벌크업일 경우)
    # -	200 ~ 300칼로리: 100일 뒤엔 목표 체중보다 2.2kg가 더 증가합니다. 생각했던 것보다 더 벌크업이 될 수 있으니

    #   1) 간식을 먹는다고 한 유저의 경우
    # 이런 간식은 어때요? (식단 추천)

    #   2) 간식을 먹지않는 유저의 경우
    # 일반식사 대신에 이런 건강식은 어때요? (식단 추천)
    Diet.create start_calorie: 200, end_calorie: 300, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>2.2kg가 더 증가합니다.<br>생각했던 것보다 더 벌크업이 될 수 있으니<br>이런 간식은 어때요?", snack: true
    Diet.create start_calorie: 200, end_calorie: 300, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>2.2kg가 더 증가합니다.<br>생각했던 것보다 더 벌크업이 될 수 있으니<br>일반식사 대신에 이런 건강식은 어때요?", snack: false

    Diet.create start_calorie: 200, end_calorie: 300, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>2.2kg가 더 증가합니다.<br>생각했던 것보다 더 벌크업이 될 수 있으니<br>이런 간식은 어때요?", snack: true, protein: :high
    Diet.create start_calorie: 200, end_calorie: 300, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>2.2kg가 더 증가합니다.<br>생각했던 것보다 더 벌크업이 될 수 있으니<br>일반식사 대신에 이런 건강식은 어때요?", snack: false, protein: :high

  #   -	300 ~ 500칼로리: 100일 뒤엔 목표 체중보다 4.4kg가 더 증가합니다. 생각했던 것보다 더 벌크업이 될 수 있으니

  #   1) 간식을 먹는다고 한 유저의 경우
  # 이런 간식은 어때요? (식단 추천)

  #   2) 간식을 먹지않는 유저의 경우
  # 일반식사 중 한 끼를 70% 정도로 줄이시면 좋을 것 같아요:) 이런 건강식은 어때요? (식단 추천)
    Diet.create start_calorie: 300, end_calorie: 500, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>4.4kg가 더 증가합니다.<br>생각했던 것보다 더 벌크업이 될 수 있으니<br>이런 간식은 어때요?", snack: true
    Diet.create start_calorie: 300, end_calorie: 500, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>4.4kg가 더 증가합니다.<br>생각했던 것보다 더 벌크업이 될 수 있으니<br>일반식사 중 한 끼를<br>70% 정도로 줄이시면 좋을 것 같아요:)<br>이런 건강식은 어때요?", snack: false

    Diet.create start_calorie: 300, end_calorie: 500, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>4.4kg가 더 증가합니다.<br>생각했던 것보다 더 벌크업이 될 수 있으니<br>이런 간식은 어때요?", snack: true, protein: :high
    Diet.create start_calorie: 300, end_calorie: 500, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>4.4kg가 더 증가합니다.<br>생각했던 것보다 더 벌크업이 될 수 있으니<br>일반식사 중 한 끼를<br>70% 정도로 줄이시면 좋을 것 같아요:)<br>이런 건강식은 어때요?", snack: false, protein: :high

  # -	500 ~ 600칼로리: 100일 뒤엔 목표 체중보다 6.6kg가 더 증가합니다. 생각했던 것보다 많이 벌크업이 될 수 있으니

  # 	1) 간식을 먹는다고 한 유저의 경우
  # 이런 간식은 어때요? (식단 추천)

  # 	2) 간식을 먹지않는 유저의 경우
  # 일반식사 중 한 끼를 절반으로 줄이시면 좋을 것 같아요:) 이런 건강식은 어때요? (식단 추천)
  
    Diet.create start_calorie: 500, end_calorie: 600, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>6.6kg가 더 증가합니다.<br>생각했던 것보다 많이 벌크업이 될 수 있으니<br>이런 간식은 어때요?", snack: true
    Diet.create start_calorie: 500, end_calorie: 600, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>6.6kg가 더 증가합니다.<br>생각했던 것보다 많이 벌크업이 될 수 있으니<br>일반식사 중 한 끼를 절반으로 줄이시면<br>좋을 것 같아요:)<br>이런 건강식은 어때요?", snack: false

    Diet.create start_calorie: 500, end_calorie: 600, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>6.6kg가 더 증가합니다.<br>생각했던 것보다 많이 벌크업이 될 수 있으니<br>이런 간식은 어때요?", snack: true, protein: :high
    Diet.create start_calorie: 500, end_calorie: 600, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>6.6kg가 더 증가합니다.<br>생각했던 것보다 많이 벌크업이 될 수 있으니<br>일반식사 중 한 끼를 절반으로 줄이시면<br>좋을 것 같아요:)<br>이런 건강식은 어때요?", snack: false, protein: :high

    # -	700+ : 100일 뒤엔 목표 체중보다 7.7kg가 더 증가합니다! 혹시 살크업은 아닐까요?! 일반식사 중 한 끼를 아예 건강식으로 대체하시는 게 좋을 것 같아요:) 이런 건강식은 어때요? (식단 추천)
    Diet.create start_calorie: 600, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>7.7kg가 더 증가합니다!<br>혹시 살크업은 아닐까요?!<br>일반식사 중 한 끼를 아예<br>건강식으로 대체하시는 게 좋을 것 같아요:)<br>이런 건강식은 어때요?"

    Diet.create start_calorie: 600, purpose: :bulk_up, body: "100일 뒤엔 목표 체중보다<br>7.7kg가 더 증가합니다!<br>혹시 살크업은 아닐까요?!<br>일반식사 중 한 끼를 아예<br>건강식으로 대체하시는 게 좋을 것 같아요:)<br>이런 건강식은 어때요?", protein: :high


    # 칼로리 오버 (운동 목적이 다이어트인 경우)
    # -	200 ~ 300칼로리: 너무 잘하고 있지만, 연말에 아직 빼지 못한 2.2kg가 그대로 남아 있어요ㅠ

    # 	1) 간식을 먹는다고 한 유저의 경우
    # 일반 간식보다 이런 간식은 어때요? (식단 추천)

    # 	2) 간식을 먹지않는 유저의 경우
    # 일반식사 대신에 이런 건강식은 어때요? (식단 추천)

    Diet.create start_calorie: 200, end_calorie: 300, purpose: :slim, body: "너무 잘하고 있지만,<br>연말에 아직 빼지 못한<br>2.2kg가 그대로 남아 있어요ㅠ<br>일반 간식보다 이런 간식은 어때요?", snack: true
    Diet.create start_calorie: 200, end_calorie: 300, purpose: :slim, body: "너무 잘하고 있지만,<br>연말에 아직 빼지 못한<br>2.2kg가 그대로 남아 있어요ㅠ<br>일반식사 대신에 이런 건강식은 어때요?", snack: false

    Diet.create start_calorie: 200, end_calorie: 300, purpose: :slim, body: "너무 잘하고 있지만,<br>연말에 아직 빼지 못한<br>2.2kg가 그대로 남아 있어요ㅠ<br>일반 간식보다 이런 간식은 어때요?", snack: true, protein: :high
    Diet.create start_calorie: 200, end_calorie: 300, purpose: :slim, body: "너무 잘하고 있지만,<br>연말에 아직 빼지 못한<br>2.2kg가 그대로 남아 있어요ㅠ<br>일반식사 대신에 이런 건강식은 어때요?", snack: false, protein: :high


  # -	300 ~ 500칼로리: 이대로 연말이 되면 아직 빼지 못한 4.4kg가 그대로 남아 있어요ㅠ

  #   1) 간식을 먹는다고 한 유저의 경우
  # 이런 간식은 어때요? (식단 추천)

  #   2) 간식을 먹지않는 유저의 경우
  # 일반식사 중 한 끼를 70% 정도로 줄이시면 좋을 것 같아요:) 이런 건강식은 어때요? (식단 추천)
    Diet.create start_calorie: 300, end_calorie: 500, purpose: :slim, body: "이대로 연말이 되면<br>아직 빼지 못한 4.4kg가 그대로 남아 있어요ㅠ<br>이런 간식은 어때요?", snack: true
    Diet.create start_calorie: 300, end_calorie: 500, purpose: :slim, body: "이대로 연말이 되면<br>아직 빼지 못한 4.4kg가 그대로 남아 있어요ㅠ<br>일반식사 중 한 끼를 70% 정도로 줄이시면<br>좋을 것 같아요:)<br>이런 건강식은 어때요?", snack: false

    Diet.create start_calorie: 300, end_calorie: 500, purpose: :slim, body: "이대로 연말이 되면<br>아직 빼지 못한 4.4kg가 그대로 남아 있어요ㅠ<br>이런 간식은 어때요?", snack: true, protein: :high
    Diet.create start_calorie: 300, end_calorie: 500, purpose: :slim, body: "이대로 연말이 되면<br>아직 빼지 못한 4.4kg가 그대로 남아 있어요ㅠ<br>일반식사 중 한 끼를 70% 정도로 줄이시면<br>좋을 것 같아요:)<br>이런 건강식은 어때요?", snack: false, protein: :high
  
  # -	500 ~ 600칼로리: 이렇게 연말이 되면 아직 빼지 못한 6.6kg가 그대로 남아 있어요ㅠ

  # 1) 간식을 먹는다고 한 유저의 경우
  # 이런 간식은 어때요? (식단 추천)

  # 2) 간식을 먹지않는 유저의 경우
  # 일반식사 중 한 끼를 절반으로 줄이시면 좋을 것 같아요:) 이런 건강식은 어때요? (식단 추천)

    Diet.create start_calorie: 500, end_calorie: 600, purpose: :slim, body: "이렇게 연말이 되면<br>아직 빼지 못한 6.6kg가 그대로 남아 있어요ㅠ<br>이런 간식은 어때요?", snack: true
    Diet.create start_calorie: 500, end_calorie: 600, purpose: :slim, body: "이렇게 연말이 되면<br>아직 빼지 못한 6.6kg가 그대로 남아 있어요ㅠ<br>일반식사 중 한 끼를 절반으로 줄이시면<br>좋을 것 같아요:)<br>이런 건강식은 어때요?", snack: false

    Diet.create start_calorie: 500, end_calorie: 600, purpose: :slim, body: "이렇게 연말이 되면<br>아직 빼지 못한 6.6kg가 그대로 남아 있어요ㅠ<br>이런 간식은 어때요?", snack: true, protein: :high
    Diet.create start_calorie: 500, end_calorie: 600, purpose: :slim, body: "이렇게 연말이 되면<br>아직 빼지 못한 6.6kg가 그대로 남아 있어요ㅠ<br>일반식사 중 한 끼를 절반으로 줄이시면<br>좋을 것 같아요:)<br>이런 건강식은 어때요?", snack: false, protein: :high
  
# -	700+ : 아직 빼지 못한 7.7kg를 가진 채로 연말을 맞이할 수도 있어요ㅠ 일반식사 중 한 끼를 아예 건강식으로 대체하시는 게 좋을 것 같아요:) 이런 건강식은 어때요? (식단 추천)
    Diet.create start_calorie: 600, purpose: :slim, body: "아직 빼지 못한 7.7kg를 가진 채로<br>연말을 맞이할 수도 있어요ㅠ<br>일반식사 중 한 끼를 아예<br>건강식으로 대체하시는 게 좋을 것 같아요:)<br>이런 건강식은 어때요?"

    Diet.create start_calorie: 600, purpose: :slim, body: "아직 빼지 못한 7.7kg를 가진 채로<br>연말을 맞이할 수도 있어요ㅠ<br>일반식사 중 한 끼를 아예<br>건강식으로 대체하시는 게 좋을 것 같아요:)<br>이런 건강식은 어때요?", protein: :high


#   칼로리 언더 (운동 목적이 벌크업일 경우)

# -	200 ~ 300칼로리: 먹는 것까지가 운동인 것 아시죠? 열심히 운동하셨는데 너무 아깝잖아요ㅠ 이런 간식들로 운동을 마무리하시는 건 어때요? (식단추천)
    Diet.create start_calorie: -300, end_calorie: -200, purpose: :bulk_up, body: "먹는 것까지가 운동인 것 아시죠?<br>열심히 운동하셨는데 너무 아깝잖아요ㅠ<br>이런 간식들로 운동을 마무리하시는 건 어때요?"
    
    Diet.create start_calorie: -300, end_calorie: -200, purpose: :bulk_up, body: "먹는 것까지가 운동인 것 아시죠?<br>열심히 운동하셨는데 너무 아깝잖아요ㅠ<br>이런 간식들로 운동을 마무리하시는 건 어때요?", protein: :high

# -	300 ~ 500칼로리: 먹는 것까지가 운동인 것 아시죠? 열심히 운동하셨는데 너무 아깝잖아요ㅠ 이런 식단으로 건강하게 영양보충하시는 건 어때요? (식단추천)
    Diet.create start_calorie: -500, end_calorie: -300, purpose: :bulk_up, body: "먹는 것까지가 운동인 것 아시죠?<br>열심히 운동하셨는데 너무 아깝잖아요ㅠ<br>이런 식단으로 건강하게 영양보충하시는 건 어때요?"
    
    Diet.create start_calorie: -500, end_calorie: -300, purpose: :bulk_up, body: "먹는 것까지가 운동인 것 아시죠?<br>열심히 운동하셨는데 너무 아깝잖아요ㅠ<br>이런 식단으로 건강하게 영양보충하시는 건 어때요?", protein: :high

# -	500 ~ 600칼로리: 먹는 것까지가 운동인 것 아시죠? 열심히 운동하셨는데 너무 아깝잖아요ㅠ 운동한 것에 비해서 몸이 커지지 않을 가능성이 많은 상태입니다. 이런 식단 어떠세요? (식단추천)
    Diet.create start_calorie: -600, end_calorie: -500, purpose: :bulk_up, body: "먹는 것까지가 운동인 것 아시죠?<br>열심히 운동하셨는데 너무 아깝잖아요ㅠ<br>운동한 것에 비해서<br>몸이 커지지 않을 가능성이 많은 상태입니다.<br>이런 식단 어떠세요?"
    
    Diet.create start_calorie: -600, end_calorie: -500, purpose: :bulk_up, body: "먹는 것까지가 운동인 것 아시죠?<br>열심히 운동하셨는데 너무 아깝잖아요ㅠ<br>운동한 것에 비해서<br>몸이 커지지 않을 가능성이 많은 상태입니다.<br>이런 식단 어떠세요?", protein: :high

# -	700+ : 먹는 것까지가 운동인 것 아세요? 당신이 운동으로 흘린 땀이 조금 더 가치있을 수 있도록 저희가 영양으로 도와드리고 싶어요. 이런 식단 어떠세요? (식단추천)
    Diet.create end_calorie: -600, purpose: :bulk_up, body: "먹는 것까지가 운동인 것 아세요?<br>당신이 운동으로 흘린 땀이<br>조금 더 가치있을 수 있도록<br>저희가 영양으로 도와드리고 싶어요.<br>이런 식단 어떠세요?"
    
    Diet.create end_calorie: -600, purpose: :bulk_up, body: "먹는 것까지가 운동인 것 아세요?<br>당신이 운동으로 흘린 땀이<br>조금 더 가치있을 수 있도록<br>저희가 영양으로 도와드리고 싶어요.<br>이런 식단 어떠세요?", protein: :high


  #   칼로리 언더 (운동 목적이 다이어트인 경우)

  # -	200 ~ 300칼로리: 100일 뒤엔 원하는 몸무게보다도 2.2kg가 더 빠지겠군요!  잘하고 계시지만 혹시 현재의 식단을 유지하기 힘드시다면 이 정도는 먹어도 돼요:) (식단 추천)
    Diet.create start_calorie: -300, end_calorie: -200, purpose: :slim, body: "100일 뒤엔 원하는 몸무게보다도<br>2.2kg가 더 빠지겠군요!<br> 잘하고 계시지만 혹시 현재의 식단을 유지하기 힘드시다면<br>이 정도는 먹어도 돼요:)"
    
    Diet.create start_calorie: -300, end_calorie: -200, purpose: :slim, body: "100일 뒤엔 원하는 몸무게보다도<br>2.2kg가 더 빠지겠군요!<br> 잘하고 계시지만 혹시 현재의 식단을 유지하기 힘드시다면<br>이 정도는 먹어도 돼요:)", protein: :high
  # -	300 ~ 500칼로리: 100일 뒤엔 원하는 몸무게보다도 4.4kg가 더 빠지겠군요! 잘하고 계시지만 혹시 현재의 식단을 유지하기 힘드시다면 이 정도는 먹어도 돼요:) (식단 추천)
    Diet.create start_calorie: -500, end_calorie: -300, purpose: :slim, body: "100일 뒤엔 원하는 몸무게보다도<br>4.4kg가 더 빠지겠군요!<br>잘하고 계시지만 혹시 현재의 식단을 유지하기 힘드시다면<br>이 정도는 먹어도 돼요:)"
    
    Diet.create start_calorie: -500, end_calorie: -300, purpose: :slim, body: "100일 뒤엔 원하는 몸무게보다도<br>4.4kg가 더 빠지겠군요!<br>잘하고 계시지만 혹시 현재의 식단을 유지하기 힘드시다면<br>이 정도는 먹어도 돼요:)", protein: :high
  # -	500 ~ 600칼로리: 너무 심하게 칼로리를 제한하고 있으신 것 같아요ㅠㅠ 면연력 저하로 인한 무기력증에 걸리기 쉬운 상태입니다. 맛있는 건강식을 통해 관리를 추천합니다.  (식단 추천)
    Diet.create start_calorie: -600, end_calorie: -500, purpose: :slim, body: "너무 심하게<br>칼로리를 제한하고 있으신 것 같아요ㅠㅠ<br>면연력 저하로 인한 무기력증에 걸리기 쉬운 상태입니다.<br>맛있는 건강식을 통해 관리를 추천합니다."
    
    Diet.create start_calorie: -600, end_calorie: -500, purpose: :slim, body: "너무 심하게<br>칼로리를 제한하고 있으신 것 같아요ㅠㅠ<br>면연력 저하로 인한 무기력증에 걸리기 쉬운 상태입니다.<br>맛있는 건강식을 통해 관리를 추천합니다.", protein: :high
  # -	700+ : 극단적인 칼로리 제한으로 인해 면역력 저하, 무기력증에 걸리기 쉬운 상태입니다. 저희는 당신이 몇 달 후에도 지속가능한 다이어트를 하길 원해요. 아직도 쫄쫄 굶고 계세요? (식단 추천)
    Diet.create end_calorie: -600, purpose: :slim, body: "극단적인 칼로리 제한으로 인해<br>면역력 저하, 무기력증에 걸리기 쉬운 상태입니다.<br>저희는 당신이 몇 달 후에도<br>지속가능한 다이어트를 하길 원해요.<br>아직도 쫄쫄 굶고 계세요?"
    
    Diet.create end_calorie: -600, purpose: :slim, body: "극단적인 칼로리 제한으로 인해<br>면역력 저하, 무기력증에 걸리기 쉬운 상태입니다.<br>저희는 당신이 몇 달 후에도<br>지속가능한 다이어트를 하길 원해요.<br>아직도 쫄쫄 굶고 계세요?", protein: :high
  end
  
end










