module Chroot
  module Repository
    module Client
      module Package
        module Mroonga

          def check_build_mroonga(options)
            codes = get_option_codes(options)
            archs = get_option_arch(options)

            codes.each do |code|
              archs.each do |arch|
                base_version=`cat ../version`
                sets=`find apt/repositories -name "*#{base_version}*.deb" | grep #{code} | grep #{arch}`
                printf "%8s %5s %s",code, arch, base_version
                if not sets.length.zero?
                  printf " => %d debs\n", sets.split("\n").length
                else
                  printf " => %d debs\n", 0
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
                  base_version=`cat ../version`
                  sets=`find yum/repositories/#{dist}/#{version} -name "*#{base_version}*.rpm" | grep #{arch}`
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

          def check_install_mroonga(options)
            codes = get_option_codes(options)
            archs = get_option_arch(options)

            codes.each do |code|
              archs.each do |arch|
                get_chroot_dir

                root_dir = get_chroot_dir + "/#{code}-#{arch}"
                script_path = "#{root_dir}/tmp/check-install-mroonga.sh"
                content = <<-EOS
#!/bin/sh
dpkg -l *roonga | grep roonga
EOS
                File.open(script_path, "w+", 0755) do |file|
                  file.puts(content)
                end
                host = "#{code}-#{arch}"
                basename = File.basename(script_path)
                command = "sudo chname #{host} chroot #{root_dir} /tmp/#{basename}"
                puts `#{command}`
              end
            end
          end
        end
      end

      class Check < Thor

        desc "provide", "Check provided packages"
        option :codes
        option :dists
        option :arch
        def provide
          codes = get_option_codes(options)
          archs = get_option_arch(options)

          codes.each do |code|
            archs.each do |arch|
              content = <<-EOS
apt-get update > /dev/null 2>&1
apt-cache show mysql-server | grep "Version:" | head -1 > /tmp/mysql-version
EOS
              root_dir = get_chroot_dir + "/#{code}-#{arch}"
              script_path = "#{root_dir}/tmp/check-provided-mysql.sh"
              File.open(script_path, "w+", 0755) do |file|
                file.puts(content)
              end
              host = "#{code}-#{arch}"
              basename = File.basename(script_path)
              command = "sudo chname #{host} chroot #{root_dir} /tmp/#{basename}"
              raw = `#{command}`
              File.open("#{root_dir}/tmp/mysql-version") do |file|
                content = file.read.chomp
                printf "%8s %5s mysql:%s\n", code, arch, content.split(":")[1]

              end
            end
          end
        end
      end
    end
  end
end
