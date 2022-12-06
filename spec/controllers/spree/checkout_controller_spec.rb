RSpec.describe Spree::CheckoutController, type: :controller do
  let(:order) { create(:order_with_totals, email: nil, user: nil) }
  let(:user)  { build(:user, spree_api_key: 'fake') }
  let(:token) { 'some_token' }

  before do
    allow(controller).to receive(:current_order) { order }
    allow(order).to receive(:confirmation_required?) { true }
    Spree::Store.default.update(default_locale: 'en', supported_locales: 'en,fr') if Spree.version.to_f >= 4.2
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
          get :edit, params: { state: 'address' }
          expect(response).to render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'redirects to registration step' do
          get :edit, params: { state: 'address' }
          expect(response).to redirect_to spree.checkout_registration_path
        end

        context 'non default locale' do
          it 'redirects to registration step with non default locale' do
            get :edit, params: { state: 'address', locale: 'fr' }
            expect(response).to redirect_to spree.checkout_registration_path(locale: 'fr')
          end
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
          get :edit, params: { state: 'address' }
          expect(response).to render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'proceeds to the first checkout step' do
          get :edit, params: { state: 'address' }
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
        before do
          if Spree.version.to_f > 3.6
            allow(order).to receive(:token) { 'ABC' }
          else
            allow(order).to receive(:guest_token) { 'ABC' }
          end
        end

        it 'redirects to the tokenized order view' do
          if Spree.version.to_f > 3.6
            request.cookie_jar.signed[:token] = 'ABC'
          else
            request.cookie_jar.signed[:guest_token] = 'ABC'
          end
          post :update, params: { state: 'confirm' }
          expect(response).to redirect_to spree.order_path(order)
        end

        context 'non default locale' do
          it 'redirects to the tokenized order view with a non default locale' do
            # spree version higher than 3.6 required for test to work correctly
            request.cookie_jar.signed[:token] = 'ABC'
            post :update, params: { state: 'confirm', locale: 'fr' }
            expect(response).to redirect_to spree.order_path(order, locale: 'fr')
          end
        end
      end

      context 'with a registered user' do
        before do
          allow(controller).to receive(:spree_current_user) { user }
          allow(order).to receive(:user) { user }
          if Spree.version.to_f > 3.6
            allow(order).to receive(:token) { nil }
          else
            allow(order).to receive(:guest_token) { nil }
          end
        end

        it 'redirects to the standard order view' do
          post :update, params: { state: 'confirm' }
          expect(response).to redirect_to spree.order_path(order)
        end

        context 'non default locale' do
          it 'redirects to the standard order view with a non default locale' do
            post :update, params: { state: 'confirm', locale: 'fr' }
            expect(response).to redirect_to spree.order_path(order, locale: 'fr')
          end
        end
      end
    end
  end

  context '#registration' do
    it 'does not check registration' do
      allow(controller).to receive(:check_authorization)
      expect(controller).not_to receive(:check_registration)
      get :registration
    end

    it 'checks if the user is authorized for :edit' do
      expect(controller).to receive(:authorize!).with(:edit, order, token)
      if Spree.version.to_f > 3.6
        request.cookie_jar.signed[:token] = token
      else
        request.cookie_jar.signed[:guest_token] = token
      end
      get :registration, params: {}
    end
  end

  context '#update_registration' do
    let(:user) { build(:user) }

    it 'does not check registration' do
      controller.stub :check_authorization
      order.stub update: true
      controller.should_not_receive :check_registration
      put :update_registration, params: { order: {} }
    end

    it 'renders the registration view if unable to save' do
      allow(controller).to receive(:check_authorization)
      put :update_registration, params: { order: { email: 'invalid' } }
      expect(flash[:error]).to eq I18n.t(:email_is_invalid, scope: [:errors, :messages])
      expect(response).to render_template :registration
    end

    it 'redirects to the checkout_path after saving' do
      allow(order).to receive(:update) { true }
      allow(controller).to receive(:check_authorization)
      put :update_registration, params: { order: { email: 'jobs@spreecommerce.com' } }
      expect(response).to redirect_to spree.checkout_state_path(:address)
    end

    context 'non default locale' do
      it 'redirects to the checkout_path after saving with non default locale' do
        allow(controller).to receive(:check_authorization)
        put :update_registration, params: { order: { email: 'jobs@spreecommerce.com' }, locale: 'fr' }
        expect(response).to redirect_to spree.checkout_state_path(:address, locale: 'fr')
      end
    end

    it 'checks if the user is authorized for :edit' do
      if Spree.version.to_f > 3.6
        request.cookie_jar.signed[:token] = token
      else
        request.cookie_jar.signed[:guest_token] = token
      end
      allow(order).to receive(:update) { true }
      expect(controller).to receive(:authorize!).with(:edit, order, token)
      put :update_registration, params: { order: { email: 'jobs@spreecommerce.com' } }
    end
  end
end
