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
    it 'will soft delete' do
      order = build(:order, completed_at: Time.now)
      order.save
      user = order.user
      user.destroy
      expect(Spree::User.find_by_id(user.id)).to be_nil
      expect(Spree::User.with_deleted.find_by_id(user.id)).to eq(user)
      expect(Spree::User.with_deleted.find_by_id(user.id).orders.first).to eq(order)

      expect(Spree::Order.find_by_user_id(user.id)).not_to be_nil
      expect(Spree::Order.where(user_id: user.id).first).to eq(order)
    end
  end
end
