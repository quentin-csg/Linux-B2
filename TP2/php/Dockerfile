# Utilisez l'image officielle PHP avec Apache
FROM php:7.2-apache

WORKDIR /tp2

# Copiez les fichiers PHP dans le répertoire web du conteneur
COPY /php /var/www/html/

# Installez le module MySQLi pour la connexion à MySQL
RUN docker-php-ext-install mysqli
