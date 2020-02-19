require 'rails_helper'
RSpec.describe ::GroupEvents::Updator do
  let!(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let!(:group_event) { create(:group_event, user: user) }
  let(:params) do
    ActiveSupport::HashWithIndifferentAccess.new(
      start_date: Date.today + 2.days,
      end_date: Date.today + 5.days,
      duration: 3,
      name: 'test 2',
      description:  'test desc 2',
      published: false,
      latitude: 51.08804,
      longitude: 15.42076,
      user_id: user_2.id,
    )
  end

  let(:updator) do
    described_class.new(group_event, params)
  end

  it 'should return true' do
    expect(updator.call).to be_truthy
  end

  it 'calls ::GroupEvents::ParamsNormalisator usecase' do
    expect_any_instance_of(::GroupEvents::ParamsNormalisator).to receive(:call).and_return(params)
    updator.call
  end

  it 'should update active record model' do
    updator.call
    expect(GroupEvent.count).to eq(1)
    expect(GroupEvent.first.attributes.except('id', 'created_at', 'updated_at', 'enabled')).to eq(params)
  end
end
