#!/bin/bash

NVIDIA_ENV="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only"
lspci=$(lspci | grep VGA)
IFS=$'\n' read -rd '' -a gpus <<< "$lspci"
env_string=""

for gpu in "${gpus[@]}"
do
  split=($(echo $gpu | awk '{split($0,a," VGA compatible controller: "); print a[1], a[2]}'))
  pci=$(echo ${split[0]} | sed 's/:/_/g' | sed 's/\./_/g' | awk '{print "pci-0000_"$0}')

  if [[ $(echo ${split[1]} | tr '[:upper:]' '[:lower:]') =~ "nvidia" ]]; then
    env_string="DRI_PRIME=$pci $NVIDIA_ENV"
    break
  elif [[ $(echo ${split[1]} | tr '[:upper:]' '[:lower:]') =~ "amd" ]]; then
    env_string="DRI_PRIME=$pci"
    break
  fi
done

echo $env_string
