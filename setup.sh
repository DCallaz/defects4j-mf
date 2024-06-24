#!/bin/bash
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`
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
home="$(dirname $0)"
home="$(readlink -f "$(echo ${home/"~"/~})")"
echo "${green}defects4j-mf has been successfully installed!${reset}"
echo "Please add the following lines to your bashrc (or equivalent)"
echo "${yellow}export D4J_HOME=\"$d4j_dir\""
echo "export PATH=\"\$PATH:\$D4J_HOME\"${reset}"
exit 1
if [ $# -lt 1 ]; then
  echo "Defects4J directory not given, installing locally..."
  git clone https://github.com/rjust/defects4j.git
  cd defects4j
  cpanm --installdeps .
  ./init.sh
  export PATH=$PATH:"$home"/defects4j/framework/bin
  d4j_dir="$home/defects4j"
  # check d4j installation
  defects4j info -p Lang &> /dev/null
  if [ $? -ne 0 ]; then
    echo "ERROR: Defects4J could not be installed, please install manually."
    exit 1
  fi
else
  d4j_dir="$1"
fi
cd "$d4j_dir"
git apply "$home"/defects4j_multi_with_jars.patch
defects4j_multi -h &> /dev/null
if [ $? -ne 0 ]; then
  echo "ERROR: Could not set up defects4j-mf properly, exiting..."
  exit 1
fi
cd "$home/fault_data"
tar -xjf multi.tar.bz2
defects4j_multi configure -f "$home/fault_data"
echo "${green}defects4j-mf has been successfully installed!${reset}"
echo "Please run the following commands or add them to your bashrc (or equivalent):"
echo "${yellow}export D4J_HOME=\"$d4j_dir\""
echo "export PATH=\"\$PATH:\$D4J_HOME\"${reset}"
