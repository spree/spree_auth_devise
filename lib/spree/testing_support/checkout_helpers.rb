module Spree
  module TestingSupport
    module CheckoutHelpers
      def fill_in_address
        address = 'order_bill_address_attributes'
        fill_in "#{address}_firstname", with: 'Ryan'
        fill_in "#{address}_lastname", with: 'Bigg'
        fill_in "#{address}_address1", with: '143 Swan Street'
        fill_in "#{address}_city", with: 'Richmond'
        select country.name, from: "#{address}_country_id"
        select state.name, from: "#{address}_state_id"
        fill_in "#{address}_zipcode", with: '12345'
        fill_in "#{address}_phone", with: '(555) 555-5555'
      end

      def fill_in_credit_card_info(invalid: false)
        fill_in 'name_on_card', with: 'Spree Commerce'
        fill_in 'card_number', with: invalid ? '123' : '4111 1111 1111 1111'
        fill_in 'card_expiry', with: '12 / 24'
        fill_in 'card_code', with: '123'
      end
    end
  end
end
