require 'json_web_token'

class ApplicationController < ActionController::API
  before_action :authenticate_by_jwt!

  private

  def authenticate_by_jwt!
    decoded = JsonWebToken.decode(auth_token) rescue nil
    if decoded && decoded.fetch('user_id') == Rails.application.secrets.user_id
      return true
    end

    render json: { error: 'Login required' }, status: :unauthorized
  end

  def auth_token
    auth_header = request.headers['Authorization']
    token = auth_header && auth_header.split(' ').last.presence
    token || params[:auth_token].presence
  end
end
