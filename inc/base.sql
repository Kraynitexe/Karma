CREATE DATABASE IF NOT EXISTS karma

USE karma;

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
);

CREATE TABLE IF NOT EXISTS produits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    description TEXT,
    prix DECIMAL(10,2) NOT NULL,
    categorie_id INT,
    images TEXT,
    FOREIGN KEY (categorie_id) REFERENCES categories(id)
);


CREATE TABLE IF NOT EXISTS avis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produit_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    note INT NOT NULL CHECK (note >= 1 AND note <= 5),
    commentaire TEXT,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produit_id) REFERENCES produits(id) ON DELETE CASCADE,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,

    UNIQUE KEY unique_avis (produit_id, utilisateur_id)
);

INSERT INTO categories (nom) VALUES
('Fruits and Vegetables'),
('Meat and Fish'),
('Cooking'),
('Beverages'),
('Home and Cleaning'),
('Pest Control'),
('Office Products'),
('Beauty Products'),
('Health Products'),
('Pet Care'),
('Home Appliances'),
('Baby Care');

INSERT INTO produits (nom,description, prix, categorie_id, images) VALUES
('Addidas New Hammer Sole - P3', 'Idéale pour les entraînements de force, cette chaussure offre une stabilité exceptionnelle grâce à son talon renforcé et sa semelle rigide. Elle garantit un maintien optimal lors des squats, deadlifts ou exercices de charge lourde, assurant sécurité et efficacité à chaque mouvement.', 150.00, 8, 'img/product/p3.jpg'),
('Addidas New Hammer Sole - P2', 'Conçue pour affronter les terrains difficiles, cette chaussure de trail intègre une semelle crantée offrant une accroche supérieure sur surfaces glissantes, boueuses ou rocheuses. Son amorti renforcé absorbe les chocs tandis que sa structure protectrice apporte confort et sécurité lors des randonnées ou courses en pleine nature.', 150.00, 8, 'img/product/p2.jpg'),
('Addidas New Hammer Sole - P4', 'Cette chaussure combine souplesse et légèreté pour accompagner vos activités quotidiennes. Sa semelle flexible suit les mouvements naturels du pied et son tissu respirant procure un confort durable. Un excellent choix pour la marche active, les déplacements urbains ou les séances de sport modéré.', 150.00, 8, 'img/product/p4.jpg'),
('Addidas New Hammer Sole - P5', 'Adaptée aux sports en salle, cette chaussure offre une agilité remarquable lors des changements de direction rapides. Sa semelle antidérapante assure une excellente adhérence, tandis que son amorti ciblé protège le pied lors des impacts répétés. Parfaite pour le tennis en salle, le badminton ou le handball.', 150.00, 8, 'img/product/p5.jpg'),
('Addidas New Hammer Sole - P6', 'Conçue pour un usage intensif, cette chaussure de sport offre une durabilité exceptionnelle grâce à son tissu robuste et son amorti renforcé. Elle est idéale pour les activités de fitness, de musculation ou de sport en plein air, assurant un confort optimal et une protection maximale.', 150.00, 8, 'img/product/p6.jpg'),
('Addidas New Hammer Sole - P1', 'Idéale pour les entraînements de force, cette chaussure offre une stabilité exceptionnelle grâce à son talon renforcé et sa semelle rigide. Elle garantit un maintien optimal lors des squats, deadlifts ou exercices de charge lourde, assurant sécurité et efficacité à chaque mouvement.', 150.00, 8, 'img/product/p1.jpg');
