#!/usr/bin/bash

# download haixialiangan video of the cctv4
mkdir temp; cd temp
read -p "Please enter haixialiangan's url: " url
wget -O raw $url
videoCenterId=$(cat raw | grep -E -o 'videoCenterId[^)]+' | cut -d\" -f3)
m3u8_first=$(echo $videoCenterId | sed 's@^@http://hls.cntv.kcdnvip.com/asp/hls/main/0303000a/3/default/@' | sed 's@$@/main.m3u8\?maxbr\=2048@')
first_part=$(echo ${m3u8_first%/asp*})
wget -O m3u8_fist_file $m3u8_first
second_part=$(cat m3u8_fist_file | sed -n '$p')
m3u8_url=$(echo $first_part $second_part | sed 's@\ @@')
ts_url_prefix=${m3u8_url%/*}/
wget -O m3u8file_second $m3u8_url
cat m3u8file_second | grep 'ts' | sed "s@^@${ts_url_prefix}@" >tsurlist
tsnums=$(cat tsurlist | wc -l)
seq -w $tsnums | sed 's@^@wget -O @' | sed 's/$/.ts/' >prefix
paste  prefix tsurlist >gets.txt
bash gets.txt
timestamp=$(cat raw | grep '<title>' | grep -E -o '[0-9]{8}')
cat *.ts >../haixialiangan_${timestamp}.ts
cd ..
rm -rf temp/
