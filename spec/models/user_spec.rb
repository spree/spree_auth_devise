RSpec.describe Spree::User, type: :model do

  before(:all) { Spree::Role.create name: 'admin' }

  it '#admin?' do
    expect(create(:admin_user).admin?).to be true
    expect(create(:user).admin?).to be false
  end

  it 'generates the reset password token' do
    user = build(:user)
    expect(Spree::UserMailer).to receive(:reset_password_instructions).with(user, anything, {}).and_return(double(deliver: true))
    user.send_reset_password_instructions
    expect(user.reset_password_token).not_to be_nil
  end

  context '#destroy' do
    it 'can not delete if it has completed orders' do
      order = build(:order, completed_at: Time.now)
      order.save
      user = order.user
      expect { user.destroy }.to raise_exception(Spree::User::DestroyWithOrdersError)
    end
  end
end
