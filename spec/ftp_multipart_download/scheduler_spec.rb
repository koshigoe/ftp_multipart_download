require 'spec_helper'
require 'tempfile'

RSpec.describe FtpMultipartDownload::Scheduler, type: :lib do
  describe '#schedule' do
    it 'download file' do
      pool = FtpMultipartDownload::ConnectionPool.new(3, '127.0.0.1', username: 'user', password: 'password')

      Tempfile.create('rspec') do |temp|
        temp.write('abcdefghijklmnopqrstuvwxyz')
        temp.flush
        pool.first.putbinaryfile(temp.path, '/rspec')
      end

      Tempfile.create('rspec') do |temp|
        described_class.new(pool).schedule('/rspec', temp.path, FtpMultipartDownload::DEFAULT_BLOCKSIZE)
        temp.rewind
        expect(temp.read).to eq 'abcdefghijklmnopqrstuvwxyz'
      end

      pool.first.delete('/rspec')
    end
  end
end
