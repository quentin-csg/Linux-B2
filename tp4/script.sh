#!/bin/bash


packages () {
    echo "salut from function"
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

    pkg="chrony"
    if rpm -qa | grep $pkg
    then
        echo "$pkg installed"
    else
        dnf install $pkg -y
    fi
}


permissions () {
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
}

icmp_redirect () {
    printf "
        net.ipv4.conf.all.accept_redirects = 0
        net.ipv4.conf.default.accept_redirects = 0
        " >> /etc/sysctl.d/60-netipv4_sysctl.conf
}

secure_icmp_redirect () {
    printf "
        net.ipv4.conf.all.secure_redirects = 0
        net.ipv4.conf.default.secure_redirects = 0
        " >> /etc/sysctl.d/60-netipv4_sysctl.conf
}

ip_forward () {
    printf "
        net.ipv4.conf.all.accept_source_route = 0
        net.ipv4.conf.default.accept_source_route = 0
        " >> /etc/sysctl.d/60-netipv4_sysctl.conf

    printf "
        net.ipv4.ip_forward = 0
        " >> /etc/sysctl.d/60-netipv4_sysctl.conf
}

packet_redirect () {
    printf "
    net.ipv4.conf.all.send_redirects = 0
    net.ipv4.conf.default.send_redirects = 0
    " >> /etc/sysctl.d/60-netipv4_sysctl.conf
}

syslog () {
    dnf install rsyslog -y
    systemctl --now enable rsyslog
    sed -i 's/#ForwardToSyslog=no/ForwardToSyslog=yes/g' /etc/systemd/journald.conf
    systemctl restart rsyslog
}

chrony () {
    sed -i 's/OPTIONS="-F 2"/OPTIONS="-u chrony"/g' /etc/sysconfig/chronyd
    systemctl enable chronyd
    systemctl start chronyd
}

selinux () {
    dnf install selinux-policy-targeted selinux-policy-devel -y
    sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

}



SSH () {

    echo "Copier coller votre clé publique ici :"
    read pubkey
    set -- $pubkey

    mkdir /home/$username/.ssh
    touch /home/$username/.ssh/authorized_keys
    echo $pubkey >> /home/$username/.ssh/authorized_keys

    systemctl restart sshd

    chmod 600 "/home/"$username"/.ssh/authorized_keys"
    chmod 700 "/home/"$username"/.ssh/"


    cp ./conf/sshd_config /etc/ssh/sshd_config
    echo "AllowUsers $username" >> /etc/ssh/sshd_config

    systemctl restart sshd
}


Fail2Ban () {
    systemctl enable fail2ban
    systemctl start fail2ban
    cp ./conf/jail.local /etc/fail2ban/jail.local
    mv /etc/fail2ban/jail.d/00-firewalld.conf /etc/fail2ban/jail.d/00-firewalld.local
    systemctl restart fail2ban
}


Nginx () {
    dnf install nginx -y
    systemctl enable nginx
    systemctl start nginx

    echo "Enter your IP address :"
    read ip
    set -- $ip

    echo "Choose the name of your website :"
    read site
    set -- $site

    echo "certificate creation"
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -keyout $site.key -out $site.crt

    mkdir -p /var/www/$site/html
    chown -R $username:$username /var/www/$site/html
    echo "<p>This is a simple page</p>" > /var/www/$site/html/index.html
    cp ./conf/conf_domain.conf /etc/nginx/conf.d/$site.conf


    sed -i 's/server_name your_domain;/server_name '$site';/g' /etc/nginx/conf.d/$site.conf
    sed -i 's|root /var/www/your_domain/html;|root /var/www/'$site'/html;|g' /etc/nginx/conf.d/$site.conf
    sed -i '0,/listen/s//listen '$ip':80;/' /etc/nginx/conf.d/$site.conf

    sed -i 's|ssl_certificate_key|ssl_certificate_key /'$path'/'$site'.key;|g' /etc/nginx/conf.d/$site.conf
    sed -i '/ssl_certificate_key/i \ \ \ \ ssl_certificate \/home\/quentin\/'$site'.crt;' /etc/nginx/conf.d/$site.conf


    echo ''$ip' '$site'' >> /etc/hosts
    systemctl restart nginx
}


DOT () {
    dnf install systemd-resolved -y
    systemctl enable systemd-resolved
    systemctl start systemd-resolved

    cp ./conf/resolved.conf /etc/systemd/resolved.conf

    systemctl restart systemd-resolved
    ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
}


AIDE () {
    dnf install aide -y
    aide --init
    mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
    aide --check
}


Firewall () {
    systemctl start firewalld
    firewall-cmd --add-service=http --permanent
    firewall-cmd --add-service=https --permanent
    firewall-cmd --add-port=4433/tcp --permanent
    firewall-cmd --reload
}


Information () {
    echo "ssh connexion port 4433 with rsa key"
    echo "fail2ban configured, logs at /var/log/fail2ban.log or sudo fail2ban-client status"
    echo "nginx configured, available at http://"$site" or http://"$ip""
    echo "DNSOverTLS configured"
    echo "AIDE configured : do aide --check and mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz for checking configuration files"
}

username=$(who | tr ' ' '\n' | head -n1)
path=$(pwd)
dnf update -y
dnf upgrade -y
dnf install epel-release -y
dnf remove openldap-clients -y
dnf remove tftp -y
dnf remove ftp -y
packages
permissions
icmp_redirect
secure_icmp_redirect
ip_forward
packet_redirect
syslog
chrony
selinux
SSH
Fail2Ban
Nginx
DOT
AIDE
Firewall
Information