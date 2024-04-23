class Spree::UsersController < Spree::StoreController
  before_action :set_current_order, except: :show

  include Spree::Core::ControllerHelpers

  def show
    load_object
    @orders = @user.orders.for_store(current_store).complete.order('completed_at desc')
  end

  def edit
    load_object
  end

  def create
    @user = Spree.user_class.new(user_params)
    if @user.save

      if current_order
        session[:guest_token] = nil
      end

      redirect_back_or_default(root_url)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    load_object
    if @user.update(user_params)
      if params[:user][:password].present?
        # this logic needed b/c devise wants to log us out after password changes
        Spree.user_class.reset_password_by_token(params[:user])
        if Spree::Auth::Config[:signout_after_password_change]
          sign_in(@user, event: :authentication)
        else
          bypass_sign_in(@user)
        end
      end
      redirect_to spree.account_path, notice: Spree.t(:account_updated)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(Spree::PermittedAttributes.user_attributes)
  end

  def load_object
    @user ||= spree_current_user
    authorize! params[:action].to_sym, @user
  end

  def authorize_actions
    authorize! params[:action].to_sym, Spree.user_class.new
  end

  def accurate_title
    Spree.t(:my_account)
  end
end
