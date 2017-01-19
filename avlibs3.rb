class Avlibs3 < Formula
  desc ""
  homepage ""
  url "https://github.com/bji/libs3/archive/bb96e59583266a7abc9be7fc5d4d4f0e9c1167cb.zip"
  version "bb96e59583266a7abc9be7fc5d4d4f0e9c1167cb"
  sha256 "79ac4feabde304998ca5dcaed1dd10ce79f497d7cc0c6f48a391b1f6dfdc01ef"

  def install
    system "mkdir", bin
    system "mkdir", lib
    system "mkdir", "#{include}"
    system "mv", "GNUmakefile.osx", "GNUmakefile"
    ENV.append("DESTDIR", prefix)
    system "make", "install"
  end

end
