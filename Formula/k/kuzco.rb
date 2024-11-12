class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "70baccb282e25d74a1d168e3e8e1786431690df9639ca6ef9701f3fdff12a3a4"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"kuzco", "completion")
  end

  test do
    resource("terraform") do
      url "https://github.com/hashicorp/terraform/archive/refs/tags/v1.5.7.tar.gz"
      sha256 "6742fc87cba5e064455393cda12f0e0241c85a7cb2a3558d13289380bb5f26f5"
    end

    resource("terraform").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: testpath/"terraform")
    end

    ENV.prepend_path "PATH", testpath

    (testpath/"main.tf").write <<~EOS
      resource "aws_s3_bucket" "cloudtrail_logs" {
        bucket              = "my-cloudtrail-logs-bucket"
        object_lock_enabled = true

        tags = {
          Name        = "My CloudTrail Bucket"
          Environment = "Dev"
          Region      = "us-west-2"
        }
      }
    EOS

    output = shell_output("#{bin}/kuzco recommend -f #{testpath} --dry-run")
    assert_match "version block", output
    assert_match version.to_s, shell_output("#{bin}/kuzco version")
  end
end
