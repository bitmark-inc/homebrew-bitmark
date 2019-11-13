class LitecoinCore < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://litecoin.org/"
  url "https://github.com/litecoin-project/litecoin/archive/v0.17.1.tar.gz", :tag => "v0.17.1"
  sha256 "6e05514a480990f1ff1e7c81b5443d741f4016c03ab5c1ef44bf4b169af88bee"

  head do
    url "https://github.com/litecoin-project/litecoin"
  end

  option "with-gui", "Build the GUI client (requires Qt5)"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "openssl"
  depends_on "miniupnpc" => :recommended

  if build.with? "gui"
    depends_on "qt5"
    depends_on "qrencode" => :recommended
    depends_on "gettext" => :recommended
  end

  def install
    args = ["--prefix=#{libexec}", "--disable-dependency-tracking"]
    args << "--with-gui=no" if build.without? "gui"

    system "./autogen.sh"
    system "./configure", *args

    system "make"
    system "make", "check"
    system "make", "install"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/test_litecoin"
  end
end
