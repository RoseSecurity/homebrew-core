class Pngxx < Formula
  desc "C++ wrapper for libpng library"
  homepage "https://www.nongnu.org/pngpp/"
  url "https://download.savannah.gnu.org/releases/pngpp/png++-0.2.10.tar.gz"
  sha256 "998af216ab16ebb88543fbaa2dbb9175855e944775b66f2996fc945c8444eee1"
  license "BSD-3-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/pngpp/"
    regex(/href=.*?png\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "acf63a60a34fbd3c3491c29b7ea5081736b7ce316d6d27b7732313920f450701"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5eec08e707d28e9849abb32efc3d218abfb2ff953ee1e9ed6fe3790646713090"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ede8356bf0fad95a8d5e0ff94f9e586bcca7ca67ef24097d50bb69e3bc20173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ede8356bf0fad95a8d5e0ff94f9e586bcca7ca67ef24097d50bb69e3bc20173"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ff35d41f1ad4d5cff20cc77fa72c905a6cab65f0102dfe898241082ffc53b24"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec92097253de6c3aeaa2213cc13800294a76d97a82245bcea915d1963efac4f"
    sha256 cellar: :any_skip_relocation, ventura:        "49ec98d8aa47bff88e3572d13c1613d107a450dd60421e39102aa90d7e001608"
    sha256 cellar: :any_skip_relocation, monterey:       "49ec98d8aa47bff88e3572d13c1613d107a450dd60421e39102aa90d7e001608"
    sha256 cellar: :any_skip_relocation, big_sur:        "536874bdcfa9f6b546f8a924bf4b72b8b6beba84883e6ee93645080632b51a2e"
    sha256 cellar: :any_skip_relocation, catalina:       "c6377c5185e7ae53ff7ec9a133b8c12618a400f64d14b55ee751dc7c85cbc491"
    sha256 cellar: :any_skip_relocation, mojave:         "536f9c2dd05cfd2ae8a4f7f5d0c5c38575cf91609498f98bd6c3f97c4de2c520"
    sha256 cellar: :any_skip_relocation, high_sierra:    "536f9c2dd05cfd2ae8a4f7f5d0c5c38575cf91609498f98bd6c3f97c4de2c520"
    sha256 cellar: :any_skip_relocation, sierra:         "cee110f568bae723e8e5172e8bab36c8f4c5adb8bf339a444926a572bfa13f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8ad881818b116ae124ab2f34ded71329044961ce3bcc58ad722fca0fc293d1ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ede8356bf0fad95a8d5e0ff94f9e586bcca7ca67ef24097d50bb69e3bc20173"
  end

  depends_on "libpng"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <png++/png.hpp>
      int main() {
        png::image<png::rgb_pixel> image(200, 300);
        if (image.get_width() != 200) return 1;
        if (image.get_height() != 300) return 2;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end
