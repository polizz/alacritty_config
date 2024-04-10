#!/bin/bash

config_dir=~/.config
alacritty_config=${config_dir}/alacritty
alacritty_themes=${alacritty_config}/themes
curr_color_file=${alacritty_config}/curr_color

declare -a arr=($(ls -al ${alacritty_themes} | awk 'NR>3 { printf("%s ", $9) }'))

curr_color=$(cat ${curr_color_file} 2>/dev/null)

if [[ -z "$curr_color" ]]; then
   next_color=${arr[0]}
else
   len=${#arr[@]}
   for ((i = 0; i < len; i++));
   do
      # echo "Checking: ${arr[$i]} against: ${curr_color}"
      if [ "${arr[$i]}" == "$curr_color" ]; then
         if [ $((i+1)) -ge "$len" ]; then
            next_color="${arr[0]}"
         else
            next_color="${arr[$i+1]}"
         fi

         break
      fi
   done
fi

$(echo ${next_color} > "${curr_color_file}")
echo "Picking next color: ${next_color}"

cat ~/.config/alacritty/base.toml ~/.config/alacritty/themes/${next_color} > ~/.config/alacritty/alacritty.toml

