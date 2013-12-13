require 'spec_helper'

describe Spree::UserMailer do 

  before do
    ActionMailer::Base.default_url_options[:host] = "http://example.com"
    user = create(:user)
    Spree::UserMailer.reset_password_instructions(user, 'token goes here').deliver
    @message = ActionMailer::Base.deliveries.last
  end

  describe '#reset_password_instructions' do 
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

end
