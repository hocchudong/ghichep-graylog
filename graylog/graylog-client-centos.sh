#!/bin/bash
echo "##### ENTER IP ADDRESS GRAYLOG SERVER (NHAP IP CUA GRAYLOG SERVER) #####"
read -r IP_GRAYLOG

# SAO LUU FILE /etc/rsyslog.d/50-default.conf
defaultconf=/etc/rsyslog.d/50-default.conf
test -f $defaultconf.bka || cp $defaultconf $defaultconf.bka

cat << EOF > /etc/rsyslog.d/50-default.conf
auth,authpriv.*                 /var/log/auth.log
kern.*                          -/var/log/kern.log
mail.*                          -/var/log/mail.log
mail.err                        /var/log/mail.err
news.crit                       /var/log/news/news.crit
news.err                        /var/log/news/news.err
news.notice                     -/var/log/news/news.notice
*.emerg                                :omusrmsg:*
daemon.*;mail.*;\\
        news.err;\\
        *.=debug;*.=info;\\
        *.=notice;*.=warn       |/dev/xconsole
\$template GRAYLOG,"<%pri%>1 %timegenerated:::date-rfc3339% %fromhost% %app-name% %procid% %msg%\n"
\$template GRAYLOGRFC5424,"<%pri%>%protocol-version% %timestamp:::date-rfc3339% %HOSTNAME% %app-name% %procid% %msg%\n"
$PreserveFQDN on
*.* @$IP_GRAYLOG:10514;GRAYLOG
EOF

echo "Restarting rsyslog"
service rsyslog restart
echo "##### COMPLETE SYSLOG FOR CLIENT (HOAN THANH CAU HINH RSYSLOG CHO CLIENT) #####"
