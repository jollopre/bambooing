require 'bambooing/time_off/employee'

module Bambooing
  module TimeOff
    module Table
      class PTO < Request
<<<<<<< Updated upstream

        PATH = '/time_off/employee'.freeze
        APPROVED = 'approved'.freeze    
=======
        PTO_TYPES = [77,81,91,102].freeze
        APPROVED = 'approved'.freeze
>>>>>>> Stashed changes

        class << self
          
          def approved(employee_id:, year:)
<<<<<<< Updated upstream
            pto_types = Employee.pto_types(employee_id)
            ptos = []

            pto_types.each { |pto_type|
=======

            ptos = []

            PTO_TYPES.each { |pto_type|
>>>>>>> Stashed changes
              
              (ptos << where(employee_id: employee_id, type_id: pto_type, year: year)).flatten!
            }

            ptos.select { |pto| 
<<<<<<< Updated upstream
=======
              pp pto 
>>>>>>> Stashed changes
              pto.status == APPROVED
            }
          end
        end
      end
    end
  end
end
