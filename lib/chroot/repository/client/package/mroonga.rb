module Chroot
  module Repository
    module Client
      module Package
        module Mroonga

          def use_html_summary?(options)
            if options[:summary] and options[:summary] == "html"
              true
            else
              false
            end
          end

          def check_build_mroonga(options)
            config = get_config_file

            codes = get_option_codes(options)
            archs = get_option_arch(options)

            mroonga_dir = config['mroonga_dir']
            use_html_summary = use_html_summary?(options)
            summary = {}
            codes.each do |code|
              summary[code] ||= {}
              archs.each do |arch|
                base_version=`cat #{mroonga_dir}/version`
                repository_dir = "#{mroonga_dir}/packages/apt/repositories"
                sets = `find #{repository_dir} -name "*#{base_version}*.deb" | grep #{code} | grep #{arch}`
                if not sets.length.zero?
                  summary[code][arch] ||= sets.split("\n").length
                else
                  summary[code][arch] ||= 0
                end
                unless use_html_summary
                  printf "%8s %5s %s",code, arch, base_version
                  if not sets.length.zero?
                    printf " => %d debs\n", sets.split("\n").length
                  else
                    printf " => %d debs\n", 0
                  end
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
                  base_version = `cat #{mroonga_dir}/version`
                  target_dir = "#{mroonga_dir}/packages/yum/repositories/#{dist}/#{version}"
                  target_name = ""
                  case dist
                  when "centos"
                    ["mysql-mroonga", "mysql55-mroonga"].each do |target|
                      next if target == "mysql55-mroonga" and version == "6"
                      sets=`find #{target_dir} -name "#{target}*#{base_version}*.rpm" | grep #{arch}`
                      tag = "#{dist} #{version} #{target}"
                      summary[tag] ||= {}
                      if not sets.length.zero?
                        summary[tag][arch] ||= sets.split("\n").length
                      else
                        summary[tag][arch] ||= 0
                      end
                      unless use_html_summary
                        printf "%10s %7s %16s %s => ", "#{dist}-#{version}", arch, target, base_version
                        if not sets.length.zero?
                          printf "%2d rpms\n", sets.split("\n").length
                        else
                          printf "%2d rpms\n", 0
                        end
                      end
                    end
                  when "fedora"
                    ["mariadb-mroonga", "mysql-mroonga"].each do |target|
                      sets=`find #{target_dir} -name "#{target}*#{base_version}*.rpm" | grep #{arch}`
                      tag = "#{dist} #{version} #{target}"
                      summary[tag] ||= {}
                      if not sets.length.zero?
                        summary[tag][arch] ||= sets.split("\n").length
                      else
                        summary[tag][arch] ||= 0
                      end
                      unless use_html_summary
                        printf "%10s %7s %16s %s => ", "#{dist}-#{version}", arch, target, base_version
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
            if use_html_summary
              html = "<table>\n"
              x86 = "i386"
              x64 = "amd64"
              html << "<tr><th></th><th>#{x86}</th><th>#{x64}</th></tr>\n"
              summary.keys.each do |key|
                html << "<tr><td>#{key}</td>"
                summary[key].keys.each do |arch|
                  if summary[key][arch] > 0
                    html << "<td>OK</td>"
                  else
                    html << "<td>NG</td>"
                  end
                end
                html << "</tr>\n"
              end
              html << "</table>\n"
              puts html
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
