require 'rails_helper'
RSpec.describe ::GroupEvents::ParamsNormalisator do
  let!(:user) { create(:user) }
  let(:basic_params) do
    ActiveSupport::HashWithIndifferentAccess.new(
      name: 'test 1',
      description:  'test desc 1',
      published: false,
      latitude: 50.08804,
      longitude: 14.42076,
      user_id: user.id,
    )
  end
  let(:duration) { 5 }


  context 'when provided with params missing duration' do
    let(:params) do
      basic_params.merge({start_date: Date.today, end_date: Date.today + duration.days})
    end

    let(:normalisator) do
      described_class.new(params)
    end

    it 'should return params with calculated duration' do
      expect(normalisator.call).to eq(params.merge(duration: duration))
    end
  end

  context 'when provided with params missing start_date' do
    let(:params) do
      basic_params.merge({duration: duration, end_date: Date.today + duration.days})
    end

    let(:normalisator) do
      described_class.new(params)
    end

    it 'should return params with calculated start_date' do
      expect(normalisator.call).to eq(params.merge(start_date: params[:end_date] - duration.days))
    end
  end

  context 'when provided with params missing end_date' do
    let(:params) do
      basic_params.merge({duration: duration, start_date: Date.today})
    end

    let(:normalisator) do
      described_class.new(params)
    end

    it 'should return params with calculated end_date' do
      expect(normalisator.call).to eq(params.merge(end_date: params[:start_date] + duration.days))
    end
  end

  context 'when provided with params missing more than 1 time field' do
    let(:params) do
      basic_params.merge({end_date: Date.today})
    end

    let(:normalisator) do
      described_class.new(params)
    end

    it 'should return unchanged params' do
      expect(normalisator.call).to eq(params)
    end
  end
end
