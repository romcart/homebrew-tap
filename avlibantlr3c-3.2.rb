class Avlibantlr3c32 < Formula
  desc "Fork of ANTLRv3 parsing library for C at version 3.2"
  homepage "http://www.antlr3.org"
  url "http://www.antlr3.org/download/C/libantlr3c-3.2.tar.gz"
  sha256 "2ccfb8a8bdd3d6c1d60742ff3a5a954af6d5a8d7f8901c87229fc6fa540ac99a"
  revision 1

  option "without-exceptions", "Compile without support for exception handling"

  conflicts_with "libantlr3c", :because => "Not compatible with newer version"
 
  def install
    args = ["--disable-dependency-tracking",
            "--disable-antlrdebug",
            "--prefix=#{prefix}"]
    args << "--enable-64bit" if MacOS.prefer_64_bit?
    system "./configure", *args
    if build.with? "exceptions"
      inreplace "Makefile" do |s|
        cflags = s.get_make_var "CFLAGS"
        cflags = cflags << " -fexceptions"
        s.change_make_var! "CFLAGS", cflags
      end
    end
    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
      #include <antlr3.h>
      int main() {
        if (0) {
          antlr3GenericSetupStream(NULL);
        }
        return 0;
      }
    EOS
    system ENV.cc, "hello.c", "-lantlr3c", "-o", "hello", "-O0"
    system testpath/"hello"
  end
end