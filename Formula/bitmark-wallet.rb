class BitmarkWallet < Formula
  desc "This is an HD wallet of Bitcoin and Litecoin made by Bitmark"
  homepage "https://github.com/bitmark-inc/bitmark-wallet"
  url "https://github.com/bitmark-inc/bitmark-wallet/archive/v0.6.3.tar.gz"
  sha256 "b8d03fee0ff4a94e2840a02e6c463a156aca4327dc9aabca77d5082409aa9efa"
  head "https://github.com/bitmark-inc/bitmark-wallet.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", ".", "-ldflags", "-X main.version=#{version}", "./..."
    cp("command/bitmark-wallet/wallet.conf.sample", "command/bitmark-wallet/wallet.conf")
    etc.install "command/bitmark-wallet/wallet.conf" => "bitmark-wallet/wallet.conf"
    etc.install "command/bitmark-wallet/wallet.conf.sample" => "bitmark-wallet/wallet.conf.sample"
    bin.install "bitmark-wallet"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bitmark-wallet -C #{etc}/bitmark-wallet/wallet.conf version")
  end
end
