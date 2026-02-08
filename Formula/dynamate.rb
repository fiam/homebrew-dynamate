class Dynamate < Formula
  desc "Terminal UI for DynamoDB exploration and querying"
  homepage "https://github.com/fiam/dynamate"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fiam/dynamate/releases/download/v0.1.0/dynamate-aarch64-apple-darwin.tar.gz"
      sha256 "d6d134bdbf115d19107d0f718c091603c988bf5907a7a4917158b21eb7c3aed7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fiam/dynamate/releases/download/v0.1.0/dynamate-x86_64-apple-darwin.tar.gz"
      sha256 "e1897c3a538340a80abfcd4a191a264b70c5cfddaa118d4825a7584bee1cfdad"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fiam/dynamate/releases/download/v0.1.0/dynamate-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5b1ee8ce05a7afa5c36e23687356abe7f49316b554ee2970376c8f52bbf9f960"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fiam/dynamate/releases/download/v0.1.0/dynamate-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c594eeb87d69195a1252cebe1ff2de7f03dbf9ecd3cd730f007642fcb4995ddb"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dynamate" if OS.mac? && Hardware::CPU.arm?
    bin.install "dynamate" if OS.mac? && Hardware::CPU.intel?
    bin.install "dynamate" if OS.linux? && Hardware::CPU.arm?
    bin.install "dynamate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
