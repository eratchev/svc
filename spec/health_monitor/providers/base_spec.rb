require 'spec_helper'

describe HealthMonitor::Providers::Base do

  describe '#provider_name' do
    it { expect(described_class.provider_name).to eq('base') }
  end

  describe '#check!' do
    it 'abstract' do
      expect {
        subject.check!
      }.to raise_error(NotImplementedError)
    end
  end

end
