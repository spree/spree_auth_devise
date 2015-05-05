class Spree::UserPasswordsController < Devise::PasswordsController
  helper 'spree/base', 'spree/store'
 protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
 
  if Spree::Auth::Engine.dash_available?
    helper 'spree/analytics'
  end

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
#  include Spree::Core::ControllerHelpers::SSL
  include Spree::Core::ControllerHelpers::Store

#  ssl_required
  
     force_ssl if: :ssl_configured?

    def ssl_configured?
      !Rails.env.development?
    end  
  # Overridden due to bug in Devise.
  #   respond_with resource, :location => new_session_path(resource_name)
  # is generating bad url /session/new.user
  #
  # overridden to:
  #   respond_with resource, :location => spree.login_path
  #
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if resource.errors.empty?
      @user=resource
      respond_to do |format|
        format.html {
          set_flash_message(:notice, :send_instructions) if is_navigational_format?
          respond_with resource, :location => spree.login_path
        }
        format.js {
          api_key=@user.spree_api_key
          if api_key.nil?
            @user.generate_spree_api_key!
            api_key=@user.spree_api_key
          end
          render :json => {:user => @user
            
          }
        }
        format.json {
          api_key=@user.spree_api_key
          if api_key.nil?
            @user.generate_spree_api_key!
            api_key=@user.spree_api_key
          end
          render :json => {:user => @user
            
          }
        }
      end
    else
      respond_to do |format|
        format.html {
          respond_with_navigational(resource) { render :new }
        }
        format.js {
          
            render :json => { error: resource.errors.messages }, status: :unprocessable_entity
         
        }
        format.json {
          
            render :json => { error: resource.errors.messages }, status: :unprocessable_entity
         
        }
      end
    end
  end

  # Devise::PasswordsController allows for blank passwords.
  # Silly Devise::PasswordsController!
  # Fixes spree/spree#2190.
  def update
    if params[:spree_user][:password].blank?
      self.resource = resource_class.new
      resource.reset_password_token = params[:spree_user][:reset_password_token]
      set_flash_message(:error, :cannot_be_blank)
      render :edit
    else
      super
    end
  end

end
