class LitecoinCore < Formula
  desc "A decentralized, peer to peer payment network"
  homepage "https://litecoin.org/"
  url "https://github.com/litecoin-project/litecoin/archive/v0.16.3.tar.gz", :tag => 'v0.16.3'
  sha256 "7788800eb4a433696a464563384cbdf83a47eebb8698325c75314171833227c8"

  head do
    url "https://github.com/litecoin-project/litecoin"
  end

  option "with-gui", "Build the GUI client (requires Qt5)"

  depends_on "libevent"
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
