class Bitmarkd < Formula
  desc "Bitmark distributed property system"
  homepage "https://github.com/bitmark-inc/bitmarkd"
  url "https://github.com/bitmark-inc/bitmarkd.git",
      :tag      => "v0.12.4-beta.3",
      :revision => "3678a1ace16c44081f6252ddf4dbc111e3bc13a3"
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
