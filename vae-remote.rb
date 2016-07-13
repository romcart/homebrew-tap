class VaeRemote < Formula
  desc "Vae Platform PHP Library that provides VaeML and Vae PHP functions."
  url "https://github.com/actionverb/vae_remote/archive/1.0.0.tar.gz"
  sha256 "2448c6b3c2aff98fc9af447e2d35bfd193a0e8275e1eba081bb4bd194809a71c"
  version "1.0.0"

  def install
    prefix.install Dir["*"]
  end
end
