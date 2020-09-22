require 'popbill/message'

class MessageAlarmService
  LinkID = "GORILLANUTRI"
  SecretKey = "38GYuKKeb92oktWQhjRm1at/JZIkxScMpkk+y3NfzEE="

  # 팝빌 문자 Service 초기화
  MSGService = MessageService.instance(
    MessageAlarmService::LinkID,
    MessageAlarmService::SecretKey
  )

  # 연동환경 설정값, (true-개발용, false-상업용)
  MSGService.setIsTest(false)

  # 인증토큰 IP제한기능 사용여부, true-권장
  MSGService.setIpRestrictOnOff(true)

  def initialize(receiver, receiverName, subject, contents)
    @corpNum = "7468701862"
    @sender = "028783087"
    @senderName = "주식회사 고릴라밤"
    @receiver = receiver
    @receiverName = receiverName
    @subject = subject
    @contents = contents
    @reserveDT = ""
    @adsYN = false
    @userID = "jb1014"
    @requestNum = ''
  end

  def send_message
    begin
      @value = MessageAlarmService::MSGService.sendXMS(
        @corpNum,
        @sender,
        @senderName,
        @receiver,
        @receiverName,
        @subject,
        @contents,
        @reserveDT,
        @adsYN,
        @userID,
        @requestNum,
      )['receiptNum']
      @name = "receiptNum(접수번호)"
    rescue PopbillException => pe
      @Response = pe
    end
  end
end
