# frozen_string_literal: true

module Callcounter
  # enable the Callcounter rack middleware automatically in rails
  class Railtie < Rails::Railtie
    initializer 'callcounter.middleware' do |app|
      app.middleware.use(Callcounter::Capturer)
    end
  end
end
