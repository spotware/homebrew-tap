class CtraderCli < Formula
  desc "Headless command-line client for the cTrader trading platform"
  homepage "https://ctrader.com/"
  version "5.9.0"
  license :cannot_represent

  on_linux do
    on_intel do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-linux-x64.tar.gz"
      sha256 "040b05f1342b896f5d4ab2f0ae02bca0f57cb1d94787b690c2ca3db986baf4ec"
    end
    on_arm do
      url "https://getctrader.spotware.com/cli/homebrew/ctrader-cli-5.9.0-linux-arm64.tar.gz"
      sha256 "6923c501dce4fbcc14b54d7f4e5bbf0cc6da1341ef2bc3824428173a5ef9ac7b"
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
