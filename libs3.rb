class Avlibs3 < Formula
  desc ""
  homepage ""
  url "https://github.com/bji/libs3/archive/master.zip"
  version "master"
  sha256 "9352223a07263937da8f1536bf95dfb26a393d9a34f53784eed6934e01b8dfe7"

  def install
    system "mkdir", bin
    system "mkdir", lib
    system "mkdir", "#{include}"
    system "mv", "GNUmakefile.osx", "GNUmakefile"
    ENV.append("DESTDIR", prefix)
    system "make", "install"
  end

end
