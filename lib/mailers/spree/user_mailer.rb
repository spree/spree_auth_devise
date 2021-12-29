module Spree
  class UserMailer < BaseMailer
    def reset_password_instructions(user, token, opts = {})
      @current_store = current_store(opts)
      @edit_password_reset_url = edit_password_url(token, @current_store)
      @user = user

      mail to: user.email, from: from_address, reply_to: reply_to_address,
           subject: @current_store.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions]),
           store_url: @current_store.url
    end

    def confirmation_instructions(user, token, opts = {})
      @current_store = current_store(opts)
      @confirmation_url = spree.confirmation_url(confirmation_token: token, host: @current_store.url)
      @email = user.email

      mail to: user.email, from: from_address, reply_to: reply_to_address,
           subject: @current_store.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :confirmation_instructions]),
           store_url: @current_store.url
    end

    protected

    def edit_password_url(token, store)
      if frontend_available?
        spree.edit_password_url(reset_password_token: token, host: store.url)
      else
        spree.admin_edit_password_url(reset_password_token: token, host: store.url)
      end
    end

    def current_store(opts = {})
      @current_store = Spree::Store.find_by(id: opts[:current_store_id]) || Spree::Store.default
    end
  end
end
