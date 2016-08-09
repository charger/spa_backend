# https://github.com/cyu/rack-cors
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3000', '127.0.0.1:3000',
            /\Ahttp:\/\/107\.23\.7\.96(:\d+)?\z/

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
