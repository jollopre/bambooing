module Bambooing
  module TimeOff
    module Table
      class Request
        PATH = '/time_off/table/requests'.freeze
        attr_accessor :id, :employee_id, :start, :end, :status, :type_id

        def initialize(args)
          @id = args[:id]
          @employee_id = args[:employee_id]
          @start = args[:start]
          @end = args[:end]
          @status = args[:status]
          @type_id = args[:type_id]
        end

        class << self
          def where(employee_id:, type_id:, year:)
            payload = Client.get(path: PATH, params: { id: employee_id, type: type_id, year: year }, headers: {})

            payload[:requests].reduce([]) do |acc, (_,value)|
              acc << new(id: value[:id], employee_id: value[:employeeId], start: Date.parse(value[:startYmd]), end: Date.parse(value[:endYmd]), status: value[:status], type_id: value[:timeOffTypeId])
              acc
            end
          rescue Client::Redirection, Client::ClientError, Client::ServerError, Client::UnknownResponse
            []
          end
        end
      end
    end
  end
end
