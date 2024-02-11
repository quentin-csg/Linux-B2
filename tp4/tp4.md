# TP4 : Hardening Script

## Sommaire

- [TP4 : Hardening Script](#tp4--hardening-script)
  - [Sommaire](#sommaire)
- [I. Setup initial](#i-setup-initial)
- [II. Hardening script](#ii-hardening-script)

# I. Setup initial

| Machine      | IP          | Rôle                       |
| ------------ | ----------- | -------------------------- |
| `rp.tp5.b2`  | `10.5.1.11` | reverse proxy (NGINX)      |
| `web.tp5.b2` | `10.5.1.12` | serveur Web (NGINX oci) |

🌞 **Setup `web.tp5.b2`**

- préparation du site web
  - choisissez des permissions adéquates pour le dossier et le fichier
```
[quentin@web ~]$ sudo chown -R nginx:nginx /var/www/app_nulle
```

- ajouter un fichier de conf NGINX dans `/etc/nginx/conf.d/` pour servir le dossier `/var/www/app_nulle/` sur le port 80
```
server {
        listen 80;
        listen [::]:80;

        root /var/www/app_nulle;
        index index.html index.htm index.nginx-debian.html;

        server_name app.tp4.b2;

        location / {
                index index.html;
        }
}
```

🌞 **Setup `rp.tp5.b2`**

- ajouter un fichier de conf NGINX dans `/etc/nginx/conf.d/` pour proxy vers `http://10.5.1.12`

```nginx
server {
    listen    80;
    server_name   app.tp4.b2;

    location / {
        proxy_pass http://10.5.1.12;
    }
}
```

```
PS C:\Users\quentin1> curl http://app.tp4.b2                                                                                

StatusCode        : 200
StatusDescription : OK
Content           : <h1>Site nul</h1>

RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 18
                    Content-Type: text/html
                    Date: Fri, 19 Jan 2024 09:58:14 GMT
                    ETag: "65aa39f9-12"
                    Last-Modified: Fri, 19 Jan 2024 08...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 18], [Content-Type, text/html]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 18
```


🌞 **HTTPS `rp.tp5.b2`**

- mettez en place du HTTPS avec le reverse proxy afin de proposer une connexion sécurisée aux clients
- un certificat auto-signé ça fait très bien l'affaire, vous pouvez générer une clé et un certificat avec RSA et des clés de 1024 bits avec :

```bash
openssl req -new -newkey rsa:1024 -days 365 -nodes -x509 -keyout server.key -out server.crt
```

- un exemple de configuration NGINX ressemble à :

```nginx
server {
    listen    443 ssl;
    server_name   app.tp5.b2;

    ssl_certificate     /path/to/cert;
    ssl_certificate_key /path/to/key;

    location / {
        proxy_pass http://10.5.1.12;
    }
}
```

```
[quentin@debian ~]$ curl -k https://10.5.1.11
<h1>Site nul</h1>
```

# II. Hardening script

```
Mettre script code.sh dans le home directory et créer un dossier conf avec les 3 fichiers de configuration présents sur le répo puis modifier le script en exécutable et le lancer avec un utilisateur ayant les droits sudo
```

```
sudo chmod +x script.sh
sudo ./script.sh
```