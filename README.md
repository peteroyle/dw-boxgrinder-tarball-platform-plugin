# dw-boxgrinder-tarball-platform-plugin

This BoxGrinder platform plugin generates a compressed tarball which can be uploaded 
to a host with a minimal OS install. When extracted the payload will place the files
from your "files:" section into the appropriate directories and will place 
a script in the root directory which can install all of your "packages:" and
execute your "post: base:" commands. 

In other words, it provides a way to customise an existing minimal OS install 
according to a BoxGrinder appliance definition. This can be useful eg: when your 
test environment is virtualised but parts of your production/staging environment are not,
or if your VM hosting providers only allow pre-configured images to be used
and you can't build your hosted images from scratch.

## Installation

    gem install dw-boxgrinder-tarball-platform-plugin

## Usage

    boxgrinder-build your_appliance.appl -p tarball -l dw-boxgrinder-tarball-platform-plugin
    
After the build has finished, you'll find the payload archive under 
build/appliances/x86_64/centos/6/your_appliance/1.0/your_appliance.tgz

Copy this file into the root directory of you target host, untar it (tar -zxvf your_appliance.tgz)
and run the "install.sh" file (sh install.sh).

## Known Issues and Limitations

This plugin currently only works when BoxGrinder is executed from within the directory 
containing your .appl file(s) (otherwise the files in your "files:" section won't 
be found). A fix for that is being investigated.

If you have platform-specific "post" instructions they will be ignored by this plugin.
We have no need for such functionality, though pull requests to implement it would be welcomed.

## Building

To build the gem from source:

    gem build dw-boxgrinder-tarball-platform-plugin.gemspec

## Copyright

Copyright (c) 2012 Digital Worx Aus. See LICENSE file for
further details.

