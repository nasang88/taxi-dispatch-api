require 'rails_helper'

RSpec.describe  'Authentication', type: :request do
  describe 'POST /auth/login' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_credentials) do
      {
          email: user.email,
          password: user.password,
          user_type: 'passenger'
      }.to_json
    end
    let(:invalid_credentials) do
      {
          email: Faker::Internet.email,
          password: Faker::Internet.password,
          user_type: 'passenger'
      }.to_json
    end

    context '로그인 성공' do
      before { post '/auth/login', params: valid_credentials, headers: headers }

      it 'status: 200' do
        expect(response).to have_http_status(200)
      end
    end

    context '로그인 실패' do
      before { post '/auth/login', params: invalid_credentials, headers: headers }

      it 'status: 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
