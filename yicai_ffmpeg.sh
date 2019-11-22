#!/data/data/com.termux/files/usr/bin/bash
read -p "Please input video related web url: " url
wget -O page $url
name=$(cat page | grep -E -o '<h1>.*</h1>' | sed 's@£º@_@g' | sed 's@£¿@@g' | sed 's@Ø­@_@g' | sed 's@£¬@_@g' | sed 's@¡°@@g' | sed 's@¡±@@' | sed 's@<h1>@@' | sed 's@</h1>@@')
time=$(cat page | grep -E -o '[0-9]{4}-[0-9]{2}-[0-9]{2}' | sed -n '1p' | sed 's@-@_@g')
filename=${name}_${time}
if  grep -q 'mp4?auth_key' page
then
	
	videourl=$(cat page | grep -E -o  '//ycalvod[^"]+mp4\?auth_key[^"]+' | sed -n '1p' |sed 's/^/http:/')
	wget -O "${filename}.mp4" $videourl

elif temp=$(grep -E -o '//[^"]+m3u8[^"]+' page)
then
	videourl=$( echo $temp | sed -n '1p' | sed 's/^/http:/')
	wget -O m3u8file $videourl
	ffmpeg -i m3u8file "${filename}.ts"

fi

rm page
