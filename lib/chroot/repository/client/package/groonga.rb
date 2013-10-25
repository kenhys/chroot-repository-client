

module Chroot
  module Repository
    module Client
      module Package
        module Groonga

          def check_build_groonga(options)
            codes = get_option_codes(options)
            archs = get_option_arch(options)

            config = get_config_file
            groonga_dir = config['groonga_dir']
            base_version=`cat #{groonga_dir}/base_version`
            codes.each do |code|
              archs.each do |arch|
                repository_dir = File.join(groonga_dir, "packages/apt/repositories")
                sets=`find #{repository_dir} -name "*#{base_version}*.deb" | grep #{code} | grep #{arch}`
                if not sets.length.zero?
                  printf "%8s %5s %s => %2d debs\n", code, arch, base_version, sets.split("\n").length
                else
                  printf "%8s %5s %s => %2d debs\n", code, arch, base_version, 0
                end
              end
            end

            dists = get_option_dists(options)
            darch = get_option_darch(options)
            dists.each do |dist|
              versions = CENTOS_VERSIONS if dist == "centos"
              versions = ["19"] if dist == "fedora"
              versions.each do |version|
                darch.each do |arch|
                  repository_dir = File.join(groonga_dir, "packages/yum/repositories")
                  sets=`find #{repository_dir}/#{dist}/#{version} -name "*#{base_version}*.rpm" | grep #{arch}`
                  printf "%10s %7s %s => ", "#{dist}-#{version}", arch, base_version
                  if not sets.length.zero?
                    printf "%2d rpms\n", sets.split("\n").length
                  else
                    printf "%2d rpms\n", 0
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
