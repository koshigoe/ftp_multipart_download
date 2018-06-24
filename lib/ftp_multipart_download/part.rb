module FtpMultipartDownload
  class Part
    attr_reader :connection

    # @param [Net::FTP] connection an instance of Net::FTP.
    #
    def initialize(connection)
      @connection = connection
    end

    # download a part of file.
    #
    # @param [String] remotefile remote file path.
    # @param [String] localfile local file path.
    # @param [Integer] blocksize block size.
    # @param [Integer] offset offset
    # @param [Integer] limit limit
    #
    def download(remotefile, localfile, blocksize, offset, limit)
      old_resume, connection.resume = connection.resume, true

      File.open(localfile, 'wb') do |f|
        retrieved = 0
        connection.retrbinary("RETR #{remotefile}", blocksize, offset) do |chunk|
          retrievable = [limit - retrieved, chunk.bytesize].min
          break if retrievable <= 0

          retrieved += f.write(chunk[0, retrievable])
        end
      end
    ensure
      connection.resume = old_resume
    end
  end
end
