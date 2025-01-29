#!/bin/bash
green=`tput setaf 2;`
warn=`tput setaf 3`
err=`tput setaf 1`
reset=`tput sgr0`

if [ $# -lt 3 ]; then
  echo "USAGE: ./single_coverage.sh <project> <version> <savedir>"
  exit 0
fi

project=$1
version=$2
savedir=$3

tmpdir="$(mktemp -du /tmp/"$project-$version".XXXXXX)"
defects4j_multi checkout -p "$project" -v "$version" -w "$tmpdir" &>/dev/null
#check if all bugs are findable
#echo "${green}All bugs present, continuing...${reset}"
#collect coverage
cd "$tmpdir"
defects4j_multi coverage &> /dev/null
#move coverage to exposed data
mkdir -p "$savedir/$project/$version"
cp sfl/txt/* "$savedir/$project/$version/"
#inject faults into coverage
output=$(defects4j_multi identify -p $project -v $version -c "$savedir/$project/$version/")
if [ ! -z "$output" ]; then
  echo "${warn}$output${reset}"
fi
#echo "${green}$full succeeded${reset}"
rm -rf "$tmpdir"

#if [ -f /tmp/tempout_$version ]; then
  #tempout=$(cat /tmp/tempout_$version)
  #while [ ! -z "$tempout" ]; do
    #old_ver=$(echo "$version")
    #for missing in $tempout; do
      ##echo "Removing bug $missing from $version (not found in spectrum)"
      #if [ "$missing" == "$(echo $version | sed 's/.*-//')" ]; then
        #echo "${warn}Version bug $missing not found in $version${reset}"
        #rm -r /root/fault_data/"$project"/"$old_ver"
        #exit 0
      #fi
      #version=$(echo "$version" | sed "s/-$missing//")
    #done
    #rm -r /root/fault_data/"$project"/"$old_ver"
    #rm /tmp/tempout_$old_ver
    #coverage $version
    #if [ -f /tmp/tempout_$version ]; then
      #tempout=$(cat /tmp/tempout_$version)
    #else
      #unset tempout
    #fi
  #done
#fi
echo "${green}$version finished${reset}"
