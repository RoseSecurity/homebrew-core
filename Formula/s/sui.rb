class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.37.2.tar.gz"
  sha256 "e85c97f3f6352e8e6f33d1c4464677a506a210b6272447e2dc1a65e586bf0e66"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c56c4943cd8bc2ab0524f510c1a2bfe59ec91b0118f7a59524311dcada37b17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d582209fb0b16c8fe60f25c9d39f0551417d7ae025d4fd07055cee3450a2f14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1881034a829e51810b2d4a53795f8dec305046b531a0fe3e837c46abebc8b7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f988baab99cb1debc61a7306288d32ede78907b6e2e5c777b5e5eb9348e7075d"
    sha256 cellar: :any_skip_relocation, ventura:       "17e39bbf74f7ab98a25310a94f1ec45f4d59d6cc364e9197686e76ba8efdf81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec708d37e3bf11f5bcc1db57ae74d36eca91c9c70c8a9db663918b287d5e0e29"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", *std_cargo_args(path: "crates/sui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sui --version")

    (testpath/"testing.keystore").write <<~EOS
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    EOS
    keystore_output = shell_output("#{bin}/sui keytool --keystore-path testing.keystore list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end
