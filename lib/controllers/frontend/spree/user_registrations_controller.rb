class Spree::UserRegistrationsController < Devise::RegistrationsController
  helper 'spree/base', 'spree/store'
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
 
    if Spree::Auth::Engine.dash_available?
      helper 'spree/analytics'
    end

    include Spree::Core::ControllerHelpers::Auth
    include Spree::Core::ControllerHelpers::Common
    include Spree::Core::ControllerHelpers::Order
    include Spree::Core::ControllerHelpers::Store

    #  ssl_required
    before_filter :check_permissions, :only => [:edit, :update]
    skip_before_filter :require_no_authentication
    force_ssl if: :ssl_configured?

    def ssl_configured?
      !Rails.env.development?
    end  
    # GET /resource/sign_up
    def new
      super
      @user = resource
    end

    # POST /resource/sign_up
    def create
      @user = build_resource(spree_user_params)
      if resource.save
        respond_to do |format|
          format.html {
        
            set_flash_message(:notice, :signed_up)
            sign_in(:spree_user, @user)
            session[:spree_user_signup] = true
            associate_user
            respond_with resource, location: after_sign_up_path_for(resource)
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
           
            render json: @user.to_json(include: [:ship_address, :bill_address,:spree_roles => {:only => [ :scan_limit, :name ]}
              ])
          
          }
        end
      else
        respond_to do |format|
          format.html {
            clean_up_passwords(resource)
            render :new
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

    # GET /resource/edit
    def edit
      super
    end

    # PUT /resource
    def update
      super
    end

    # DELETE /resource
    def destroy
      super
    end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    def cancel
      super
    end

    protected
    def check_permissions
      authorize!(:create, resource)
    end

    private
    def spree_user_params
      params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes)
    end
  end
