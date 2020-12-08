class PostsController < ApplicationController
  before_action :load_object, only: [:loading, :show, :update]

  def index
  end

  def create
    post = Post.create(post_params)
    redirect_to loading_post_path(post)
  end

  def complete
  end

  def loading ;end

  def show ;end

  def update
    @post.update(post_update_params)

    templateCode = '020110000087'
    content = "안녕하세요, 핏테이블입니다:)\n 신청해주신 식단관리 프로그램 진행을 위해 닉네임을 입력해주세요!"
    receiver = @post.phone
    receiverName = @post.name
    nutrition_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
    nutrition_alarm.send_alarm

    receiver = '010-3884-6836'
    receiverName = "박영록"
    subject = "우와 누가 상담했어"
    contents = "누가 상담 요청을 했습니다!"
    nutrition_admin_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
    nutrition_admin_alarm.send_message

    redirect_to complete_posts_path
  end

  private
  def load_object
    @post = Post.find params[:id]
  end

  def post_params
    params.require(:post).permit(:age, :height, :weight, :gender, :activity, :work_time, :work_count, :work_strength, :target_weight, :target_date, :lunch, :sickness, :name, :post_type, :counsel_time)
  end

  def post_update_params
    params.require(:post).permit(:phone, :email, :is_morebox)
  end
end
