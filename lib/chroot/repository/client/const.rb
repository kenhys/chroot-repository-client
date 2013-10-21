
module Chroot
  module Repository
    module Client

      CONFIG_DIR = "~/.chroot-repository-client"
      CONFIG_FILE = "config.yaml"
      CONFIG_PATH = "#{CONFIG_DIR}/#{CONFIG_FILE}"

      CODES = ["squeeze", "wheezy", "jessie", "unstable",
               "lucid", "precise", "quantal", "raring", "saucy"]
      CODES_ARCH = ["i386", "amd64"]

      DISTS = ["centos", "fedora"]
      DISTS_ARCH = ["i386", "x86_64"]

      CENTOS_VERSIONS = ["5", "6"]
    end
  end
end
