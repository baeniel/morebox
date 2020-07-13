require 'popbill/kakaotalk'

class KakaoAlarmService
  LinkID = "GORILLANUTRI"
  SecretKey = "38GYuKKeb92oktWQhjRm1at/JZIkxScMpkk+y3NfzEE="

  # 팝빌 카카오톡 Service 초기화
  KakaoService = KakaoService.instance(
    KakaoAlarmService::LinkID,
    KakaoAlarmService::SecretKey
  )

  # 연동환경 설정값, (true-개발용, false-상업용)
  KakaoService.setIsTest(false)

  # 인증토큰 IP제한기능 사용여부, true-권장
  KakaoService.setIpRestrictOnOff(true)

  def initialize(templateCode, content, receiver, receiverName)
    @corpNum = "7468701862"
    @userID = "jb1014"
    @templateCode = templateCode
    @snd = '010-5605-3087'
    @content = content
    @altContent = '대체문자 내용 입니다'
    @altSendType = 'C'
    @sndDT = ''
    @receiverName = receiverName
    @receiver = receiver
    @requestNum = ''
  end

  def send_alarm
    begin
      @value = KakaoAlarmService::KakaoService.sendATS_one(
          @corpNum,
          @templateCode,
          @snd,
          @content,
          @altContent,
          @altSendType,
          @sndDT,
          @receiver,
          @receiverName,
          @requestNum,
          @userID,
      )['receiptNum']
      @name = "receiptNum(접수번호)"
    rescue PopbillException => pe
      @Response = pe
      # render "home/exception"
    end
  end
end
