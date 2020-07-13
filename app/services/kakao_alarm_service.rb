require 'popbill/kakaotalk'
require 'popbill/message'
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

  # 팝빌 문자 Service 초기화
  MSGService = MessageService.instance(
    KakaoAlarmService::LinkID,
    KakaoAlarmService::SecretKey
  )

  # 연동환경 설정값, (true-개발용, false-상업용)
  MSGService.setIsTest(false)

  # 인증토큰 IP제한기능 사용여부, true-권장
  MSGService.setIpRestrictOnOff(true)

  def initialize(templateCode, content, receiver, receiverName)
    @templateCode, @content, @receiver, @receiverName = templateCode, content, receiver, receiverName
    @corpNum = "7468701862"
    @userID = "jb1014"
    @snd = '010-5605-3087'
    @altContent = '대체문자 내용 입니다'
    # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
    @altSendType = 'C'
    @sndDT = ''
    @requestNum = ''
  end

  def send_alarm
    begin
      value = KakaoService.sendATS_one(
          @corpNum,
          @snd,
          @altContent,
          @altSendType,
          @sndDT,
          @requestNum,
          @userID,
          @templateCode,
          @content,
          @receiver,
          @receiverName,

      )['receiptNum']
      # @name = "receiptNum(접수번호)"
    #   true
    rescue PopbillException => pe
      puts pe
    end
  end
end
