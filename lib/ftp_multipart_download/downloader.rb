module FtpMultipartDownload
  class Downloader
    attr_reader :argv

    # see Net::FTP#initialize
    #
    # @param [String] host Host name.
    # @param [Hash, String] user_or_options username or option as Hash.
    # @param [String] passwd password
    # @param [String] acct Account information for ACCT.
    #
    def initialize(host = nil, user_or_options = {}, passwd = nil, acct = nil)
      @argv = [host, user_or_options, passwd, acct]
    end

    # concurrent multipart downloading.
    #
    # @param [Integer] concurrent number of concurrent download sessions.
    # @param [String] remotefile remote file path.
    # @param [String] localfile local file path.
    # @param [Integer] blocksize block size.
    # @raise [ConnectionError]
    #
    def download(concurrent, remotefile, localfile = File.basename(remotefile), blocksize = DEFAULT_BLOCKSIZE)
      connection_pool = ConnectionPool.new(concurrent, *argv)
      if connection_pool.count == 0
        raise ConnectionError.new('Could not establish any connection.', errors: connection_pool.errors)
      end

      Scheduler.new(connection_pool).schedule(remotefile, localfile, blocksize)
    end
  end
end
