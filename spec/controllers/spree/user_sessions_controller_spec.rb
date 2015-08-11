RSpec.describe Spree::UserSessionsController, type: :controller do

  let(:user) { create(:user) }

  before { @request.env['devise.mapping'] = Devise.mappings[:spree_user] }

  context "#create" do
    context "using correct login information" do
      it 'properly assigns orders user from guest_token' do
        order1 = create(:order, email: user.email, guest_token: 'ABC', user_id: nil, created_by_id: nil)
        order2 = create(:order, guest_token: 'ABC', user_id: 200)
        request.cookie_jar.signed[:guest_token] = 'ABC'
        spree_post :create, spree_user: { email: user.email, password: 'secret' }

        expect(order1.reload.user_id).to eq user.id
        expect(order1.reload.created_by_id).to eq user.id
        expect(order2.reload.user_id).to eq 200
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
