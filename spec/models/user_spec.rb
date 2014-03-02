require 'spec_helper'

describe Spree::User do
  before(:all) { Spree::Role.create name: 'admin' }

  it '#admin?' do
    expect(create(:admin_user).admin?).to be_true
    expect(create(:user).admin?).to be_false
  end

  it 'generate the reset password token' do
    user = build(:user)
    Spree::UserMailer.should_receive(:reset_password_instructions).with(user, anything, {}).and_return(double(deliver: true))
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
