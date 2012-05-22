# dw-boxgrinder-tarball-platform-plugin

This platform plugin generates an archive payload which can be uploaded to a 
physical machine with a minimal install and executed to create a physical
installation of a virtual machine definition. This can be useful eg: when your 
test environment is virtualised but parts of your production environment are not.

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

## Copyright

Copyright (c) 2012 Digital Worx Aus. See LICENSE file for
further details.

