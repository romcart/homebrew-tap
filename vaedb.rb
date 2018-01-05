class Vaedb < Formula
  desc "In-memory database for querying data stored by the Vae CMS application."
  homepage "https://github.com/actionverb/vaedb"
  url "https://github.com/actionverb/vaedb/archive/1.0.0.tar.gz"
  version "1.0.0"
  sha256 "c851a75814f098aa710a82c6f6bf5d9193411705c454cd22f4bf25fa6b325c4e"

  depends_on 'boost'
  depends_on 'cmake'
  depends_on 'ragel'
  depends_on 're2'
  depends_on 'pcre'
  depends_on 'zeromq'
  depends_on 'libmemcached'
  depends_on 'mysql-connector-c++'
  depends_on 'jemalloc'
  depends_on 'actionverb/tap/avlibs3'
  depends_on 'actionverb/tap/served'

  def install
    system "./configure", "--prefix=#{prefix}"
    # OS X does not expose malloc.h as expected, remove the include
    inreplace "main.cpp", "#include <malloc.h>", ""
    system "make"
    prefix.install Dir["*"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vae_thrift`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
