# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class BrickQt59 < Formula
  desc "Version 5.9.0 of Qt framework Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  revision 2
  head "https://code.qt.io/qt/qt5.git", :branch => "5.9", :shallow => false

  stable do
    url "http://download.qt.io/official_releases/qt/5.9/5.9.0/single/qt-everywhere-opensource-src-5.9.0.tar.xz"
    mirror "https://www.mirrorservice.org/sites/download.qt-project.org/official_releases/qt/5.9/5.9.0/single/qt-everywhere-opensource-src-5.9.0.tar.xz"
    sha256 "f70b5c66161191489fc13c7b7eb69bf9df3881596b183e7f6d94305a39837517"

    # Upstream issue "Qt5.8: macOS, designer examples fails to compile"
    # Reported 15 Dec 2016 https://bugreports.qt.io/browse/QTBUG-57656
    # Upstream PR from 31 Jan 2017 "fix installation of header-only frameworks"
    # See https://codereview.qt-project.org/#/c/184053/1
    #patch do
    #  url "https://raw.githubusercontent.com/Homebrew/formula-patches/634a19fb/qt5/QTBUG-57656.patch"
    #  sha256 "a69fc727f4378dbe0cf05ecf6e633769fe7ee6ea52b1630135a05d5adfa23d87"
    #end

    # Upstream issue QTBUG-58344 "UI crash upon start" which won't be fixed in qt 5.7, 5.8
    # See https://codereview.qt-project.org/#/c/183183/
    #patch do
    #  url "https://raw.githubusercontent.com/Homebrew/formula-patches/a2c2bea6/qt5/QTBUG-58344.patch"
    #  sha256 "b5eebbe587ab64b66aea4938c0d2b90a00516d4d5b33d0971d049d919b4fcf9d"
    #end
  end

  bottle do
    rebuild 1
    sha256 "ce3b733a2acace3b95b35738a3fdbb7e329613ffa369300a0e80a2dd237c9082" => :sierra
    sha256 "ae2005c8092f8d00bcdfb0bd82ed47935ddb50abee9f16e65835a2cb6555df24" => :el_capitan
    sha256 "a56ec9c06bc95de647cdfb51560aabcc6199de79890aff3b3a5267d1d44736dc" => :yosemite
  end

  keg_only "Qt 5 has CMake issues when linked"

  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"
  option "with-qtwebkit", "Build with QtWebkit module"

  # OS X 10.7 Lion is still supported in Qt 5.5, but is no longer a reference
  # configuration and thus untested in practice. Builds on OS X 10.7 have been
  # reported to fail: <https://github.com/Homebrew/homebrew/issues/45284>.
  depends_on :macos => :mountain_lion

  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "mysql" => :optional
  depends_on "postgresql" => :optional

  # http://lists.qt-project.org/pipermail/development/2016-March/025358.html
  #resource "qt-webkit" do
  #  url "https://download.qt.io/community_releases/5.8/5.8.0-final/qtwebkit-opensource-src-5.8.0.tar.xz"
  #  sha256 "79ae8660086bf92ffb0008b17566270e6477c8fa0daf9bb3ac29404fb5911bec"
  #end

  # Restore `.pc` files for framework-based build of Qt 5 on OS X. This
  # partially reverts <https://codereview.qt-project.org/#/c/140954/> merged
  # between the 5.5.1 and 5.6.0 releases. (Remove this as soon as feasible!)
  #
  # Core formulae known to fail without this patch (as of 2016-10-15):
  #   * gnuplot  (with `--with-qt` option)
  #   * mkvtoolnix (with `--with-qt` option, silent build failure)
  #   * poppler    (with `--with-qt` option)
  #patch do
  #  url "https://raw.githubusercontent.com/Homebrew/formula-patches/e8fe6567/qt5/restore-pc-files.patch"
  #  sha256 "48ff18be2f4050de7288bddbae7f47e949512ac4bcd126c2f504be2ac701158b"
  #end

  def install
    args = %W[
      -verbose
      -prefix #{prefix}
      -debug-and-release
      -opensource -confirm-license
      -system-zlib
      -qt-libpng
      -qt-libjpeg
      -qt-freetype
      -qt-pcre
      -nomake tests
      -no-rpath
      -pkg-config
      -dbus-runtime
      -openssl-linked
      -no-securetransport
    ]

    args << "-nomake" << "examples" if build.without? "examples"

    if build.with? "mysql"
      args << "-plugin-sql-mysql"
      (buildpath/"brew_shim/mysql_config").write <<-EOS.undent
        #!/bin/sh
        if [ x"$1" = x"--libs" ]; then
          mysql_config --libs | sed "s/-lssl -lcrypto//"
        else
          exec mysql_config "$@"
        fi
      EOS
      chmod 0755, "brew_shim/mysql_config"
      args << "-mysql_config" << buildpath/"brew_shim/mysql_config"
    end

    args << "-plugin-sql-psql" if build.with? "postgresql"

    if build.with? "qtwebkit"
      (buildpath/"qtwebkit").install resource("qt-webkit")
      inreplace ".gitmodules", /.*status = obsolete\n((\s*)project = WebKit\.pro)/, "\\1\n\\2initrepo = true"
    end

    # BRICKFPT OpenSSL
    openssl_opt = Formula["openssl"].opt_prefix
    args << "-L#{openssl_opt}/lib"
    args << "-I#{openssl_opt}/include"

    
    ENV["OPENSSL_LIBS"] = "-L/opt/ssl/lib -lssl -lcrypto"
    system("./configure", *args)
    system "make -j4"
    ENV.j1
    
    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    if build.with? "docs"
      system "make", "docs"
      system "make", "install_docs"
    end

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end

  test do
    (testpath/"hello.pro").write <<-EOS.undent
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<-EOS.undent
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert File.exist?("hello")
    assert File.exist?("main.o")
    system "./hello"
  end
end
