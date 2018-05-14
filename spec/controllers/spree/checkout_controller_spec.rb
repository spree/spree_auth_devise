RSpec.describe Spree::CheckoutController, type: :controller do
  let(:order) { create(:order_with_totals, email: nil, user: nil) }
  let(:user)  { build(:user, spree_api_key: 'fake') }
  let(:token) { 'some_token' }

  before do
    allow(controller).to receive(:current_order) { order }
    allow(order).to receive(:confirmation_required?) { true }
  end

  context '#edit' do
    context 'when registration step enabled' do
      before do
        allow(controller).to receive(:check_authorization)
        Spree::Auth::Config.set(registration_step: true)
      end

      context 'when authenticated as registered user' do
        before { allow(controller).to receive(:spree_current_user) { user } }

        it 'proceeds to the first checkout step' do
          spree_get :edit, { state: 'address' }
          expect(response).to render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'redirects to registration step' do
          spree_get :edit, { state: 'address' }
          expect(response).to redirect_to spree.checkout_registration_path
        end
      end
    end

    context 'when registration step disabled' do
      before do
        Spree::Auth::Config.set(registration_step: false)
        allow(controller).to receive(:check_authorization)
      end

      context 'when authenticated as registered' do
        before { allow(controller).to receive(:spree_current_user) { user } }

        it 'proceeds to the first checkout step' do
          spree_get :edit, { state: 'address' }
          expect(response).to render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'proceeds to the first checkout step' do
          spree_get :edit, { state: 'address' }
          expect(response).to render_template :edit
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
        allow(order).to receive(:payment_required?) { false }
      end

      context 'with a token' do
        before { allow(order).to receive(:guest_token) { 'ABC' } }

        it 'redirects to the tokenized order view' do
          request.cookie_jar.signed[:guest_token] = 'ABC'
          spree_post :update, { state: 'confirm' }
          expect(response).to redirect_to spree.order_path(order)
          expect(flash.notice).to eq Spree.t(:order_processed_successfully)
        end
      end

      context 'with a registered user' do
        before do
          allow(controller).to receive(:spree_current_user) { user }
          allow(order).to receive(:user) { user }
          allow(order).to receive(:guest_token) { nil }
        end

        it 'redirects to the standard order view' do
          spree_post :update, { state: 'confirm' }
          expect(response).to redirect_to spree.order_path(order)
        end
      end
    end
  end

  context '#registration' do
    it 'does not check registration' do
      allow(controller).to receive(:check_authorization)
      expect(controller).not_to receive(:check_registration)
      spree_get :registration
    end

    it 'checks if the user is authorized for :edit' do
      expect(controller).to receive(:authorize!).with(:edit, order, token)
      request.cookie_jar.signed[:guest_token] = token
      spree_get :registration, {}
    end
  end

  context '#update_registration' do
    let(:user) { build(:user) }

    it 'does not check registration' do
      controller.stub :check_authorization
      order.stub update_attributes: true
      controller.should_not_receive :check_registration
      spree_put :update_registration, { order: {} }
    end

    it 'renders the registration view if unable to save' do
      allow(controller).to receive(:check_authorization)
      spree_put :update_registration, { order: { email: 'invalid' } }
      expect(flash[:error]).to eq I18n.t(:email_is_invalid, scope: [:errors, :messages])
      expect(response).to render_template :registration
    end

    it 'redirects to the checkout_path after saving' do
      allow(order).to receive(:update_attributes) { true }
      allow(controller).to receive(:check_authorization)
      spree_put :update_registration, { order: { email: 'jobs@spreecommerce.com' } }
      expect(response).to redirect_to spree.checkout_state_path(:address)
    end

    it 'checks if the user is authorized for :edit' do
      request.cookie_jar.signed[:guest_token] = token
      allow(order).to receive(:update_attributes) { true }
      expect(controller).to receive(:authorize!).with(:edit, order, token)
      spree_put :update_registration, { order: { email: 'jobs@spreecommerce.com' } }
    end
  end
end
