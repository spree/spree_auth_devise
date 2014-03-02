require 'spec_helper'

describe Spree::UserMailer do
  let(:user) { create(:user) }

  before do
    ActionMailer::Base.default_url_options[:host] = 'http://example.com'
    user = create(:user)
    Spree::UserMailer.reset_password_instructions(user, 'token goes here').deliver
    @message = ActionMailer::Base.deliveries.last
  end

  describe '#reset_password_instructions' do
    describe 'message contents' do
      before do
        Spree::UserMailer.reset_password_instructions(user, 'token goes here').deliver
        @message = ActionMailer::Base.deliveries.last
      end

      context 'subject includes' do
        it 'translated devise instructions' do
          expect(@message.subject).to include(
            I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])
          )
        end

        it 'Spree site name' do
          expect(@message.subject).to include Spree::Config[:site_name]
        end
      end

      context 'body includes' do
        it 'password reset url' do
          expect(@message.body.raw_source).to include 'http://example.com/user/spree_user/password/edit'
        end
      end
    end

    describe 'legacy support for User object' do
      it 'send an email' do
        expect {
          Spree::UserMailer.reset_password_instructions(user, 'token goes here').deliver
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end
    end
  end
end
