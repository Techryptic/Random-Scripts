#!/bin/bash

#Grab all the ips from censys and convert those to dns, print the ones machine the search query.
#Made by Techryptic
# ./subdomains.sh google.com

searchquery=$1
http https://censys.io/ipv4/_search?q=$searchquery -o togrep.txt
grep "class=\"dns\" id=\"" togrep.txt >> tosed.txt
sed -i -e 's/        <span class=\"dns\" id=\"//g' tosed.txt
sed -i -e 's/\">//g' tosed.txt

#get page count
grep "<li><a href=\"/ipv4?q=$searchquery&amp;page=" togrep.txt | tail -1  >> maxpage.txt
maxpage=$(grep -o -P '(?<=page=).*(?=")' maxpage.txt > maxpage2.txt)
i=$(cat maxpage2.txt)
echo $i" max pages"
START=2
END=$i
for (( c=$START; c<=$END; c++ ))
do
   echo "Working on https://censys.io/ipv4/_search?q=$searchquery&page="$c
   http https://censys.io/ipv4/_search?q=$searchquery\&page=$c -o togrep$c.txt
   grep "class=\"dns\" id=\"" togrep$c.txt >> tosed.txt
   sed -i -e 's/        <span class=\"dns\" id=\"//g' tosed.txt
   sed -i -e 's/\">//g' tosed.txt
done
#check dns record
echo "Checking DNS records"
rm maxpage.txt maxpage2.txt togrep*

while read IP ; do
        LOOKUP_RES=$(nslookup $IP | sed -n 's/.*arpa.*name = \(.*\)/\1/p')
        echo "$LOOKUP_RES" | grep $searchquery | sed 's/.$//' >> subdomains.txt
done < tosed.txt
rm tosed*
echo "Completed! -Check subdomains.txt"
