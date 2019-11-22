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
	mkdir tsfolder; cd tsfolder
	
	videourl=$( echo $temp | sed -n '1p' | sed 's/^/http:/')
	wget -O m3u8file $videourl
	cat m3u8file | grep -E -o 'cbn.*' >ts_parts
	num_ts=$(cat ts_parts| wc -l)
	temp2=$(echo $videourl |grep -E -o 'http.*/live/')
	cat ts_parts| sed "s@^@$temp2@" >suffix
	seq -w $num_ts| sed 's@^@wget --user-agent="" -O @' | sed 's/$/.ts/' >prefix
	paste prefix suffix >gotit
	bash gotit
	cat *.ts >  ../"${filename}.ts"
	cd ..
	rm -f tsfolder/ 

fi

rm page
