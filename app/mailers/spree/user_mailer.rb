class Spree::UserMailer < ActionMailer::Base
  def reset_password_instructions(user)
    @edit_password_reset_url = spree.edit_spree_user_password_url(:reset_password_token => user.reset_password_token)

    mail(:to => user.email, :from => Spree::Config[:emails_sent_from],
         :subject => Spree::Config[:site_name] + ' ' + I18n.t(:password_reset_instructions))
  end
end
