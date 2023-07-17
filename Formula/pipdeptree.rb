class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/e3/b5/ed56647826df29dba3cd946120e74060db63c9777d876e27d72ea8db4a8f/pipdeptree-2.10.1.tar.gz"
  sha256 "ecf9c7a72dc45d9854b0d9925bac8028f9599bb2900cf5687e48fb79e19954fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "139b50263650dae744c7bf3446bd98c51e41ea3f14cea8fd92a066187cc78061"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e1c625b8291dc47f8d373dd04c1864082a9106ef8736b20f43b2b370bc0d08f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50c72518468c859df0c195164c957bf63704043e514134a07304206760a53763"
    sha256 cellar: :any_skip_relocation, ventura:        "fdb40803505296ea498d2bbb85af9eff963fdc541cb744e942f4fec0e575c8dd"
    sha256 cellar: :any_skip_relocation, monterey:       "7c4c8c2325474992f8eb9365eec56ea99b5c13634000d8905256af240856762f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5cfdcc321412637b5b2e7f9eb3bb464d14fcfefe8fb39cefca5338d2908d0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d25e8c2a56cfa6d068beb824a91cd60a5e866a2bd1fcf3d3d0c18015f97989"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
