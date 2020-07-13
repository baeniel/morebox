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

  def initialize(receiver, receiverName, contents)
    @corpNum = "7468701862"
    @userID = "jb1014"
    @sender = "01056053087"
    @senderName = "주식회사 고릴라밤"
    @receiver = receiver
    @receiverName = receiverName
    @contents = contents
    @reserveDT = ""
    @adsYN = false
    @requestNum = ''
  end

  def send_message
    begin
      @value = MessageAlarmService::MSGService.sendSMS(
        @corpNum,
        @sender,
        @senderName,
        @receiver,
        @receiverName,
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
