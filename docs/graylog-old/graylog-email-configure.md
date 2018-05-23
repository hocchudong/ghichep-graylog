## Hướng dẫn cấu hình gửi email cảnh báo Graylog

### 1. Cấu hình Postfix email 
Cài đặt mail postfix :

```sh
apt-get install mailutils -y
```

Cấu hình mail postfix, chỉnh sửa file : /etc/postfix/main.cf

```sh
# See /usr/share/postfix/main.cf.dist for a commented, more complete version


# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
#myorigin = /etc/mailname

smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no
# sets gmail as relay
relayhost = [smtp.gmail.com]:587

#  use tls
smtp_use_tls=yes

# use sasl when authenticating to foreign SMTP servers
smtp_sasl_auth_enable = yes 

# path to password map file
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd

# list of CAs to trust when verifying server certificate
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

# eliminates default security options which are imcompatible with gmail
smtp_sasl_security_options = noanonymous
smtp_sasl_tls_security_options = noanonymous

# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = graylog-cuccntt.openstacklocal
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
#mydestination = localdomain, localhost, localhost.localdomain, localhost
mydestination = $myhostname, localhost.$mydomain, $mydomain
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
#inet_interfaces = all
inet_interfaces = loopback-only
inet_protocols = all
```

Tạo file chứa thông tin email dùng để xác thực : `vi /etc/postfix/sasl_passwd`

```sh
[smtp.gmail.com]:587 username:password
```
Thay `username:password` với email và password dùng để xác thực.

Cấu hình phân quyền và xác thực : 

```sh
postmap /etc/postfix/sasl_passwd
chown root:postfix /etc/postfix/sasl_passwd*
chmod 640 /etc/postfix/sasl_passwd*
service postfix restart
```

Cài đặt ca-certificate cho java cảnh báo của Graylog có thể gửi dưới dạng TLS hoặc SSL :

```sh
apt-get install --reinstall ca-certificates-java
update-ca-certificates -f
```

Gửi mail test : 

```
echo "This is a test." | mail -s "test message" manh.dinhvan@meditech.vn
```

Sau khi nhận được email test, tiến hành cấu hình email cảnh báo cho Graylog :

Tại file cấu hình graylog :  /etc/graylog/server/server.conf , sửa các thông tin như sau : 

```sh
# Email transport
transport_email_enabled = true
transport_email_hostname = smtp.gmail.com
transport_email_port = 587
transport_email_use_auth = true
transport_email_use_tls = true
transport_email_use_ssl = false
transport_email_auth_username = manhdinh1994@gmail.com
transport_email_auth_password = password
transport_email_subject_prefix = [graylog]
transport_email_from_email = manhdinh1994@gmail.com
```
Thay user, password với email và password của bạn.

Restart lại dịch vụ Graylog :

```sh
restart graylog-server
```

Cấu hình trên Graylog Web-interface :

![email](/imagesemail-00.png)

Các mục cần cấu hình cảnh báo :

![email](/imagesemail-01.png)

**1** : Tạo điều kiện cho cảnh báo, ví dụ muốn tạo 1 cảnh báo là khi Stream nhận nhiều hơn 10 bản tin về ssh fail trong vòng 5 phút cuối và đợi ít nhất 5 phút 
cho đến khi gửi một cảnh báo mới. Khi gửi cảnh báo thì chứa 2 bản tin cuối cùng của stream.

![email](/imagesemail-02.png)

**2** : Chọn loại Alert Callback và Add 

![email](/imagesemail-03.png)

**3** : Nhập User hoặc địa chỉ email mà bạn muốn cảnh báo được gửi đến.

![email](/imagesemail-04.png)

Khi Graylog nhận được trigger, email cảnh báo sẽ được gửi :

![email](/imagesemail-05.png)
