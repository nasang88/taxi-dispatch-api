require 'rails_helper'

RSpec.describe 'Taxi Dispatch API', type: :request do
  let!(:user) { create(:user) }
  let!(:dispatches) { create_list(:dispatch, 10) }
  let(:id) { dispatches.first.id }
  let(:headers) { valid_headers }

  # 배차 요청 목록 조회
  describe 'GET /dispatches' do
    before { get '/dispatches', headers: headers }

    it 'returns dispatches' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

  end

  # 배차 요청
  describe 'POST /dispatches' do
    let(:headers) { raw_valid_headers }
    let(:valid_attributes) { { address: 'seoul korea', requested_at: '2020-07-28 11:55:00' } }

    context '배차 요청 성공' do
      before { post '/dispatches', params: valid_attributes, headers: headers  }

      it '배차 생성' do
          expect(json['address']).to eq('seoul korea')
      end

      it 'status: 201' do
        expect(response).to have_http_status(201)
      end
    end

    context '주소 값 없음' do
      before { post '/dispatches', params: { requested_at: '2020-07-28 11:55:00' }, headers: headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end

  context '주소 값 100자 초과' do
    before { post '/dispatches', params: { address: Faker::Lorem.characters(101), requested_at: '2020-07-28 11:55:00' }, headers: headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end

    context '요청 시간 값 없음' do
      before { post '/dispatches', params: { address: 'seoul korea' }, headers: headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end
  end

  # 배차 수락
  describe 'PATCH /dispatches/:id' do
    let(:headers) { raw_valid_headers }
    let(:valid_attributes) { { accepted_at: '2020-07-28 11:55:00' } }

    context '배차 수락 성공' do
      before { patch "/dispatches/#{id}", params: valid_attributes, headers: headers  }

      it '배차 수락' do
        puts(response.body)
        expect(json['accepted_at']).not_to be_nil
    end

      it 'status: 200' do
        expect(response).to have_http_status(200)
      end
    end

    context '배차 수락 시간 값 없음' do
      before { patch "/dispatches/#{id}", params: {}, headers: headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end

    context '이미 배차 완료된 요청' do
      before { patch "/dispatches/#{id}", params: valid_attributes, headers: headers  }
      before { patch "/dispatches/#{id}", params: valid_attributes, headers: headers  }

      it 'status: 409' do
        expect(response).to have_http_status(409)
      end
    end
  end
end
