# spec/auth/authorize_api_request_spec.rb
require 'rails_helper'

RSpec.describe Auth::AuthorizeService, type: :service do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  subject { described_class.new(header) }

  describe '#call' do
    context '인증 성공' do
      it '유저 반환' do
        result = subject.call
        expect(result[:user]).to eq(user)
      end
    end

    context '인증 실패' do
      context '토큰이 존재하지 않음' do
        let(:header) { {} }
        it 'raises a MissingToken error' do
          expect { subject.call }
              .to raise_error( ExceptionHandler::MissingToken )
        end
      end

      context '토큰이 무효함' do
        let(:header) { { 'Authorization' => token_generator(5) } }

        it 'raises an InvalidToken error' do
          expect { subject.call }
              .to raise_error( ExceptionHandler::InvalidToken )
        end
      end

      context '토큰이 만료됨' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect { subject.call }
              .to raise_error( ExceptionHandler::InvalidToken )
        end
      end

      context '무효한 토큰' do
        let(:header) { { 'Authorization' => 'foobar' } }

        it 'handles JWT::DecodeError' do
          expect { subject.call }
              .to raise_error( ExceptionHandler::InvalidToken )
        end
      end
    end
  end
end
