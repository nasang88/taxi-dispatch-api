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

    context '유효한 로그인' do
      before { post '/auth/login', params: valid_credentials, headers: headers }

      it 'status: 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
