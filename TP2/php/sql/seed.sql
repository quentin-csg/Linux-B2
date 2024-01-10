CREATE TABLE utilisateurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

INSERT INTO utilisateurs (name, password) VALUES ('test','test');

