# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe FtpMultipartDownload::Downloader, type: :lib do
  describe '#download' do
    context 'gives correct configuration' do
      it 'download file' do
        connection = Net::FTP.new('localhost', username: 'user', password: 'password')

        Tempfile.create('rspec') do |temp|
          temp.write('abcdefghijklmnopqrstuvwxyz')
          temp.flush
          connection.putbinaryfile(temp.path, '/rspec')
        end

        Tempfile.create('rspec') do |temp|
          downloader = described_class.new('localhost', username: 'user', password: 'password')
          downloader.download(3, '/rspec', temp.path, FtpMultipartDownload::DEFAULT_BLOCKSIZE)
          temp.rewind
          expect(temp.read).to eq 'abcdefghijklmnopqrstuvwxyz'
        end

        connection.delete('/rspec')
      end
    end

    context 'gives insufficient configuration' do
      it 'raise ConnectionError' do
        downloader = described_class.new
        expect { downloader.download(3, '/rspec', 'dummy', FtpMultipartDownload::DEFAULT_BLOCKSIZE) }
          .to raise_error(FtpMultipartDownload::ConnectionError) do |e|
          expect(e.errors).to be_empty
        end
      end
    end

    context 'gives incorrect configuration' do
      it 'raise ConnectionError' do
        downloader = described_class.new('localhost', username: 'none')
        expect { downloader.download(3, '/rspec', 'dummy', FtpMultipartDownload::DEFAULT_BLOCKSIZE) }
          .to raise_error(FtpMultipartDownload::ConnectionError) do |e|
          expect(e.errors.count).to eq 3
        end
      end
    end
  end
end
