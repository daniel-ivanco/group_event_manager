require 'rails_helper'
RSpec.describe 'GET /group_events/:id' do
  def fetch_group_event(id)
    get("/api/v1/group_events/#{id}")
  end

  def json
    @json = JSON.parse(response.body)
  end

  let!(:user) { create(:user) }
  let!(:group_event_1) { create(:group_event, user: user) }
  let!(:disabled_group_event) { create(:group_event, :disabled, user: user) }

  it 'returns enabled - not deleted - group event' do
    fetch_group_event(group_event_1.id)
    expect(response.status).to eq(200)
    expect(json.dig('data').to_json).to eq(group_event_1.to_json)
  end

  it "doesn't return disabled group event" do
    expect{ fetch_group_event(disabled_group_event.id) }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end
