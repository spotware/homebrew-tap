class CtraderCli < Formula
  desc "Headless command-line client for the cTrader trading platform"
  homepage "https://ctrader.com/"
  version "5.9.0"
  license :cannot_represent

  on_linux do
    on_intel do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-linux-x64.tar.gz"
      sha256 "8b690bbb6a2c1b250d2356f6dc4a55576b6a4f753d0b017c932ffbf72c48181b"
    end
    on_arm do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-linux-arm64.tar.gz"
      sha256 "4fd85eb2f1f8bccc58fa505b09df5ecef76bf9ad4e1427f09f3aa0223df2315c"
    end
  end

  on_macos do
    on_arm do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-osx-arm64.tar.gz"
      sha256 "5d198ab25df6b7c14febb159232fa769b0aa8c6aaea12234e4631ed45679e434"
    end
    on_intel do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-osx-x64.tar.gz"
      sha256 "18328a0b8208e1e2a0552dec4ff41c796b977dde0d327cf317be406ca979c20c"
    end
  end

  def install
    libexec.install Dir["*"]

    # The tarball is built on Windows, whose tar drops the POSIX exec bit. Restore it on
    # the native apphost launchers - the CLI and the algo host apphost are extensionless
    # files (managed assemblies all carry a .dll/.json/etc. suffix).
    Dir[libexec/"**/*"].each do |path|
      next if File.directory?(path)
      File.chmod(0755, path) unless File.basename(path).include?(".")
    end

    bin.install_symlink libexec/"ctrader-cli"
  end

  test do
    assert_match "cTrader", shell_output("#{bin}/ctrader-cli --version 2>&1")
  end
end
