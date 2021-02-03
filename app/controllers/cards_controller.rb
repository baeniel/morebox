class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_object, only: [:show, :update]

  def index
    @cards = Card.ready
    @cards = Card.complete if params[:status] == "complete"
  end

  def new ;end

  def create
    card = Card.new(card_params)
    if card.save
      redirect_to cards_path, notice: "건의가 등록되었습니다."
    else
      redirect_to cards_path, alert: "다시 시도해주세요!"
    end
  end

  def show ;end

  def update
    @card.complete!
    redirect_to cards_path, notice: "태스크를 완료했습니다!"
  end

  private
  def card_params
    params.require(:card).permit(:description, :importance, :category)
  end

  def load_object
    @card = Card.find params[:id]
  end
end
