class LitecoinCore < Formula
  desc "A decentralized, peer to peer payment network"
  homepage "https://litecoin.org/"
  url "https://github.com/litecoin-project/litecoin/archive/v0.13.2.1.tar.gz"
  sha256 "5c205336fba9ab281375e4e8ec4c9a48068cbbeeb5dfc0a55b58649b53c898ad"

  head do
    url "https://github.com/litecoin-project/litecoin"
  end

  option "without-gui", "Build the GUI client (requires Qt5)"

  depends_on "libevent"
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
    depends_on "protobuf@2.6"
    depends_on "gettext" => :recommended
  end

  def install
    args = ["--prefix=#{libexec}", "--disable-dependency-tracking"]
    args << "--without-gui" if build.without? "gui"
    args << "--without-miniupnpc" if build.without? "miniupnpc"

    system "./autogen.sh"
    system "./configure", *args

    system "make"
    system "make", "check"
    system "make", "install"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
