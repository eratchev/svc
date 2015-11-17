require 'spec_helper'

describe HealthMonitor::Providers::Sidekiq do

  let(:request) { Sinatra::Request.new(nil) }
  subject { described_class.new(request: request, settings: nil) }

  before do
    redis_conn = proc { Redis.new }

    Sidekiq.configure_client do |config|
      config.redis = ConnectionPool.new(&redis_conn)
    end

    Sidekiq.configure_server do |config|
      config.redis = ConnectionPool.new(&redis_conn)
    end
  end

  describe '#provider_name' do
    it { expect(described_class.provider_name).to eq('sidekiq') }
  end

  describe '#check!' do

    context 'success' do
      before do
        workers = double('workers')
        allow(::Sidekiq::Workers).to receive(:new).and_return(workers)
        allow(workers).to receive(:size).and_return(1)

        latency = double('workers')
        allow(::Sidekiq::Queue).to receive(:new).and_return(latency)
        allow(latency).to receive(:latency).and_return(10)

        allow(Sidekiq).to receive(:redis)
      end

      it 'succesfully checks' do
        expect {
          subject.check!
        }.not_to raise_error
      end

    end

    context 'failing' do
      context 'workers' do
        before do
          allow_any_instance_of(Sidekiq::Workers).to receive(:size).and_raise(Exception)
        end

        it 'fails check!' do
          expect {
            subject.check!
          }.to raise_error(HealthMonitor::Providers::SidekiqException)
        end
      end

      context 'latency' do
        before do
          allow_any_instance_of(Sidekiq::Queue).to receive(:latency).and_return(Float::INFINITY)
        end

        it 'fails check!' do
          expect {
            subject.check!
          }.to raise_error(HealthMonitor::Providers::SidekiqException)
        end
      end

      context 'redis' do
        before do
          allow(Sidekiq).to receive(:redis).and_raise(Redis::CannotConnectError)
        end

        it 'fails check!' do
          expect {
            subject.check!
          }.to raise_error(HealthMonitor::Providers::SidekiqException)
        end
      end
    end
  end

end