module Bambooing
  module TimeOff
    class ExclusionService
      class << self
        def excluded_dates(employee_id:, year:, exclude_ptos: true, exclude_digital_disconnect_days: true)
          excluded_requests = []
          
          if exclude_ptos
            excluded_requests.concat(Table::PTO.approved(employee_id: employee_id, year: year))
          end
          
          if exclude_digital_disconnect_days
            excluded_requests.concat(Table::DigitalDisconnectDay.approved(employee_id: employee_id, year: year))
          end
          
          excluded_requests
        end
      end
    end
  end
end