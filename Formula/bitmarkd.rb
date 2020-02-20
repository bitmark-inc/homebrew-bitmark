class Bitmarkd < Formula
  desc "Bitmark distributed property system"
  homepage "https://github.com/bitmark-inc/bitmarkd"
  url "https://github.com/bitmark-inc/bitmarkd.git",
      :tag      => "v0.12.4",
      :revision => "45c1c59b61f5bee73d8235f432d55481b5cec836"
  head "https://github.com/bitmark-inc/bitmarkd.git"

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "zeromq"

  def install
    system "go", "build", "-o", ".", "-ldflags", "-X main.version=#{version}", "./..."
    bin.install "bitmark-cli"
    sbin.install "bitmarkd", "recorderd"

    inreplace "command/bitmarkd/bitmarkd.conf.sub", "/var/lib/bitmarkd", var/"lib/bitmarkd"
    inreplace "command/bitmarkd/bitmarkd.conf.sub", "add_port(\"*\", 2135)", "add_port(\"[::]\", 2135)"
    inreplace "command/bitmarkd/bitmarkd.conf.sub", "add_port(\"*\", 2136)", "add_port(\"[::]\", 2136)"
    (etc/"bitmarkd").mkpath
    etc.install "command/bitmarkd/bitmarkd.conf.sub" => "bitmarkd/bitmarkd.conf.sub"
    etc.install "command/bitmarkd/bitmarkd.conf.sample" => "bitmarkd/bitmarkd.conf.sample"

    (etc/"recorderd").mkpath
    etc.install "command/recorderd/recorderd.conf.sample" => "recorderd/recorderd.conf.sample"
    prefix.install_metafiles
  end

  def post_install
    (var/"lib/bitmarkd").mkpath
    unless File.exist? "#{var}/lib/bitmarkd/peer.private"
      cd (var/"lib/bitmarkd") do
        system "#{sbin}/bitmarkd", "--config-file=#{etc}/bitmarkd/bitmarkd.conf.sample", "gen-rpc-cert"
        system "#{sbin}/bitmarkd", "--config-file=#{etc}/bitmarkd/bitmarkd.conf.sample", "gen-peer-identity"
        system "#{sbin}/bitmarkd", "--config-file=#{etc}/bitmarkd/bitmarkd.conf.sample", "gen-proof-identity"
      end
    end

    (var/"lib/recorderd").mkpath
    unless File.exist? "#{var}/lib/recorderd/recorderd.private"
      cd (var/"lib/recorderd") do
        system "#{sbin}/recorderd", "--config-file=#{etc}/recorderd/recorderd.conf.sample", "generate-identity"
      end
    end
  end

  plist_options :manual => "bitmarkd --config-file=#{HOMEBREW_PREFIX}/etc/bitmarkd/bitmarkd.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/bitmarkd</string>
          <string>--config-file=#{etc}/bitmarkd/bitmarkd.conf</string>
        </array>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/bitmarkd version")
    assert_match version.to_s, shell_output("#{sbin}/recorderd version")
    assert_match version.to_s, shell_output("#{bin}/bitmark-cli version")
  end
end
