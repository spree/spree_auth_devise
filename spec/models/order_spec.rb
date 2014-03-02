require 'spec_helper'

describe Spree::Order do
  let(:order) { described_class.new }

  context '#associate_user!' do
    let(:user) { mock_model Spree::User, email: 'spree@example.com', anonymous?: false }
    before { order.stub(save!: true) }

    it 'associate the order with the specified user' do
      order.associate_user! user
      expect(order.user).to eq user
    end

    it "set the order's email attribute to that of the specified user" do
      order.associate_user! user
      expect(order.email).to eq user.email
    end

    it 'destroy any previous association with a guest user' do
      guest_user = mock_model Spree::User
      order.user = guest_user
      order.associate_user! user
      expect(order.user).not_to eq guest_user
    end
  end

  context '#create' do
    it 'create a token permission' do
      order.save
      expect(order.token).not_to be_nil
    end
  end
end
