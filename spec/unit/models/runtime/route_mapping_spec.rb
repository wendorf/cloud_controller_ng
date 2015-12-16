require 'spec_helper'

module VCAP::CloudController
  describe VCAP::CloudController::RouteMapping, type: :model do
    let(:mapping) { RouteMapping.new }
    it { is_expected.to have_timestamp_columns }

    describe 'Associations' do
      it { is_expected.to have_associated :app }
      it { is_expected.to have_associated :route }
    end

    describe 'Validations' do

    end
  end
end
