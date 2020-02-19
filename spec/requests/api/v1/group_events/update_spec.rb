require 'rails_helper'
RSpec.describe 'PUT /group_events/:id' do
  let!(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let!(:group_event) { create(:group_event, user: user) }
  let!(:disabled_group_event) { create(:group_event, :disabled, user: user) }

  let(:basic_params) do
    ActiveSupport::HashWithIndifferentAccess.new(
      name: 'test 5',
      description:  'test desc 5',
      latitude: 51.08804,
      longitude: 15.42076,
      user_id: user_2.id,
    )
  end
  let(:event_params) do
    basic_params.merge({
      start_date: Date.today + 2.days,
      end_date: Date.today + 4.days,
      duration: 2,
    })
  end
  let(:event_params_missing_duration) do
    basic_params.merge({
      start_date: Date.today + 2.days,
      end_date: Date.today + 4.days,
    })
  end
  let(:event_params_missing_start_date) do
    basic_params.merge({
      end_date: Date.today + 4.days,
      duration: 2,
    })
  end
  let(:event_params_missing_end_date) do
    basic_params.merge({
      start_date: Date.today + 2.days,
      duration: 2,
    })
  end


  def update_group_event(id, params)
    put("/api/v1/group_events/#{id}",
      params: params
    )
  end

  it 'calls ::GroupEvents::Updator usecase' do
    expect_any_instance_of(::GroupEvents::Updator).to receive(:call)
    update_group_event(group_event.id, event_params)
  end

  it 'updates group event' do
    update_group_event(group_event.id, event_params)
    expect(response.status).to eq(200)
    expect(GroupEvent.find(group_event.id).attributes.except('id', 'created_at', 'updated_at', 'enabled', 'published')).to eq(event_params)
  end

  it "doesn't update disabled group event" do
    expect{ update_group_event(disabled_group_event.id, event_params) }.to raise_exception(ActiveRecord::RecordNotFound)
  end

  it 'updates group event with calculated missing duration' do
    update_group_event(group_event.id, event_params_missing_duration)
    expect(response.status).to eq(200)
    expect(GroupEvent.find(group_event.id)
      .attributes
      .except('id', 'created_at', 'updated_at', 'enabled', 'published'))
      .to eq(event_params_missing_duration.merge(duration: 2))
  end

  it 'updates group event with calculated missing start_date' do
    update_group_event(group_event.id, event_params_missing_start_date)
    expect(response.status).to eq(200)
    expect(GroupEvent.find(group_event.id)
      .attributes
      .except('id', 'created_at', 'updated_at', 'enabled', 'published'))
      .to eq(event_params_missing_start_date.merge(start_date: Date.today + 2.days))
  end

  it 'updates group event with calculated missing end_date' do
    update_group_event(group_event.id, event_params_missing_end_date)
    expect(response.status).to eq(200)
    expect(GroupEvent.find(group_event.id)
      .attributes
      .except('id', 'created_at', 'updated_at', 'enabled', 'published'))
      .to eq(event_params_missing_end_date.merge(end_date: Date.today + 4.days))
  end
end
