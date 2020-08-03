require 'rails_helper'

RSpec.describe 'Taxi Dispatch API', type: :request do
  let!(:dispatches) { create_list(:todo, 10) }
  let(:id) { dispatches.first.id }

  # 배차 요청 목록 조회
  describe 'GET /dispatches' do
    before { get '/dispatches' }

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
    let(:valid_attributes) {{ address: 'seoul korea', passerger_id: 1, requested_at: '2020-07-28 11:55:00' }}

    context '배차 요청 성공' do
      before { post '/dispatches', param: valid_attributes }

      it '배차 생성' do
        expect(json['address']).to eq('seoul korea')
      end

      it 'status: 201' do
        expect(response).to have_http_status(201)
      end
    end

    context '주소 값 없음' do
      before { post '/dispatches', param: { passerger_id: 1, requested_at: '2020-07-28 11:55:00' } }

      it 'status: 400' do
        expect(response).to have_http_status(400)
    end
  end

  context '주소 값 100자 초과' do
    before { post '/dispatches', param: { address: 'AAAAAAAAAABBBBBBBBBBCCCCCCCCCCAAAAAAAAAABBBBBBBBBBCCCCCCCCCCAAAAAAAAAABBBBBBBBBBCCCCCCCCCCAAAAAAAAAAB', passerger_id: 1, requested_at: '2020-07-28 11:55:00' } }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end

    context '요청 시간 값 없음' do
      before { post '/dispatches', param: { address: 'seoul korea', passerger_id: 1 } }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end
  end

  # 배차 수락
  describe 'PATCH /dispatches' do
    let(:valid_attributes) {{ accepted_at: '2020-07-28 12:40:00' }}

    context '배차 수락 성공' do
      before {  patch '/dispatches', param: valid_attributes }

      it '배차 수락' do
        expect(json['accepted_at']).not_to nil
      end

      it 'status: 200' do
        expect(response).to have_http_status(200)
      end
    end

    context '배차 수락 시간 값 없음' do
      before { patch '/dispatches', param: {} }

      it 'status: 400' do
        expect(response).to have_http_status(400)
      end
    end
  end

end

