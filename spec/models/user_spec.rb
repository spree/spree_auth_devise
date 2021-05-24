RSpec.describe Spree::User, type: :model do
  before(:all) { Spree::Role.create name: 'admin' }
  let!(:store) { create(:store) }

  it '#admin?' do
    expect(create(:admin_user).admin?).to be true
    expect(create(:user).admin?).to be false
  end

  it 'generates the reset password token' do
    user = build(:user)
    current_store = Spree::Store.current
    expect(Spree::UserMailer).to receive(:reset_password_instructions).with(user, anything, { current_store_id: current_store.id }).and_return(double(deliver: true))
    user.send_reset_password_instructions(current_store)
    expect(user.reset_password_token).not_to be_nil
  end

  describe '.admin_created?' do
    it 'returns true when admin exists' do
      create(:admin_user)

      expect(Spree::User).to be_admin_created
    end

    it 'returns false when admin does not exist' do
      expect(Spree::User).to_not be_admin_created
    end
  end

  describe 'validations' do
    context 'email' do
      let(:user) { build(:user, email: nil) }

      it 'cannot be empty' do
        expect(user.valid?).to be false
        expect(user.errors.messages[:email].first).to eq "can't be blank"
      end
    end

    context 'password' do
      let(:user) { build(:user, password_confirmation: nil) }

      it 'password confirmation cannot be empty' do
        expect(user.valid?).to be false
        expect(user.errors.messages[:password_confirmation].first).to eq "doesn't match Password"
      end

      let(:user) { build(:user, password: 'pass1234', password_confirmation: 'pass') }

      it 'passwords has to be equal to password confirmation' do
        expect(user.valid?).to be false
        expect(user.errors.messages[:password_confirmation].first).to eq "doesn't match Password"
      end
    end
  end

  context '#destroy' do
    it 'will soft delete with uncompleted orders' do
      order = build(:order)
      order.save
      user = order.user
      user.destroy
      expect(Spree.user_class.find_by_id(user.id)).to be_nil
      expect(Spree.user_class.with_deleted.find_by_id(user.id).id).to eq(user.id)
      expect(Spree.user_class.with_deleted.find_by_id(user.id).orders.first).to eq(order)

      expect(Spree::Order.find_by_user_id(user.id)).not_to be_nil
      expect(Spree::Order.where(user_id: user.id).first).to eq(order)
    end

    it 'will not soft delete with completed orders' do
      # depends on Spree Core
      # this was introduced in Spree 3.2
      skip "this is't supported in Spree 3.1 and lower" if Spree.version.to_f < 3.2
      order = build(:order, completed_at: Time.now)
      order.save
      user = order.user
      expect { user.destroy }.to raise_error(Spree::Core::DestroyWithOrdersError)
    end

    it 'will allow users to register later with same email address as previously deleted account' do
      user1 = build(:user)
      user1.save

      user2 = build(:user)
      user2.email = user1.email
      expect(user2.save).to be false
      expect(user2.errors.messages[:email].first).to eq "has already been taken"

      user1.destroy
      expect(user2.save).to be true
    end
  end

  describe "confirmable" do
    it "is confirmable if the confirmable option is enabled", confirmable: true do
      Spree::UserMailer.stub(:confirmation_instructions).with(anything, anything, { current_store_id: Spree::Store.current.id }).and_return(double(deliver: true))
      expect(Spree.user_class.devise_modules).to include(:confirmable)
    end

    it "is not confirmable if the confirmable option is disabled", confirmable: false do
      expect(Spree.user_class.devise_modules).not_to include(:confirmable)
    end
  end

  describe "#send_confirmation_instructions", retry: 2 do
    let(:default_store) { Spree::Store.default }

    context "when current store not exists" do
      it 'takes default store and sends confirmation instruction', confirmable: true do
        user = Spree.user_class.new
        user.email = FFaker::Internet.email
        user.password = user.password_confirmation = 'pass1234'
        user.save
        
        expect(Spree::UserMailer).to receive(:confirmation_instructions).with(
          user, anything, { current_store_id: default_store.id }).and_return(double(deliver: true)
        )

        user.send_confirmation_instructions(nil)
      end
    end

    context "when current store exists" do
      it 'takes current store and sends confirmation instruction', confirmable: true do
        user = Spree.user_class.new
        user.email = FFaker::Internet.email
        user.password = user.password_confirmation = 'pass1234'
        user.save

        expect(Spree::UserMailer).to receive(:confirmation_instructions).with(
          user, anything, { current_store_id: store.id }).and_return(double(deliver: true)
        )

        user.send_confirmation_instructions(store)
      end
    end
  end
end
