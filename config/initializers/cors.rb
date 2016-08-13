#https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  debug true

  allow do
    origins 'localhost:4000', '127.0.0.1:4000',
            'spa.front.s3-website-us-east-1.amazonaws.com'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
