class Bitmarkd < Formula
  desc "Bitmark distributed property system"
  homepage "https://github.com/bitmark-inc/bitmarkd"
  url "https://github.com/bitmark-inc/bitmarkd/archive/v0.12.2.tar.gz"
  sha256 "23c3fab54a6e6ed874425f225efed41ba605766a6c66d83e184ab90dda64bce4"
  head "https://github.com/bitmark-inc/bitmarkd.git"

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "zeromq"

  def install
    system "go", "build", "-o", ".", "-ldflags", "-X main.version=#{version}", "./..."
    bin.install "bitmarkd", "bitmark-cli", "recorderd"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bitmarkd version")
    assert_match version.to_s, shell_output("#{bin}/recorderd version")
    assert_match version.to_s, shell_output("#{bin}/bitmark-cli version")
  end
end
