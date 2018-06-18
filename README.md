# Matlab Installer

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/c7574e6abc1840ab95a0f622170a9af1)](https://www.codacy.com/app/marshki/matlab_installer?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=marshki/matlab_installer&amp;utm_campaign=Badge_Grade)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/hyperium/hyper/master/LICENSE)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
[![Open Source Love svg3](https://badges.frapsoft.com/os/v3/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)

Bash script to retrieve, install, and symlink various versions of [Matlab](https://www.mathworks.com/products/matlab.html).   

Open to members of New York University's [Center for Brain Imaging](http://cbi.nyu.edu/), [Center for Neural Science](http://www.cns.nyu.edu/), and [Department of Psychology](http://www.psych.nyu.edu/psychology.html) on the Meyer network.   

Tested to run on currently-supported versions of Linux ([Debian-based OSs](https://www.debian.org/derivatives/#list)) and Mac OS X.  

## Getting Started

__Pre-flight checklist__ (the script will check for the following conditions):
 
  * root privileges  

  * adeqaute free disk space (14 GBs)

  * [curl](https://curl.haxx.se/docs/manpage.html)

  * access to the Meyer network.  

**_NOTE:_** If you want the TUI version, you'll need to add the `dialog` and `pv` packages via [Apt](https://wiki.debian.org/Apt) with: 

`apt-get install --yes dialog pv` prior to executing the script. 

__Liftoff:__

Grab the script for your OS from `/src` in this repository, then, as root, call the script:  

* `bash matlab_install_linux.sh (Linux)`, or: `bash matlab_install_osx.sh` (OS X) to auto-install the most recent version of Matlab. 
**_YOU PROBABLY WANT ONE OF THESE INSTALLERS_**


* `bash matlab_mult_install_osx.sh` will launch a text-based menu. From there, follow on-screen prompts:

![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/matlab_multi.png "multi-install")

* `bash matlab_linux_tui.sh` will launch a text-based user interface and do the driving for you: 

![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/ping_cns.png "ping")|![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/retrieve_matlab.png "retrieve")

## TODO

- [ ] Revisit ping progress bar (TUI). 

- [ ] Code review, comments (all). 

## History 
v.0.2 20180211

## License 
[MIT License](https://github.com/marshki/matlab_installer/blob/master/LICENSE). 

## Acknowledgments
`wget` + `dialog` progress bar built off of gist from [here](https://gist.github.com/Gregsen/7822421). 
 
