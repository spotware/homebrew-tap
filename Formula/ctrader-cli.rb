class CtraderCli < Formula
  desc "Headless command-line client for the cTrader trading platform"
  homepage "https://ctrader.com/"
  version "5.9.0"
  license :cannot_represent

  on_linux do
    on_intel do
      url "https://getctraderlinux.spotware.com/cli/homebrew/ctrader-cli-5.9.0-linux-x64.tar.gz"
      sha256 "85ae87b35343584e3b983b55574411ed63c428c1691254c01c688fedb48aec7f"
    end
    on_arm do
      url "https://getctraderlinux.spotware.com/cli/homebrew/ctrader-cli-5.9.0-linux-arm64.tar.gz"
      sha256 "9d3f99e5d322e6dfbb66858cd69df9bd4cb5bdf0f822ebbe4afb4f4d6c8b53cb"
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
