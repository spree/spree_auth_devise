module Spree
  class UserMailer < BaseMailer
    def reset_password_instructions(user, token, *args)
      @edit_password_reset_url = spree.edit_spree_user_password_url(:reset_password_token => token, :host => Spree::Store.current.url)

      mail to: user.email, from: from_address, subject: Spree::Store.current.name + ' ' + I18n.t(:subject, :scope => [:devise, :mailer, :reset_password_instructions])
    end



    def confirmation_instructions(user, token, opts={})
      @email = user.email
      @user = spree.confirm_url(confirmation_token: token)
      mail(:to => user.email, :from => "from@example.com" ,:subject => "Please confirm your mail")
    end
  end
end
