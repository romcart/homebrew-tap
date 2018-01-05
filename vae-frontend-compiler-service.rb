class VaeFrontendCompilerService < Formula
  desc "Provides Haml and Sass compilation via a JSON API on port 9092"
  homepage "https://github.com/actionverb/vae-frontend-compiler-service"
  url "https://github.com/actionverb/vae-frontend-compiler-service/archive/1.0.0.tar.gz"
  version "1.0.0"

  def install
    system "bundle"
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
