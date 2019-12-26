class BitmarkdAT0123 < Formula
  desc "Bitmark distributed property system"
  homepage "https://github.com/bitmark-inc/bitmarkd"
  url "https://github.com/bitmark-inc/bitmarkd.git",
      :tag      => "v0.12.3",
      :revision => "bf73bd5002812794e432dd86aa04d52d26a8f3f4"
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
