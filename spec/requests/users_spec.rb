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

      it '가입 회원정보 반환' do
        expect(json['email']).to eq(user.email)
        expect(json['user_type']).to eq(user.user)
        expect(json['auth_token']).not_to be_nil
      end
    end
  end
end
