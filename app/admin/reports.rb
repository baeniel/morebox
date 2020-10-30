ActiveAdmin.register Report do
  scope "전체", :all
  scope "daily", :daily
  scope "weekly", :weekly
  scope "monthly", :monthly

  action_item only: :index do
    link_to('기간별 리포트 생성', create_period_report_admin_reports_path)
  end

  collection_action :create_period_report do
  end
  
  collection_action :creating_period_report, method: :post do
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
    reports = Report.daily.where(created_at: start_date..end_date)
    names = reports.pluck(:name).uniq
    names.each do |name|
      target_reports = reports.where(report_type: :daily).where(name: name)
      Report.create(
        name: name,
        weight: target_reports.average(:weight),
        target_weight: target_reports.average(:target_weight),
        target_date: target_reports.last.target_date,
        morning_carbo: target_reports.average(:morning_carbo),
        morning_protein: target_reports.average(:morning_protein),
        morning_fat: target_reports.average(:morning_fat),
        morning_kcal: target_reports.average(:morning_kcal),
        lunch_carbo: target_reports.average(:lunch_carbo),
        lunch_protein: target_reports.average(:lunch_protein),
        lunch_fat: target_reports.average(:lunch_fat),
        lunch_kcal: target_reports.average(:lunch_kcal),
        dinner_carbo: target_reports.average(:dinner_carbo),
        dinner_protein: target_reports.average(:dinner_protein),
        dinner_fat: target_reports.average(:dinner_fat),
        dinner_kcal: target_reports.average(:dinner_kcal),
        snack_carbo: target_reports.average(:snack_carbo),
        snack_protein: target_reports.average(:snack_protein),
        snack_fat: target_reports.average(:snack_fat),
        snack_kcal: target_reports.average(:snack_kcal),
        ideal_kcal: target_reports.average(:ideal_kcal),
        ideal_carbo: target_reports.average(:ideal_carbo),
        ideal_protein: target_reports.average(:ideal_protein),
        ideal_fat: target_reports.average(:ideal_fat),
        report_type: params[:report_type]
      )
    end
    redirect_to admin_reports_path, notice: "#{params[:report_type]} 레포트 생성이 완료되었습니다."
  end

  index do
    selectable_column if current_admin_user.has_role? :admin
    column "이름", :name
    column "체중", :weight
    column "목표체중", :target_weight
    column "목표날짜", :target_date
    column "타입", :report_type
    actions
  end
end
