# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Steam::UpdateListService, type: :service do
  subject { described_class.call(limit: limit_per_request) }
  let(:limit_per_request) { 2 }
  let(:dobule_client) { double('Steam::Client') }
  let!(:steam_store) { create(:store, :steam) }

  before(:example) do
    allow(dobule_client).to receive(:app_list).and_return(first_response, second_response, third_response)
    allow(Steam::Client).to receive(:new).and_return(dobule_client)
  end

  def response(response_num, records_count = limit_per_request, more: true)
    init_id = (limit_per_request * response_num) + 1
    apps = Array.new(records_count) do |i|
      {
        appid: init_id + i,
        name: Faker::Lorem.characters(number: 5),
        last_modified: Time.now.to_i
      }
    end
    response = { apps: apps, last_appid: apps.last&.fetch(:appid), have_more_results: more }
    { response: response }
  end

  describe '#call' do
    let(:first_response) { response(0) }
    let(:second_response) { response(1) }
    let(:third_response) { response(2, 1, more: false) }
    let(:responses_to_calc) { %i[first_response second_response third_response] }
    let(:new_records_count) do
      responses_to_calc.sum do |var|
        public_send(var).dig(:response, :apps).length
      end
    end

    context 'when there are full 3 pages of games' do
      it 'makes 3 requests and creates all records' do
        aggregate_failures do
          response = nil
          expect(dobule_client).to receive(:app_list).exactly(3).times
          expect { response = subject }.to change(Game, :count).by(new_records_count)
          expect(response).to be_success
        end
      end
    end

    context 'when third response is empty and there is no signal' do
      let(:third_response) { response(2, 0, more: false) }
      let(:responses_to_calc) { %i[first_response second_response] }

      context 'and there is no last page signal' do
        it 'makes 3 requests and creates all records' do
          aggregate_failures do
            response = nil
            expect(dobule_client).to receive(:app_list).exactly(3).times
            expect { response = subject }.to change(Game, :count).by(new_records_count)
            expect(response).to be_success
          end
        end
      end

      context 'and there is no last page signal' do
        let(:second_response) { response(1, 1, more: false) }

        it 'makes 2 requests and creates all records' do
          aggregate_failures do
            response = nil
            expect(dobule_client).to receive(:app_list).exactly(2).times
            expect { response = subject }.to change(Game, :count).by(new_records_count)
            expect(response).to be_success
          end
        end
      end
    end
  end
end
