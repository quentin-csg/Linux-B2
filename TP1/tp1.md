# TP1 : Premiers pas Docker

## Sommaire

- [TP1 : Premiers pas Docker](#tp1--premiers-pas-docker)
  - [Sommaire](#sommaire)
- [0. Setup](#0-setup)
- [I. Init](#i-init)
- [II. Images](#ii-images)
- [III. Docker compose](#iii-docker-compose)

# I. Init

- [I. Init](#i-init)
  - [1. Installation de Docker](#1-installation-de-docker)
  - [2. Vérifier que Docker est bien là](#2-vérifier-que-docker-est-bien-là)
  - [3. sudo c pa bo](#3-sudo-c-pa-bo)
  - [4. Un premier conteneur en vif](#4-un-premier-conteneur-en-vif)
  - [5. Un deuxième conteneur en vif](#5-un-deuxième-conteneur-en-vif)

## 1. Installation de Docker

## 2. Vérifier que Docker est bien là

```bash
# est-ce que le service Docker existe ?
systemctl status docker

# si oui, on le démarre alors
sudo systemctl start docker

# voyons si on peut taper une commande docker
sudo docker info
sudo docker ps
```

## 3. sudo c pa bo

🌞 **Ajouter votre utilisateur au groupe `docker`**

- vérifier que vous pouvez taper des commandes `docker` comme `docker ps` sans avoir besoin des droits `root`

```
[quentin@localhost ~]$ sudo usermod -aG docker quentin
```
```
[quentin@tp1 ~]$ docker info | head -n 3
Client: Docker Engine - Community
 Version:    24.0.7
 Context:    default
```

## 4. Un premier conteneur en vif

🌞 **Lancer un conteneur NGINX**

```
[quentin@tp1 ~]$ docker run -d -p 9999:80 nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
af107e978371: Pull complete
336ba1f05c3e: Pull complete
8c37d2ff6efa: Pull complete
51d6357098de: Pull complete
782f1ecce57d: Pull complete
5e99d351b073: Pull complete
7b73345df136: Pull complete
Digest: sha256:bd30b8d47b230de52431cc71c5cce149b8d5d4c87c204902acf2504435d4b4c9
Status: Downloaded newer image for nginx:latest
daf7a393fbfd26fe2bf087e9ccb2178f8f109faacae2f14709f976239525cdbe
```

🌞 **Visitons**

- vérifier que le conteneur est actif avec une commande qui liste les conteneurs en cours de fonctionnement
```
[quentin@tp1 ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS
 NAMES
daf7a393fbfd   nginx     "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   0.0.0.0:9999->80/tcp, :::9999->80/tcp   lucid_kepler
```

- afficher les logs du conteneur
```
[quentin@tp1 ~]$ docker logs daf7a393fbfd
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2023/12/21 09:59:18 [notice] 1#1: using the "epoll" event method
2023/12/21 09:59:18 [notice] 1#1: nginx/1.25.3
2023/12/21 09:59:18 [notice] 1#1: built by gcc 12.2.0 (Debian 12.2.0-14)
2023/12/21 09:59:18 [notice] 1#1: OS: Linux 5.14.0-362.13.1.el9_3.x86_64
2023/12/21 09:59:18 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1073741816:1073741816
2023/12/21 09:59:18 [notice] 1#1: start worker processes
2023/12/21 09:59:18 [notice] 1#1: start worker process 29
```

- afficher toutes les informations relatives au conteneur avec une commande `docker inspect`
```
[quentin@tp1 ~]$ docker inspect lucid_kepler | head -n 7
[
    {
        "Id": "daf7a393fbfd26fe2bf087e9ccb2178f8f109faacae2f14709f976239525cdbe",
        "Created": "2023-12-21T09:59:13.725859739Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
```
- afficher le port en écoute sur la VM avec un `sudo ss -lnpt`
```
[quentin@tp1 ~]$ sudo ss -lnpt | grep 9999
LISTEN 0      4096         0.0.0.0:9999      0.0.0.0:*    users:(("docker-proxy",pid=3825,fd=4))
LISTEN 0      4096            [::]:9999         [::]:*    users:(("docker-proxy",pid=3830,fd=4))
```

- ouvrir le port `9999/tcp` (vu dans le `ss` au dessus normalement) dans le firewall de la VM
```
[quentin@tp1 ~]$ sudo firewall-cmd --add-port=9999/tcp --permanent
success
```

- depuis le navigateur de votre PC, visiter le site web sur `http://IP_VM:9999`
```
PS C:\Users\quentin1> curl 10.1.1.100:9999                                                                              

StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <title>Welcome to nginx!</title>
                    <style>
```

🌞 **On va ajouter un site Web au conteneur NGINX**

```nginx
[quentin@tp1 nginx]$ pwd
/home/quentin/nginx
[quentin@tp1 nginx]$ ls
index.html  site_nul.conf
```

```bash
docker run -d -p 9999:8080 -v /home/$USER/nginx/index.html:/var/www/html/index.html -v /home/$USER/nginx/site_nul.conf:/etc/nginx/conf.d/site_nul.conf nginx
```

🌞 **Visitons**

- vérifier que le conteneur est actif
```
[quentin@tp1 ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                               NAMES
d8447b9ff861   nginx     "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds   80/tcp, 0.0.0.0:9999->8080/tcp, :::9999->8080/tcp   agitated_payne
```

- visiter le site web depuis votre PC
```
PS C:\Users\quentin1> curl 10.1.1.100:9999


StatusCode        : 200
StatusDescription : OK
Content           : <h1>MEOOOW</h1>

RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 16
                    Content-Type: text/html
                    Date: Thu, 21 Dec 2023 10:50:46 GMT
                    ETag: "65841292-10"
                    Last-Modified: Thu, 21 Dec 2023 10...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 16], [Content-Type, text/html]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 16
```

## 5. Un deuxième conteneur en vif

🌞 **Lance un conteneur Python, avec un shell**
```
[quentin@tp1 ~]$ docker run -it python bash
Unable to find image 'python:latest' locally
latest: Pulling from library/python
bc0734b949dc: Already exists
b5de22c0f5cd: Pull complete
917ee5330e73: Pull complete
b43bd898d5fb: Pull complete
7fad4bffde24: Pull complete
d685eb68699f: Pull complete
107007f161d0: Pull complete
02b85463d724: Pull complete
Digest: sha256:3733015cdd1bd7d9a0b9fe21a925b608de82131aa4f3d397e465a1fcb545d36f
Status: Downloaded newer image for python:latest
```

🌞 **Installe des libs Python**


- installez deux libs, elles ont été choisies complètement au hasard (avec la commande `pip install`):
```
root@cde208508071:/home# pip install aiohttp

root@cde208508071:/home# pip install aioconsole
```

- tapez la commande `python` pour ouvrir un interpréteur Python
- taper la ligne `import aiohttp` pour vérifier que vous avez bien téléchargé la lib
```
root@cde208508071:/home# python
Python 3.12.1 (main, Dec 19 2023, 20:14:15) [GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import aiohttp
```

# II. Images

- [II. Images](#ii-images)
  - [1. Images publiques](#1-images-publiques)
  - [2. Construire une image](#2-construire-une-image)

## 1. Images publiques

🌞 **Récupérez des images**

- avec la commande `docker pull`
- récupérez :
  - l'image `python` officielle en version 3.11 (`python:3.11` pour la dernière version)
  ```
  [quentin@tp1 nginx]$ docker pull python:3.11
  ```

  - l'image `mysql` officielle en version 5.7
  ```
  [quentin@tp1 nginx]$ docker pull mysql:5.7
  ```
  
  - l'image `wordpress` officielle en dernière version
    - c'est le tag `:latest` pour récupérer la dernière version
    - si aucun tag n'est précisé, `:latest` est automatiquement ajouté
```
[quentin@tp1 nginx]$ docker pull wordpress
Using default tag: latest
```

  - l'image `linuxserver/wikijs` en dernière version
    - ce n'est pas une image officielle car elle est hébergée par l'utilisateur `linuxserver` contrairement aux 3 précédentes
    - on doit donc avoir un moins haut niveau de confiance en cette image
```
[quentin@tp1 nginx]$ docker pull linuxserver/wikijs:latest
```

- listez les images que vous avez sur la machine avec une commande `docker`
```
[quentin@tp1 nginx]$ docker images
REPOSITORY           TAG       IMAGE ID       CREATED       SIZE
debian               latest    2a033a8c6371   2 days ago    117MB
linuxserver/wikijs   latest    869729f6d3c5   5 days ago    441MB
mysql                5.7       5107333e08a8   8 days ago    501MB
python               latest    fc7a60e86bae   13 days ago   1.02GB
wordpress            latest    fd2f5a0c6fba   2 weeks ago   739MB
python               3.11      22140cbb3b0c   2 weeks ago   1.01GB
nginx                latest    d453dd892d93   8 weeks ago   187MB
```

🌞 **Lancez un conteneur à partir de l'image Python**

- lancez un terminal `bash` ou `sh`
- vérifiez que la commande `python` est installée dans la bonne version
```
[quentin@tp1 ~]$ docker run -it 22140cbb3b0c /bin/bash
root@793a82709ac1:/# python --version
Python 3.11.7
```

## 2. Construire une image

🌞 **Ecrire un Dockerfile pour une image qui héberge une application Python**

```
[quentin@tp1 python_app_build]$ cat Dockerfile
FROM debian

RUN apt update -y

RUN apt install python3 -y

RUN apt install python3-pip -y

RUN apt install python3-emoji -y

RUN mkdir /app

WORKDIR /app

COPY app.py /app/app.py

ENTRYPOINT ["python3" "app.py"]
```

```
[quentin@tp1 python_app_build]$ ls
Dockerfile  app.py
[quentin@tp1 python_app_build]$ pwd
/home/quentin/python_app_build
```

🌞 **Build l'image**

- déplace-toi dans ton répertoire de build `cd python_app_build`
```
[quentin@tp1 python_app_build]$ docker build . -t python_app:version_de_ouf
[+] Building 91.2s (13/13) FINISHED                                                                docker:default
 => [internal] load build definition from Dockerfile                                                         0.0s
 => => transferring dockerfile: 312B                                                                         0.0s
 => [internal] load .dockerignore                                                                            0.0s
 => => transferring context: 2B                                                                              0.0s
 => [internal] load metadata for docker.io/library/debian:latest                                             0.0s
 => [1/8] FROM docker.io/library/debian                                                                      0.0s
 => [internal] load build context                                                                            0.0s
 => => transferring context: 86B                                                                             0.0s
 => CACHED [2/8] RUN apt update -y                                                                           0.0s
 => CACHED [3/8] RUN apt install python3 -y                                                                  0.0s
 => [4/8] RUN apt install python3-pip -y                                                                    77.0s
 => [5/8] RUN apt install python3-emoji -y                                                                   3.9s
 => [6/8] RUN mkdir /app                                                                                     0.3s
 => [7/8] WORKDIR /app                                                                                       0.1s
 => [8/8] COPY app.py /app/app.py                                                                            0.1s
 => exporting to image                                                                                       9.8s
 => => exporting layers                                                                                      9.8s
 => => writing image sha256:f01a1d384baf625a0128f12c52bfc3e6b27d1ef316e5aea5d2a2cc2800e28f8f                 0.0s
 => => naming to docker.io/library/python_app:version_de_ouf
```

- une fois le build terminé, constater que l'image est dispo avec une commande `docker`
```
[quentin@tp1 python_app_build]$ docker images | grep python_app
python_app           version_de_ouf   f01a1d384baf   2 minutes ago   637MB
```

🌞 **Lancer l'image**

- lance l'image avec `docker run` :
```
[quentin@tp1 python_app_build]$ docker run python_app:version_de_ouf
Cet exemple d'application est vraiment naze 👎
```

# III. Docker compose

🌞 **Créez un fichier `docker-compose.yml`**

```
[quentin@tp1 compose_test]$ cat /home/quentin/compose_test/docker-compose.yml
version: "3"

services:
  conteneur_nul:
    image: debian
    entrypoint: sleep 9999
  conteneur_flopesque:
    image: debian
    entrypoint: sleep 9999
```

🌞 **Lancez les deux conteneurs** avec `docker compose`

- go exécuter `docker compose up -d`
```
[quentin@tp1 compose_test]$ docker compose up -d
[+] Running 3/3
 ✔ Network compose_test_default                  Created                                                     0.4s
 ✔ Container compose_test-conteneur_flopesque-1  Started                                                     0.2s
 ✔ Container compose_test-conteneur_nul-1        Started                                                     0.2s
```

🌞 **Vérifier que les deux conteneurs tournent**

```
[quentin@tp1 compose_test]$ docker compose ps
NAME                                 IMAGE     COMMAND        SERVICE               CREATED         STATUS         PORTS
compose_test-conteneur_flopesque-1   debian    "sleep 9999"   conteneur_flopesque   2 minutes ago   Up 2 minutes
compose_test-conteneur_nul-1         debian    "sleep 9999"   conteneur_nul         2 minutes ago   Up 2 minutes
```

🌞 **Pop un shell dans le conteneur `conteneur_nul`**

```
[quentin@tp1 compose_test]$ docker exec -it compose_test-conteneur_nul-1 /bin/bash
root@14c11f0281cf:/#
```

- effectuez un `ping conteneur_flopesque` (ouais ouais, avec ce nom là)
  - il faudra installer un paquet qui fournit la commande `ping` pour pouvoir tester
  ```
  root@14c11f0281cf:/# apt-get install iputils-ping -y
  ```

```
root@14c11f0281cf:/# ping compose_test-conteneur_flopesque-1
PING compose_test-conteneur_flopesque-1 (172.18.0.3) 56(84) bytes of data.
64 bytes from compose_test-conteneur_flopesque-1.compose_test_default (172.18.0.3): icmp_seq=1 ttl=64 time=0.067 ms
64 bytes from compose_test-conteneur_flopesque-1.compose_test_default (172.18.0.3): icmp_seq=2 ttl=64 time=0.131 ms
^C
--- compose_test-conteneur_flopesque-1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1056ms
rtt min/avg/max/mdev = 0.067/0.099/0.131/0.032 ms
```