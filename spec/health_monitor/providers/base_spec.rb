require 'spec_helper'

describe HealthMonitor::Providers::Base do
  let(:request) { Sinatra::Request.new(nil) }

  def app
    Sinatra::Application
  end

  subject { described_class.new(request: request) }

  describe '#initialize' do
    it 'sets the request' do
      expect(described_class.new(request: request).request).to eq(request)
    end
  end

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
