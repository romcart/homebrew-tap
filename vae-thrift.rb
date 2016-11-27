class VaeThrift < Formula
  desc "VaeThrift contains two daemons that run for the purpose of servicing Vae Remote."
  homepage ""
  url "https://github.com/actionverb/vae_thrift/archive/1.0.0.tar.gz"
  version "1.0.0"
  sha256 "697e63929ae62665a317b6596c768d33a13b679413f119b6fbb27a2332cf3546"

  depends_on 'pcre'
  depends_on 'zeromq'
  depends_on 'actionverb/tap/avthrift-0.9.2'
  depends_on 'libmemcached'
  depends_on 'mysql-connector-c++'
  depends_on 'jemalloc'
  depends_on 'actionverb/tap/avlibs3'
  
  def install
    cd 'cpp' do
      system "./configure", "--prefix=#{prefix}"
      # OS X does not expose malloc.h as expected, remove the include
      inreplace "main.cpp", "#include <malloc.h>", ""
      system "make"
    end
    cd 'rb' do
      system "bundle"
    end
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
