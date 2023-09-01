#!/bin/bash


STORAGE_CLASS="longhorn"




# -------------------------- utils Functions --------------------


print_result() {
  if [ "$2" = true ]; then
    echo -e "\e[32mPassed:\e[0m $1"  # Green color for passed
  else
    echo -e "\e[31mFailed:\e[0m $1"  # Red color for failed
  fi
}
