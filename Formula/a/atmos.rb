class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/refs/tags/v1.142.0.tar.gz"
  sha256 "0edfb2829674633dd6bf76f5a85bbe14072d347c67f15a3f00744de4e0c7c8aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b25a51fdaa6fe27181a908daaf5ecfbd3127847f7250f31a767e08166b9c4c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b25a51fdaa6fe27181a908daaf5ecfbd3127847f7250f31a767e08166b9c4c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b25a51fdaa6fe27181a908daaf5ecfbd3127847f7250f31a767e08166b9c4c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbd9fe31057a7dfb8a3106ece6efcf1b9862ec97a7666dbdc2f12704a7217abc"
    sha256 cellar: :any_skip_relocation, ventura:       "cbd9fe31057a7dfb8a3106ece6efcf1b9862ec97a7666dbdc2f12704a7217abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f75aff70f7b867f0f9761cbc40471ab208775b4e97173eeebb7d458f14304994"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "tenv symlinks atmos binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/cloudposse/atmos/pkg/version.Version=#{version}'")

    generate_completions_from_executable(bin/"atmos", "completion")
  end

  test do
    # create basic atmos.yaml
    (testpath/"atmos.yaml").write <<~YAML
      components:
        terraform:
          base_path: "./components/terraform"
          apply_auto_approve: false
          deploy_run_init: true
          auto_generate_backend_file: false
        helmfile:
          base_path: "./components/helmfile"
          kubeconfig_path: "/dev/shm"
          helm_aws_profile_pattern: "{namespace}-{tenant}-gbl-{stage}-helm"
          cluster_name_pattern: "{namespace}-{tenant}-{environment}-{stage}-eks-cluster"
      stacks:
        base_path: "./stacks"
        included_paths:
          - "**/*"
        excluded_paths:
          - "globals/**/*"
          - "catalog/**/*"
          - "**/*globals*"
        name_pattern: "{tenant}-{environment}-{stage}"
      logs:
        verbose: false
        colors: true
    YAML

    # create scaffold
    mkdir_p testpath/"stacks"
    mkdir_p testpath/"components/terraform/top-level-component1"
    (testpath/"stacks/tenant1-ue2-dev.yaml").write <<~YAML
      terraform:
        backend_type: s3 # s3, remote, vault, static, etc.
        backend:
          s3:
            encrypt: true
            bucket: "eg-ue2-root-tfstate"
            key: "terraform.tfstate"
            dynamodb_table: "eg-ue2-root-tfstate-lock"
            acl: "bucket-owner-full-control"
            region: "us-east-2"
            role_arn: null
          remote:
          vault:

      vars:
        tenant: tenant1
        region: us-east-2
        environment: ue2
        stage: dev

      components:
        terraform:
          top-level-component1: {}
    YAML

    # create expected file
    (testpath/"backend.tf.json").write <<~JSON
      {
        "terraform": {
          "backend": {
            "s3": {
              "workspace_key_prefix": "top-level-component1",
              "acl": "bucket-owner-full-control",
              "bucket": "eg-ue2-root-tfstate",
              "dynamodb_table": "eg-ue2-root-tfstate-lock",
              "encrypt": true,
              "key": "terraform.tfstate",
              "region": "us-east-2",
              "role_arn": null
            }
          }
        }
      }
    JSON

    system bin/"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath/"components/terraform/top-level-component1/backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath/"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set

    assert_match "Atmos #{version}", shell_output("#{bin}/atmos version")
  end
end
