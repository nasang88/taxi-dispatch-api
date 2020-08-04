require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { create(:user) }
  subject(:valid_auth_obj) { described_class.new(user.email, user.password) }
  subject(:invalid_auth_obj) { described_class.new('foo', 'bar') }

  describe '#call' do
    context '유효한 인증인 경우' do
      it '토큰 반환' do
        token = valid_auth_obj.funcall
        expect(token).not_to be_nil
      end
    end

    context '무효한 인증인 경우' do
      it 'raises an authentication error' do
        expect { invalid_auth_obj.call }
            .to raise_error( ExceptionHandler::AuthenticationError )
      end
    end
  end
end
