module Bambooing
  module TimeOff
    module Table
      class PTO < Request
        TYPE = 77.freeze
        APPROVED = 'approved'.freeze

        class << self
          def approved(employee_id:, year:)
            ptos = where(employee_id: employee_id, type_id: TYPE, year: year)
            ptos.select { |pto| pto.status == APPROVED }
          end
        end
      end
    end
  end
end
