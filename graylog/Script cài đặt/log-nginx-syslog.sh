#!/bin/bash 
# Cau hinh cho NGINX day log qua rsyslog

########

# Tao file /etc/rsyslog.d/nginx.conf

cat << EOF > /etc/rsyslog.d/nginx.conf

EOF# error log
$InputFileName /var/log/nginx/error.log
$InputFileTag nginx:
$InputFileStateFile stat-nginx-error
$InputFileSeverity error
$InputFileFacility local6
$InputFilePollInterval 1
$InputRunFileMonitor

# access log
$InputFileName /var/log/nginx/access.log
$InputFileTag nginx:
$InputFileStateFile stat-nginx-access
$InputFileSeverity notice
$InputFileFacility local6
$InputFilePollInterval 1
$InputRunFileMonitor
EOF

# Sua file /etc/rsyslog.conf
cp /etc/rsyslog.conf /etc/rsyslog.conf.orig

# Them dong moi
#sed -e  "s/\$ModLoad imklog   # provides kernel logging support/\$ModLoad imklog   # provides kernel logging support\n\
#\$ModLoad imfile # module log for Nginx/g"   /etc/rsyslog.conf

sed -i 's/\$ModLoad imklog   # provides kernel logging support/\$ModLoad imklog   # provides kernel logging support\n\
\$ModLoad imfile # module log for Nginx/g' /etc/rsyslog.conf
