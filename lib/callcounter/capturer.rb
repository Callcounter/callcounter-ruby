# frozen_string_literal: true

require 'net/http'

module Callcounter
  # class that captures the rack requests and sends them to Callcounter
  class Capturer
    attr_accessor :buffer

    def initialize(app)
      @app = app
      @buffer = []
    end

    def call(env)
      start = Time.now
      result = @app.call(env)
      finish = Time.now

      return result if app_token.nil?

      threading do
        background_work(start, finish, env, result)
      end

      result
    end

    def debug?
      Callcounter.configuration.debug
    end

    def track?(request)
      Callcounter.configuration.track.call(request)
    end

    def project_token
      Callcounter.configuration.project_token
    end

    def app_token
      Callcounter.configuration.app_token || project_token
    end

    def async?
      Callcounter.configuration.async
    end

    def threading(&block)
      if async?
        Thread.new(&block)
      else
        yield
      end
    end

    def send_buffer
      http = Net::HTTP.new('api.callcounter.io', 443)
      http.use_ssl = true
      track = Net::HTTP::Post.new('/api/v1/events/batch')
      track['content-type'] = 'application/json'
      track['user-agent'] = "callcounter-gem (#{Callcounter::VERSION})"
      track.body = { batch: { project_token: app_token, events: @buffer } }.to_json

      http.request(track)

      puts 'sent request' if debug?
    rescue StandardError
      puts 'failed to send request' if debug?
    end

    def should_send_buffer?
      @buffer.first[:created_at] < Time.now - Random.rand(300..359) || @buffer.size > 25
    end

    def event_attributes(start, finish, request, result)
      {
        created_at: start,
        elapsed_time: ((finish - start) * 1000).round,
        method: request.request_method,
        path: request.path,
        user_agent: request.user_agent,
        status: result.first
      }
    end

    def background_work(start, finish, env, result)
      request = Rack::Request.new(env)
      return unless track?(request)

      @buffer << event_attributes(start, finish, request, result)

      return unless should_send_buffer?

      send_buffer
      @buffer = []
    end
  end
end
