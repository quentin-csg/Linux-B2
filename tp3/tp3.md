# TP3 : Linux Hardening

## Sommaire

- [TP3 : Linux Hardening](#tp3--linux-hardening)
  - [Sommaire](#sommaire)
  - [0. Setup](#0-setup)
  - [1. Guides CIS](#1-guides-cis)
  - [2. Conf SSH](#2-conf-ssh)
  - [4. DoT](#4-dot)
  - [5. AIDE](#5-aide)

## 1. Guides CIS

🌞 **Suivre un guide CIS**

- vous devez faire :
  - la section 2.1
```
[quentin@tp3-secu ~]$  rpm -q chrony
chrony-4.3-1.el9.x86_64

[quentin@tp3-secu ~]$ grep -E "^(server|pool)" /etc/chrony.conf
pool 2.rocky.pool.ntp.org iburst

[quentin@tp3-secu ~]$ grep ^OPTIONS /etc/sysconfig/chronyd
OPTIONS="-F 2"

[quentin@tp3-secu ~]$ grep ^OPTIONS /etc/sysconfig/chronyd
OPTIONS="-u chrony"
```

  - les sections 3.1 3.2 et 3.3
```
[quentin@tp3-secu ~]$ grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && echo -e "\n -
IPv6 is enabled\n" || echo -e "\n - IPv6 is not enabled\n"

 -
IPv6 is enabled

---

[quentin@tp3-secu ~]$ ./audit.sh

- Audit Result:
 ** PASS **

 - System has no wireless NICs installed

---

[quentin@tp3-secu ~]$ ./audit.sh

- Audit Result:
 ** PASS **

 - Module "tipc" doesn't exist on the
system

---

[quentin@tp3-secu ~]$ ./audit.sh

- Audit Result:
 ** PASS **

 - "net.ipv4.ip_forward" is set to
"0" in the running configuration
 - "net.ipv4.ip_forward" is set to "0"
in "/etc/sysctl.d/60-netipv4_sysctl.conf"
 - "net.ipv4.ip_forward" is not set incorectly in
a kernel parameter configuration file
 - "net.ipv6.conf.all.forwarding" is set to
"0" in the running configuration
 - "net.ipv6.conf.all.forwarding" is set to "0"
in "/etc/sysctl.d/60-netipv6_sysctl.conf"
 - "net.ipv6.conf.all.forwarding" is not set incorectly in
a kernel parameter configuration file

---

[root@tp3-secu ~]# cat /etc/sysctl.d/60-netipv4_sysctl.conf

net.ipv4.ip_forward = 0

net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
[root@tp3-secu ~]#  {
 sysctl -w net.ipv4.conf.all.send_redirects=0
 sysctl -w net.ipv4.conf.default.send_redirects=0
 sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.route.flush = 1

[root@tp3-secu ~]# printf "
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
" >> /etc/sysctl.d/60-netipv4_sysctl.conf
[root@tp3-secu ~]# {
 sysctl -w net.ipv4.conf.all.accept_source_route=0
 sysctl -w net.ipv4.conf.default.accept_source_route=0
 sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.route.flush = 1
[root@tp3-secu ~]# printf "
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
" >> /etc/sysctl.d/60-netipv6_sysctl.conf
[root@tp3-secu ~]#  {
 sysctl -w net.ipv6.conf.all.accept_source_route=0
 sysctl -w net.ipv6.conf.default.accept_source_route=0
 sysctl -w net.ipv6.route.flush=1
}
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
net.ipv6.route.flush = 1


printf "
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

---

[root@tp3-secu ~]# {
 sysctl -w net.ipv4.conf.all.accept_redirects=0
 sysctl -w net.ipv4.conf.default.accept_redirects=0
 sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.route.flush = 1
[root@tp3-secu ~]# printf "
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
" >> /etc/sysctl.d/60-netipv6_sysctl.conf
[root@tp3-secu ~]# {
 sysctl -w net.ipv6.conf.all.accept_redirects=0
 sysctl -w net.ipv6.conf.default.accept_redirects=0
 sysctl -w net.ipv6.route.flush=1
}
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.route.flush = 1

---

[root@tp3-secu ~]# printf "
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
" >> /etc/sysctl.d/60-netipv4_sysctl.conf
[root@tp3-secu ~]#  {
 sysctl -w net.ipv4.conf.all.secure_redirects=0
 sysctl -w net.ipv4.conf.default.secure_redirects=0
 sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.route.flush = 1

---

[root@tp3-secu ~]#  printf "
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
" >> /etc/sysctl.d/60-netipv4_sysctl.conf
[root@tp3-secu ~]#  {
 sysctl -w net.ipv4.conf.all.log_martians=1
 sysctl -w net.ipv4.conf.default.log_martians=1
 sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
net.ipv4.route.flush = 1

---

[root@tp3-secu ~]#  printf "
net.ipv4.icmp_echo_ignore_broadcasts = 1
" >> /etc/sysctl.d/60-netipv4_sysctl.conf
[root@tp3-secu ~]#  {
 sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
 sysctl -w net.ipv4.route.flush=1
}
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.route.flush = 1

---

[root@tp3-secu ~]# printf "
net.ipv4.icmp_ignore_bogus_error_responses = 1
" >> /etc/sysctl.d/60-netipv4_sysctl.conf
[root@tp3-secu ~]# {
 sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
 sysctl -w net.ipv4.route.flush=1
}
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.route.flush = 1

---

[root@tp3-secu ~]# printf "
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
" >> /etc/sysctl.d/60-netipv4_sysctl.conf
[root@tp3-secu ~]# {
 sysctl -w net.ipv4.conf.all.rp_filter=1
 sysctl -w net.ipv4.conf.default.rp_filter=1
 sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.route.flush = 1

---

[root@tp3-secu ~]# printf "
net.ipv4.tcp_syncookies = 1
" >> /etc/sysctl.d/60-netipv4_sysctl.conf
[root@tp3-secu ~]# {
 sysctl -w net.ipv4.tcp_syncookies=1
 sysctl -w net.ipv4.route.flush=1
}
net.ipv4.tcp_syncookies = 1
net.ipv4.route.flush = 1

---

[root@tp3-secu ~]# printf "
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
" >> /etc/sysctl.d/60-netipv6_sysctl.conf
[root@tp3-secu ~]#  {
 sysctl -w net.ipv6.conf.all.accept_ra=0
 sysctl -w net.ipv6.conf.default.accept_ra=0
 sysctl -w net.ipv6.route.flush=1
}
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
net.ipv6.route.flush = 1
```


  - toute la section 5.2 Configure SSH Server
```
[quentin@tp3-secu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/ssh/sshd_config
/etc/ssh/sshd_config 600 0/root 0/root

---

[quentin@tp3-secu ~]$ ./test.sh
find: ‘/etc/ssh/sshd_config.d’: Permission denied

- Audit Result:
 *** PASS ***

---

[quentin@tp3-secu ~]$ sudo ./remediation.sh
 - Checking private key file: "/etc/ssh/ssh_host_ed25519_key.pub"
 - File: "/etc/ssh/ssh_host_ed25519_key.pub" is owned by: "" changing
owner to "root"
 - File: "/etc/ssh/ssh_host_ed25519_key.pub" is owned by group ""
changing to group "root"
 - Checking private key file: "/etc/ssh/ssh_host_ecdsa_key.pub"
 - File: "/etc/ssh/ssh_host_ecdsa_key.pub" is owned by: "" changing
owner to "root"
 - File: "/etc/ssh/ssh_host_ecdsa_key.pub" is owned by group ""
changing to group "root"
 - Checking private key file: "/etc/ssh/ssh_host_rsa_key.pub"
 - File: "/etc/ssh/ssh_host_rsa_key.pub" is owned by: "" changing
owner to "root"
 - File: "/etc/ssh/ssh_host_rsa_key.pub" is owned by group ""
changing to group "root"

---

[quentin@tp3-secu ssh]$ sudo grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+(\h+.*)?$' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf
/etc/ssh/sshd_config:AllowUsers quentin

---

[quentin@tp3-secu ~]$ sudo cat /etc/ssh/sshd_config | grep LogLevel
LogLevel VERBOSE

---

[quentin@tp3-secu ~]$ sudo grep -Pi '^\h*UsePAM\b' /etc/ssh/sshd_config
UsePAM yes

---

[quentin@tp3-secu ~]$ sudo grep -Pi '^\h*PermitRootLogin\b' /etc/ssh/sshd_config
PermitRootLogin no

---

[quentin@tp3-secu ~]$ sudo grep -Pi '^\h*HostbasedAuthentication\b' /etc/ssh/sshd_config
HostbasedAuthentication no

---

[quentin@tp3-secu ~]$ sudo grep -Pi '^\h*PermitEmptyPasswords\b' /etc/ssh/sshd_config
PermitEmptyPasswords no

---

[quentin@tp3-secu ~]$ sudo grep -Pi '^\h*PermitUserEnvironment\b' /etc/ssh/sshd_config
PermitUserEnvironment no

---

[quentin@tp3-secu ~]$ sudo grep -Pi '^\h*ignorerhosts\b' /etc/ssh/sshd_config
IgnoreRhosts yes

---

[quentin@tp3-secu ~]$ sudo grep -Pi '^\h*X11Forwarding\b' /etc/ssh/sshd_config
X11Forwarding no

---

[quentin@tp3-secu ~]$ sudo grep -Pi '^\h*AllowTcpForwarding\b' /etc/ssh/sshd_config
AllowTcpForwarding no

---

[quentin@tp3-secu ~]$ sudo update-crypto-policies --show
DEFAULT

---

[quentin@tp3-secu ~]$ sudo cat /etc/ssh/sshd_config | grep Banner
Banner /etc/issue.net

---

[quentin@tp3-secu ~]$ sudo cat /etc/ssh/sshd_config | grep MaxAuthTries
MaxAuthTries 4

---

[quentin@tp3-secu ~]$ sudo grep -Ei '^\s*maxstartups\s+(((1[1-9]|[1-9][0-9][0-9]+):([0-9]+):([0-9]+))|(([0-9]+):(3[1-9]|[4-9][0-9]|[1-9][0-9][0-9]+):([0-9]+))|(([0-9]+):([0-9]+):(6[1-9]|[7-9][0-9]|[1-9][0-9][0-9]+)))' /etc/ssh/sshd_config
MaxStartups 10:30:60

---

[quentin@tp3-secu ~]$ sudo cat /etc/ssh/sshd_config | grep MaxSessions
MaxSessions 10

---

[quentin@tp3-secu ~]$ sudo cat /etc/ssh/sshd_config | grep LoginGraceTime
LoginGraceTime 60

---

[quentin@tp3-secu ~]$ sudo cat /etc/ssh/sshd_config | grep ClientAlive*
ClientAliveInterval 15
ClientAliveCountMax 3

```

  - au moins 10 points dans la section 6.1 System File Permissions
```
6.1.1 Ensure permissions on /etc/passwd are configured
[quentin@tp3-secu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/passwd
/etc/passwd 644 0/root 0/root

---

6.1.2 Ensure permissions on /etc/passwd- are configured
[quentin@tp3-secu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/passwd-
/etc/passwd- 644 0/root 0/root

---

6.1.3 Ensure permissions on /etc/group are configured
[quentin@tp3-secu ~]$  stat -Lc "%n %a %u/%U %g/%G" /etc/group
/etc/group 644 0/root 0/root

---

6.1.4 Ensure permissions on /etc/group- are configured
[quentin@tp3-secu ~]$  stat -Lc "%n %a %u/%U %g/%G" /etc/group-
/etc/group- 644 0/root 0/root

---

6.1.5 Ensure permissions on /etc/shadow are configured 
[quentin@tp3-secu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/shadow
/etc/shadow 0 0/root 0/root

---

6.1.6 Ensure permissions on /etc/shadow- are configured
[quentin@tp3-secu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/shadow-
/etc/shadow- 0 0/root 0/root

---

6.1.7 Ensure permissions on /etc/gshadow are configured
[quentin@tp3-secu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/gshadow
/etc/gshadow 0 0/root 0/root

---

6.1.8 Ensure permissions on /etc/gshadow- are configured
[quentin@tp3-secu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/gshadow-
/etc/gshadow- 0 0/root 0/root

---

6.1.11 Ensure no ungrouped files or directories exist
[quentin@tp3-secu ~]$ sudo df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup 2>/dev/n
ull

---

6.1.13 Audit SUID executables
[quentin@tp3-secu ~]$ sudo df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -40
00 2>/dev/null
/usr/bin/chage
/usr/bin/gpasswd
/usr/bin/newgrp
/usr/bin/su
/usr/bin/mount
/usr/bin/umount
/usr/bin/crontab
/usr/bin/passwd
/usr/bin/sudo
/usr/sbin/pam_timestamp_check
/usr/sbin/unix_chkpwd
/usr/sbin/grub2-set-bootflag

---

6.1.14 Audit SGID executables
[quentin@tp3-secu ~]$ sudo df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -20
00 2>/dev/null
/usr/bin/write
/usr/libexec/utempter/utempter
/usr/libexec/openssh/ssh-keysign

```

  - au moins 10 points ailleur sur un truc que vous trouvez utile
```
1.6.1.1 Ensure SELinux is installed
[quentin@tp3-secu ~]$ rpm -q libselinux
libselinux-3.5-1.el9.x86_64

---

1.1.1.1 Ensure mounting of squashfs filesystems is disabled
[quentin@tp3-secu ~]$ ./audit.sh

- Audit Result:
 ** PASS **

 - Module "squashfs" doesn't exist on the
system

---

1.3.1 Ensure AIDE is installed
[quentin@tp3-secu ~]$ sudo aide --init
Start timestamp: 2024-01-15 22:45:39 +0100 (AIDE 0.16)
AIDE initialized database at /var/lib/aide/aide.db.new.gz

Number of entries:      33210

---------------------------------------------------
The attributes of the (uncompressed) database(s):
---------------------------------------------------

/var/lib/aide/aide.db.new.gz
  MD5      : U4PNg58VrBhUX0ddLUNhcA==
  SHA1     : oSTMeoYubVoDKuyAGhHy2OnmkPo=
  RMD160   : gAR4MXR+B23oyUvTetpBPlH3YXA=
  TIGER    : Rpz86bMLNTVFCWLs9SnmbL15dvCu83O/
  SHA256   : Vh6zWNll+6sUoju/r91Jmv4tFKHZiUyG
             dAvg/6poPVA=
  SHA512   : LlltB8OA+cfX4XoO/fjY5KFq4WbSKXkd
             sosGxi9doLobTzUvvFgh3CWPsYhn3j6I
             nE7WMyqPmC56FpOrHpY4Mg==


End timestamp: 2024-01-15 22:46:42 +0100 (run time: 1m 3s)
[quentin@tp3-secu ~]$ rpm -q aide
aide-0.16-100.el9.x86_64

---

1.4.1 Ensure bootloader password is set
[quentin@tp3-secu ~]$ sudo awk -F. '/^\s*GRUB2_PASSWORD/ {print $1"."$2"."$3}' /boot/grub2/user.cfg
GRUB2_PASSWORD=grub.pbkdf2.sha512

---

1.4.2 Ensure permissions on bootloader config are configured
[quentin@tp3-secu ~]$ sudo stat -Lc "%n %#a %u/%U %g/%G" /boot/grub2/grub.cfg
/boot/grub2/grub.cfg 0700 0/root 0/root
[quentin@tp3-secu ~]$ sudo stat -Lc "%n %#a %u/%U %g/%G" /boot/grub2/grubenv
/boot/grub2/grubenv 0600 0/root 0/root
[quentin@tp3-secu ~]$ sudo stat -Lc "%n %#a %u/%U %g/%G" /boot/grub2/user.cfg
/boot/grub2/user.cfg 0600 0/root 0/root

---

1.5.1 Ensure core dump storage is disabled
[quentin@tp3-secu ~]$ sudo grep -i '^\s*storage\s*=\s*none' /etc/systemd/coredump.conf
Storage=none

---

1.6.1.1 Ensure SELinux is installed
[quentin@tp3-secu ~]$ rpm -q libselinux
libselinux-3.5-1.el9.x86_64

---

2.3 Ensure telnet client, LDAP client, TFTP client and FTP client are not installed
[quentin@tp3-secu ~]$ rpm -q telnet
package telnet is not installed
[quentin@tp3-secu ~]$ rpm -q openldap-clients
package openldap-clients is not installed
[quentin@tp3-secu ~]$ rpm -q tftp
package tftp is not installed
[quentin@tp3-secu ~]$ rpm -q ftp
package ftp is not installed

---

6.2.8 Ensure root PATH Integrity
[quentin@tp3-secu ~]$ ./audit.sh
/root/.local/bin is not a directory
/root/bin is not a directory

---

6.2.9 Ensure root is the only UID 0 account 
[quentin@tp3-secu ~]$ sudo awk -F: '($3 == 0) { print $1 }' /etc/passwd
root

6.2.1 Ensure accounts in /etc/passwd use shadowed passwords
[quentin@tp3-secu ~]$ sudo awk -F: '($2 != "x" ) { print $1 " is not set to shadowed passwords "}' /etc/passwd

```


## 2. Conf SSH

🌞 **Chiffrement fort côté serveur**

- trouver une ressource de confiance (je veux le lien en compte-rendu)

https://www.ibm.com/docs/ja/ahts/4.4?topic=upgrades-configuring-ssh-server


- configurer le serveur SSH pour qu'il utilise des paramètres forts en terme de chiffrement (je veux le fichier de conf dans le compte-rendu)
  - conf dans le fichier de conf

[sshd_config](./sshd.config)

🌞 **Clés de chiffrement fortes pour le client**

- trouver une ressource de confiance (je veux le lien en compte-rendu)

https://linux-audit.com/using-ed25519-openssh-keys-instead-of-dsa-rsa-ecdsa/#:~:text=It%20is%20using%20an%20elliptic,be%20used%20together%20with%20OpenSSH.

- générez-vous une paire de clés qui utilise un chiffrement fort et une passphrase

```shell
ssh-keygen -t ed25519 #local
```
```shell
echo "publicKey" >> ~/.ssh/authorized_keys #vm
```

🌞 **Connectez-vous en SSH à votre VM avec cette paire de clés**

[connectionVerbose](./ssh-proof)

## 4. DoT

🌞 **Configurer la machine pour qu'elle fasse du DoT**

- installez `systemd-resolved` sur la machine pour ça
```
[quentin@tp3-secu ~]$ sudo systemctl status systemd-resolved | head -n 3
● systemd-resolved.service - Network Name Resolution
     Loaded: loaded (/usr/lib/systemd/system/systemd-resolved.service; enabled; preset: disabled)
     Active: active (running) since Thu 2024-01-18 15:47:02 CET; 1min 7s ago
```

- activez aussi DNSSEC tant qu'on y est
```
[quentin@tp3-secu ~]$ sudo cat /etc/systemd/resolved.conf | grep DNSSEC
DNSSEC=true
```

```
sudo ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

🌞 **Prouvez que les requêtes DNS effectuées par la machine...**

```
[quentin@tp3-secu ~]$ dig ynov.com

; <<>> DiG 9.16.23-RH <<>> ynov.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 46524
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;ynov.com.                      IN      A

;; ANSWER SECTION:
ynov.com.               214     IN      A       104.26.11.233
ynov.com.               214     IN      A       172.67.74.226
ynov.com.               214     IN      A       104.26.10.233

;; Query time: 13 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
;; WHEN: Thu Jan 18 16:15:37 CET 2024
;; MSG SIZE  rcvd: 85

[quentin@tp3-secu ~]$ sudo tcpdump -i enp0s3 src 1.1.1.1
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on enp0s3, link-type EN10MB (Ethernet), snapshot length 262144 bytes
16:15:37.456872 IP one.one.one.one.domain > tp3-secu.33446: 46524 3/0/1 A 104.26.11.233, A 172.67.74.226, A 104.26.10.233 (85)
16:15:37.538510 IP one.one.one.one.domain > tp3-secu.51770: 8749 NXDomain 0/0/0 (40)
16:15:37.551466 IP one.one.one.one.domain > tp3-secu.44246: 15180 1/0/0 PTR one.one.one.one. (67)
^C
3 packets captured
3 packets received by filter
0 packets dropped by kernel
```

## 5. AIDE

🌞 **Installer et configurer AIDE**

- configurez AIDE pour qu'il surveille (fichier de conf en compte-rendu)
  - le fichier de conf du serveur SSH
```
[quentin@tp3-secu ~]$ sudo cat /etc/aide.conf | grep ssh
# ssh
/etc/ssh/sshd_config$ CONTENT_EX
/etc/ssh/ssh_config$ CONTENT_EX
```
  - le fichier de conf du client chrony (le service qui gère le temps)
```
[quentin@tp3-secu ~]$ sudo cat /etc/aide.conf | grep chrony
/etc/chrony.conf$ CONTENT_EX
/etc/chrony.keys$ CONTENT_EX
```
  - le fichier de conf de `systemd-resolved`
```
[quentin@tp3-secu ~]$ sudo cat /etc/aide.conf | grep reso*
/etc/resolv.conf$ DATAONLY
/etc/systemd/resolved.conf CONTENT_EX
/etc/resolv.conf CONTENT_EX
```

🌞 **Scénario de modification**

- introduisez une modification dans le fichier de conf du serveur SSH
- montrez que AIDE peut la détecter
```
[quentin@tp3-secu ~]$ sudo aide --check
Start timestamp: 2024-01-19 12:35:15 +0100 (AIDE 0.16)
AIDE found differences between database and filesystem!!

Summary:
  Total number of entries:      33376
  Added entries:                0
  Removed entries:              0
  Changed entries:              1

---------------------------------------------------
Changed entries:
---------------------------------------------------

f   ...    .C... : /etc/ssh/sshd_config

---------------------------------------------------
Detailed information about changes:
---------------------------------------------------

File: /etc/ssh/sshd_config
  SHA512   : 0GW46NzfLxBQtAu3Lp7QjdROxWMDKYxg | 5XFsnFs+nzW4RrF9orCi22wUKMjYQaVk
             5CF8907j0UlZv0AXNymYhgQpeNY2SFHu | 44x8Qos76m01jLa3ezB0xZv2DoCu5A8t
             UjsDVHXYTcPC3ho0Mhl9Lw==         | Ug+9GBrNkfHsNy1r7uZHvA==


---------------------------------------------------
The attributes of the (uncompressed) database(s):
---------------------------------------------------

/var/lib/aide/aide.db.gz
  MD5      : 7XCrtfw3g2kHFTyVfZF5zA==
  SHA1     : BBlXboorbT+nq792Qs9pBSprA1E=
  RMD160   : LaTWuwThTdTmxNFRPa0YkJBQZrY=
  TIGER    : y9cRqUx+mgU6bruzlkzWT2l8Y/+ISa8w
  SHA256   : Lr928ly9Vu11z1teghD/eqPuDPD8YQaj
             V/nUsgQ7hbA=
  SHA512   : B7PWflNcfJvHVni4Uksyu0fdbtrgBArc
             0P1oS3kcP13zIljOBsWVL87UONG3mGIs
             KZSW2ZZio5Ln8GnHGt4Ahw==


End timestamp: 2024-01-19 12:35:22 +0100 (run time: 0m 7s)
```

🌞 **Timer et service systemd**

- créez un service systemd qui exécute un check AIDE
  - il faut créer un fichier `.service` dans le dossier `/etc/systemd/system/`
```
[quentin@tp3-secu ~]$ sudo cat /etc/systemd/system/aide.service
[Unit]
Description=Aide Check Service

[Service]
ExecStart=/home/quentin/check.sh

[Install]
WantedBy=default.target
```

- créez un timer systemd qui exécute un check AIDE toutes les 10 minutes
  - il faut créer un fichier `.timer` dans le dossier `/etc/systemd/system/`
```
[quentin@tp3-secu ~]$ sudo cat /etc/systemd/system/aide.timer
[Unit]
Description=Aide Check Timer

[Timer]
OnUnitActiveSec=60s
Unit=aide.service

[Install]
WantedBy=timers.target
```


```
[quentin@tp3-secu ~]$ sudo journalctl -u test.service -f
Jan 19 14:52:21 tp3-secu check.sh[2620]:   TIGER    : y9cRqUx+mgU6bruzlkzWT2l8Y/+ISa8w
Jan 19 14:52:21 tp3-secu check.sh[2620]:   SHA256   : Lr928ly9Vu11z1teghD/eqPuDPD8YQaj
Jan 19 14:52:21 tp3-secu check.sh[2620]:              V/nUsgQ7hbA=
Jan 19 14:52:21 tp3-secu check.sh[2620]:   SHA512   : B7PWflNcfJvHVni4Uksyu0fdbtrgBArc
Jan 19 14:52:21 tp3-secu check.sh[2620]:              0P1oS3kcP13zIljOBsWVL87UONG3mGIs
Jan 19 14:52:21 tp3-secu check.sh[2620]:              KZSW2ZZio5Ln8GnHGt4Ahw==
Jan 19 14:52:21 tp3-secu check.sh[2620]: End timestamp: 2024-01-19 14:52:21 +0100 (run time: 0m 10s)
Jan 19 14:52:21 tp3-secu systemd[1]: test.service: Main process exited, code=exited, status=5/NOTINSTALLED
Jan 19 14:52:21 tp3-secu systemd[1]: test.service: Failed with result 'exit-code'.
Jan 19 14:52:21 tp3-secu systemd[1]: test.service: Consumed 6.492s CPU time.
Jan 19 14:53:25 tp3-secu systemd[1]: Started Aide Check Service.
Jan 19 14:53:26 tp3-secu check.sh[2668]: File /var/log/aide/aide.log is locked by another process.
Jan 19 14:53:26 tp3-secu check.sh[2668]: Cannot open /var/log/aide/aide.log for writing
Jan 19 14:53:39 tp3-secu check.sh[2668]: Start timestamp: 2024-01-19 14:53:26 +0100 (AIDE 0.16)
Jan 19 14:53:39 tp3-secu check.sh[2668]: AIDE found differences between database and filesystem!!
Jan 19 14:53:39 tp3-secu check.sh[2668]: Summary:
Jan 19 14:53:39 tp3-secu check.sh[2668]:   Total number of entries:        33385
Jan 19 14:53:39 tp3-secu check.sh[2668]:   Added entries:                9
Jan 19 14:53:39 tp3-secu check.sh[2668]:   Removed entries:                0
Jan 19 14:53:39 tp3-secu check.sh[2668]:   Changed entries:                5
Jan 19 14:53:39 tp3-secu check.sh[2668]: ---------------------------------------------------
Jan 19 14:53:39 tp3-secu check.sh[2668]: Added entries:
Jan 19 14:53:39 tp3-secu check.sh[2668]: ---------------------------------------------------
Jan 19 14:53:39 tp3-secu check.sh[2668]: f++++++++++++++++: /etc/systemd/system/aide.service
Jan 19 14:53:39 tp3-secu check.sh[2668]: f++++++++++++++++: /etc/systemd/system/aide.timer
Jan 19 14:53:39 tp3-secu check.sh[2668]: d++++++++++++++++: /etc/systemd/system/default.target.wants
Jan 19 14:53:39 tp3-secu check.sh[2668]: l++++++++++++++++: /etc/systemd/system/default.target.wants/aide.service
Jan 19 14:53:39 tp3-secu check.sh[2668]: l++++++++++++++++: /etc/systemd/system/default.target.wants/aide.timer
Jan 19 14:53:39 tp3-secu check.sh[2668]: l++++++++++++++++: /etc/systemd/system/default.target.wants/test.service
Jan 19 14:53:39 tp3-secu check.sh[2668]: f++++++++++++++++: /etc/systemd/system/test.service
Jan 19 14:53:39 tp3-secu check.sh[2668]: f++++++++++++++++: /etc/systemd/system/test.timer
Jan 19 14:53:39 tp3-secu check.sh[2668]: l++++++++++++++++: /etc/systemd/system/timers.target.wants/test.timer
Jan 19 14:53:39 tp3-secu check.sh[2668]: ---------------------------------------------------
Jan 19 14:53:39 tp3-secu check.sh[2668]: Changed entries:
Jan 19 14:53:39 tp3-secu check.sh[2668]: ---------------------------------------------------
Jan 19 14:53:39 tp3-secu check.sh[2668]: f   ...    .C... : /etc/firewalld/zones/public.xml
Jan 19 14:53:39 tp3-secu check.sh[2668]: f   ...    .C... : /etc/firewalld/zones/public.xml.old
Jan 19 14:53:39 tp3-secu check.sh[2668]: f   ...    .C... : /etc/ssh/sshd_config
Jan 19 14:53:39 tp3-secu check.sh[2668]: f   ...    ....S : /etc/sudoers
Jan 19 14:53:39 tp3-secu check.sh[2668]: d   ...    n ... : /etc/systemd/system
Jan 19 14:53:39 tp3-secu check.sh[2668]: ---------------------------------------------------
Jan 19 14:53:39 tp3-secu check.sh[2668]: Detailed information about changes:
Jan 19 14:53:39 tp3-secu check.sh[2668]: ---------------------------------------------------
Jan 19 14:53:39 tp3-secu check.sh[2668]: File: /etc/firewalld/zones/public.xml
Jan 19 14:53:39 tp3-secu check.sh[2668]:   SHA512   : ExqOlJxabjl7NnEh3pNbCTI0wpXwD6Aa | 4t5Xq53xzrZ1XRmOmPU5yU4uRuJ44NzW
Jan 19 14:53:39 tp3-secu check.sh[2668]:              og9MNMEdsyfEFrS2/IjVLXYJkD+0Kt7C | 8K62ODMoF6gLFlngX9Txb/2/SzcnPNYw
Jan 19 14:53:39 tp3-secu check.sh[2668]:              HbX4CFGvfRD1tg4vYYy6rw==         | 4ZEy6viPvNMboIq/RBj0cQ==
Jan 19 14:53:39 tp3-secu check.sh[2668]: File: /etc/firewalld/zones/public.xml.old
Jan 19 14:53:39 tp3-secu check.sh[2668]:   SHA512   : 2ia3I+8+Av8NZp12SOf5nvABfeBwmYww | ExqOlJxabjl7NnEh3pNbCTI0wpXwD6Aa
Jan 19 14:53:39 tp3-secu check.sh[2668]:              t4vrll+LQe4RSmm5cnm+ft2RSnvxSVEE | og9MNMEdsyfEFrS2/IjVLXYJkD+0Kt7C
Jan 19 14:53:39 tp3-secu check.sh[2668]:              hAcIXdeAPnZ0ibX+dAnXgg==         | HbX4CFGvfRD1tg4vYYy6rw==
Jan 19 14:53:39 tp3-secu check.sh[2668]: File: /etc/ssh/sshd_config
Jan 19 14:53:39 tp3-secu check.sh[2668]:   SHA512   : 0GW46NzfLxBQtAu3Lp7QjdROxWMDKYxg | 5XFsnFs+nzW4RrF9orCi22wUKMjYQaVk
Jan 19 14:53:39 tp3-secu check.sh[2668]:              5CF8907j0UlZv0AXNymYhgQpeNY2SFHu | 44x8Qos76m01jLa3ezB0xZv2DoCu5A8t
Jan 19 14:53:39 tp3-secu check.sh[2668]:              UjsDVHXYTcPC3ho0Mhl9Lw==         | Ug+9GBrNkfHsNy1r7uZHvA==
Jan 19 14:53:39 tp3-secu check.sh[2668]: File: /etc/sudoers
Jan 19 14:53:39 tp3-secu check.sh[2668]:   SELinux  : system_u:object_r:etc_t:s0       | unconfined_u:object_r:etc_t:s0
Jan 19 14:53:39 tp3-secu check.sh[2668]: Directory: /etc/systemd/system
Jan 19 14:53:39 tp3-secu check.sh[2668]:   Linkcount: 9                                | 10
Jan 19 14:53:39 tp3-secu check.sh[2668]: ---------------------------------------------------
Jan 19 14:53:39 tp3-secu check.sh[2668]: The attributes of the (uncompressed) database(s):
Jan 19 14:53:39 tp3-secu check.sh[2668]: ---------------------------------------------------
Jan 19 14:53:39 tp3-secu check.sh[2668]: /var/lib/aide/aide.db.gz
Jan 19 14:53:39 tp3-secu check.sh[2668]:   MD5      : 7XCrtfw3g2kHFTyVfZF5zA==
Jan 19 14:53:39 tp3-secu check.sh[2668]:   SHA1     : BBlXboorbT+nq792Qs9pBSprA1E=
Jan 19 14:53:39 tp3-secu check.sh[2668]:   RMD160   : LaTWuwThTdTmxNFRPa0YkJBQZrY=
Jan 19 14:53:39 tp3-secu check.sh[2668]:   TIGER    : y9cRqUx+mgU6bruzlkzWT2l8Y/+ISa8w
Jan 19 14:53:39 tp3-secu check.sh[2668]:   SHA256   : Lr928ly9Vu11z1teghD/eqPuDPD8YQaj
Jan 19 14:53:39 tp3-secu check.sh[2668]:              V/nUsgQ7hbA=
Jan 19 14:53:39 tp3-secu check.sh[2668]:   SHA512   : B7PWflNcfJvHVni4Uksyu0fdbtrgBArc
Jan 19 14:53:39 tp3-secu check.sh[2668]:              0P1oS3kcP13zIljOBsWVL87UONG3mGIs
Jan 19 14:53:39 tp3-secu check.sh[2668]:              KZSW2ZZio5Ln8GnHGt4Ahw==
Jan 19 14:53:39 tp3-secu check.sh[2668]: End timestamp: 2024-01-19 14:53:39 +0100 (run time: 0m 13s)
Jan 19 14:53:39 tp3-secu systemd[1]: test.service: Main process exited, code=exited, status=5/NOTINSTALLED
Jan 19 14:53:39 tp3-secu systemd[1]: test.service: Failed with result 'exit-code'.
Jan 19 14:53:39 tp3-secu systemd[1]: test.service: Consumed 6.517s CPU time.
Jan 19 14:55:04 tp3-secu systemd[1]: Started Aide Check Service.
Jan 19 14:55:04 tp3-secu check.sh[2678]: File /var/log/aide/aide.log is locked by another process.
Jan 19 14:55:04 tp3-secu check.sh[2678]: Cannot open /var/log/aide/aide.log for writing
Jan 19 14:55:17 tp3-secu check.sh[2678]: Start timestamp: 2024-01-19 14:55:04 +0100 (AIDE 0.16)
Jan 19 14:55:17 tp3-secu check.sh[2678]: AIDE found differences between database and filesystem!!
Jan 19 14:55:17 tp3-secu check.sh[2678]: Summary:
Jan 19 14:55:17 tp3-secu check.sh[2678]:   Total number of entries:        33385
Jan 19 14:55:17 tp3-secu check.sh[2678]:   Added entries:                9
Jan 19 14:55:17 tp3-secu check.sh[2678]:   Removed entries:                0
Jan 19 14:55:17 tp3-secu check.sh[2678]:   Changed entries:                5
Jan 19 14:55:17 tp3-secu check.sh[2678]: ---------------------------------------------------
Jan 19 14:55:17 tp3-secu check.sh[2678]: Added entries:
Jan 19 14:55:17 tp3-secu check.sh[2678]: ---------------------------------------------------
Jan 19 14:55:17 tp3-secu check.sh[2678]: f++++++++++++++++: /etc/systemd/system/aide.service
Jan 19 14:55:17 tp3-secu check.sh[2678]: f++++++++++++++++: /etc/systemd/system/aide.timer
Jan 19 14:55:17 tp3-secu check.sh[2678]: d++++++++++++++++: /etc/systemd/system/default.target.wants
Jan 19 14:55:17 tp3-secu check.sh[2678]: l++++++++++++++++: /etc/systemd/system/default.target.wants/aide.service
Jan 19 14:55:17 tp3-secu check.sh[2678]: l++++++++++++++++: /etc/systemd/system/default.target.wants/aide.timer
Jan 19 14:55:17 tp3-secu check.sh[2678]: l++++++++++++++++: /etc/systemd/system/default.target.wants/test.service
Jan 19 14:55:17 tp3-secu check.sh[2678]: f++++++++++++++++: /etc/systemd/system/test.service
Jan 19 14:55:17 tp3-secu check.sh[2678]: f++++++++++++++++: /etc/systemd/system/test.timer
Jan 19 14:55:17 tp3-secu check.sh[2678]: l++++++++++++++++: /etc/systemd/system/timers.target.wants/test.timer
Jan 19 14:55:17 tp3-secu check.sh[2678]: ---------------------------------------------------
Jan 19 14:55:17 tp3-secu check.sh[2678]: Changed entries:
Jan 19 14:55:17 tp3-secu check.sh[2678]: ---------------------------------------------------
Jan 19 14:55:17 tp3-secu check.sh[2678]: f   ...    .C... : /etc/firewalld/zones/public.xml
Jan 19 14:55:17 tp3-secu check.sh[2678]: f   ...    .C... : /etc/firewalld/zones/public.xml.old
Jan 19 14:55:17 tp3-secu check.sh[2678]: f   ...    .C... : /etc/ssh/sshd_config
Jan 19 14:55:17 tp3-secu check.sh[2678]: f   ...    ....S : /etc/sudoers
Jan 19 14:55:17 tp3-secu check.sh[2678]: d   ...    n ... : /etc/systemd/system
Jan 19 14:55:17 tp3-secu check.sh[2678]: ---------------------------------------------------
Jan 19 14:55:17 tp3-secu check.sh[2678]: Detailed information about changes:
Jan 19 14:55:17 tp3-secu check.sh[2678]: ---------------------------------------------------
Jan 19 14:55:17 tp3-secu check.sh[2678]: File: /etc/firewalld/zones/public.xml
Jan 19 14:55:17 tp3-secu check.sh[2678]:   SHA512   : ExqOlJxabjl7NnEh3pNbCTI0wpXwD6Aa | 4t5Xq53xzrZ1XRmOmPU5yU4uRuJ44NzW
Jan 19 14:55:17 tp3-secu check.sh[2678]:              og9MNMEdsyfEFrS2/IjVLXYJkD+0Kt7C | 8K62ODMoF6gLFlngX9Txb/2/SzcnPNYw
Jan 19 14:55:17 tp3-secu check.sh[2678]:              HbX4CFGvfRD1tg4vYYy6rw==         | 4ZEy6viPvNMboIq/RBj0cQ==
Jan 19 14:55:17 tp3-secu check.sh[2678]: File: /etc/firewalld/zones/public.xml.old
Jan 19 14:55:17 tp3-secu check.sh[2678]:   SHA512   : 2ia3I+8+Av8NZp12SOf5nvABfeBwmYww | ExqOlJxabjl7NnEh3pNbCTI0wpXwD6Aa
Jan 19 14:55:17 tp3-secu check.sh[2678]:              t4vrll+LQe4RSmm5cnm+ft2RSnvxSVEE | og9MNMEdsyfEFrS2/IjVLXYJkD+0Kt7C
Jan 19 14:55:17 tp3-secu check.sh[2678]:              hAcIXdeAPnZ0ibX+dAnXgg==         | HbX4CFGvfRD1tg4vYYy6rw==
Jan 19 14:55:17 tp3-secu check.sh[2678]: File: /etc/ssh/sshd_config
Jan 19 14:55:17 tp3-secu check.sh[2678]:   SHA512   : 0GW46NzfLxBQtAu3Lp7QjdROxWMDKYxg | 5XFsnFs+nzW4RrF9orCi22wUKMjYQaVk
Jan 19 14:55:17 tp3-secu check.sh[2678]:              5CF8907j0UlZv0AXNymYhgQpeNY2SFHu | 44x8Qos76m01jLa3ezB0xZv2DoCu5A8t
Jan 19 14:55:17 tp3-secu check.sh[2678]:              UjsDVHXYTcPC3ho0Mhl9Lw==         | Ug+9GBrNkfHsNy1r7uZHvA==
Jan 19 14:55:17 tp3-secu check.sh[2678]: File: /etc/sudoers
Jan 19 14:55:17 tp3-secu check.sh[2678]:   SELinux  : system_u:object_r:etc_t:s0       | unconfined_u:object_r:etc_t:s0
Jan 19 14:55:17 tp3-secu check.sh[2678]: Directory: /etc/systemd/system
Jan 19 14:55:17 tp3-secu check.sh[2678]:   Linkcount: 9                                | 10
Jan 19 14:55:17 tp3-secu check.sh[2678]: ---------------------------------------------------
Jan 19 14:55:17 tp3-secu check.sh[2678]: The attributes of the (uncompressed) database(s):
Jan 19 14:55:17 tp3-secu check.sh[2678]: ---------------------------------------------------
Jan 19 14:55:17 tp3-secu check.sh[2678]: /var/lib/aide/aide.db.gz
Jan 19 14:55:17 tp3-secu check.sh[2678]:   MD5      : 7XCrtfw3g2kHFTyVfZF5zA==
Jan 19 14:55:17 tp3-secu check.sh[2678]:   SHA1     : BBlXboorbT+nq792Qs9pBSprA1E=
Jan 19 14:55:17 tp3-secu check.sh[2678]:   RMD160   : LaTWuwThTdTmxNFRPa0YkJBQZrY=
Jan 19 14:55:17 tp3-secu check.sh[2678]:   TIGER    : y9cRqUx+mgU6bruzlkzWT2l8Y/+ISa8w
Jan 19 14:55:17 tp3-secu check.sh[2678]:   SHA256   : Lr928ly9Vu11z1teghD/eqPuDPD8YQaj
Jan 19 14:55:17 tp3-secu check.sh[2678]:              V/nUsgQ7hbA=
Jan 19 14:55:17 tp3-secu check.sh[2678]:   SHA512   : B7PWflNcfJvHVni4Uksyu0fdbtrgBArc
Jan 19 14:55:17 tp3-secu check.sh[2678]:              0P1oS3kcP13zIljOBsWVL87UONG3mGIs
Jan 19 14:55:17 tp3-secu check.sh[2678]:              KZSW2ZZio5Ln8GnHGt4Ahw==
Jan 19 14:55:17 tp3-secu check.sh[2678]: End timestamp: 2024-01-19 14:55:17 +0100 (run time: 0m 13s)
Jan 19 14:55:17 tp3-secu systemd[1]: test.service: Main process exited, code=exited, status=5/NOTINSTALLED
Jan 19 14:55:17 tp3-secu systemd[1]: test.service: Failed with result 'exit-code'.
Jan 19 14:55:17 tp3-secu systemd[1]: test.service: Consumed 6.131s CPU time.
^C
```