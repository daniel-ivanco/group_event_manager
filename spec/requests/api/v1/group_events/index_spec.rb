require 'rails_helper'
RSpec.describe 'GET /group_events' do
  def fetch_group_events
    get('/api/v1/group_events')
  end

  def json
    @json = JSON.parse(response.body)
  end

  let!(:user) { create(:user) }
  let!(:group_event_1) { create(:group_event, user: user) }
  let!(:group_event_2) { create(:group_event, :next_day, user: user) }
  let!(:group_event_3) { create(:group_event, :disabled, user: user) }

  it 'returns enabled group events' do
    fetch_group_events
    expect(response.status).to eq(200)
    expect(json.dig('data').count).to eq(2)
    expect(json.dig('data').first.to_json).to eq(group_event_2.to_json)
    expect(json.dig('data').second.to_json).to eq(group_event_1.to_json)
  end
end
