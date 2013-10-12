

module Chroot
  module Repository
    module Client
      module Package
        module Groonga

          def check_build_groonga(options)
            codes = get_option_codes(options)
            archs = get_option_arch(options)

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
