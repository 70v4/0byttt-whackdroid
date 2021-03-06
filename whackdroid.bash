#!/data/data/com.termux/files/usr/bin/bash
# Source : https://github.com/zerobyte-id/0byttt-whackdroid
# By ZeroByte.ID Team

VERSION='1.1';
APPSDIR="/data/data/com.termux/files/usr/share/whackdroid";
CURL="/data/data/com.termux/files/usr/bin/curl";
TIMEOUT="/data/data/com.termux/files/usr/bin/timeout";

echo "       _           _     _         _   _ ";
echo " _ _ _| |_ ___ ___| |_ _| |___ ___|_|_| |";
echo "| | | |   | .'|  _| '_| . |  _| . | | . |";
echo "|_____|_|_|__,|___|_,_|___|_| |___|_|___|";
echo "--- V ${VERSION} - 0byte Termux Tool Project ---";
echo "---                by www.zerobyte.id ---";
echo "";
echo "### Web Cracking ###";
echo "[1] Webadmin Finder";
echo "[2] Reverse IP (Yougetsignal)";
echo "[3] Subdomain Enumeration";
echo "";
echo "[?] Help";
echo "[!] Upgrade";
echo "[0] Exit from Tools";
echo "";
echo -ne "select@number:-> ";
read MENU

if [[ ${MENU} == '!' ]];
then
	echo "[INFO] Upgrade...";
	LASTUPDATE=$(curl -s "https://raw.githubusercontent.com/zerobyte-id/0byttt-whackdroid/master/VERSION");
	if [[ ${LASTUPDATE} == ${VERSION} ]];
		then
		echo "[FAIL] Your version has been latest version!";
	else
		echo "[INFO] Updating...";
		whackdroid-update
	fi
elif [[ ${MENU} == '0' ]];
then
	exit
elif [[ ${MENU} == '?' ]];
then
	echo "[INFO] Help & Tools Information";
	echo "-- 0byttt is tools for cracking activity --";
	echo "-- Tools based on BASH Script on Termux  --";
	echo "-- Source privilege by ZeroByte.ID Team  --"
### ADMIN FINDER ###
elif [[ ${MENU} == '1' ]];
then
	echo "[*] Weblogin Finder";
	echo -ne "[?] Insert URL [http://example.com/] : ";
	read URL
	WEBLIB=$(echo ${URL} | sed 's|http://||g' | sed 's|https://||g' | sed 's|/||g');
	WEBDIR="${APPSDIR}/data/${WEBLIB}";
	mkdir ${WEBDIR}

	for PATH in $(cat /data/data/com.termux/files/usr/share/whackdroid/list/loginpath.lst);
	do
		URLS=${URL}/${PATH};
		HTTPCODE=`${TIMEOUT} -k 3 3 ${CURL} -s -o /dev/null -w "%{http_code}" "${URLS}"`;
		if [[ ${HTTPCODE} == "200" ]];
			then
			echo "[INFO][${HTTPCODE}] ${URLS} Found!";
			echo "[${HTTPCODE}] ${URLS}" >> ${WEBDIR}/path.txt;
			if [[ `${CURL} -s ${URLS} | grep '<input' | grep 'type'` =~ 'password' ]];
				then
				echo "[OK] Found a password form!";
				echo "[!] ${URLS}";
				echo -ne "[?] Wanna stop scanning? [y/n] : "
				read CHOOSE
				if [[ ${CHOOSE} == 'y' ]];
					then
					exit;
				fi
			fi
		elif [[ ${HTTPCODE} == "404" ]]; then
			echo "[INFO][${HTTPCODE}] ${URLS}";
		else
			echo "[INFO][${HTTPCODE}] ${URLS}";
			echo "[${HTTPCODE}] ${URLS}" >> ${WEBDIR}/path.txt;
		fi
	done
### REVERSE IP ###
elif [[ ${MENU} == '2' ]];
then
	echo "[*] Reverse IP";
	echo "[*] Powered by YouGetSignal";
	echo -ne "[?] Insert URL [example.com] : ";
	read URLD
	URL=$(echo ${URLD} | sed 's|http://||g' | sed 's|https://||g' | sed 's|/||g');
	REVIPWEBS=$(curl -s -X POST -F "remoteAddress=${URL}" -F "key=" "https://domains.yougetsignal.com/domains.php" | sed 's|\["|\nDomain |g' | sed 's|"|\n|g' | grep 'Domain' | awk '{print $2}');
	if [[ -z ${REVIPWEBS} ]];
		then
		echo "[BAD] Something wrong!";
	else
		echo "[*] Weblist :";
		i=0;
		for WEB in ${REVIPWEBS}
		do
			((i++));
			echo "[${i}]. ${WEB}";
		done
	fi
### SUBDOMAIN ENUMERATION ###
elif [[ ${MENU} == '3' ]];
then
	SUBDOMAINS=$(cat /data/data/com.termux/files/usr/share/whackdroid/list/subdomain.lst);
	HOSTCMD=$(command -v host);
	if [[ -z ${HOSTCMD} ]];
		then
		pkg install dnsutils
	fi
	echo "[*] Subdomain Enumeration";
	echo -ne "[?] Insert Domain [example.com] : ";
	read DOMAIN
	for SUB in ${SUBDOMAINS};
	do
		DNSIP=$(${HOSTCMD} "${SUB}.${DOMAIN}" | awk '{print $4}' | head -1 | grep [0-9]);
		if [[ ! -z ${DNSIP} ]];
			then
			echo "[OK] ${SUB}.${DOMAIN} => [${DNSIP}]";
		else
			echo "[BAD] ${SUB}.${DOMAIN}";
		fi
	done
else
	echo "[FAIL] Failed to open!";
fi
