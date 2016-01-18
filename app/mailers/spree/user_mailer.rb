module Spree
  class UserMailer < BaseMailer
    def reset_password_instructions(user, token, *args)
      @edit_password_reset_url = spree.edit_spree_user_password_url(
        reset_password_token: token, host: Spree::Store.current.url)
      reset_password_template
    end

    def reset_admin_password_instructions(user, token, *args)
      @edit_password_reset_url = spree.admin_edit_password_url(
        reset_password_token: token, host: Spree::Store.current.url)
      reset_password_template
    end

    def confirmation_instructions(user, token, opts={})
      @confirmation_url = spree.spree_user_confirmation_url(:confirmation_token => token, :host => Spree::Store.current.url)

      mail to: user.email, from: from_address, subject: Spree::Store.current.name + ' ' + I18n.t(:subject, :scope => [:devise, :mailer, :confirmation_instructions])
    end

    protected

    def reset_password_template
      mail(to: user.email,
           from: from_address,
           subject: "#{Spree::Store.current.name}
                     #{I18n.t(:subject, scope: [:devise,
                                                :mailer,
                                                :reset_password_instructions
                                               ])}",
           template_name: 'reset_password_template'
          )
    end
  end
end
