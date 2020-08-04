# spec/auth/authorize_api_request_spec.rb
require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  # Create test user
  let(:user) { create(:user) }
  # Mock `Authorization` header
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  # Invalid request subject
  subject(:invalid_request_obj) { described_class.new({}) }
  # Valid request subject
  subject(:request_obj) { described_class.new(header) }


  describe '#call' do
    context '인증 성공' do
      it '유저 반환' do
        result = request_obj.call
        expect(result[:user]).to eq(user)
      end
    end

    context '인증 실패' do
      context '토큰이 존재하지 않음' do
        it 'raises a MissingToken error' do
          expect { invalid_request_obj.call }
              .to raise_error( ExceptionHandler::MissingToken )
        end
      end

      context '토큰이 무효함' do
        subject(:invalid_request_obj) do
          described_class.new('Authorization' => token_generator(5))
        end

        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }
              .to raise_error( ExceptionHandler::InvalidToken )
        end
      end

      context '토큰이 만료됨' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request_obj) { described_class.new(header) }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect { request_obj.call }
              .to raise_error( ExceptionHandler::InvalidToken )
        end
      end

      context '무효한 토큰' do
        let(:header) { { 'Authorization' => 'foobar' } }
        subject(:invalid_request_obj) { described_class.new(header) }

        it 'handles JWT::DecodeError' do
          expect { invalid_request_obj.call }
              .to raise_error( ExceptionHandler::InvalidToken )
        end
      end
    end
  end
end
