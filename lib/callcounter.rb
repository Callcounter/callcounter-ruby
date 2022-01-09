# frozen_string_literal: true

require 'callcounter/capturer'
require 'callcounter/configuration'
require 'callcounter/railtie' if defined?(Rails::Railtie)
require 'callcounter/version'

# rack middleware that captures incoming api requests and sends them to Callcounter
module Callcounter
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Callcounter::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
