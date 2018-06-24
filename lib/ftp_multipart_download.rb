require 'ftp_multipart_download/version'
require 'ftp_multipart_download/connection_pool'
require 'ftp_multipart_download/downloader'
require 'ftp_multipart_download/part'
require 'ftp_multipart_download/scheduler'
require 'net/ftp'

module FtpMultipartDownload
  class Error < StandardError; end
  class ConnectionError < Error
    attr_reader :errors

    def initialize(error_message = nil, errors: [])
      super(error_message)
      @errors = errors
    end
  end

  DEFAULT_BLOCKSIZE = Net::FTP::DEFAULT_BLOCKSIZE
end
