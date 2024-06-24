#!/bin/bash
USAGE="USAGE: ./setup.sh [-h] [<defects4j dir>]"
while getopts ":h" opt; do
  case ${opt} in
    h )
      echo "$USAGE"
      exit 0
      ;;
  esac
done
shift $((OPTIND -1))
home="$(dirname $0)/../../"
home="$(readlink -f "$(echo ${home/"~"/~})")"
if [ $# -lt 1 ]; then
  echo "Defects4J directory not given, installing locally..."
  git clone https://github.com/rjust/defects4j.git
  cd defects4j
  cpanm --installdeps .
  ./init.sh
  export PATH=$PATH:"$home"/defects4j/framework/bin
  d4j_dir="$home/defects4j"
  # check d4j installation
  $d4j_dir/framework/bin/defects4j info -p Lang &> /dev/null
  if [ $? -ne 0 ]; then
    echo "ERROR: Defects4J could not be installed, please install manually."
    exit 1
  fi
else
  d4j_dir="$1"
fi
cd "$d4j_dir"
git apply "$home"/defects4j_multi_with_jars.patch
$d4j_dir/framework/bin/defects4j_multi -h &> /dev/null
if [ $? -ne 0 ]; then
  echo "ERROR: Could not set up defects4j-mf properly, exiting..."
  exit 1
fi
cd "$home/fault_data"
tar -xjf multi.tar.bz2
$d4j_dir/framework/bin/defects4j_multi configure -f "$home/fault_data"
