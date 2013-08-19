require 'spec_helper'

describe Spree::UserMailer do
  let(:user) { create(:user) }

  before do 
    ActionMailer::Base.default_url_options[:host] = "http://example.com"
  end

  describe '#reset_password_instructions' do
    describe 'message contents' do
      before do
        Spree::UserMailer.reset_password_instructions(user.id).deliver
        @message = ActionMailer::Base.deliveries.last
      end

      context 'subject includes' do
        it 'translated devise instructions' do 
          @message.subject.should include(
            I18n.t(:subject, :scope => [:devise, :mailer, :reset_password_instructions])
          )
        end

        it 'Spree site name' do 
          @message.subject.should include(Spree::Config[:site_name])
        end
      end

      context 'body includes' do
        it 'password reset url' do
          @message.body.raw_source.should include('http://example.com/user/spree_user/password/edit')
        end
      end
    end

    describe 'legacy support for User object' do
      it 'should send an email' do
        lambda {
          Spree::UserMailer.reset_password_instructions(user).deliver
        }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end
    end
  end

end
