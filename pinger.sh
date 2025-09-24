#!/bin/bash
input="/root/ip.txt"
while IFS= read -r line
do
  #echo "$line"
  for g in ${line}; do
    result=$(ping -c 2 -W 1 -q $g | grep transmitted)
    pattern="0 received";
        if [[ $result =~ $pattern ]]; then
            #while [[ $result =~ $pattern ]]
                #do
                #result=$(ping -c 2 -W 1 -q $g | grep transmitted)
                #echo "$result"
            #done
            #echo "$g is down"
            wget -qO - "https://api.telegram.org/bot***************/sendMessage?chat_id=********&text=wg_"$g"_down"
        #else
             #echo "$g is up"
        fi
done
done < "$input"
