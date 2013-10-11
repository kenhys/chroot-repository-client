

module Chroot
  module Repository
    module Client
      module Package
        module Groonga

          @@config_path = "~/.chroot-repository-client/config.yaml"

          def check_build_groonga(options)
            all_codes = ["squeeze", "wheezy", "jessie", "unstable"]
            all_arch = ["i386", "amd64"]

            codes = options[:codes].split if options[:codes]
            codes = all_codes if options[:codes] == "all"

            archs = options[:arch].split if options[:arch]
            archs = all_arch if options[:arch] == "all"
            archs = all_arch unless options[:arch]

            codes.each do |code|
              archs.each do |arch|
                base_version=`cat ../base_version`
                sets=`find apt/repositories -name "*#{base_version}*.deb" | grep #{code} | grep #{arch}`
                if not sets.length.zero?
                  printf "%8s %5s %s => %d debs\n", code, arch, base_version, sets.split("\n").length
                end
              end
            end
          end
        end
      end
    end
  end
end
