require 'net/ftp'

module FtpMultipartDownload
  class ConnectionPool
    attr_reader :errors

    # @param [Integer] size number of connections.
    # @param [Array] argv argument values for Net::FTP#initialize.
    #
    def initialize(size, *argv)
      @errors = []
      @connection_pool = Array.new(size) do
        Net::FTP.new(*argv).yield_self { |c| c.closed? ? nil : c }
      rescue => e
        errors << e
        nil
      end.compact
    end

    include ::Enumerable

    # @yield [connection] gives an instance of Net::FTP which connected
    # @yieldparam [Net::FTP] an instance of Net::FTP which connected
    #
    def each(&block)
      @connection_pool.each(&block)
    end
  end
end
