# frozen_string_literal: true

require 'thwait'
require 'tmpdir'

module FtpMultipartDownload
  # An internal implementation to download a file by concurrent multipart.
  #
  # NOTE: This class create some Threads.
  #
  class Scheduler
    attr_reader :connection_pool

    # @param [Array<Net::FTP>] connection_pool an array of instance of Net::FTP.
    #
    def initialize(connection_pool)
      @connection_pool = connection_pool
    end

    # concurrent multipart downloading.
    #
    # @param [String] remotefile remote file path.
    # @param [String] localfile local file path.
    # @param [Integer] blocksize block size.
    #
    def schedule(remotefile, localfile, blocksize)
      total_size = connection_pool.first.size(remotefile)
      part_size = (total_size.to_f / connection_pool.count).ceil

      Dir.mktmpdir do |dir|
        part_files = []
        threads = connection_pool.map.with_index do |connection, i|
          offset = part_size * i
          next if offset >= total_size
          part_files << "#{dir}/#{i}"
          thread(connection, remotefile, part_files.last, blocksize, offset, part_size)
        end.compact
        ThreadsWait.all_waits(*threads)

        concat_files(localfile, *part_files)
      end
    end

    private

    def thread(*args)
      Thread.start(*args) do |connection, remotefile, partfile, blocksize, offset, limit|
        Part.new(connection).download(remotefile, partfile, blocksize, offset, limit)
      end
    end

    def concat_files(dest, *parts)
      File.open(dest, 'wb') do |output|
        parts.each do |part|
          next unless File.exist?(part)
          IO.copy_stream(part, output)
        end
      end
    end
  end
end
