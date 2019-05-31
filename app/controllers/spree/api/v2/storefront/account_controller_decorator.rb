class AccountControllerDecorator
  before_action :require_spree_current_user, except: :create

  def create
    user_resource_params = {
      email: params[:data][:attributes][:email],
      password: params[:data][:attributes][:password],
      password_confirmation: params[:data][:attributes][:password_confirmation]
    }

    @user = build_resource(user_resource_params)
    resource_saved = resource.save

    render_serialized_payload { serialize_resource(@user) }
  end

  private

  def render_serialized_payload(status = 201)
    render json: yield, status: status, content_type: content_type
  rescue ArgumentError => exception
    render_error_payload(exception.message, 422)
  end

  def render_error_payload(error, status = 422)
    if error.is_a?(Struct)
      render json: { error: error.to_s, errors: error.to_h }, status: status, content_type: content_type
    elsif error.is_a?(String)
      render json: { error: error }, status: status, content_type: content_type
    end
  end

  def content_type
    Spree::Api::Config[:api_v2_content_type]
  end
end

Spree::Api::V2::Storefront::AccountController.prepend AccountControllerDecorator
