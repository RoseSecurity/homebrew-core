class Pbzip2 < Formula
  desc "Parallel bzip2"
  homepage "http://compression.great-site.net/pbzip2/"
  url "https://launchpad.net/pbzip2/1.1/1.1.13/+download/pbzip2-1.1.13.tar.gz"
  sha256 "8fd13eaaa266f7ee91f85c1ea97c86d9c9cc985969db9059cdebcb1e1b7bdbe6"
  license "bzip2-1.0.6"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "09d47c48c9c64a8c026c28f30e3e0074f1f0a195d5886d37e1a15f6925ab91bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96fd12c7e49a4710a7d718412bc0d1cbda865873486489bb068ff49bd5c23dd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef28ddb3c52e0a2fba318d9a5e95dea37414a1a98d7e2c8277d2edccb8d09572"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f797274e8b39d8abd60046352780028c987a268a78e3229e6ce8ff845bcd424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a42feae1d424ac132a520973b5bb9517bdf83bda8439263008b20c2208ed493"
    sha256 cellar: :any_skip_relocation, sonoma:         "935dbc363cc12919d81114e7fe614ee662dfd365c831ac587e0e8630aabb8809"
    sha256 cellar: :any_skip_relocation, ventura:        "b4a7a29f559ab1ccc53aae75504fe277aa2037887991f8b622e9db3ad313ba8e"
    sha256 cellar: :any_skip_relocation, monterey:       "740e3b3cee57142c2fe385795782f86bbfd02e96cfc6c5a8f2d63da647ffbaec"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea9f81b7830949f9e449c5277807f931e3041a63071bf0b66a9c254cbff2e965"
    sha256 cellar: :any_skip_relocation, catalina:       "57c1c1065cd29ee37187b87705adfb73b84d114fc46408d4690024f3a29ac837"
    sha256 cellar: :any_skip_relocation, mojave:         "5594212d69f619f7fa59cfec23ce2c6eefa0f8c69d5e77cdd84cf9e2478d0d51"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d72e618d7301937ab6a392e1ef3d9ed1f8d5380cd6516ea17b4e4bde11eea9a7"
    sha256 cellar: :any_skip_relocation, sierra:         "c15b9c38b5302286033e54ff4be006c3b31ccb179f96641e44f1126958527d7e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "be653d724b6f061cb9939dbdbf457aebc275e16dbf599f598b9ff3999fdd5db3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c63518fb5d60d394bcc30e58d8af968509e373d1b658fdcc0a42b48368fd4b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33c30ab657b712607e295bb648c8d7ce7c5590ec916aef948e2f38dc25c51551"
  end

  uses_from_macos "bzip2"

  def install
    system "make", "PREFIX=#{prefix}",
                   "CC=#{ENV.cxx}",
                   "CFLAGS=#{ENV.cflags}",
                   "PREFIX=#{prefix}",
                   "install"
  end

  test do
    system bin/"pbzip2", "--version"
  end
end
