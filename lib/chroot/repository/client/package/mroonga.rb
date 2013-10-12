

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

          def check_install_mroonga(options)
            codes = options[:codes].split if options[:codes]
            codes = CODES if options[:codes] == "all"
            codes = CODES unless options[:codes]

            archs = options[:arch].split if options[:arch]
            archs = CODES_ARCH if options[:arch] == "all"
            archs = CODES_ARCH unless options[:arch]

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
    end
  end
end
