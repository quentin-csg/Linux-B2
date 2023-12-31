# TP2 : Utilisation courante de Docker

## Sommaire

- [TP2 : Utilisation courante de Docker](#tp2--utilisation-courante-de-docker)
  - [Sommaire](#sommaire)
- [I. Commun à tous : PHP](#i-commun-à-tous--php)
- [II Dév. Python](#ii-dév-python)
- [II Admin. Maîtrise de la stack PHP](#ii-admin-maîtrise-de-la-stack-php)
- [II Secu. Big brain](#ii-secu-big-brain)

# I. Commun à tous : PHP

# TP2 Commun : Stack PHP

![PHP](./img/php.jpg)

*Copain PHP.*

**Droit au but : vous allez conteneuriser votre projet PHP Symfony.**

> *Installer MySQL et Apache sur votre machine avec WAMP/LAMP/MAMP c'est bien si on s'en passe non ?*

Le but donc :

➜ **avoir un seul `docker-compose.yml` qui lance tout**

- un conteneur avec Apache/PHP installés qui fait tourner votre code
- un conteneur base de données MySQL
- un conteneur PHPMyAdmin pour gérer la base

➜ **on utilise des images officielles dans l'idéal**

- on évite de rédiger des `Dockerfile` si on peut
- surtout si c'est des images officielles

➜ **donc pour bosser sur le projet :**

- `docker compose up`
- tu dév sur ta machine, ça s'exécute sur des conteneurs
- `docker compose down` quand t'as fini de dév, plus rien qui tourne

➜ **et surtout : juste un fichier `docker-compose.yml` à se partager au sein du groupe**

- quelques lignes
- pour avoir exactement le même environnement
- à la racine du projet dans le dépôt git c'est carré

## Sommaire

- [TP2 Commun : Stack PHP](#tp2-commun--stack-php)
  - [Sommaire](#sommaire)
- [0. Setup](#0-setup)
- [I. Packaging de l'app PHP](#i-packaging-de-lapp-php)

# 0. Setup

➜ **Dans le TP, l'emoji 📜 figurera à la fin de chaque partie pour t'indiquer quels fichiers tu dois rendre**

Bon, je vais pas y couper, et j'vais découvrir encore plein de trucs que j'ai ps envie de découvrir.

T'es un dév. Tu dév avec ta machine, ton OS. Donc ça veut dire...

➜ **Installer Docker sur votre PC**

- pas dans une VM quoi, sur ton PC
- doc officielle
- je préviens tout de suite pour les Windowsiens :
  - Docker nécessite soit WSL soit Hyper-V
  - je vous recommande WSL parce que Hyper-V il va péter votre VirtualBox
  - et même avec WSL, magic happens
  - on l'a vu en cours et premier TP, Docker, c'est une techno Linux...

> Même si j'étais dév sous Windows, je préférerai lancer moi-même une VM Linux et faire deux trois bails d'intégration pour que je puisse lancer des commandes `docker run` sur mon PC qui lance des conteneurs dans la VM. Je peux vous apprendre c'est pas compliqué, faut juste lancer la VM quand tu veux use Docker (au lieu de lancer Docker, ça revient au même quoi finalement, t'façon il lance un noyau Linux pour toi le bougre si tu le fais pas toi-même). J'suis ptet trop un hippie après hein.

![Docker on Windows](./img/docker_on_windows.jpg)

# I. Packaging de l'app PHP

🌞 **`docker-compose.yml`**

- genre `tp2/php/docker-compose.yml` dans votre dépôt git de rendu
- votre code doit être à côté dans un dossier `src` : `tp2/php/src/tous_tes_bails.php`
- s'il y a un script SQL qui est injecté dans la base à son démarrage, il doit être dans `tp2/php/sql/seed.sql`
  - on appelle ça "seed" une database quand on injecte le schéma de base et éventuellement des données de test
- bah juste voilà ça doit fonctionner : je git clone ton truc, je `docker compose up` et ça doit fonctionne :)
- ce serait cool que l'app affiche un truc genre `App is ready on http://localhost:80` truc du genre dans les logs !

➜ **Un environnement de dév local propre avec Docker**

- 3 conteneurs, donc environnement éphémère/destructible
- juste un **`docker-compose.yml`** donc facilement transportable
- TRES facile de mettre à jour chacun des composants si besoin
  - oh tiens il faut ajouter une lib !
  - oh tiens il faut une autre version de PHP !
  - tout ça c'est np




# II Dév. Python

## Sommaire

- [TP2 dév : packaging et environnement de dév local](#tp2-dév--packaging-et-environnement-de-dév-local)
  - [Sommaire](#sommaire)
- [I. Packaging](#i-packaging)
  - [1. Calculatrice](#1-calculatrice)
  - [2. Chat room](#2-chat-room)

# I. Packaging

## 1. Calculatrice

🌞 **Packager l'application de calculatrice réseau**

- packaging du serveur, pas le client
- créer un répertoire `calc_build/` dans votre dépôt git de rendu
- créer un `Dockerfile` qui permet de build l'image
- créer un `docker-compose.yml` qui permet de l'ancer un conteneur calculatrice
- écrire vitefé un `README.md` qui indique les commandes pour build et run l'app

🌞 **Environnement : adapter le code si besoin**

- on doit pouvoir choisir sur quel port écoute la calculatrice si on définit la variable d'environnement `CALC_PORT`
- votre code doit donc :
  - récupérer la valeur de la variable d'environnement `CALC_PORT` si elle existe
  - vous devez vérifier que c'est un entier
  - écouter sur ce port là
- ainsi, on peut choisir le port d'écoute comme ça avec `docker run` :

```bash
$ docker run -e CALC_PORT=6767 -d calc
```

🌞 **Logs : adapter le code si besoin**

- tous les logs de la calculatrice DOIVENT sortir en sortie standard
- en effet, il est courant qu'un conteneur génère tous ses logs en sortie standard
- on peut ensuite les consulter avec `docker logs`

📜 **Dossier `tp2/calc/` dans le dépôt git de rendu**

- `Dockerfile`
- `docker-compose.yml`
- `README.md`
- `calc.py` : le code de l'app calculatrice

## 2. Chat room

![Cat Whale](./img/cat_whale.png)

🌞 **Packager l'application de chat room**

- pareil : on package le serveur
- `Dockerfile` et `docker-compose.yml`
- code adapté :
  - logs en sortie standard
  - variable d'environnement `CHAT_PORT` pour le port d'écoute
  - variable d'environnement `MAX_USERS` pour limiter le nombre de users dans chaque room (ou la room s'il y en a qu'une)
- encore un README propre qui montre comment build et comment run (en démontrant l'utilisation des variables d'environnement)

📜 **Dossier `tp2/chat/` dans le dépôt git de rendu**

- `Dockerfile`
- `docker-compose.yml`
- `README.md`
- `chat.py` : le code de l'app chat room

➜ **J'espère que ces cours vous ont apporté du recul sur la relation client/serveur**

- deux programmes distincts, chacun a son rôle
  - le serveur
    - est le gardien de la logique, le maître du jeu, garant du respect des règles
    - c'est votre bébé vous le maîtrisez
    - opti et sécu en tête
  - le client c'est... le client
    - faut juste qu'il soit joooooli
    - garder à l'esprit que n'importe qui peut le modifier ou l'adapter
    - ou carrément dév son propre client
- y'a même des milieux comme le web, où les gars qui dév les serveurs (Apache, NGINX, etc) c'est pas DU TOUT les mêmes qui dévs les clients (navigateurs Web, `curl`, librairie `requests` en Python, etc)





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
