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
# Dans /home/$USER/Documents/rendu-tp-linux-b2/tp2/php

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

> Ca se fait avec une option sur `docker run` ou son équivalent en syntaxe `docker-compose.yml`.

🌞 **No `root`**

- s'assurer que chaque conteneur n'utilise pas l'utilisateur `root`
- mais bien un utilisateur dédié
- on peut préciser avec une option du `run` sous quelle identité le processus sera lancé

> Je rappelle qu'un conteneur met en place **un peu** d'isolation, **mais le processus tourne concrètement sur la machine hôte**. Donc il faut bien que, sur la machine hôte, il s'exécute sous l'identité d'un utilisateur, comme n'importe quel autre processus.

# II. Reverse proxy buddy

On continue sur le sujet PHP !

On va ajouter un reverse proxy dans le mix !

## A. Simple HTTP setup

🌞 **Adaptez le `docker-compose.yml`** de [la partie précédente](./php.md)

- il doit inclure un quatrième conteneur : un reverse proxy NGINX
  - image officielle !
  - un volume pour ajouter un fichier de conf
- je vous file une conf minimale juste en dessous
- c'est le seul conteneur exposé (partage de ports)
  - il permet d'accéder soit à PHPMyAdmin
  - soit à votre site
- vous ajouterez au fichier `hosts` de **votre PC** (le client)
  - `www.supersite.com` qui pointe vers l'IP de la machine qui héberge les conteneurs
  - `pma.supersite.com` qui pointe vers la même IP (`pma` pour PHPMyAdmin)
  - en effet, c'est grâce au nom que vous saisissez que NGINX saura vers quel conteneur vous renvoyer !

> *Tu peux choisir un nom de domaine qui te plaît + on s'en fout, mais pense à bien adapter tous mes exemples par la suite si tu en choisis un autre.*

```nginx
server {
    listen       80;
    server_name  www.supersite.com;

    location / {
        proxy_pass   http://nom_du_conteneur_PHP;
    }
}

server {
    listen       80;
    server_name  pma.supersite.com;

    location / {
        proxy_pass   http://nom_du_conteneur_PMA;
    }
}
```

## B. HTTPS auto-signé

🌞 **HTTPS** auto-signé

- générez un certificat et une clé auto-signés
- adaptez la conf de NGINX pour tout servir en HTTPS
- la clé et le certificat doivent être montés avec des volumes (`-v`)
- la commande pour générer une clé et un cert auto-signés :

```bash
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -keyout www.supersite.com.key -out www.supersite.com.crt
```

> Vous pouvez générer deux certificats (un pour chaque sous-domaine) ou un certificat *wildcard* qui est valide pour `*.supersite.com` (genre tous les sous-domaines de `supersite.com`).

## C. HTTPS avec une CA maison

> **Vous pouvez jeter la clé et le certificat de la partie précédente :D**

On va commencer par générer la clé et le certificat de notre Autorité de Certification (CA). Une fois fait, on pourra s'en servir pour signer d'autres certificats, comme celui de notre serveur web.

Pour que la connexion soit trusted, il suffira alors d'ajouter le certificat de notre CA au magasin de certificats de votre navigateur sur votre PC.

Il vous faudra un shell bash et des commandes usuelles sous la main pour réaliser les opérations. Lancez une VM, ou ptet Git Bash, ou ptet un conteneur debian oneshot ?

🌞 **Générer une clé et un certificat de CA**

```bash
# mettez des infos dans le prompt, peu importe si c'est fake
# on va vous demander un mot de passe pour chiffrer la clé aussi
$ openssl genrsa -des3 -out CA.key 4096
$ openssl req -x509 -new -nodes -key CA.key -sha256 -days 1024  -out CA.pem
$ ls
# le pem c'est le certificat (clé publique)
# le key c'est la clé privée
```

Il est temps de générer une clé et un certificat que notre serveur web pourra utiliser afin de proposer une connexion HTTPS.

🌞 **Générer une clé et une demande de signature de certificat pour notre serveur web**

```bash
$ openssl req -new -nodes -out www.supersite.com.csr -newkey rsa:4096 -keyout www.supersite.com.key
$ ls
# www.supersite.com.csr c'est la demande de signature
# www.supersite.com.key c'est la clé qu'utilisera le serveur web
```

🌞 **Faire signer notre certificat par la clé de la CA**

- préparez un fichier `v3.ext` qui contient :

```ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = www.supersite.com
DNS.2 = www.tp7.secu
```

- effectuer la demande de signature pour récup un certificat signé par votre CA :

```bash
$ openssl x509 -req -in www.supersite.com.csr -CA CA.pem -CAkey CA.key -CAcreateserial -out www.supersite.com.crt -days 500 -sha256 -extfile v3.ext
$ ls
# www.supersite.com.crt c'est le certificat qu'utilisera le serveur web
```

🌞 **Ajustez la configuration NGINX**

- le site web doit être disponible en HTTPS en utilisant votre clé et votre certificat
- une conf minimale ressemble à ça :

```nginx
server {
    [...]
    # faut changer le listen
    listen 10.7.1.103:443 ssl;

    # et ajouter ces deux lignes
    ssl_certificate /chemin/vers/le/cert/www.supersite.com.crt;
    ssl_certificate_key /chemin/vers/la/clé/www.supersite.com.key;
    [...]
}
```

🌞 **Prouvez avec un `curl` que vous accédez au site web**

- depuis votre PC
- avec un `curl -k` car il ne reconnaît pas le certificat là

🌞 **Ajouter le certificat de la CA dans votre navigateur**

- vous pourrez ensuite visitez `https://web.tp7.b2` sans alerte de sécurité, et avec un cadenas vert
- il est nécessaire de joindre le site avec son nom pour que HTTPS fonctionne (fichier `hosts`)

> *En entreprise, c'est comme ça qu'on fait pour qu'un certificat de CA non-public soit trusted par tout le monde : on dépose le certificat de CA dans le navigateur (et l'OS) de tous les PCs. Evidemment, on utilise une technique de déploiement automatisé aussi dans la vraie vie, on l'ajoute pas à la main partout hehe.*
