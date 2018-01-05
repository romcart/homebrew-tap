class Served < Formula
  desc "https://github.com/datasift/served.git"
  homepage "https://github.com/datasift/served.git"
  url "https://github.com/datasift/served/archive/6288e52c79c9ce72fe3dfadde1e0023b907acb3e.zip"
  version "1"

  def install
    system "cmake", "."
    system "make", "install"
  end

end
