class ReportsController < ApplicationController
  def new ;end

  def create
    report = Report.create(report_params)
    redirect_to report_path(report)
  end

  def show
    @report = Report.find params[:id]
    @total_kcal = @report.morning_kcal + @report.lunch_kcal + @report.dinner_kcal + @report.snack_kcal
    @total_carbo = @report.morning_carbo + @report.lunch_carbo + @report.dinner_carbo + @report.snack_carbo
    @total_protein = @report.morning_protein + @report.lunch_protein + @report.dinner_protein + @report.snack_protein
    @total_fat = @report.morning_fat + @report.lunch_fat + @report.dinner_fat + @report.snack_fat
  end

  private
  def report_params
    params.require(:report).permit(:name, :weight, :target_weight, :target_date, :morning_kcal, :morning_carbo, :morning_protein, :morning_fat, :lunch_kcal, :lunch_carbo, :lunch_protein, :lunch_fat, :dinner_kcal, :dinner_carbo, :dinner_protein, :dinner_fat, :snack_kcal, :snack_carbo, :snack_protein, :snack_fat, :ideal_kcal, :ideal_carbo, :ideal_protein, :ideal_fat, :comment)
  end
end
