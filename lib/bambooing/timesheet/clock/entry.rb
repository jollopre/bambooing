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
          @employee_id = args[:employee_id] || Bambooing.configuration.employee_id
          @date = args[:date]
          @start = args[:start]
          @end = args[:end]
          @note = args[:note]
        end

        def to_json(opts = nil)
          { 'id' => id, 'trackingId' => tracking_id, 'employeeId' => employee_id, 'date' => date, 'start' => start, 'end' => @end, 'note' => note }.to_json
        end

        class << self
          def save(arg)
            url = URI('https://flywire.bamboohr.com/timesheet/clock/entries')
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            
            request = Net::HTTP::Post.new(url)
            request['Content-type'] = 'application/json;charset=UTF-8'
            request['x-csrf-token'] = Bambooing.configuration.x_csrf_token
            request['cookie'] = "PHPSESSID=#{Bambooing.configuration.session_id}"
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
