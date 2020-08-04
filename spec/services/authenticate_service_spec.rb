require 'rails_helper'

RSpec.describe Auth::AuthenticateService, type: :service do
  let(:user) { create(:user) }
  let(:email) { user.email }
  let(:password) { user.password }
  subject {described_class.new(email, password)}

  describe '#call' do
    context '유효한 인증인 경우' do
      it '토큰 반환' do
        token = subject.call
        expect(token).not_to be_nil
      end
    end

    context '무효한 인증인 경우' do
      let(:email) { 'foobar' }

      it 'raises an authentication error' do
        expect { subject.call }
            .to raise_error( ExceptionHandler::AuthenticationError )
      end
    end
  end
end
