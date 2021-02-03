class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_object, only: [:show, :update, :edit]

  def index
    @cards = Card.ready
    @cards = Card.complete if params[:status] == "complete"
  end

  def new
    @card = Card.new
  end

  def create
    card = Card.new(card_params)
    card.importance = "할지안할지논의가필요해요"
    if card.save!
      redirect_to cards_path, notice: "건의가 등록되었습니다."
    end
  end

  def show ;end

  def edit; end

  def update
    if @card.update!(card_params)
      redirect_to cards_path, notice: "태스크를 수정했습니다!"
    end
  end

  private
  def card_params
    params.require(:card).permit(:description, :importance, :category, :status)
  end

  def load_object
    @card = Card.find params[:id]
  end
end
