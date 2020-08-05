require 'rails_helper'

RSpec.describe 'Taxi Dispatch API', type: :request do
  let!(:passenger_user) { create(:passenger_user) }
  let!(:driver_user) { create(:driver_user) }
  let!(:dispatches) { create_list(:dispatch, 10) }
  let(:id) { dispatches.first.id }
  let(:passenger_headers) { valid_headers(user_id: passenger_user.id) }
  let(:driver_headers) { valid_headers(user_id: driver_user.id) }
  let(:raw_passenger_headers) { raw_valid_headers(user_id: passenger_user.id) }
  let(:raw_driver_headers) { raw_valid_headers(user_id: driver_user.id) }

  # 배차 요청 목록 조회
  describe 'GET /dispatches' do

    context '목록조회 성공' do
      before { get '/dispatches', headers: passenger_headers }
      it 'returns dispatches' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context '인증정보가 유효하지 않음' do
      before { get '/dispatches', headers: {} }

      it 'status: 401' do
        expect(response).to have_http_status(401)
      end
    end

  end

  # 배차 요청
  describe 'POST /dispatches' do
    let(:valid_attributes) { { address: 'seoul korea', requested_at: '2020-07-28 11:55:00' } }

    context '배차 요청 성공' do
      before { post '/dispatches', params: valid_attributes, headers: raw_passenger_headers }

      it '배차 생성' do
          expect(json['address']).to eq('seoul korea')
      end

      it 'status: 201' do
        expect(response).to have_http_status(201)
      end
    end

    context '인증정보가 유효하지 않음' do
      before { post '/dispatches', params: valid_attributes, headers: {}  }

      it 'status: 401' do
        expect(response).to have_http_status(401)
      end
    end

    context '승객이 아닌 회원의 배차 요청' do
      before { post '/dispatches', params: valid_attributes, headers: raw_driver_headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end

    context '주소 값 없음' do
      before { post '/dispatches', params: { requested_at: '2020-07-28 11:55:00' }, headers: raw_passenger_headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end

    context '주소 값 100자 초과' do
      before { post '/dispatches', params: { address: Faker::Lorem.characters(101), requested_at: '2020-07-28 11:55:00' }, headers: raw_passenger_headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end

    context '요청 시간 값 없음' do
      before { post '/dispatches', params: { address: 'seoul korea' }, headers: raw_passenger_headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end
  end

  # 배차 수락
  describe 'PATCH /dispatches/:id' do
    let(:valid_attributes) { { accepted_at: '2020-07-28 11:55:00' } }

    context '배차 수락 성공' do
      before { patch "/dispatches/#{id}", params: valid_attributes, headers: raw_driver_headers  }

      it '배차 수락' do
        puts(response.body)
        expect(json['accepted_at']).not_to be_nil
    end

      it 'status: 200' do
        expect(response).to have_http_status(200)
      end
    end

    context '인증정보가 유효하지 않음' do
      before { patch "/dispatches/#{id}", params: valid_attributes, headers: {} }

      it 'status: 401' do
        expect(response).to have_http_status(401)
      end
    end

    context '기사가 아닌 회원의 배차 수락' do
      before { patch "/dispatches/#{id}", params: valid_attributes, headers: raw_passenger_headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end

    context '배차 수락 시간 값 없음' do
      before { patch "/dispatches/#{id}", params: {}, headers: raw_driver_headers }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end

    context '존재하지 않는 배차 요청' do
      before { patch "/dispatches/0", params: valid_attributes, headers: raw_driver_headers }

      it 'status: 404' do
        expect(response).to have_http_status(404)
      end
    end

    context '이미 배차 완료된 요청' do
      before { patch "/dispatches/#{id}", params: valid_attributes, headers: raw_driver_headers  }
      before { patch "/dispatches/#{id}", params: valid_attributes, headers: raw_driver_headers  }

      it 'status: 409' do
        expect(response).to have_http_status(409)
      end
    end
  end
end
