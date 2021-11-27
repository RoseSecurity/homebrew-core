class Sqlc < Formula
  desc "Generate type safe Go from SQL"
  homepage "https://sqlc.dev/"
  url "https://github.com/kyleconroy/sqlc/archive/v1.11.0.tar.gz"
  sha256 "6e18562a066ea70687e7abb642e3dde48a128633f71d29788c4df6a886eac1d1"
  license "MIT"
  head "https://github.com/kyleconroy/sqlc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb666cb62956f46089e845a75bbdf9e1dd2468e6de60b31efbb3b22e826f4b6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cb9142b29b5be3a4a051918c0f7105a54777ba34aab756e3ec30c32d4e54936"
    sha256 cellar: :any_skip_relocation, monterey:       "2d28c4e3e14ecfdd3680ebcb4c6bba6e11fe6cd7040e08da1a30e08ed05c868c"
    sha256 cellar: :any_skip_relocation, big_sur:        "57822dbcd38cd5835b0e8d5ae8bed2ed010e925563b47cd0b406cc64f4055ef6"
    sha256 cellar: :any_skip_relocation, catalina:       "7359588cc4700484e7a12867f93a289424100114d9d8af037f36d1a3231091ba"
    sha256 cellar: :any_skip_relocation, mojave:         "4093ef305a8d00ad0acf13a87cd31340f17219560c58ac98b1d4ad2213e8fc89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0449046713f387fa8023eea6cb4e1a4d574e0897d15a28b27a4a3e3165112c89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/sqlc"
  end

  test do
    (testpath/"sqlc.json").write <<~SQLC
      {
        "version": "1",
        "packages": [
          {
            "name": "db",
            "path": ".",
            "queries": "query.sql",
            "schema": "query.sql",
            "engine": "postgresql"
          }
        ]
      }
    SQLC

    (testpath/"query.sql").write <<~EOS
      CREATE TABLE foo (bar text);

      -- name: SelectFoo :many
      SELECT * FROM foo;
    EOS

    system bin/"sqlc", "generate"
    assert_predicate testpath/"db.go", :exist?
    assert_predicate testpath/"models.go", :exist?
    assert_match "// Code generated by sqlc. DO NOT EDIT.", File.read(testpath/"query.sql.go")
  end
end
