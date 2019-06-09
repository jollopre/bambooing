require 'json'
require 'uri'
require 'net/http'

module Bambooing
  module Timesheet
    module Clock
      class Entry
        attr_accessor :id, :tracking_id, :employee_id, :date, :start, :end, :note

        def initialize(args)
          @id = args[:id]
          @tracking_id = args[:tracking_id]
          @employee_id = args[:employee_id]
          @date = args[:date]
          @start = args[:start]
          @end = args[:end]
          @note = args[:note]
        end

        def to_json(opts = nil)
          { 'id' => id, 'trackingId' => tracking_id, 'employeeId' => employee_id, 'date' => date.to_s, 'start' => format_start, 'end' => format_end, 'note' => note }.to_json
        end

        private

        def format_start
          start.strftime('%H:%M')
        end

        def format_end
          @end.strftime('%H:%M')
        end

        class << self
          def save(arg)
            url = URI('https://flywire.bamboohr.com/timesheet/clock/entries')
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            configuration = Bambooing.configuration
            
            request = Net::HTTP::Post.new(url)
            request['Content-type'] = 'application/json;charset=UTF-8'
            request['x-csrf-token'] = configuration.x_csrf_token
            request['cookie'] = "PHPSESSID=#{configuration.session_id}"
            entries = arg.respond_to?(:map) ? arg : [arg]
            request.body = { entries: entries }.to_json

            response = http.request(request)

            return true if response.code == "200"

            Bambooing.logger.error("status: #{response.code}, body: #{response.read_body}")
          end
        end
      end
    end
  end
end
