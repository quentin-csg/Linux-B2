# TP2 : Utilisation courante de Docker

## Sommaire

- [TP2 : Utilisation courante de Docker](#tp2--utilisation-courante-de-docker)
  - [Sommaire](#sommaire)
- [I. Commun à tous : PHP](#i-commun-à-tous--php)
- [II Admin. Maîtrise de la stack PHP](#ii-admin-maîtrise-de-la-stack-php)

# I. Commun à tous : PHP

# I. Packaging de l'app PHP

🌞 **`docker-compose.yml`**

```shell
git clone https://gitlab.com/quentin_csg/rendu-tp-linux-b2.git # Dans /home/$USER/Documents
```

```shell
# Dans /home/$USER/Documents/rendu-tp-linux-b2/TP2/php

docker build . -t php:7.2-apache
docker compose up -d
```

# II Admin. Maîtrise de la stack PHP

## Sommaire

- [TP2 admins : PHP stack](#tp2-admins--php-stack)
  - [Sommaire](#sommaire)
- [I. Good practices](#i-good-practices)
- [II. Reverse proxy buddy](#ii-reverse-proxy-buddy)
  - [A. Simple HTTP setup](#a-simple-http-setup)
  - [B. HTTPS auto-signé](#b-https-auto-signé)
  - [C. HTTPS avec une CA maison](#c-https-avec-une-ca-maison)

# I. Good practices

🌞 **Limiter l'accès aux ressources**


- limiter la RAM que peut utiliser chaque conteneur à 1G
- limiter à 1CPU chaque conteneur

🌞 **No `root`**

- s'assurer que chaque conteneur n'utilise pas l'utilisateur `root`
- mais bien un utilisateur dédié
- on peut préciser avec une option du `run` sous quelle identité le processus sera lancé

```docker
# Dans le docker compose
deploy:
  resources:
    limits:
      cpus: "1"
      memory: 1000M
user: 'docker_user'
```

```
quentin@tp2:~/Documents/tp2$ docker stats --no-stream
CONTAINER ID   NAME               CPU %     MEM USAGE / LIMIT    MEM %     NET I/O       BLOCK I/O        PIDS
f923cf8deb5d   tp2-php_apache-1   0.02%     19.78MiB / 1000MiB   1.98%     3.43kB / 0B   38.5MB / 147kB   7
13efd8a4cbc8   tp2-phpmyadmin-1   0.00%     22.36MiB / 1000MiB   2.24%     3.68kB / 0B   41.2MB / 528kB   6
78fe8e1f33a8   tp2-mysql-1        0.88%     351.1MiB / 1000MiB   35.11%    7.48kB / 0B   103MB / 46.5MB   38
```

# II. Reverse proxy buddy

On continue sur le sujet PHP !

On va ajouter un reverse proxy dans le mix !

## A. Simple HTTP setup

🌞 **Adaptez le `docker-compose.yml`** de [la partie précédente](./php.md)

- il doit inclure un quatrième conteneur : un reverse proxy NGINX
  - image officielle !
```
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2/php$ docker pull nginx
```

  - un volume pour ajouter un fichier de conf
```
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2/php$ cat ./conf/nginx.conf
server {
    listen       80;
    server_name  www.supersite.com;
   
    location / {
        proxy_pass   http://php_apache;
    }
}  

server {
    listen       80;
    server_name  pma.supersite.com;

    location / {
        proxy_pass   http://phpmyadmin;
    }
}
```

```docker
# Dans docker compose
nginx:
    image: nginx:latest
    ports:
      - "8092:80"
    volumes:
      - ./conf:/etc/nginx/
    restart: always
```

- vous ajouterez au fichier `hosts` de **votre PC** (le client)
  - `www.supersite.com` qui pointe vers l'IP de la machine qui héberge les conteneurs
  - `pma.supersite.com` qui pointe vers la même IP (`pma` pour PHPMyAdmin)
```
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2/php$ cat /etc/hosts | grep supersite
172.17.0.1 www.supersite.com
172.17.0.1 pma.supersite.com
```

```
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2/php$ curl http://www.supersite.com:8080/
<h1>Site pas ouf</h1>
```

```
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2/php$ curl pma.supersite.com:8081 | grep phpmyadmin
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
<a href="./url.php?url=https%3A%2F%2Fwww.phpmyadmin.net%2F" target="_blank" rel="noopener noreferrer" class="logo">
```


## B. HTTPS auto-signé

🌞 **HTTPS** auto-signé

```
quentin@tp2:~/Documents/rendu-tp-linux-b2/tp2$ openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -keyout www.supersite.com.key -out www.supersite.com.crt
```

## C. HTTPS avec une CA maison

🌞 **Générer une clé et un certificat de CA**

```bash
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2$ openssl genrsa -des3 -out CA.key 4096

quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2$ openssl req -x509 -new -nodes -key CA.key -sha256 -days 1024  -out CA.pem

quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2$ ls
CA.key  CA.pem  php  tp2.md  www.supersite.com.crt  www.supersite.com.key
```

Il est temps de générer une clé et un certificat que notre serveur web pourra utiliser afin de proposer une connexion HTTPS.

🌞 **Générer une clé et une demande de signature de certificat pour notre serveur web**

```bash
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2$ openssl req -new -nodes -out www.supersite.com.csr -newkey rsa:4096 -keyout www.supersite.com.key

quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2$ ls www*
www.supersite.com.crt  www.supersite.com.csr  www.supersite.com.key
```

🌞 **Faire signer notre certificat par la clé de la CA**

```shell
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2$ cat v3.ext 
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = www.supersite.com
```

- effectuer la demande de signature pour récup un certificat signé par votre CA :

```bash
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2$ openssl x509 -req -in www.supersite.com.csr -CA CA.pem -CAkey CA.key -CAcreateserial -out www.supersite.com.crt -days 500 -sha256 -extfile v3.ext
Signature ok
subject=C = AU, ST = Some-State, O = Internet Widgits Pty Ltd
Getting CA Private Key
Enter pass phrase for CA.key:
```

🌞 **Ajustez la configuration NGINX**

```
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2/php/conf$ docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' php-php_apache-1
172.22.0.5
```

- le site web doit être disponible en HTTPS en utilisant votre clé et votre certificat

```shell
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2/php/conf$ cat nginx.conf 
server {
    server_name  www.supersite.com;
    listen       443 ssl;

    ssl_certificate /home/quentin/Documents/rendu-tp-linux-b2/TP2/www.supersite.com.crt
    ssl_certificate_key /home/quentin/Documents/rendu-tp-linux-b2/TP2/www.supersite.com.key

    location / {
        proxy_pass   http://php_apache;
    }
}

```

🌞 **Prouvez avec un `curl` que vous accédez au site web**

- avec un `curl -k` car il ne reconnaît pas le certificat là
```
quentin@tp2:~/Documents/rendu-tp-linux-b2/TP2/php$ curl -k https://www.supersite.com:8080/
<h1>Site pas ouf</h1>
```
