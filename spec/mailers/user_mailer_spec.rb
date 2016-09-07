RSpec.describe Spree::UserMailer, type: :mailer do

  let!(:store) { create(:store) }
  let(:user) { create(:user) }

  describe '#reset_password_instructions' do
    describe 'message contents' do
      before do
        @message = described_class.reset_password_instructions(user, 'token goes here')
      end

      context 'subject includes' do
        it 'translated devise instructions' do
          expect(@message.subject).to include(
            I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])
          )
        end

        it 'Spree site name' do
          expect(@message.subject).to include store.name
        end
      end

      context 'body includes' do
        it 'password reset url' do
          expect(@message.body.raw_source).to include "http://#{store.url}/user/spree_user/password/edit"
        end
      end
    end

    describe 'legacy support for User object' do
      it 'sends an email' do
        expect {
          described_class.reset_password_instructions(user, 'token goes here').deliver_now
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end
    end
  end
end
