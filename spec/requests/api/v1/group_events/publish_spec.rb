require 'rails_helper'

RSpec.describe 'PUT /group_events/:id/publish' do
  let!(:user) { create(:user) }
  let!(:group_event) { create(:group_event, user: user) }
  let!(:incomplete_group_event) { create(:group_event, user: user, latitude: nil) }
  let!(:disabled_group_event) { create(:group_event, :disabled, user: user) }


  def publish_group_event(id)
    put("/api/v1/group_events/#{id}/publish")
  end

  it 'publishes group event' do
    expect(group_event.published).to eq(false)
    publish_group_event(group_event.id)
    expect(response.status).to eq(200)
    expect(GroupEvent.find(group_event.id).published).to eq(true)
  end

  it "doesn't publish incomplete group event" do
    expect(incomplete_group_event.published).to eq(false)
    publish_group_event(incomplete_group_event.id)
    expect(response.status).to eq(422)
    expect(GroupEvent.find(incomplete_group_event.id).published).to eq(false)
  end

  it "doesn't publish disabled group event" do
    expect(disabled_group_event.published).to eq(false)
    expect{ publish_group_event(disabled_group_event.id) }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end
