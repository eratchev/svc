require 'spec_helper'

describe HealthMonitor do
  let(:time) { Time.local(1990) }

  before do
    Timecop.freeze(time)
  end

  after do
    Timecop.return
  end

  describe '#check' do
    context 'default providers' do
      it 'succesfully checks' do
        expect(subject.check).to eq(
                                                       :results => [
                                                           'database' => {
                                                               message: '',
                                                               status: 'OK',
                                                               timestamp: time.to_s(:db)
                                                           }
                                                       ],
                                                       :status => :ok
                                                   )
      end
    end

    context 'with error' do

      before do
        allow(ActiveRecord::Migrator).to receive(:current_version).and_raise(Exception)
      end

      it 'calls error_callback' do
        expect(subject.check).to eq(
                                                       :results => [
                                                           {
                                                               'database' => {
                                                                   message: 'Exception',
                                                                   status: 'ERROR',
                                                                   timestamp: time.to_s(:db)
                                                               }
                                                           }
                                                       ],
                                                       :status => :service_unavailable
                                                   )

      end
    end
  end
end