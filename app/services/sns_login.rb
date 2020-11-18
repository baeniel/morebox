class SnsLogin
  attr_reader :auth, :signed_in_resource

  def initialize(auth, signed_in_resource = nil)
    @auth = auth
    @signed_in_resource = signed_in_resource
  end

  def find_user_oauth
    identity = build_identity
    user = @signed_in_resource ? @signed_in_resource : identity.user
    if user.nil?
      user = User.create!(get_auth_params)
    end
    update_identity_user(identity, user)
    user
  end

  private

  def build_identity
    Identity.find_for_oauth(@auth)
  end

  def get_auth_params
    auth_params = {
      name: @auth.info.name,
      password: Devise.friendly_token[0,20],
      account_type: @auth.provider
    }

    if @auth.info.email.present? # 카카오의 경우 email을 받아올 수 없어서 아래와 같이 처리했습니다. 또한 sns 계정 로그인 할 때 이메일 계정이 아닌 경우가 있어서 일반화하여 처리할 수 있습니다.
      auth_params[:email] = @auth.info.email
    else
      loop do
        uniq_num = SecureRandom.hex(3).downcase
        @generated_email = "#{@auth.provider}#{uniq_num}@grow.com"
        break unless User.find_by(email: @generated_email).present?
      end
      auth_params[:email] = @generated_email
    end
    auth_params

  end

  def update_identity_user(identity, user)
    if identity.user != user #identity의 유저와 현재 유저를 일치시킵니다.
      identity.user = user
      identity.save
    end
  end

end
