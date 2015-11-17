require 'spec_helper'

describe HealthMonitor::Providers::Redis do
  IP = '0.0.0.0'
  let(:request) { Sinatra::Request.new(nil) }
  let(:redis_url) { 'redis://localhost:6379/0' }

  let(:key) { "health:#{IP}" }
  let(:time) {Time.local(1990) }

  let(:settings) { double('settings') }
  subject { described_class.new(request: request, settings: settings) }

  before do
    allow(settings).to receive(:redis_url).and_return(redis_url)
    allow(request).to receive(:ip).and_return IP
    allow(Time).to receive(:now).and_return(time)
    allow_any_instance_of(Redis).to receive(:set).with(key, time.to_s(:db))
    allow_any_instance_of(Redis).to receive(:get).with(key).and_return(time.to_s(:db))
    client = double('client')
    allow_any_instance_of(Redis).to receive(:client).and_return(client)
    allow(client).to receive(:disconnect)
  end

  describe '#provider_name' do
    it { expect(described_class.provider_name).to eq('redis') }
  end

  describe '#check!' do
    it 'succesfully checks' do
      expect {
        subject.check!
      }.not_to raise_error
    end

    context 'failing' do
      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(false)
      end

      it 'fails check!' do
        expect {
          subject.check!
        }.to raise_error(HealthMonitor::Providers::RedisException)
      end
    end
  end

  describe '#key' do
    it { expect(subject.send(:key)).to eq(key) }
  end
end