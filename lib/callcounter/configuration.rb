# frozen_string_literal: true

module Callcounter
  # configuration class for Callcounter middleware
  class Configuration
    attr_accessor :debug, :project_token, :track, :async, :app_token

    def initialize
      @debug = false
      @project_token = nil
      @app_token = nil
      @track = lambda { |request|
        return request.hostname.start_with?('api') || request.path.start_with?('/api')
      }
      @async = true
    end
  end
end
