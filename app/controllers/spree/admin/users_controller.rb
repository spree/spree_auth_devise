module Spree
  module Admin
    class UsersController < ResourceController

      # http://spreecommerce.com/blog/2010/11/02/json-hijacking-vulnerability/
      before_filter :check_json_authenticity, :only => :index
      before_filter :load_roles, :only => [:edit, :new, :update, :create, :generate_api_key, :clear_api_key]

      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      def generate_api_key
        if @user.generate_spree_api_key!
          flash.notice = t('key_generated', :scope => 'spree.api')
        end
        redirect_to edit_admin_user_path(@user)
      end

      def clear_api_key
        if @user.clear_spree_api_key!
          flash.notice = t('key_cleared', :scope => 'spree.api')
        end
        redirect_to edit_admin_user_path(@user)
      end

      def create
        if params[:user]
          roles = params[:user].delete("spree_role_ids")
        end

        @user = Spree::User.new(params[:user])
        if @user.save

          if roles
            @user.spree_roles = roles.reject(&:blank?).collect{|r| Spree::Role.find(r)}
          end

          flash.now[:notice] = t(:created_successfully)
          render :edit
        else
          render :new
        end
      end

      def update
        if params[:user]
          roles = params[:user].delete("spree_role_ids")
        end

        if @user.update_attributes(params[:user])
          if roles
            @user.spree_roles = roles.reject(&:blank?).collect{|r| Spree::Role.find(r)}
          end

          if params[:user][:password].present?
            # this logic needed b/c devise wants to log us out after password changes
            user = Spree::User.reset_password_by_token(params[:user])
            sign_in(@user, :event => :authentication, :bypass => !Spree::Auth::Config[:signout_after_password_change])
          end
          flash.now[:notice] = t(:account_updated)
          render :edit
        else
          render :edit
        end
      end


      protected

        def collection
          return @collection if @collection.present?
          unless request.xhr?
            @search = Spree::User.registered.ransack(params[:q])
            @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page])
          else
            #disabling proper nested include here due to rails 3.1 bug
            #@collection = User.includes(:bill_address => [:state, :country], :ship_address => [:state, :country]).
            @collection = Spree::User.includes(:bill_address, :ship_address).
                              where("spree_users.email #{LIKE} :search
                                     OR (spree_addresses.firstname #{LIKE} :search AND spree_addresses.id = spree_users.bill_address_id)
                                     OR (spree_addresses.lastname  #{LIKE} :search AND spree_addresses.id = spree_users.bill_address_id)
                                     OR (spree_addresses.firstname #{LIKE} :search AND spree_addresses.id = spree_users.ship_address_id)
                                     OR (spree_addresses.lastname  #{LIKE} :search AND spree_addresses.id = spree_users.ship_address_id)",
              { :search => "#{params[:q].strip}%" }).
                limit(params[:limit] || 100)
            end
          end

      private

        # handling raise from Spree::Admin::ResourceController#destroy
        def user_destroy_with_orders_error
          invoke_callbacks(:destroy, :fails)
          render :status => :forbidden, :text => t(:error_user_destroy_with_orders)
        end

        # Allow different formats of json data to suit different ajax calls
        def json_data
          json_format = params[:json_format] or 'default'
          case json_format
          when 'basic'
            collection.map { |u| { 'id' => u.id, 'name' => u.email } }.to_json
          else
            address_fields = [:firstname, :lastname, :address1, :address2, :city, :zipcode, :phone, :state_name, :state_id, :country_id]
            includes = { :only => address_fields , :include => { :state => { :only => :name }, :country => { :only => :name } } }

            collection.to_json(:only => [:id, :email], :include =>
                               { :bill_address => includes, :ship_address => includes })
          end
        end

    end
  end
end
