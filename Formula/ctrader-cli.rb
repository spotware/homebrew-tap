class CtraderCli < Formula
  desc "Headless command-line client for the cTrader trading platform"
  homepage "https://ctrader.com/"
  version "5.9.0"
  license :cannot_represent

  on_linux do
    on_intel do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-linux-x64.tar.gz"
      sha256 "50d5c04753bdd55c230062bfa1e5d6c89dc5c1e4daf302c1cd73453061c67532"
    end
    on_arm do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-linux-arm64.tar.gz"
      sha256 "c0633ce8b03207025de49cade80381b6fb01490ac8d73997eef948522841ffa4"
    end
  end

  on_macos do
    on_arm do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-osx-arm64.tar.gz"
      sha256 "372527de8713dafa40d2f13843478d172faae9b4fdfddb7ac438aceea9afffbe"
    end
    on_intel do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-osx-x64.tar.gz"
      sha256 "707636720636915461c21f2cd71e5a302abadeffb20846649fca85b6c2e9f679"
    end
  end

  def install
    libexec.install Dir["*"]

    # The tarball is built on Windows, whose tar drops the POSIX exec bit. Restore it on
    # the native apphost launchers: every extensionless file (the CLI itself, the runtime's
    # own native helpers) plus the algo host launcher the CLI spawns, whose name
    # algohost.netcore/<rid>/algohost.netcore carries a dot and is therefore not covered by
    # the extensionless rule. A non-executable launcher makes every `build` fail with
    # "The build host process stopped unexpectedly before the build completed." (XT-18848).
    Dir[libexec/"**/*"].each do |path|
      next if File.directory?(path)
      basename = File.basename(path)
      next if basename.include?(".") && basename != "algohost.netcore"
      File.chmod(0755, path)
    end

    bin.install_symlink libexec/"ctrader-cli"
  end

  test do
    assert_match "cTrader", shell_output("#{bin}/ctrader-cli --version 2>&1")
  end
end
