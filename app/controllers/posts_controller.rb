class PostsController < ApplicationController
  def index
  end

  def create
    post = Post.create(post_params)

    link = "https://pf.kakao.com/_tVCXK/chat"
    receiver = post.phone
    receiverName = post.name
    subject = "당신만을 위한 식단관리"
    contents = "[핏테이블]\n"+"#{link}"+"\n 위 링크에 접속하셔서 '닉네임, 상담시작'이라고 카톡을 보내주세요:)\n\n ex)미키마우스, 상담시작"
    nutrition_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
    nutrition_alarm.send_message

    receiver = '010-5605-3087'
    receiverName = "박진배"
    subject = "우와 누가 상담했어"
    contents = "누가 상담 요청을 했습니다!"
    nutrition_admin_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
    nutrition_admin_alarm.send_message

    redirect_to complete_posts_path
  end

  def complete
  end

  private
  def post_params
    params.require(:post).permit(:age, :height, :weight, :gender, :activity, :work_time, :work_count, :work_strength, :target_weight, :target_date, :lunch, :sickness, :name, :post_type, :phone, :email, :period, :money)
  end
end
