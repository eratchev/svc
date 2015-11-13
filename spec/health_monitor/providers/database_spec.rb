require 'spec_helper'

describe HealthMonitor::Providers::Database do
  # subject { described_class.new(request: ActionController::TestRequest.new) }

  describe '#provider_name' do
    it { expect(described_class.provider_name).to eq('database') }
  end

  describe '#check!' do
    it 'succesfully checks' do
      expect {
        subject.check!
      }.not_to raise_error
    end

    context 'failing' do
      before do
        allow(ActiveRecord::Migrator).to receive(:current_version).and_raise(Exception)
      end

      it 'fails check!' do
        expect {
          subject.check!
        }.to raise_error(HealthMonitor::Providers::DatabaseException)
      end
    end
  end

end