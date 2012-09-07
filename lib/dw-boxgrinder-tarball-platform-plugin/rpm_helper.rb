require "fileutils"

$YUM_REPOS_DIR="etc/yum.repos.d"

module RpmHelper

  include FileUtils

  def install_repos(working_root_dir)
    @log.debug "Installing repositories from appliance definition file..."

    # It seems that the directory is not always created by default if default repos are inhibited (e.g. SL6)
    yum_d = "#{working_root_dir}/#{$YUM_REPOS_DIR}/"
    mkdir_p(yum_d)

    @appliance_config.repos.each do |repo|
      if repo['ephemeral']
        @log.debug "Repository '#{repo['name']}' is an ephemeral repo. It'll not be installed in the appliance."
        next
      end

      @log.debug "Installing #{repo['name']} repo..."
      repo_file = File.read("#{File.dirname(__FILE__)}/src/base.repo").gsub(/#NAME#/, repo['name'])

      ['baseurl', 'mirrorlist'].each do |type|
        repo_file << ("#{type}=#{repo[type]}\n") unless repo[type].nil?
      end

      File.open("#{yum_d}#{repo['name']}.repo", 'w') {|repo_file_out|
        repo_file_out.puts(repo_file)
      }
      
      @log.debug "wrote to #{yum_d}#{repo['name']}.repo: "
      @log.debug repo_file

      
    end
    @log.debug "Repositories installed."
  end
  
end
