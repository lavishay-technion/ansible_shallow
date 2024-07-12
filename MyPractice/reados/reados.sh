#!/bin/bash
# This script checks the OS of the linux distribution and prints it out
. /etc/os-release
printf "This Linux distribution is %s And it's version is: %s"  $ID $VERSION_ID
 