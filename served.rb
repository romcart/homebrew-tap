class Served < Formula
  desc "https://github.com/datasift/served.git"
  homepage "https://github.com/datasift/served.git"
  url "https://github.com/datasift/served/zipball/master/"
  version "1"

  def install
    system "cmake", "."
    system "make", "install"
  end

end
