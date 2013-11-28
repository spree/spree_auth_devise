require 'spec_helper'

describe Spree::CheckoutController do
  let(:order) { FactoryGirl.create(:order_with_totals, :email => nil, :user => nil) }
  let(:user) { mock_model Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }
  let(:token) { 'some_token' }

  before do
    controller.stub :current_order => order
    order.stub :confirmation_required? => true
  end

  context '#edit' do
    context 'when registration step enabled' do
      before do
        controller.stub :check_authorization
        Spree::Auth::Config.set(:registration_step => true)
      end

      context 'when authenticated as registered user' do
        before { controller.stub :spree_current_user => user }

        it 'should proceed to the first checkout step' do
          user.should_receive(:ship_address)
          spree_get :edit, { :state => 'address' }
          response.should render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'should redirect to registration step' do
          spree_get :edit, { :state => 'address' }
          response.should redirect_to spree.checkout_registration_path
        end
      end
    end

    context 'when registration step disabled' do
      before do
        Spree::Auth::Config.set(:registration_step => false)
        controller.stub :check_authorization
      end

      context 'when authenticated as registered' do
        before { controller.stub :spree_current_user => user }

        it 'should proceed to the first checkout step' do
          user.should_receive(:ship_address)
          spree_get :edit, { :state => 'address' }
          response.should render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'should proceed to the first checkout step' do
          spree_get :edit, { :state => 'address' }
          response.should render_template :edit
        end
      end

    end

  end

  context '#update' do
    context 'when in the confirm state' do
      before do
        order.update_column(:email, 'spree@example.com')
        order.update_column(:state, 'confirm')

        # So that the order can transition to complete successfully
        order.stub :payment_required? => false
      end

      context "with a token" do
        before do
          order.stub :token => 'ABC'
        end

        it 'should redirect to the tokenized order view' do
          spree_post :update, { :state => 'confirm' }, { :access_token => "ABC" }
          response.should redirect_to spree.token_order_path(order, 'ABC')
          flash.notice.should == Spree.t(:order_processed_successfully)
        end
      end

      context 'with a registered user' do
        before do
          controller.stub :spree_current_user => user
          order.stub :user => user
          order.stub :token => nil
        end

        it 'should redirect to the standard order view' do
          spree_post :update, { :state => 'confirm' }
          response.should redirect_to spree.order_path(order)
        end
      end
    end
  end

  context '#registration' do
    it 'should not check registration' do
      controller.stub :check_authorization
      controller.should_not_receive :check_registration
      spree_get :registration
    end

    it 'should check if the user is authorized for :edit' do
      controller.should_receive(:authorize!).with(:edit, order, token)
      spree_get :registration, {}, { :access_token => token }
    end
  end

  context '#update_registration' do
    let(:user) { user = mock_model Spree::User }

    it 'should not check registration' do
      controller.stub :check_authorization
      order.stub :update_attributes => true
      controller.should_not_receive :check_registration
      spree_put :update_registration, { :order => { } }
    end

    it 'should render the registration view if unable to save' do
      controller.stub :check_authorization
      spree_put :update_registration, { :order => { :email => 'invalid' } }
      flash[:registration_error].should == I18n.t(:email_is_invalid, :scope => [:errors, :messages])
      response.should render_template :registration
    end

    it 'should redirect to the checkout_path after saving' do
      order.stub :update_attributes => true
      controller.stub :check_authorization
      spree_put :update_registration, { :order => { :email => 'jobs@spreecommerce.com' } }
      response.should redirect_to spree.checkout_path
    end

    it 'should check if the user is authorized for :edit' do
      order.stub :update_attributes => true
      controller.should_receive(:authorize!).with(:edit, order, token)
      spree_put :update_registration, { :order => { :email => 'jobs@spreecommerce.com' } }, { :access_token => token }
    end
  end
end
