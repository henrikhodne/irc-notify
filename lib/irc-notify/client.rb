module IrcNotify
  class Client
    def self.build(host, port = 6667, options = {})
      require "socket"
      socket = TCPSocket.new(host, port)
      if options[:ssl]
        require "openssl"
        ssl_context = OpenSSL::SSL::SSLContext.new
        ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
        socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context).tap do |sock|
          sock.sync = true
          sock.connect
        end
      end

      new(socket)
    end

    def initialize(socket)
      @socket = socket
    end

    def register(nick, options = {})
      print("PASS #{options[:password]}") if options[:password]
      print("NICK #{nick}")
      print("USER #{nick} * * :#{nick}")

      loop do
        case @socket.gets
        when /00[1-4] #{Regexp.escape(nick)}/
          break
        when /^PING\s*:\s*(.*)$/
          print("PONG #{$1}")
        end
      end

      identify_nickserv(options[:nickserv_password]) if options[:nickserv_password]
    end

    def notify(channel, message, options = {})
      join(channel, options[:channel_key]) if options.fetch(:join, true)
      if options[:notice]
        notice(channel, message)
      else
        privmsg(channel, message)
      end
    end

    def quit(message = nil)
      message = " :#{message}" if message
      print("QUIT#{message}")
      @socket.gets until @socket.eof?
    end

    private

    def identify_nickserv(password)
      privmsg("NickServ", "IDENTIFY #{password}")
      loop do
        case @socket.gets
        when /^:NickServ/i
          break
        when /^PING\s*:\s*(.*)$/
          print("PONG #{$1}")
        end
      end
    end

    def privmsg(receiver, message)
      print("PRIVMSG #{receiver} :#{message}")
    end

    def notice(receiver, message)
      print("NOTICE #{receiver} :#{message}")
    end

    def join(channel, key = nil)
      if key
        print("JOIN #{channel} #{key}")
      else
        print("JOIN #{channel}")
      end
    end

    def print(line)
      @socket.print("#{line}\r\n")
    end
  end
end
