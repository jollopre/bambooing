require 'json'

module Bambooing
  module Timesheet
    module Clock
      class Entry
        PATH = '/timesheet/clock/entries'.freeze
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
          to_h.to_json
        end

        def to_h
          { id: id, trackingId: tracking_id, employeeId: employee_id, date: date.to_s, start: format_start, end: format_end, note: note }
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
            entries = arg.respond_to?(:map) ? arg : [arg]
            params = { entries: entries.map(&:to_h) }

            Client.post(path: PATH, params: params, headers: {})
            true
          rescue Client::ClientError
            false
          end
        end
      end
    end
  end
end
