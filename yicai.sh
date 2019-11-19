#!/usr/bin/bash
read -p "Please input your number: " number
weburl=https://www.yicai.com/video/${number}.html
echo -e "YOur weburl looks like: " $weburl
wget -O page $weburl
name=$(cat page | grep -E -o '<h1>.*</h1>' | sed 's@£º@_@g;s@¡°@_@g;s@¡±@_@g;s@Ø­@_@g;s@<h1>@@;s@</h1>@@;s@\ @@g')
time=$(cat page | grep -E -o '[0-9]{4}-[0-9]{2}-[0-9]{2}' | sed -n '1p' | sed 's@-@_@g')
filename=${name}_${time}.mp4
url=$(cat page | grep -E -o "//[^']+mp4" | sed 's@^@http:@')
wget -O $filename $url
rm page
ffmpeg -i $filename ${filename%.mp4}.mp3
