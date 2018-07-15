RSpec.describe Spree::UserSessionsController, type: :controller do
  let(:user) { create(:user) }

  before { @request.env['devise.mapping'] = Devise.mappings[:spree_user] }

  context "#create" do
    context "using correct login information" do
      if Gem.loaded_specs['spree_core'].version >= Gem::Version.create('3.6.0')
        #regression tests for https://github.com/spree/spree_auth_devise/pull/438
        context 'with a token present' do
          before do
            request.cookie_jar.signed[:token] = 'ABC'
          end

          it 'assigns orders with the correct token and no user present' do
            order = create(:order, email: user.email, token: 'ABC', user_id: nil, created_by_id: nil)
            spree_post :create, spree_user: { email: user.email, password: 'secret' }

            order.reload
            expect(order.user_id).to eq user.id
            expect(order.created_by_id).to eq user.id
          end

          it 'assigns orders with the correct token and no user or email present' do
            order = create(:order, token: 'ABC', user_id: nil, created_by_id: nil)
            spree_post :create, spree_user: { email: user.email, password: 'secret' }

            order.reload
            expect(order.user_id).to eq user.id
            expect(order.created_by_id).to eq user.id
          end

          it 'does not assign completed orders' do
            order = create(:order, email: user.email, token: 'ABC',
                           user_id: nil, created_by_id: nil,
                           completed_at: 1.minute.ago)
            spree_post :create, spree_user: { email: user.email, password: 'secret' }

            order.reload
            expect(order.user_id).to be_nil
            expect(order.created_by_id).to be_nil
          end

          it 'does not assign orders with an existing user' do
            order = create(:order, token: 'ABC', user_id: 200)
            spree_post :create, spree_user: { email: user.email, password: 'secret' }

            expect(order.reload.user_id).to eq 200
          end

          it 'does not assign orders with a different token' do
            order = create(:order, token: 'DEF', user_id: nil, created_by_id: nil)
            spree_post :create, spree_user: { email: user.email, password: 'secret' }

            expect(order.reload.user_id).to be_nil
          end
        end
      end

      context 'with a guest token present' do
        before do
          request.cookie_jar.signed[:guest_token] = 'ABC'
        end

        it 'assigns orders with the correct token and no user present' do
          order = create(:order, email: user.email, guest_token: 'ABC', user_id: nil, created_by_id: nil)
          spree_post :create, spree_user: { email: user.email, password: 'secret' }

          order.reload
          expect(order.user_id).to eq user.id
          expect(order.created_by_id).to eq user.id
        end

        it 'assigns orders with the correct token and no user or email present' do
          order = create(:order, guest_token: 'ABC', user_id: nil, created_by_id: nil)
          spree_post :create, spree_user: { email: user.email, password: 'secret' }

          order.reload
          expect(order.user_id).to eq user.id
          expect(order.created_by_id).to eq user.id
        end

        it 'does not assign completed orders' do
          order = create(:order, email: user.email, guest_token: 'ABC',
                         user_id: nil, created_by_id: nil,
                         completed_at: 1.minute.ago)
          spree_post :create, spree_user: { email: user.email, password: 'secret' }

          order.reload
          expect(order.user_id).to be_nil
          expect(order.created_by_id).to be_nil
        end

        it 'does not assign orders with an existing user' do
          order = create(:order, guest_token: 'ABC', user_id: 200)
          spree_post :create, spree_user: { email: user.email, password: 'secret' }

          expect(order.reload.user_id).to eq 200
        end

        it 'does not assign orders with a different token' do
          order = create(:order, guest_token: 'DEF', user_id: nil, created_by_id: nil)
          spree_post :create, spree_user: { email: user.email, password: 'secret' }

          expect(order.reload.user_id).to be_nil
        end
      end

      context "and html format is used" do
        it "redirects to default after signing in" do
          spree_post :create, spree_user: { email: user.email, password: 'secret' }
          expect(response).to redirect_to spree.root_path
        end
      end

      context "and js format is used" do
        it "returns a json with ship and bill address" do
          spree_post :create, spree_user: { email: user.email, password: 'secret' }, format: 'js'
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
          spree_post :create, spree_user: { email: user.email, password: 'wrong' }
          expect(response).to render_template('new')
          expect(flash[:error]).to eq I18n.t(:'devise.failure.invalid')
        end
      end

      context "and js format is used" do
        it "returns a json with the error" do
          spree_post :create, spree_user: { email: user.email, password: 'wrong' }, format: 'js'
          parsed = ActiveSupport::JSON.decode(response.body)
          expect(parsed).to have_key("error")
        end
      end
    end
  end
end
