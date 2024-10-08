class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.4.18.tar.gz"
  sha256 "04bea172463090144fd05e7c71b4b7f5a342d4710f6c0350738fd1fceec6565d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e33af917a67d7df32418406cabb0b717dfb9165d0609017e349335da70415d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b201458429f1261c681fc2773a279d2c1366ee33c80b26218e728720e365545"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "673147def4fe3e7461a6070d170894fb63c68626b8b4bb922d8c3946cc926b37"
    sha256 cellar: :any_skip_relocation, sonoma:        "a80bf941ead214bbf52291fffed042cab7ba272951ae0bef27538b3fe89fe35e"
    sha256 cellar: :any_skip_relocation, ventura:       "e118a3a4d2a061700f1c1d5fd4c148be3eae20420499e53479bca180c4715b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81aaafa47a7dbdd77c6b8ca91d8ac3e41f0373776ace1c22ca5be4ccee2af690"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "xz"

  on_linux do
    # On macOS, bzip2-sys will use the bundled lib as it cannot find the system or brew lib.
    # We only ship bzip2.pc on Linux which bzip2-sys needs to find library.
    depends_on "bzip2"
  end

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
    generate_completions_from_executable(bin/"uvx", "--generate-shell-completion", base_name: "uvx")
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
