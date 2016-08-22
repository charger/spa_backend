require 'json_web_token'

class Api::V1::SessionController < ActionController::API
  def create
    if params[:username] == Rails.application.secrets.username && params[:password] == Rails.application.secrets.password
      return render json: { token: JsonWebToken.encode({ user_id: Rails.application.secrets.user_id, full_name: 'Valid User' }) }
    end
    render json: { error: 'Invalid credentials' }, status: :unauthorized
  end
end
