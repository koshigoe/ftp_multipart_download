require 'spec_helper'

RSpec.describe FtpMultipartDownload::ConnectionPool, type: :lib do
  describe '#initialize' do
    context 'gives correct configuration' do
      it 'establish all connections' do
        pool = FtpMultipartDownload::ConnectionPool.new(
          3,
          'localhost',
          port: 21,
          username: 'user',
          password: 'password',
        )
        aggregate_failures do
          expect(pool.count).to eq 3
          expect(pool).to all(be_a(Net::FTP).and satisfy { |c| !c.closed? })
          expect(pool.errors).to be_empty
        end
      end
    end

    context 'gives insufficient configuration' do
      it 'does not establish any connections' do
        pool = FtpMultipartDownload::ConnectionPool.new(3)
        aggregate_failures do
          expect(pool.count).to eq 0
          expect(pool.errors.count).to eq 0
        end
      end
    end

    context 'gives incorrect configuration' do
      it 'does not establish any connections' do
        pool = FtpMultipartDownload::ConnectionPool.new(3, 'localhost', username: 'none')
        aggregate_failures do
          expect(pool.count).to eq 0
          expect(pool.errors.count).to eq 3
        end
      end
    end
  end

  describe '#each' do
    it 'enumerate pooling connections' do
      pool = FtpMultipartDownload::ConnectionPool.new(3, 'localhost', username: 'user', password: 'password')
      expect { |b| pool.each(&b) }.to yield_control.exactly(3).times
    end
  end
end
