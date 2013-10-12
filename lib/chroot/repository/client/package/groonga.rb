

module Chroot
  module Repository
    module Client
      module Package
        module Groonga

          def check_build_groonga(options)
            all_codes = ["squeeze", "wheezy", "jessie", "unstable",
                        "lucid", "precise", "quantal", "raring"]
            all_arch = ["i386", "amd64"]

            codes = get_option_codes(options)

            archs = options[:arch].split if options[:arch]
            archs = CODES_ARCH if options[:arch] == "all"
            archs = CODES_ARCH unless options[:arch]

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
