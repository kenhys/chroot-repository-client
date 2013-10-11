

module Chroot
  module Repository
    module Client
      module Package
        module Mroonga

          def check_build_mroonga(options)
            codes = options[:codes].split if options[:codes]
            codes = CODES if options[:codes] == "all"
            codes = CODES unless options[:codes]

            archs = options[:arch].split if options[:arch]
            archs = CODES_ARCH if options[:arch] == "all"
            archs = CODES_ARCH unless options[:arch]

            codes.each do |code|
              archs.each do |arch|
                base_version=`cat ../version`
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