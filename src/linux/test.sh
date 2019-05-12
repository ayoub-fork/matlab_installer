#!/bin/bash
# mjk235 [at] nyu [dot] edu --2017.02.10

#===============================================================================
# Install latest version of Matlab on Linux (Debian-based) via TUI.               
# Open to members of NYU's: Center for Brain Imaging, Center for Neural Science, 
# and Department of Psychology                                                   
# Requires: root privileges; access to Meyer network; adequate free disk space.    
# Note: Use on machines WITHOUT previous version of MATLAB installed on them.   
#===============================================================================
# Script requires dialog. Install it with: sudo apt-get install --yes dialog 
#===============================================================================

script=$(basename "$0")
program="MATLAB INSTALLER"

LOCAL_WEB="128.122.112.23"

MATLAB_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.5.tgz"

MATLAB=(
Matlab9.5
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.5.tgz"
matlab9.5
)

==================
# Pre-flight check
#================= 

# Is dialog installed? If not, let's add it. 

dialog_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' dialog 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    printf "%s\\n" "DIALOG IS NOT INSTALLED. EXITING." 
    exit 1
fi
}

#==============
# Sanity checks
#==============

# Is current UID 0? If not, exit.

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    dialog --backtitle "$script" --title "$program" --msgbox "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2 10 40
    exit 1
fi
}

# Is there adequate disk space in /usr/local directory? If not, exit.

check_disk_space () {
  if [ "$(df --local -k --output=avail /usr/local |awk 'FNR == 2 {print $1}')" -le "14680064" ]; then 
    dialog --backtitle "$script" --title "$program" --msgbox "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2 10 40
    exit 1
fi
}

# Is wget installed? It should be, but if not, install it.
# --> add silent install so it doesn't break the dialog box <--

wget_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' wget 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    dialog --backtitle "$script" --title "$program" --infobox "WGET IS NOT INSTALLED. LET'S INSTALL IT..." >&2 10 40
    apt-get install wget --yes
fi
}

# Is pv installed? If not, install it.
# --> add silent install so it doesn't break the dialog box? <-- 

pv_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' pv 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    dialog --backtitle "$script" --title "$program" --infobox "PV IS NOT INSTALLED. LET'S INSTALL IT..." >&2 10 40
    apt-get install pv --yes 
fi
}

# --> Add wget http code check to replace ping test <-- 

# Is CNS local web available? If not, exit. 

sanity_checks () {
  root_check 
  check_disk_space
  pv_check
  wget_check 
  ping_local_web
} 

#=================
# Matlab Install-r
#================= 

# Download tarball to /usr/local. 
# Progress bar built off of gist from: https://gist.github.com/Gregsen/7822421

get_matlab () {

  wget --progress=dot --output-document=/usr/local/matlab.tgz --tries=3 --continue $MATLAB_INSTALLER 2>&1 | \
    grep "%" |\
    sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" |
    dialog --backtitle "$script" --title "$program" --gauge "RETRIEVING ${MATLAB[0]} INSTALLER..." 10 40 
}

# Unpack tarball to /usr/local, which installs Matlab. 

untar_matlab () {
  (pv --numeric /usr/local/matlab.tgz | tar --extract --gzip --directory=/usr/local) 2>&1|
  dialog --backtitle "$script" --title "$program" --gauge "UNTARRING ${MATLAB[0]} PACKAGE TO /usr/local..." 10 40
}

# Remove tarball. 

remove_matlab_tar () {
  dialog --backtitle "$script" --title "$program" --infobox "REMOVING ${MATLAB[0]} INSTALLER..." 10 40 ; sleep 2 
 
  rm --recursive --verbose /usr/local/matlab.tgz
}

# Does /usr/local/bin exist? If not, add it. 

local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then

    dialog --backtitle "$script" --title "$program" --infobox "/usr/local/bin DOES NOT exist; LET'S ADD IT..." 10 40 ; sleep 2 
    
    #mkdir -pv /usr/local/bin
fi
}

# Create symbolic link for Matlab. 

symlink_matlab () {
  dialog --backtitle "$script" --title "$program" --infobox "CREATING SYMLINK FOR ${MATLAB[0]}..." 10 40 ; sleep 2 

  ln --symbolic /usr/local/"${MATLAB[2]}"/bin/matlab /usr/local/bin/matlab
}

# Install complete message.  

install_complete () {
   dialog --backtitle "$script" --title "$program" --msgbox "${MATLAB[0]} installed successfully!" 10 40
}

matlab_installer () {
  get_matlab 
  untar_matlab
  remove_matlab_tar
  local_bin_check
  symlink_matlab
  install_complete
} 

#=====
# Main
#===== 

main () {
  dialog_check 
  sanity_checks
  matlab_installer
}

main "$@"
