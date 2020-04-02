#!/bin/bash

# Place holder. 
# Confirm that the destination file matches the source using checksum via md5.
# For reference: https://stackoverflow.com/questions/17988090/what-are-the-differences-between-md5-binary-mode-and-text-mode

#file1=$(md5sum "$1")
#file2=$(md5sum "$2")

source=$(md5sum "$1")
destination=$(md5sum "$2")

md5_check () { 
  printf "%s\\n" "Comparing hashes..."

  if [ "$source" = "$destination" ]
    then
      printf "%s\\n" "Same."
  else
      printf "%s\\n" "Different."
fi	
} 

md5_check	
