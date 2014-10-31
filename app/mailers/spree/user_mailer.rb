module Spree
  class UserMailer < BaseMailer
    def reset_password_instructions(user, token, *args)
         @token = token
      @resource = user
      @edit_password_reset_url = spree.edit_spree_user_password_url(reset_password_token: token, host: Spree::Store.current.url)
      @host = Spree::Store.current.url
      mail to: user.email, from: from_address, subject: Spree::Store.current.name + ' ' + I18n.t(:subject, :scope => [:devise, :mailer, :reset_password_instructions])
    end
    
   def confirmation_instructions(user, token, *args)
      @token_confirm = token
     
      @resource = user
      @host = Spree::Store.current.url
      @user_confirmation_url=spree.confirmation_url(:user_confirmation => token, :host => Spree::Store.current.url)
      mail to: user.email, from: from_address, subject: Spree::Store.current.name + ' ' + I18n.t(:subject, :scope => [:devise, :mailer, :confirmation_instructions])
    end
    
   def unlock_instructions(user, token, opts={})
      @token = token
      @resource = user
      @host = Spree::Store.current.url
      mail to: user.email, from: from_address, 
        subject: "#{Spree::Store.current.name} #{I18n.t(:subject, scope: [:devise, :mailer, :unlock_instructions])}"
    end 
  end
end
