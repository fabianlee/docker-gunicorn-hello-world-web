#!/bin/bash
#
# Creates python venv and then activates it
#

# https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
(return 0 2>/dev/null) && sourced=1 || sourced=0
if [ $sourced -eq 0 ]; then
  echo "ERROR, this script is meant to be sourced"
  exit 1
fi

# create venv in the 'myvenv' directory or activate
[[ -f myvenv/bin/activate ]] || python3 -m venv myvenv && source myvenv/bin/activate

echo ""
echo "Run 'deactivate' to exit venv"
