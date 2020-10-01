class DietsController < ApplicationController
  def recommend
    # byebug

    difference = params[:current_calorie].to_f - params[:target_calorie].to_f
    diets = Diet.all
    
    @diet = if difference.abs <= 100
              diets.where("start_calorie > :calorie and end_calorie < :calorie", calorie: difference).first
            elsif difference > 600
              diets.where(start_calorie: 600).where(protein: params[:protein]).where(purpose: params[:purpose]).first
            elsif difference < -600
              diets.where(end_calorie: -600).where(protein: params[:protein]).where(purpose: params[:purpose]).first
            else
              diets = diets.where("start_calorie > :calorie and end_calorie < :calorie", calorie: difference).where(protein: params[:protein]).where(purpose: params[:purpose])
              if difference < 0
                diets = diets.where(snack: params[:snack].to_i > 0)
              end
              diets.first
            end
    
  end
  
end
