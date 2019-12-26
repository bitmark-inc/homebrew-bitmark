class BitmarkdAT0107 < Formula
  desc "Bitmark distributed property system"
  homepage "https://github.com/bitmark-inc/bitmarkd"
  url "https://github.com/bitmark-inc/bitmarkd.git",
      :tag      => "v0.10.7",
      :revision => "307ae961c2d27cbbf60d9e5599b494bad3ff923a"
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
    assert_match "bitmarkd: version: #{version}", shell_output("#{bin}/bitmarkd --version 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/bitmark-cli version")
  end
end
