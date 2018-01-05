class Served < Formula
  desc "https://github.com/datasift/served.git"
  homepage "https://github.com/datasift/served.git"
  url "https://github.com/datasift/served/zipball/master/"
  version ""

  def install
    system "cmake", "."
    system "make", "install"
  end

end
