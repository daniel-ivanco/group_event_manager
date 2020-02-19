require 'rails_helper'
RSpec.describe ::GroupEvents::Creator do
  let!(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let(:params) do
    ActiveSupport::HashWithIndifferentAccess.new(
      start_date: Date.today,
      end_date: Date.tomorrow,
      duration: 1,
      name: 'test 1',
      description:  'test desc 1',
      published: false,
      latitude: 50.08804,
      longitude: 14.42076,
      user_id: user_2.id,
    )
  end

  let(:creator) do
    described_class.new(params)
  end

  it 'should return true' do
    expect(creator.call).to be_truthy
  end

  it 'calls ::GroupEvents::ParamsNormalisator usecase' do
    expect_any_instance_of(::GroupEvents::ParamsNormalisator).to receive(:call).and_return(params)
    creator.call
  end

  it 'should create active record model' do
    creator.call
    expect(GroupEvent.count).to eq(1)
    expect(GroupEvent.first.attributes.except('id', 'created_at', 'updated_at', 'enabled')).to eq(params)
  end
end
