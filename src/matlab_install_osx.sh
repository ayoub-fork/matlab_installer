#!/bin/bash

### Matlab installer V.1.0 for OS X.###

MATLAB_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz"

# Is user root? If not, exit.

function root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\n" "ROOT privileges are required to continue. Exiting." >&2
    exit 1
fi
}

# Is there adequate disk space in install directory? If not, exit.

function check_disk_space () {
  if [ $(df -Hl /Applications |awk 'FNR == 2 {print $4}' |sed 's/G//') -le 20 ]; then
    printf "%s\n" "Not enough free disk space. Exiting." >&2
    exit 1
fi
}
# Is curl installed? If not, exit.

function curl_check () {
if ! [ -x "$(command -v curl 2>/dev/null)" ]; then
  printf "%s\n" "Error: pv is not installed.  Please install it."  >&2
  exit 1
fi
}

# Download tarball

function get_matlab () {
  printf "%s\n" "Retrieving Matlab insaller..."
  curl --progress-bar --retry 3 --retry-delay 5 "$MATLAB_INSTALLER" --output matlab.tgz
}

# Unpack tarball to /usr/local

function untar_matlab () {
  printf "%s\n" "Untarring package to /usr/local..."
  tar --extract --gzip --file=matlab.tgz --directory=/Applications
}

# Remove tarball

function remove_matlab_tar () {
  printf "%s\n" "Removing Matlab Installer..."
  rm --recursive --force matlab.tgz
}

# Do we need to remove xattribute? 
# Do we need to check/modify permissions?

# Create symlink for Matlab

function symlink_matlab () {
  printf "%s\n" "Creating symlink..."
  ln --symbolic /Applications/MATLAB9.3/bin/matlab /usr/local/bin/matlab
}

# Launch Matlab from terminal

function launch_matlab () {
  printf "%s\n" "Launching Matlab..."
  matlab -nodesktop
}

# Main function

main () {
	root_check
	check_disk_space
	curl_check
	get_matlab
	untar_matlab
	remove_matlab_tar
	symlink_matlab
	launch_matlab
}

main "$@"
