# Bambooing

Welcome to bambooing, a gem to track bamboo time hassle free! This gem is addressed to people who forgets to clock-(in|out) during work hours.

## Usage

If you have docker installed on your machine, please run the following command:
```bash
make create_current_weekdays
```

This will add entries in Bamboo for the current week. These entries will consist of 8 hours per day with 2 breaks of 0-30 minutes, summing a total of 40 weekly hours. 

> Note, it is needed to pass valid values for the configuration.env file (e.g. csrf_token, session_id or employee_id)

If you are ever lazier, you can add entries in Bamboo for the current month, based on the same strategy that for the current week. Please run the following command:
```bash
make create_current_month_weekdays
```

If you are ever ever lazie, you can add entries in Bamboo for days between specific dates (maybe two months? 😅), based on the same strategy that for the current month. Please run the following command:
```bash
make create_custom_dates_weekdays START_DATE="01/01/2025" END_DATE="31/03/2025"
```

## Getting your credentials

You will need to open your bamboo account on a browser and navigate to `My Info` tab. Execute the following commands to read your CSRF Token and Employee ID:
```js
console.log('Employee id:', currentlyEditingEmployeeId);
console.log('CSRF token:', CSRF_TOKEN);
```

For the Session ID, you will have to use the browser's develpoment tools to find the value for the cookie named 'PHPSESSID' 

 > Notice that if `BAMBOOING_DRY_RUN_MODE` is enabled, the times will be generated but will **not** be uploaded to bamboo, you have to disable it if you want to upload the times.

## Configuration Options

The following environment variables can be set in your `configuration.env` file:

- `BAMBOOING_HOST` - Your BambooHR URL (e.g., `https://yourcompany.bamboohr.com`)
- `BAMBOOING_X_CSRF_TOKEN` - CSRF token from BambooHR
- `BAMBOOING_SESSION_ID` - Session ID from BambooHR (PHPSESSID cookie)
- `BAMBOOING_EMPLOYEE_ID` - Your employee ID
- `BAMBOOING_DRY_RUN_MODE` - Set to `true` to test without uploading (default: `false`)
- `BAMBOOING_EXCLUDE_TIME_OFF` - Set to `true` to exclude time off days (default: `false`)
- `BAMBOOING_EXCLUDE_PTOS` - Set to `true` to exclude PTO days (default: `false`)
- `BAMBOOING_EXCLUDE_DIGITAL_DISCONNECT_DAYS` - Set to `true` to exclude Digital Disconnect Days (default: `false`)

### Time Off Exclusions

When time off exclusions are enabled, the system will automatically skip creating time entries for:

- **PTOs**: Paid Time Off requests that are approved
- **Digital Disconnect Days**: Company-wide digital disconnect days (type 102) that are approved

This ensures that you don't accidentally create time entries for days when you're not supposed to be working.

## Test

```bash
make test
```

## Development

```bash
make devel
```

This will create an image and run a container to play/develop further features in bambooing. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bambooing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bambooing
    
## Code status

[![Build Status](https://travis-ci.com/jollopre/bambooing.svg?branch=master)](https://travis-ci.com/jollopre/bambooing)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jollopre/bambooing. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bambooing project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bambooing/blob/master/CODE_OF_CONDUCT.md).
