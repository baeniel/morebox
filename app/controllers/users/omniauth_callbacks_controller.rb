# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :kakao

  def kakao
    code = params[:code]
    client_id = "82ec099c21ded0719ecca17d443cd374"
    # redirect_uri = "http://localhost:3000/users/auth/kakao/callback"
    redirect_uri = "https://morebox.co.kr/users/auth/kakao/callback"

    response = HTTParty.post(
      "https://kauth.kakao.com/oauth/token",
      body: {
        grant_type: "authorization_code",
        client_id: client_id,
        redirect_uri: redirect_uri,
        code: code
      },
      headers: {
        "Content-type" => "application/x-www-form-urlencoded\;charset=utf-8"
      })

    token = response.parsed_response.dig("access_token")
    response2 = HTTParty.post(
      "https://kapi.kakao.com/v2/user/me",
      headers: {
        "Authorization" => "Bearer #{token}",
        "Content-type" => "application/x-www-form-urlencoded\;charset=utf-8"
      })

    phone_number = response2.parsed_response.dig("kakao_account").dig("phone_number").gsub("+82 ", "0").gsub("-", "")
    email = response2.parsed_response.dig("kakao_account").dig("email")
    post = Post.find(params[:state])
    post.update_attributes(phone: phone_number, email: email)

    templateCode = '020120000086'
    content = "#{post.name}님 안녕하세요? 핏테이블 식단관리 서비스를 신청해주셔서 감사합니다. 원하시는 몸이 되기 위해 #{(post.weight - post.target_weight).abs}kg 감량이 필요하시군요!
    \n\n지금 #{post.name}님을 위한 코치님이 대기하고 있어요. 상담 시작을 원하시면 닉네임을 입력해주세요:)"
    receiver = phone_number
    receiverName = post.name
    nutrition_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
    nutrition_alarm.send_alarm

    # templateCode = '020110000087'
    # content = "안녕하세요, 핏테이블입니다:)\n 신청해주신 식단관리 프로그램 진행을 위해 닉네임을 입력해주세요!"
    # receiver = phone_number
    # receiverName = post.name
    # nutrition_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
    # nutrition_alarm.send_alarm

    receiver = '010-3884-6836'
    receiverName = "박영록"
    subject = "우와 누가 상담했어"
    contents = "누가 상담 요청을 했습니다!"
    nutrition_admin_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
    nutrition_admin_alarm.send_message

    redirect_to complete_posts_path
  end

  private

  def auth_login(provider)
    if @identity.present?
      @identity.update(identity_attrs)
    else
      @user.identities.create!(identity_attrs)
    end
    sign_in @user

    # if user_signed_in?
    #   redirect_to root_path, notice: "카카오 계정으로 로그인하셨습니다."
    # else
    #   redirect_to root_path, notice: "로그인에 실패했습니다."
    # end
  end

  # def auth
  #   request.env['omniauth.auth']
  # end

  def set_identity
  end

  # def set_user
  #   if user_signed_in?
  #     @user = current_user
  #   elsif @identity.present?
  #     @user = @identity.user
  #   # 동일한 이메일로 다른 sns 계정으로 또 로그인할 경우
  #   # elsif User.where(email: auth.info.email).any?
  #   # flash[:alert] = "#{auth.provider} 계정으로 로그인하세요"
  #   else
  #     #유저의 이메일과 전화번호를 받기 위해 토큰으로 송신
  #     response = HTTParty.get(
  #       "https://kapi.kakao.com/v2/user/me",
  #       headers: {
  #         "Authorization" => "Bearer #{auth.credentials.token}",
  #         "Content-type" => "application/x-www-form-urlencoded\;charset=utf-8"
  #       })
  #
  #     #이메일과 전화번호가 없을 수도 있기 때문에 예외처리
  #     if response.dig("kakao_account", "email").present?
  #       email = response.dig("kakao_account", "email")
  #     else
  #       email = "fittable@gorilla.com"
  #     end
  #
  #     if response.dig("kakao_account", "phone_number").present?
  #       phone = response.dig("kakao_account", "phone_number").gsub("+82 ", "0").gsub("-", "")
  #     else
  #       phone = "01000000000"
  #     end
  #
  #     @user = User.create(
  #       name: auth.info.name,
  #       # password: Devise.friendly_token[0, 20],
  #       # remote_thumbnail_url: auth.extra.properties.profile_image,
  #       gym: Gym.find_by(title: "스프링타운2층"),
  #       email: email,
  #       phone: phone
  #     )
  #   end
  # end

  # def identity_attrs
  #   {
  #     provider: auth.provider,
  #     uid: auth.uid,
  #     access_token: auth.credentials.token,
  #   }
  # end
end
