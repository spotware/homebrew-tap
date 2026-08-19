class CtraderCli < Formula
  desc "Headless command-line client for the cTrader trading platform"
  homepage "https://ctrader.com/"
  version "5.9.0"
  license :cannot_represent

  on_linux do
    on_intel do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-linux-x64.tar.gz"
      sha256 "da0f5fb0c58980be9143fafca9839de784084b6e323321d9e03e5c3e64bec562"
    end
    on_arm do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-linux-arm64.tar.gz"
      sha256 "67b0153f79a59fe6fa00fddfd1d0df8183c2e43f39efa5f9a63f37df3ce267b8"
    end
  end

  on_macos do
    on_arm do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-osx-arm64.tar.gz"
      sha256 "04d29916f30b4b3d947e1699ee3a8d2578e03a9f3780f307d1c1ae86a0e4e6a9"
    end
    on_intel do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-osx-x64.tar.gz"
      sha256 "8663ace9692faffdcd836ba10e8a94f1dc398c4239f3e295ce5641777e8f5862"
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
