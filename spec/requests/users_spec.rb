require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end

  describe 'POST /signup' do
    context '회원가입 성공' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it '새 회원 작성' do
        expect(response).to have_http_status(201)
      end

      it '인증 토큰 반환' do
        expect(json['auth_token']).not_to be_nil
      end
    end


    context '가입정보 누락' do
      before { post '/signup', params: {} , headers: headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end

    context '이미 가입된 회원' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'status: 409' do
        expect(response).to have_http_status(409)
      end
    end
  end
end
