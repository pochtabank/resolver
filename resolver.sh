#!/bin/bash

domains="/pool1/bird/domain.txt"
resolved="/tmp/resolved.txt.temp"
prep="/pool1/bird/resolved.txt"
rm $prep

while read -r domain; do
   #printf "#$domin\n" >> $resolved
   ipa=$(dig +short $domain | grep -v '\.$' | sed 's/"//g')
   if [ -n "$ipa" ]; then
   printf "$(dig +short $domain | grep -v '\.$' | sed 's/"//g')\n" >> $resolved
   fi
done < "$domains"

while read -r ip; do
   printf "route $ip/32 reject;\n" >> $prep
done < "$resolved"

rm $resolved

/etc/init.d/bird reload > /dev/null
