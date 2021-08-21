module Spree
  class UserMailer < defined?(Spree::BaseMailer) ? Spree::BaseMailer : ActionMailer::Base
    def reset_password_instructions(user, token, *_args)
      current_store_id = _args.inject(:merge)[:current_store_id]
      @current_store = Spree::Store.find(current_store_id) || Spree::Store.current
      @locale = @current_store.has_attribute?(:default_locale) ? @current_store.default_locale : I18n.default_locale
      I18n.locale = @locale if @locale.present?
      @edit_password_reset_url = spree.edit_spree_user_password_url(reset_password_token: token, host: @current_store.url)
      @user = user

      mail to: user.email, from: @current_store.mail_from_address, subject: @current_store.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions]), store_url: @current_store.url
    end

    def confirmation_instructions(user, token, _opts = {})
      current_store_id = _opts[:current_store_id]
      @current_store = Spree::Store.find(current_store_id) || Spree::Store.current
      @confirmation_url = spree.confirmation_url(confirmation_token: token, host: Spree::Store.current.url)
      @email = user.email

      mail to: user.email, from: @current_store.mail_from_address, subject: @current_store.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :confirmation_instructions]), store_url: @current_store.url
    end
  end
end
