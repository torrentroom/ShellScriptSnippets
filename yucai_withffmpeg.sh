#!/usr/bin/bash
read -p "Please input video related web url: " url
wget -O page $url
name=$(cat page | grep -E -o '<h1>.*</h1>' | sed 's@£º@_@g;s@¡°@_@g;s@¡±@_@g;s@Ø­@_@g;s@<h1>@@;s@</h1>@@;s@\ @@g')
time=$(cat page | grep -E -o '[0-9]{4}-[0-9]{2}-[0-9]{2}' | sed -n '1p' | sed 's@-@_@g')
filename=${name}_${time}
if temp=$(grep -E -o  '//ycalvod[^"]+mp4[^"]+' page )                                                    ¿¿
then
	videourl=$( echo $temp | sed -n '1p' | sed 's/^/http:/')
	wget -O ${filename}.mp4 $videourl

elif temp=$(grep -E -o '//[^"]+m3u8[^"]+' page)
then
	mkdir tsfolder; cd tsfolder
	
	videourl=$( echo $temp | sed -n '1p' | sed 's/^/http:/')
	wget -O m3u8file $videourl
	cat m3u8file | grep -E -o '/.*' >ts_parts
	num_ts=$(cat ts_parts| wc -l)
	temp2=$(echo $temp |grep -E -o 'http.*/live/)
	cat ts_parts| sed "s@^@$temp2@" >suffix
	seq -w $num_ts| sed 's@^@wget --user-agent="" -O @' | sed 's/$/.ts/' >prefix
	paste prefix suffix >gotit
	bash gotit
	cat *.ts ../${filename}.ts
	cd ..
	#rm -f tsfolder/ 
elif  temp=$(grep -E -o '//[^"]+mp4"' page) 
then
	videourl=$( echo $temp | sed -n '1p' | sed 's/^/"http:/')
        wget -O ${filename}.mp4 $videourl	

fi

rm page
ffmpeg -i $filename ${filename%.mp4}.mp3
