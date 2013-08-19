require 'spec_helper'

describe Spree::User do
  before(:all) { Spree::Role.create :name => 'admin' }

  it '#admin?' do
    create(:admin_user).admin?.should be_true
    create(:user).admin?.should be_false
  end

  it 'should generate the reset password token' do
    user = create(:user)
    Spree::UserMailer.should_receive(:reset_password_instructions).with(user.id).and_return(double(:deliver => true))
    user.send_reset_password_instructions
    user.reset_password_token.should_not be_nil
  end

  context '#create' do
    let(:user) { build(:user) }

    it 'should not be anonymous' do
      user.should_not be_anonymous
    end
  end

  context '#destroy' do
    it 'can not delete if it has completed orders' do
      order = build(:order, :completed_at => Time.now)
      order.save
      user = order.user

      lambda { user.destroy }.should raise_exception(Spree::User::DestroyWithOrdersError)
    end
  end

  context 'anonymous!' do
    let(:user) { Spree::User.anonymous! }

    it 'should create a new user' do
      user.new_record?.should be_false
    end

    it 'should create a user with an example.net email' do
      user.email.should =~ /@example.net$/
    end

    it 'should be anonymous' do
      user.should be_anonymous
    end
  end

end
