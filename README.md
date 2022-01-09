# Callcounter Ruby integration gem

This gem can be used to gather API request & response data from Rack based applications and send it to Callcounter.

Callcounter is an API analytics platform that collect information about requests (calls) to your API using so-called integrations. Integrations come in the form of a Ruby gem, a Nuget package, a Pip module, etc. The integrations
can send the data to Callcounter using an API, which is described at: https://callcounter.io/docs/api

After collection data, the web interface can then be used to view all kinds of metrics, giving you insight in the
(mis)usage of your API.

## Install

### Bundler

When using bundler, simply add the following line to your Gemfile and run `bundle`:

```ruby
gem 'callcounter'
```

### Other

Install the gem with: `gem install callcounter`. Next, add the following call to your entry file in order to activate
the Rack middleware:

```ruby
use Callcounter::Capturer
```

## Configure what to capture

Configure callcounter with the following code, this can be placed in a Rails initializer when using Ruby on Rails,
for example `config/initializers/callcounter.rb`, or somewhere in your entry point file when using Sinatra or other Rack based frameworks:

```ruby
Callcounter.configure do |config|
  config.app_token = '' # TODO: fill with your unique app token
end
```

This will capture any requests to the `api` subdomain and any request that has a path which starts with `/api`.
After deploying you should start seeing data in Callcounter. Note that this might take some time because this gems
only sends data every few requests or every few minutes.

If you API doesn't match with the default matching rules, you can add a lambda that will be called for every request
to determine whether it was a request to your API. For example, you can customise the default lambda shown below:

```ruby
Callcounter.configure do |config|
  config.app_token = '' # TODO: fill with your unique app token
  config.track = lambda { |request|
    request.hostname.start_with?('api') || request.path.start_with?('/api')
  }
end
```

## Bug reporting

Bugs can be reported through the Github issues.
If you don't want to sign up for an account, you can also contact us through https://callcounter.io/contact

## Releasing

- Verify tests pass.
- Increment version number in: `lib/callcounter/version.rb`
- Run `bundle install`
- Commit all changes
- Create a git tag for the release.
- Push the git tag.
- Build the gem: `gem build callcounter.gemspec`
- Push the gem to rubygems.org: `gem push callcounter-?.?.?.gem`

## About Callcounter

[Callcounter](https://callcounter.io) is a service, developed and maintained by Lint Ltd, that
helps API providers with debugging and optimising the usage of their APIs.
