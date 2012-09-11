# Copyright 2012, Digital Worx Aust
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'boxgrinder-build/plugins/base-plugin'
require "fileutils"
require 'zlib'
require 'archive/tar/minitar'
require 'archive/tar/minitar/command'
require 'set'
require 'dw-boxgrinder-tarball-platform-plugin/rpm_helper'


module BoxGrinder
  
  class TarballPlugin < BasePlugin
    plugin :type => :platform, :name => :tarball, :full_name  => "Tarball"

    include FileUtils
    include RpmHelper
    include Archive::Tar

    attr_accessor :appliance_config, :log, :dir, :plugin_info
        
    def after_init
      @tar_name = "#{@appliance_config.name}.tgz"
      register_deliverable(
        :tarball => @tar_name
      )
    end
    
    def execute
      
      # Create a temporary directory to work from
      @working_dir = "#{@dir.tmp}"
      mkdir_p(@working_dir)
      
      # add custom repos into the /etc/yum.repos.d dir
      install_repos(tmp_path(''))
      
      # collect the RPMs and create an install_rpms.sh script to add to the payload
      install_rpms_script_name = "install_rpms.sh"
      create_script(install_rpms_script_name, :prefix => "yum install -y ", :lines => @appliance_config.packages) {|line|
        "#{line} "
      }
      
      # collect all post->base commands and create an install script to add to the payload
      install_post_script_name = "install_post.sh"
      boxgrinder_env = ["# more BoxGrinder-like environment", "export PATH=$PATH:/sbin/:/usr/sbin/", ""]
      reboot_warning = "echo 'It is highly recommended that you reboot this matchine now before proceeding, as that is more in line with the natural BoxGrinder VM creation process.'"
      lines = boxgrinder_env | @appliance_config.post['base']
      lines << reboot_warning
      create_script(install_post_script_name, :lines => lines) {|line|
        "#{line}\n"
      }
      
      # create a root install script to install rpms and perform post
      install_all_script_name = "install.sh"
      create_script(install_all_script_name, :lines => [install_rpms_script_name, install_post_script_name]) {|line|
        "sh #{line}\n"
      }
      
      # Copy all files into the working directory to add to the payload
      for tgt_dir in @appliance_config.files.keys
        sources = @appliance_config.files[tgt_dir]
        for source in sources
          # convert '../xxx/yyy' to 'xxx/yyy'
          tgt_path_suffix = source.scan(/([^\.]+)[\\\/][^\\\/]+/)
          full_tgt_path = "#{tmp_path(tgt_dir)}/#{tgt_path_suffix}"
          mkdir_p(full_tgt_path)
          cp_r("#{source}", full_tgt_path)
        end
      end
      
      # create the tar in the build tmp directory, and it will be moved into the 
      # deliverables directory automatically
      root_tar_path = tmp_path('')
      @tar_name = "#{@appliance_config.name}.tgz"
      Dir.chdir(root_tar_path) do
        begin
          sgz = Zlib::GzipWriter.new(File.open(@tar_name, 'wb'))
          tar = Archive::Tar::Minitar::Output.new(sgz)
          uniq_entries = Set.new
          # add custom repo definitions
          @appliance_config.repos.each do |repo|
            Minitar.pack_file("#{$YUM_REPOS_DIR}/#{repo['name']}.repo", tar) if repo['ephemeral'] == false
          end
          # add all files from the "files:" section
          for tgt_dir in @appliance_config.files.keys
            # remove leading slashes for relative paths
            tgt_rel = "#{tgt_dir.scan(/[\\\/]*(.*)/)}"
            Find.find(tgt_rel) do |entry|
              if !uniq_entries.include?(entry)
                Minitar.pack_file(entry, tar) 
                uniq_entries << entry
              end
            end
          end
          # add all generated scripts
          for script_name in @created_scripts
            Minitar.pack_file(script_name, tar) 
          end
        ensure
          tar.close
        end
      end
      
    end
  
    def tmp_path(dir_name)
      "#{@working_dir}/#{dir_name}"
    end
    
    def create_script(script_name, options = {}, &line_processor)
      script = (options[:prefix] || "")
      for line in options[:lines]
        processed_line = line_processor.call line
        script << processed_line
      end
      script << (options[:suffix] || "")
      File.open(tmp_path(script_name), 'w') {|script_file|
        script_file.puts(script)
      }
      # record the names of all generated scripts, so we can add them to the tarball
      @created_scripts ||= []
      @created_scripts << script_name
    end
    
  end


end