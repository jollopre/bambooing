require 'uri'
require 'net/http'
require 'json'
require 'date'
require 'time'

def days_in_month(year, month)
  Date.new(year, month.to_i, -1).day
end

def working_dir?(date)
  date.wday > 0 && date.wday < 6
end

def params
  JSON.parse(File.open("params.json").read)
end

def employee_id
  params['employee_id']
end

def csrf_token
  params['csrf_token']
end

def cookie
  params['cookie']
end

def start_day
  [ENV['START_DAY'].to_i, 1].max
end

def end_day
  end_day = ENV['END_DAY']

  if end_day.nil?
    now = DateTime.now
    month = now.strftime('%m')
    year = now.year
    return days_in_month(year, month)
  end

  end_day.to_i
end

def dry_run?
  ENV['DRY_RUN'] == 'true'
end

def entries
  now = DateTime.now
  month = now.strftime('%m')
  year = now.year
  days = days_in_month(year, month)
  entries = []

  (start_day..end_day).each do |day|
    
    date = Date.new(year.to_i, month.to_i, day.to_i)
    next unless working_dir?(date)
    day = "0#{day}" if day.to_i < 10


    str_date = "#{year}-#{month}-#{day}" 

    entries <<  {
      "id": nil,
      "trackingId": 1,
      "employeeId": employee_id,
      "date": str_date,
      "start": "9:00",
      "end": "14:00",
      "note": ""
    }

    entries <<  {
      "id": nil,
      "trackingId": 1,
      "employeeId": employee_id,
      "date": str_date,
      "start": "15:00",
      "end": "18:00",
      "note": ""
    }
  end

  {
    "entries": entries
  }
end

url = URI("https://flywire.bamboohr.com/timesheet/clock/entries")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Post.new(url)

request["content-type"] = 'application/json;charset=UTF-8'
request["cookie"] = cookie
request["x-csrf-token"] = csrf_token

if dry_run?
  puts "EMPLOYEE_ID: #{employee_id}"
  puts "ENTRIES TO BE ADDED:"
  entries[:entries].each do |entry|
    puts entry
  end
  
  return
end

request.body = entries.to_json
  
response = http.request(request)
if response.code == 200
  puts 'CLOKED IN!!'
else 
  puts "Error: #{response.read_body}"
end
