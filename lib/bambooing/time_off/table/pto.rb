require 'bambooing/time_off/employee'

module Bambooing
  module TimeOff
    module Table
      class PTO < Request

        PATH = '/time_off/employee'.freeze
        APPROVED = 'approved'.freeze    

        class << self
          
          def approved(employee_id:, year:)
            pto_types = Employee.pto_types(employee_id)
            ptos = []

            pto_types.each { |pto_type|
              
              (ptos << where(employee_id: employee_id, type_id: pto_type, year: year)).flatten!
            }

            ptos.select { |pto| 
              pto.status == APPROVED
            }
          end
        end
      end
    end
  end
end
