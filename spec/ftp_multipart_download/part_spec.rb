# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe FtpMultipartDownload::Part, type: :lib do
  describe '#download' do
    it 'download part of file' do
      connection = Net::FTP.new('127.0.0.1', username: 'user', password: 'password')

      Tempfile.create('rspec') do |temp|
        temp.write('abcdefghijklmnopqrstuvwxyz')
        temp.flush
        connection.putbinaryfile(temp.path, '/rspec')
      end

      Tempfile.create('rspec') do |temp|
        described_class.new(connection).download('/rspec', temp.path, FtpMultipartDownload::DEFAULT_BLOCKSIZE, 5, 3)
        temp.rewind
        expect(temp.read).to eq 'fgh'
      end

      expect(connection.resume).to eq false

      connection.delete('/rspec')
    end
  end
end
