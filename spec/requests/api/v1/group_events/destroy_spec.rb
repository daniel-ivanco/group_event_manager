require 'rails_helper'
RSpec.describe 'POST /group_events/destroy/:id' do
  let!(:user) { create(:user) }
  let!(:group_event) { create(:group_event, user: user) }
  let!(:disabled_group_event) { create(:group_event, :disabled, user: user) }

  def destroy_group_event(id)
    delete("/api/v1/group_events/#{id}")
  end

  it 'deletes group event' do
    expect(GroupEvent.enabled.count).to eq(1)
    destroy_group_event(group_event.id)
    expect(response.status).to eq(200)
    expect(GroupEvent.enabled.count).to eq(0)
  end

  it "doesn't delete disabled group event" do
    expect(GroupEvent.enabled.count).to eq(1)
    expect{ destroy_group_event(disabled_group_event.id) }.to raise_exception(ActiveRecord::RecordNotFound)
    expect(GroupEvent.enabled.count).to eq(1)
  end
end
