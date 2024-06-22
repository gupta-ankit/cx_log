# CxLog

Trying to debug an issue by looking at multiple logs is often cumbersome. 
CxLog allows you to create a single log line for a context (request, background job, etc.) in your application.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
    $ bundle add cx_log
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
    $ gem install cx_log
```

## Usage

### Basic Usage
CxLog generates structured logs. All logs will have a `message` attribute (that can be overwritten) using `CxLog.add`.
In order to add an attribute the log, use `CxLog.add`:

```ruby
    CxLog.log(message: 'test', foo: 'bar')
```
Flushing the log will generate `{"message":"test","foo":"bar"}`.

CxLog supports multiple values per key:

```ruby
    CxLog.log(message: 'test', foo: 'bar')
    # some code
    CxLog.add(foo: 'baz')
```

Flushing the log will generate `{"message":"test","foo":["bar","baz"]}`.

### Rails
If you are using Rails, you can use the CxLog middleware to automatically generate context logs.

Add the following to your `config/application.rb`:

```ruby
    config.middleware.use CxLog::Middleware
```

### Log Format
By default, CxLog generates logs in JSON format.
You can use your own or choose one that is shipped with the gem

```ruby
  CxLog.options = { 
    formatter: CxLog::Formatters::KeyValueFormatter.new 
  }
```

If you are using Rails middleware, you can set the formatter in an initializer:

```ruby
  config.middleware.use CxLog::Middleware, formatter: CxLog::Formatters::KeyValueFormatter.new
```

### Filter Parameters
CxLog supports filtering parameters by default. But, you can overwrite the list of filter parameters by
setting the `filter_parameters` option:

```ruby
  CxLog.options = { 
    filter_parameters: ['password', 'secret']
  }
```

If you are using Rails middleware, you can set the filter parameters in an initializer:

```ruby
  config.middleware.use CxLog::Middleware, filter_parameters: ['password', 'secret']
```

The log will replace the value of sensitive parameters with `[FILTERED]`:
```
{"message":"","request_id":"b41e3733-3ca6-46e9-a968-73e995443ec2",
 "controller":"posts","action":"index","method":"GET","post_count":1,
 "password":"[FILTERED]"}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gupta-ankit/cx_log. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/gupta-ankit/cx_log/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CxLog project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/gupta-ankit/cx_log/blob/main/CODE_OF_CONDUCT.md).
