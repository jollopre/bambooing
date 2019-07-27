module Bambooing
  module TimeOff
    module Table
      class PTO < Request
        APPROVED = 'approved'
        class << self
          def approved(employee_id:, year:)
            ptos = find_by_pto(employee_id: employee_id, year: year)
            ptos.select do |pto|
              pto.status == APPROVED
            end
          end
        end
      end
    end
  end
end
