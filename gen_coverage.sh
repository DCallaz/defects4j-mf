#!/bin/bash
green=`tput setaf 2;`
warn=`tput setaf 3`
err=`tput setaf 1`
reset=`tput sgr0`
project=$1
savedir=$2

if [ $# -lt 2 ]; then
  echo "USAGE: ./gen_coverage.sh <project> <save dir>"
  exit 1
fi

open_sem() {
  mkfifo pipe-$$
  exec 3<>pipe-$$
  rm pipe-$$
  local i=$1
  for((;i>0;i--)); do
    printf %s 000 >&3
  done
}

run_with_lock() {
  local x
  # this read waits until there is something to read
  read -u 3 -n 3 x && ((0==x)) || exit $x
  (
   ( "$@"; )
  # push the return code of the command to the semaphore
  printf '%.3d' $? >&3
  )&
}

N=4
open_sem $N

#[ -d /root/fault_data/"$project"/ ] && rm -r /root/fault_data/"$project"/

#echo "Cloning all base projects..."
#for v in $(seq $3); do
  #[ -d /tmp/"$project-$v" ] && rm -r /tmp/"$project-$v"
  #if [ ! -d /tmp/"$project-$v" ]; then
    #python3.6 /root/workspace/checkout.py "$project-$v" -w /tmp/"$project-$v" &>/dev/null
  #fi
  #echo "$v"
#done
#echo "Done cloning"

versions="$(python3 dump_versions.py $project)"
#versions="$(cat $project.vers)"
for version in $versions; do
  if [ ! -d "$savedir/$project/$version" ]; then
    echo $version
    run_with_lock ./single_coverage.sh $project $version $savedir
  fi
done
wait
#rm -r /tmp/$project-*
