#!/bin/bash

domains="/etc/bird/domain.txt"
resolved="/tmp/domain_resolved.txt.temp"
prep="/etc/bird/domain_resolved.txt"
rm $prep
yandex=77.88.8.8
google=8.8.8.8


is_ipv4_address() {
    local ip=$1
    # Check for the correct format (four octets separated by dots)
    if [[ ! $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 1 # Invalid format
    fi

    # Split the IP into octets and check their range
    IFS='.' read -r -a octets <<< "$ip"
    for octet in "${octets[@]}"; do
        if (( octet < 0 || octet > 255 )); then
            return 1 # Octet out of range
        fi
    done

    return 0 # Valid IP address
}

while read -r domain; do
   #printf "#$domin\n" >> $resolved
   ipa=$(dig +short $domain | grep -v '\.$' | sed 's/"//g')
   if [ -n "$ipa" ]; then
#yandex dns
   printf "$domain by yandex\n" >> $resolved
   printf "$(dig +short $domain @$yandex | grep -v '\.$' | sed 's/"//g')\n" >> $resolved
#google dns
   printf "$domain by google\n" >> $resolved
   printf "$(dig +short $domain @$google | grep -v '\.$' | sed 's/"//g')\n" >> $resolved
   fi
done < "$domains"

while read -r ip; do
   if is_ipv4_address "$ip"; then
      printf "route $ip/32 reject;\n" >> $prep
   else
      printf "#$ip\n" >> $prep
   fi
done < "$resolved"

rm $resolved

/etc/init.d/bird reload > /dev/null
