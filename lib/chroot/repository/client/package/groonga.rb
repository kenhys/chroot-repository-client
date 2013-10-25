require 'colored'

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
            source_mtime = File.mtime("#{groonga_dir}/groonga-#{base_version}.tar.gz")
            outdated_minutes = (Time.now - source_mtime).to_i/60
            day_before_minutes = 24*60
            codes.each do |code|
              archs.each do |arch|
                repository_dir = File.join(groonga_dir, "packages/apt/repositories")
                grep_query = "grep #{code} | grep #{arch}"
                filter = "-name \"*#{base_version}*.deb\" | #{grep_query}"
                sets = `find #{repository_dir} #{filter}`
                package_count = get_package_count(sets)
                if not package_count.zero?
                  sets = `find #{repository_dir} -mmin +#{day_before_minutes} #{filter}`
                  day_before_count = get_package_count(sets)
                  sets = `find #{repository_dir} -mmin +#{outdated_minutes} #{filter}`
                  outdated_count = get_package_count(sets)
                  printf "%8s %5s %s => ", code, arch, base_version
                  if day_before_count > 0
                    printf "%02d debs (%s day before, %s outdated, %s rest)\n",
                      package_count, day_before_count.to_s.red,
                      (outdated_count - day_before_count).to_s.yellow,
                      (package_count - outdated_count).to_s.green
                  elsif outdated_count > 0
                    printf "%02d debs (0 day before, %s outdated, %s rest)\n",
                      package_count, outdated_count.to_s.yellow,
                      (package_count - outdated_count).to_s.green
                  else
                    printf "%02d debs (%s day before, %s outdated, %s rest)\n",
                      package_count,
                      0.to_s.red, 0.to_s.yellow, package_count.to_s.green
                  end
                else
                  printf "%8s %5s %s =>  %s debs\n", code, arch, base_version, "0".green
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
