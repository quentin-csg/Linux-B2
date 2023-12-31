<?php
$servername = "mysql";
$username = "quentin";
$password = "quentin";
$dbname = "utilisateurs";

// Crée une connexion à MySQL
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifie la connexion
if ($conn->connect_error) {
    die("La connexion à MySQL a échoué : " . $conn->connect_error);
}

echo "Connexion à MySQL réussie!";
$conn->close();
?>
