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

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'rubygems'
require 'test/unit'
require 'fileutils'
require 'boxgrinder-build/appliance'
require 'boxgrinder-core/models/config'
require 'boxgrinder-core/helpers/log-helper'
require 'boxgrinder-build/helpers/guestfs-helper'
require 'dw-boxgrinder-tarball-platform-plugin/tarball_plugin'

module BoxGrinder 
  class TarballPluginTest < Test::Unit::TestCase
  
    include FileUtils
    
    def setup
      @basedir = File.dirname(__FILE__)
      @config = Config.new(:delivery => :none, :force => false, :change_to_user => false, :uid => 501, :gid => 501)
      @log = LogHelper.new(:level => :trace, :type => :stdout)
      @appliance = Appliance.new("#{@basedir}/appliances/jeos-centos6.appl", @config, :log => @log)
      @appliance.read_definition
      @appliance_config = @appliance.appliance_config

      dir = OpenCascade.new
      dir.base = "#{@appliance_config.path.build}/tarball-plugin"
      dir.tmp = "#{dir.base}/tmp"
      
      @tarball_plugin = BoxGrinder::TarballPlugin.new
      @tarball_plugin.appliance_config = @appliance_config
      @tarball_plugin.log = @log
      @tarball_plugin.dir = dir
    end
  
    def test_execution
      @tarball_plugin.execute()
    
      # check included "files:"
      assert compare_file("#{@basedir}/files/file01.txt", "#{@tarball_plugin.dir.tmp}/opt/dw-boxgrinder-tarball-platform-plugin/test/files/file01.txt")
      assert compare_file("#{@basedir}/files/file02.txt", "#{@tarball_plugin.dir.tmp}/opt/test/files/file02.txt")
      assert compare_file("#{@basedir}/files/path/pathfile01.txt", "#{@tarball_plugin.dir.tmp}/opt/somewhere/special/test/files/path/pathfile01.txt")
      assert compare_file("#{@basedir}/files/path/pathfile02.txt", "#{@tarball_plugin.dir.tmp}/opt/somewhere/special/test/files/path/pathfile02.txt")
      
      # check generated scripts
      assert compare_file("#{@basedir}/expected/scripts/install.sh", "#{@tarball_plugin.dir.tmp}/install.sh")
      assert compare_file("#{@basedir}/expected/scripts/install_rpms.sh", "#{@tarball_plugin.dir.tmp}/install_rpms.sh")
      assert compare_file("#{@basedir}/expected/scripts/install_post.sh", "#{@tarball_plugin.dir.tmp}/install_post.sh")
    end
    
  end
end