require 'jwt'

class JsonWebToken
  def self.encode(payload, expiration = 24.hours.from_now)
    payload = payload.dup
    payload['exp'] = expiration.to_i
    JWT.encode(payload, Rails.application.secrets.json_web_token_secret, 'HS256')
  end

  def self.decode(token)
    return if token.blank?
    JWT.decode(token, Rails.application.secrets.json_web_token_secret, 'HS256').first
  end
end
