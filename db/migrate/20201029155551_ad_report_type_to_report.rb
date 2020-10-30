class AdReportTypeToReport < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :report_type, :integer, default: 0
  end
end
