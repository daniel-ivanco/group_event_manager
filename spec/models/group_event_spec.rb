require 'rails_helper'
RSpec.describe GroupEvent do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    context 'validates presence of all attributes when is published' do
      before { allow(subject).to receive(:published?).and_return(true) }
      it { is_expected.to validate_presence_of(:start_date) }
      it { is_expected.to validate_presence_of(:end_date) }
      it { is_expected.to validate_presence_of(:duration) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:enabled) }
      it { is_expected.to validate_presence_of(:latitude) }
      it { is_expected.to validate_presence_of(:longitude) }
    end
  end
end

