RSpec.describe Spree::Admin::UserSessionsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:spree_user] }

  describe '#authorization_failure' do
    subject { spree_get :authorization_failure }

    context 'user signed in' do
      before { allow(controller).to receive(:spree_current_user) { build_stubbed(:user) } }

      it { is_expected.to render_template 'authorization_failure' }
    end

    context 'user not signed in' do
      it { is_expected.to redirect_to spree.admin_login_path }
    end
  end
end
