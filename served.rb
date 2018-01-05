class Served < Formula
  depends_on "cmake"

  desc "https://github.com/datasift/served.git"
  homepage "https://github.com/datasift/served.git"
  url "https://github.com/datasift/served/archive/6288e52c79c9ce72fe3dfadde1e0023b907acb3e.zip"
  sha256 "40e33b53922eba93a7a4e66935e10115e222ed679aaec70e959aa9b6efd77ef0"
  version "1"

  def install
    system "mkdir served.build && cd served.build && cmake ../ && make install"
  end

end
