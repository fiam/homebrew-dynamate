class Dynamate < Formula
  desc "Terminal UI for DynamoDB exploration and querying"
  homepage "https://github.com/fiam/dynamate"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fiam/dynamate/releases/download/v0.2.0/dynamate-aarch64-apple-darwin.tar.gz"
      sha256 "5a5f77eaa18b9c70d93378c9b5cd9d8f45f6bb1ceb63bbd654ad69d3cec64a65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fiam/dynamate/releases/download/v0.2.0/dynamate-x86_64-apple-darwin.tar.gz"
      sha256 "5ca2d0521e02e09466c2fd5f10b58143635d445f0ab2892ab604e851c7f977f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fiam/dynamate/releases/download/v0.2.0/dynamate-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3f62491b8973b0e0fd7e7c36ad3fb559e2fbe1b53da892be491615445fc42a73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fiam/dynamate/releases/download/v0.2.0/dynamate-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ef746179d21354752e8cabb89b971b28853d0f61dbdfa92a897f580a84c3026b"
    end
  end
  license "MIT"

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
