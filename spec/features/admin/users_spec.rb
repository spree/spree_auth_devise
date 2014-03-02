require 'spec_helper'

feature 'Users' do

  background do
    create(:user, email: 'a@example.com')
    create(:user, email: 'b@example.com')
    sign_in_as! create(:admin_user)
    visit spree.admin_path
    click_link 'Users'
  end

  context 'users index page with sorting' do
    background do
      click_link 'users_email_title'
    end

    scenario 'can list users with order email asc' do
      expect(page).to have_table 'listing_users'
      within_table('listing_users') do
        expect(page).to have_text 'a@example.com'
        expect(page).to have_text 'b@example.com'
      end
    end

    scenario 'can list users with order email desc' do
      click_link 'users_email_title'
      within_table('listing_users') do
        expect(page).to have_text 'a@example.com'
        expect(page).to have_text 'b@example.com'
      end
    end
  end

  context 'searching users' do
    scenario 'display the correct results for a user search' do
      fill_in 'q_email_cont', with: 'a@example.com'
      click_button 'Search'
      within_table('listing_users') do
        expect(page).to have_text 'a@example.com'
        expect(page).not_to have_text 'b@example.com'
      end
    end
  end

  context 'editing users' do
    background do
      click_link 'a@example.com'
      click_link 'Edit'
    end

    scenario 'let me edit the user email' do
      fill_in 'user_email', with: 'a@example.com99'
      click_button 'Update'

      expect(page).to have_text 'Account updated'
      expect(find_field('user_email').value).to eq 'a@example.com99'
    end

    scenario 'let me edit the user password' do
      fill_in 'user_password', with: 'welcome'
      fill_in 'user_password_confirmation', with: 'welcome'
      click_button 'Update'

      expect(page).to have_text 'Account updated'
    end
  end
end
