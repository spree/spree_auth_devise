RSpec.describe Spree::UserSessionsController, type: :controller do
  let(:user) { create(:user) }

  before { @request.env['devise.mapping'] = Devise.mappings[:spree_user] }

  context "#create" do
    context "using correct login information" do
      if Gem.loaded_specs['spree_core'].version >= Gem::Version.create('3.7.0')
        #regression tests for https://github.com/spree/spree_auth_devise/pull/438
        context 'with a token present' do
          before do
            request.cookie_jar.signed[:token] = 'ABC'
          end

          it 'assigns orders with the correct token and no user present' do
            order = create(:order, email: user.email, token: 'ABC', user_id: nil, created_by_id: nil)
            post :create, params: { spree_user: { email: user.email, password: 'secret' }}

            order.reload
            expect(order.user_id).to eq user.id
            expect(order.created_by_id).to eq user.id
          end

          it 'assigns orders with the correct token and no user or email present' do
            order = create(:order, token: 'ABC', user_id: nil, created_by_id: nil)
            post :create, params: { spree_user: { email: user.email, password: 'secret' }}

            order.reload
            expect(order.user_id).to eq user.id
            expect(order.created_by_id).to eq user.id
          end

          it 'does not assign completed orders' do
            order = create(:order, email: user.email, token: 'ABC',
                           user_id: nil, created_by_id: nil,
                           completed_at: 1.minute.ago)
            post :create, params: { spree_user: { email: user.email, password: 'secret' }}

            order.reload
            expect(order.user_id).to be_nil
            expect(order.created_by_id).to be_nil
          end

          it 'does not assign orders with an existing user' do
            order = create(:order, token: 'ABC', user_id: 200)
            post :create, params: { spree_user: { email: user.email, password: 'secret' }}

            expect(order.reload.user_id).to eq 200
          end

          it 'does not assign orders with a different token' do
            order = create(:order, token: 'DEF', user_id: nil, created_by_id: nil)
            post :create, params: { spree_user: { email: user.email, password: 'secret' }}

            expect(order.reload.user_id).to be_nil
          end
        end
      end

      context 'with a guest token present' do
        before do
          if Spree.version.to_f > 3.6
            request.cookie_jar.signed[:token] = 'ABC'
          else
            request.cookie_jar.signed[:guest_token] = 'ABC'
          end
        end

        it 'assigns orders with the correct token and no user present' do
          if Spree.version.to_f > 3.6
            order = create(:order, email: user.email, token: 'ABC', user_id: nil, created_by_id: nil)
          else
            order = create(:order, email: user.email, guest_token: 'ABC', user_id: nil, created_by_id: nil)
          end
          post :create, params: { spree_user: { email: user.email, password: 'secret' }}

          order.reload
          expect(order.user_id).to eq user.id
          expect(order.created_by_id).to eq user.id
        end

        it 'assigns orders with the correct token and no user or email present' do
          if Spree.version.to_f > 3.6
            order = create(:order, token: 'ABC', user_id: nil, created_by_id: nil)
          else
            order = create(:order, guest_token: 'ABC', user_id: nil, created_by_id: nil)
          end
          post :create, params: { spree_user: { email: user.email, password: 'secret' }}

          order.reload
          expect(order.user_id).to eq user.id
          expect(order.created_by_id).to eq user.id
        end

        it 'does not assign completed orders' do
          if Spree.version.to_f > 3.6
            order = create(:order, email: user.email, token: 'ABC',
                           user_id: nil, created_by_id: nil,
                           completed_at: 1.minute.ago)
          else
            order = create(:order, email: user.email, guest_token: 'ABC',
                           user_id: nil, created_by_id: nil,
                           completed_at: 1.minute.ago)
          end
          post :create, params: { spree_user: { email: user.email, password: 'secret' }}

          order.reload
          expect(order.user_id).to be_nil
          expect(order.created_by_id).to be_nil
        end

        it 'does not assign orders with an existing user' do
          if Spree.version.to_f > 3.6
              order = create(:order, token: 'ABC', user_id: 200)
          else
              order = create(:order, guest_token: 'ABC', user_id: 200)
          end
          post :create, params: { spree_user: { email: user.email, password: 'secret' }}

          expect(order.reload.user_id).to eq 200
        end

        it 'does not assign orders with a different token' do
          if Spree.version.to_f > 3.6
              order = create(:order, token: 'DEF', user_id: nil, created_by_id: nil)
          else
              order = create(:order, guest_token: 'DEF', user_id: nil, created_by_id: nil)
          end
          post :create, params: { spree_user: { email: user.email, password: 'secret' }}

          expect(order.reload.user_id).to be_nil
        end
      end

      context 'with a guest_token from a pre-3.7 version of Spree present' do
        before do
          request.cookie_jar.signed[:guest_token] = 'ABC'
          request.cookie_jar.signed[:token] = 'DEF'
        end

        it 'assigns the correct token attribute for the order' do 
          if Spree.version.to_f > 3.6
            order = create(:order, email: user.email, token: 'ABC', user_id: nil, created_by_id: nil)
          else
            order = create(:order, email: user.email, guest_token: 'ABC', user_id: nil, created_by_id: nil)
          end
          post :create, params: { spree_user: { email: user.email, password: 'secret' }}

          order.reload
          expect(order.user_id).to eq user.id
          expect(order.created_by_id).to eq user.id
        end 
      end

      context "and html format is used" do
        it "redirects to account path after signing in" do
          post :create, params: { spree_user: { email: user.email, password: 'secret' }}
          expect(response).to redirect_to spree.account_path
        end

        context 'different locale' do
          before do
            Spree::Store.default.update(default_locale: 'en', supported_locales: 'en,fr') if Spree.version.to_f >= 4.2
          end

          it 'redirects to localized account path after signing in' do
            skip if Spree.version.to_f < 4.2
            post :create, params: { spree_user: { email: user.email, password: 'secret' }, locale: 'fr' }
            expect(response).to redirect_to spree.account_path(locale: 'fr')
          end
        end
      end

      context "and js format is used" do
        it "returns a json with ship and bill address" do
          post :create, params: { spree_user: { email: user.email, password: 'secret' }, format: 'js' }
          parsed = ActiveSupport::JSON.decode(response.body)
          expect(parsed).to have_key("user")
          expect(parsed).to have_key("ship_address")
          expect(parsed).to have_key("bill_address")
        end
      end
    end

    context "using incorrect login information" do
      context "and html format is used" do
        it "renders new template again with errors" do
          post :create, params: { spree_user: { email: user.email, password: 'wrong' }}
          expect(response).to render_template('new')
          expect(flash[:error]).to eq I18n.t(:'devise.failure.invalid')
        end
      end

      context "and js format is used" do
        it "returns a json with the error" do
          post :create, params: { spree_user: { email: user.email, password: 'wrong' }, format: 'js' }
          parsed = ActiveSupport::JSON.decode(response.body)
          expect(parsed).to have_key("error")
        end
      end
    end
  end
end
