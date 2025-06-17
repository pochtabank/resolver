#!/bin/bash

ass="/pool1/bird/as.txt"
resolved="/tmp/resolvedas.txt.temp"
resolved_uniq="/tmp/resolvedas.txt.temp_uniq"
prep="/pool1/bird/resolvedas.txt"

rm $prep

while read -r as; do
   printf "$(whois -h whois.radb.net -- '-i origin '$as'' | grep 'route:' | cut -d' ' -f11-)\n" >> $resolved
done < "$ass"

cat $resolved | uniq > $resolved_uniq

while read -r ip; do
   printf "route $ip reject;\n" >> $prep
done < "$resolved_uniq"

rm $resolved
rm $resolved_uniq

/etc/init.d/bird reload > /dev/null
