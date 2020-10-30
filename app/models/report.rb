class Report < ApplicationRecord
  enum report_type: %i(daily weekly monthly)
end
