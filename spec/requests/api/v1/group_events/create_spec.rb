require 'rails_helper'
RSpec.describe 'POST /group_events' do
  let!(:user) { create(:user) }
  let(:basic_params) do
    ActiveSupport::HashWithIndifferentAccess.new(
      name: 'test 1',
      description:  'test desc 1',
      published: false,
      latitude: 50.08804,
      longitude: 14.42076,
    )
  end
  let(:event_params_without_user) do
    basic_params.merge({
      start_date: Date.today,
      end_date: Date.tomorrow,
      duration: 1,
    })
  end
  let(:event_params) do
    event_params_without_user.merge(user_id: user.id)
  end
  let(:event_params_missing_duration) do
    basic_params.merge({
      start_date: Date.today,
      end_date: Date.tomorrow,
      user_id: user.id,
    })
  end
  let(:event_params_missing_start_date) do
    basic_params.merge({
      end_date: Date.tomorrow,
      duration: 1,
      user_id: user.id,
    })
  end
  let(:event_params_missing_end_date) do
    basic_params.merge({
      start_date: Date.today,
      duration: 1,
      user_id: user.id,
    })
  end

  def create_group_event(params)
    post('/api/v1/group_events',
      params: params
    )
  end

  it 'calls ::GroupEvents::Creator usecase' do
    expect_any_instance_of(::GroupEvents::Creator).to receive(:call)
    create_group_event(event_params)
  end

  it 'creates new group event' do
    create_group_event(event_params)
    expect(response.status).to eq(200)
    expect(GroupEvent.count).to eq(1)
    expect(GroupEvent.first.attributes.except('id', 'created_at', 'updated_at', 'enabled')).to eq(event_params)
  end

  it "doesn't create event when missing required user id" do
    create_group_event(event_params_without_user)
    expect(response.status).to eq(422)
  end

  it 'creates group event with calculated missing duration' do
    create_group_event(event_params_missing_duration)
    expect(response.status).to eq(200)
    expect(GroupEvent.count).to eq(1)
    expect(GroupEvent.first.attributes.except('id', 'created_at', 'updated_at', 'enabled')).to eq(event_params_missing_duration.merge(duration: 1))
  end

  it 'creates group event with calculated missing start_date' do
    create_group_event(event_params_missing_start_date)
    expect(response.status).to eq(200)
    expect(GroupEvent.count).to eq(1)
    expect(GroupEvent.first.attributes.except('id', 'created_at', 'updated_at', 'enabled')).to eq(event_params_missing_start_date.merge(start_date: Date.today))
  end

  it 'creates group event with calculated missing end_date' do
    create_group_event(event_params_missing_end_date)
    expect(response.status).to eq(200)
    expect(GroupEvent.count).to eq(1)
    expect(GroupEvent.first.attributes.except('id', 'created_at', 'updated_at', 'enabled')).to eq(event_params_missing_end_date.merge(end_date: Date.tomorrow))
  end
end
