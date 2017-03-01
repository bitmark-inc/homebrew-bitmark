class Bitcoind < Formula
  desc "A decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin/archive/v0.13.2.tar.gz"
  sha256 "8a1307605b71b1df720ed0360d801d8939138aaca0a495d0f1e4e500efc2eaa1"

  head do
    url "https://github.com/bitcoin/bitcoin.git"

    depends_on "libevent"
  end

  option "with-gui", "Build the GUI client (requires Qt5)"

  depends_on :macos => :lion
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "berkeley-db4"
  depends_on "boost"
  depends_on "openssl"
  depends_on "miniupnpc" => :recommended

  if build.with? "gui"
    depends_on "qt5"
    depends_on "protobuf"
    depends_on "qrencode"
    depends_on "gettext" => :recommended
  end

  def install
    args = ["--prefix=#{libexec}", "--disable-dependency-tracking"]

    if build.with? "gui"
      args << "--with-qrencode"
    end

    args << "--without-miniupnpc" if build.without? "miniupnpc"

    system "./autogen.sh"
    system "./configure", *args

    system "make"
    system "make", "install"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end