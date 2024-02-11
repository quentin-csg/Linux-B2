#!/bin/bash

# INSTALLATION PHASE

dnf install epel-release -y

pkg="vim"
if rpm -qa | grep $pkg
then
    echo "$pkg installed"
else
    dnf install $pkg -y
fi

pkg="fail2ban"
if rpm -qa | grep $pkg
then
    echo "$pkg installed"
else
    dnf install $pkg -y
fi

pkg="aide"
if rpm -qa | grep $pkg
then
    echo "$pkg installed"
else
    dnf install $pkg -y
fi


# KERNEL PHASE

chmod u-x,go-wx /etc/passwd
chown root:root /etc/passwd
chmod u-x,go-wx /etc/group
chown root:root /etc/group
chmod 0000 /etc/shadow
chown root:root /etc/shadow
chmod 440 /etc/sudoers
chown root:root /etc/sudoers
chmod 600 /etc/ssh/sshd_config
chown root:root /etc/ssh/sshd_config
chmod 644 /etc/profile
chown root:root /etc/profile
chmod 600 /etc/crontab
chown root:root /etc/crontab
chmod 644 /etc/hosts
chown root:root /etc/hosts
chmod 644 /etc/shells
chown root:root /etc/shells
chmod 600 /etc/securetty
chown root:root /etc/securetty

sed -i 's/OPTIONS="-F 2"/OPTIONS="-u chrony"/g' /etc/sysconfig/chronyd

dnf remove openldap-clients -y
dnf remove tftp -y
dnf remove ftp -y

printf "
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
" >> /etc/sysctl.d/60-netipv4_sysctl.conf
printf "
net.ipv4.ip_forward = 0
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

dnf install rsyslog -y
systemctl --now enable rsyslog
sed -i 's/#ForwardToSyslog=no/ForwardToSyslog=yes/g' /etc/systemd/journald.conf
systemctl restart rsyslog


# SSH + FAIL2BAN execution

username=$(who | tr ' ' '\n' | head -n1)

cp ./conf/sshd_config /etc/ssh/sshd_config
echo "AllowUsers $username" >> ./test.txt
systemctl restart sshd
systemctl enable fail2ban
systemctl start fail2ban
cp ./conf/jail.local /etc/fail2ban/jail.local


# NGINX INSTALLATION

dnf install nginx -y
systemctl enable nginx
systemctl start nginx

firewall-cmd --permanent --add-service=http
firewall-cmd --reload

echo "Entrez votre adresse IP :"
read ip
set -- $ip

echo "Entrez le nom que portera votre site web :"
read site
set -- $site

mkdir -p /var/www/$site/html
chown -R $username:$username /var/www/$site/html
echo "<p>This is a simple page</p>" > /var/www/$site/html/index.html
cp ./conf/conf_domain.conf /etc/nginx/conf.d/$site.conf

sed -i 's/server_name your_domain;/server_name '$site';/g' /etc/nginx/conf.d/$site.conf
sed -i 's|root    /var/www/your_domain/html;|root    /var/www/'$site'/html;|g' /etc/nginx/conf.d/$site.conf

echo ''$ip' '$site'' >> /etc/hosts

systemctl restart nginx

# DOT + AIDE CONFIGURATION

# DOT
dnf install systemd-resolved -y

sed -i 's/#DNS=/DNS=1.1.1.1/g' /etc/systemd/resolved.conf
sed -i 's/#Domains=/Domains=~/g' /etc/systemd/resolved.conf
sed -i 's/#DNSSEC/DNSSEC=yes/g' /etc/systemd/resolved.conf
sed -i 's/#DNSOverTLS/DNSOverTLS=yes/g' /etc/systemd/resolved.conf

ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sed -i 's/nameserver 127.0.0.53/nameserver 1.1.1.1/g' /etc/resolv.conf

systemctl restart systemd-resolved

# AIDE
dnf install aide -y
aide --init
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
aide --check


echo "connexion ssh port 4433"
echo "fail2ban configured, logs at /var/log/fail2ban.log or sudo fail2ban-client status"
echo "nginx configured, available at http://"$site" or http://"$ip""
echo "DNSOverTLS configured"
echo "AIDE configured : do aide --check and mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz for checking configuration files"