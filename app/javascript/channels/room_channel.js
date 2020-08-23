import consumer from "./consumer"

window.createChannel = function (currentUser){
  if (currentUser) {
    consumer.subscriptions.create({ channel: "RoomChannel", user_id: currentUser.id }, {
      connected() {
        console.log(`Room is opened`)
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        if (data.data_type == "payment_complete"){
          $(".modal").find(".close").click();
          Swal.fire({
            icon: "success",
            title: "결제가 완료되었습니다&nbsp;&nbsp;<i class='far fa-smile'></i>",
            text: "충전한 포인트로 모어박스와 함께 영양 챙기세요!",
            showConfirmButton: true,
            confirmButtonText: '상품페이지로 돌아가기'
          }).then((result) => {
            if (result.value) {
              window.location = "/items/list"
            }
          });
        }else if(data.data_type == "direct_complete"){
          $(".modal").find(".close").click();
          $(".submit_btn").click();
        }
      }
    });

  }
}
 