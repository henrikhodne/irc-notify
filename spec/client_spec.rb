require "spec_helper"

describe IrcNotify::Client do
  let(:nick) { "Bob" }
  let(:socket) { double("socket", print: nil, gets: "001 #{nick}") }
  subject(:client) { described_class.new(socket) }

  describe "#register" do
    it "sends NICK and USER" do
      expect(socket).to receive(:print).with("NICK #{nick}\r\n").ordered
      expect(socket).to receive(:print).with("USER #{nick} * * :#{nick}\r\n").ordered

      client.register(nick)
    end

    context "with password" do
      it "sends PASS before NICK and USER" do
        expect(socket).to receive(:print).with("PASS foobar\r\n").ordered
        expect(socket).to receive(:print).with("NICK #{nick}\r\n").ordered
        expect(socket).to receive(:print).with("USER #{nick} * * :#{nick}\r\n").ordered

        client.register(nick, password: "foobar")
      end
    end

    context "with NickServ password" do
      before(:each) do
        allow(socket).to receive(:gets).and_return("001 #{nick}", ":NickServ foo")
      end

      it "messages NickServ with password" do
        expect(socket).to receive(:print).with("NICK #{nick}\r\n").ordered
        expect(socket).to receive(:print).with("USER #{nick} * * :#{nick}\r\n").ordered
        expect(socket).to receive(:print).with("PRIVMSG NickServ :IDENTIFY foobar\r\n")

        client.register(nick, nickserv_password: "foobar")
      end
    end
  end

  describe "#notify" do
    it "joins the channel" do
      client.notify("#channel", "hello, world!")
      expect(socket).to have_received(:print).with("JOIN #channel\r\n")
    end

    it "sends the message" do
      client.notify("#channel", "Hello, world!")
      expect(socket).to have_received(:print).with("PRIVMSG #channel :Hello, world!\r\n")
    end

    context "with a channel key" do
      it "joins the channel with the key" do
        client.notify("#channel", "Hello, world!", channel_key: "foobar")
        expect(socket).to have_received(:print).with("JOIN #channel foobar\r\n")
      end
    end

    context "when enabling :notice flag" do
      it "sends a notice" do
        client.notify("#channel", "Hello, world!", notice: true)
        expect(socket).to have_received(:print).with("NOTICE #channel :Hello, world!\r\n")
      end
    end

    context "when passing join: false" do
      it "does not join the channel" do
        client.notify("#channel", "hello, world!", join: false)
        expect(socket).not_to have_received(:print).with(match(/^JOIN/))
      end
    end
  end

  describe "#quit" do
    before(:each) do
      allow(socket).to receive(:eof?).and_return(true)
    end

    it "sends the command" do
      client.quit("Goodbye")
      expect(socket).to have_received(:print).with("QUIT :Goodbye\r\n")
    end
  end
end
