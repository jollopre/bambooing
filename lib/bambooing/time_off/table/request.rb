require 'json'
require 'uri'
require 'net/http'

module Bambooing
  module TimeOff
    module Table
      class Request
        attr_accessor :id, :employee_id, :start, :end, :status, :type_id
        TYPES = { pto: '77' }.freeze

        def initialize(args)
          @id = args[:id]
          @employee_id = args[:employee_id]
          @start = args[:start]
          @end = args[:end]
          @status = args[:status]
          @type_id = args[:type_id]
        end

        class << self
          def find_by_pto(employee_id:, year:)
            configuration = Bambooing.configuration

            url = URI("#{configuration.host}/time_off/table/requests?id=#{employee_id}&type=#{TYPES[:pto]}&year=#{year}")
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            
            request = Net::HTTP::Get.new(url)
            request['Content-type'] = 'application/json;charset=UTF-8'
            request['x-csrf-token'] = configuration.x_csrf_token
            request['cookie'] = "PHPSESSID=#{configuration.session_id}"

            response = http.request(request)

            return handle_error(response) unless success?(response)

            body = JSON.parse(response.body)
            pto_requests = body['requests'].select do |_, value|
              value['timeOffTypeId'] == TYPES[:pto]
            end
            pto_requests.reduce([]) do |acc, (_,value)|
              acc << new(id: value['id'], employee_id: value['employeeId'], start: Date.parse(value['startYmd']), end: Date.parse(value['endYmd']), status: value['status'], type_id: value['timeOffTypeId'])
              acc
            end
          end

          private

          def handle_error(response)
            Bambooing.logger.error("status: #{response.code}, body: #{response.body}")
            []
          end

          def success?(response)
            response.code == '200' && success_body?(response)
          end

          def success_body?(response)
            body = JSON.parse(response.body)
            body['success']
          end
        end
      end
    end
  end
end
