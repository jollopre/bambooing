module Bambooing
  module TimeOff
    module Table
      class DigitalDisconnectDay < Request
        TYPE = 102.freeze
        APPROVED = 'approved'.freeze

        class << self
          def approved(employee_id:, year:)
            ddds = where(employee_id: employee_id, type_id: TYPE, year: year)
            ddds.select { |ddd| ddd.status == APPROVED }
          end
        end
      end
    end
  end
end