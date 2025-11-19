# Liste de Tâches Détaillée - Dynamisation du Site Karma Shop

## 📋 Vue d'ensemble
Ce document contient la liste complète des tâches nécessaires pour transformer le site statique Karma Shop en une application e-commerce dynamique et fonctionnelle.

---

## 🗄️ PHASE 1 : BASE DE DONNÉES

### 1.1 Structure de Base de Données
**Priorité : HAUTE**

#### Tables à créer :
- **utilisateurs**
  - id (INT, PRIMARY KEY, AUTO_INCREMENT)
  - nom (VARCHAR 100)
  - prenom (VARCHAR 100)
  - email (VARCHAR 255, UNIQUE)
  - login (VARCHAR 50, UNIQUE)
  - motdepasse (VARCHAR 255) - hashé avec password_hash()
  - telephone (VARCHAR 20)
  - adresse (TEXT)
  - ville (VARCHAR 100)
  - code_postal (VARCHAR 10)
  - pays (VARCHAR 100)
  - role (ENUM: 'client', 'admin') DEFAULT 'client'
  - date_creation (DATETIME)
  - date_modification (DATETIME)

- **categories**
  - id (INT, PRIMARY KEY, AUTO_INCREMENT)
  - nom (VARCHAR 100)
  - slug (VARCHAR 100, UNIQUE)
  - description (TEXT)
  - image (VARCHAR 255)
  - ordre_affichage (INT)
  - actif (BOOLEAN DEFAULT 1)

- **produits**
  - id (INT, PRIMARY KEY, AUTO_INCREMENT)
  - nom (VARCHAR 255)
  - slug (VARCHAR 255, UNIQUE)
  - description (TEXT)
  - description_courte (TEXT)
  - prix (DECIMAL 10,2)
  - prix_promotion (DECIMAL 10,2, NULL)
  - stock (INT DEFAULT 0)
  - categorie_id (INT, FOREIGN KEY)
  - image_principale (VARCHAR 255)
  - images (JSON ou TEXT) - pour images multiples
  - actif (BOOLEAN DEFAULT 1)
  - en_vedette (BOOLEAN DEFAULT 0)
  - date_creation (DATETIME)
  - date_modification (DATETIME)

- **commandes**
  - id (INT, PRIMARY KEY, AUTO_INCREMENT)
  - numero_commande (VARCHAR 50, UNIQUE)
  - utilisateur_id (INT, FOREIGN KEY)
  - statut (ENUM: 'en_attente', 'confirmee', 'expediee', 'livree', 'annulee')
  - total (DECIMAL 10,2)
  - adresse_livraison (TEXT)
  - adresse_facturation (TEXT)
  - methode_paiement (VARCHAR 50)
  - date_commande (DATETIME)
  - date_modification (DATETIME)

- **details_commande**
  - id (INT, PRIMARY KEY, AUTO_INCREMENT)
  - commande_id (INT, FOREIGN KEY)
  - produit_id (INT, FOREIGN KEY)
  - quantite (INT)
  - prix_unitaire (DECIMAL 10,2)
  - sous_total (DECIMAL 10,2)

- **panier**
  - id (INT, PRIMARY KEY, AUTO_INCREMENT)
  - utilisateur_id (INT, FOREIGN KEY, NULL) - NULL si session
  - session_id (VARCHAR 255) - pour panier non connecté
  - produit_id (INT, FOREIGN KEY)
  - quantite (INT)
  - date_ajout (DATETIME)

- **wishlist**
  - id (INT, PRIMARY KEY, AUTO_INCREMENT)
  - utilisateur_id (INT, FOREIGN KEY)
  - produit_id (INT, FOREIGN KEY)
  - date_ajout (DATETIME)
  - UNIQUE KEY (utilisateur_id, produit_id)

- **avis**
  - id (INT, PRIMARY KEY, AUTO_INCREMENT)
  - produit_id (INT, FOREIGN KEY)
  - utilisateur_id (INT, FOREIGN KEY)
  - note (INT 1-5)
  - commentaire (TEXT)
  - approuve (BOOLEAN DEFAULT 0)
  - date_creation (DATETIME)

#### Fichiers à créer/modifier :
- `inc/base.sql` - Script SQL complet pour créer toutes les tables
- `inc/connexion.php` - Fonction de connexion améliorée

---

## 🔧 PHASE 2 : INFRASTRUCTURE PHP

### 2.1 Amélioration du Fichier de Connexion
**Priorité : HAUTE**

**Fichier : `inc/connexion.php`**

#### Tâches :
- [ ] Corriger la fonction `dbconnect()` pour retourner l'objet PDO
- [ ] Ajouter gestion d'erreurs appropriée
- [ ] Créer une classe Database avec méthodes réutilisables
- [ ] Implémenter singleton pattern pour connexion unique
- [ ] Ajouter configuration via fichier séparé (config.php)
- [ ] Créer fonctions helper pour requêtes courantes

**Code à implémenter :**
```php
class Database {
    private static $instance = null;
    private $pdo;
    
    private function __construct() { ... }
    public static function getInstance() { ... }
    public function query($sql, $params = []) { ... }
    public function fetchAll($sql, $params = []) { ... }
    public function fetchOne($sql, $params = []) { ... }
}
```

---

### 2.2 Système de Sessions et Sécurité
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `inc/session.php` pour gestion sessions
- [ ] Implémenter protection CSRF (tokens)
- [ ] Créer fonctions de validation et sanitization
- [ ] Ajouter protection XSS (htmlspecialchars, filter_var)
- [ ] Créer système de logs pour erreurs
- [ ] Implémenter rate limiting pour formulaires

**Fichiers à créer :**
- `inc/session.php`
- `inc/security.php`
- `inc/validation.php`

---

## 👤 PHASE 3 : SYSTÈME D'AUTHENTIFICATION

### 3.1 Inscription Utilisateur
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `pages/register.php` (formulaire d'inscription)
- [ ] Créer `pages/traitement-register.php` (traitement POST)
- [ ] Valider données (email unique, mot de passe fort)
- [ ] Hasher mot de passe avec `password_hash()`
- [ ] Envoyer email de confirmation
- [ ] Gérer erreurs et messages de succès
- [ ] Rediriger vers login après inscription

**Fonctionnalités :**
- Validation côté client (JavaScript)
- Validation côté serveur (PHP)
- Vérification email unique
- Force du mot de passe (min 8 caractères, majuscule, chiffre)

---

### 3.2 Connexion Utilisateur
**Priorité : HAUTE**

#### Tâches :
- [ ] Modifier `login.html` en `login.php`
- [ ] Créer `pages/traitement-login.php` (traitement authentification)
- [ ] Vérifier identifiants en base de données
- [ ] Utiliser `password_verify()` pour mot de passe
- [ ] Créer session utilisateur
- [ ] Implémenter "Se souvenir de moi" (cookie sécurisé)
- [ ] Gérer tentatives de connexion (limiter brute force)
- [ ] Rediriger selon rôle (client/admin)

**Fonctionnalités :**
- Session PHP sécurisée
- Cookie "remember me" avec token
- Protection contre brute force
- Messages d'erreur sécurisés

---

### 3.3 Déconnexion et Gestion de Session
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `pages/logout.php`
- [ ] Détruire session proprement
- [ ] Supprimer cookies
- [ ] Rediriger vers page d'accueil
- [ ] Créer middleware pour vérifier authentification
- [ ] Créer middleware pour vérifier rôle admin

**Fichiers à créer :**
- `pages/logout.php`
- `inc/middleware.php`

---

### 3.4 Réinitialisation Mot de Passe
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `pages/forgot-password.php`
- [ ] Créer `pages/reset-password.php`
- [ ] Générer token sécurisé
- [ ] Envoyer email avec lien de réinitialisation
- [ ] Valider token et permettre changement
- [ ] Mettre à jour mot de passe en BDD

---

## 🛍️ PHASE 4 : GESTION DES PRODUITS

### 4.1 Affichage Dynamique des Produits
**Priorité : HAUTE**

#### Tâches :
- [ ] Modifier `index.php` pour charger produits depuis BDD
- [ ] Créer fonction `getProducts($limit, $offset, $categorie = null)`
- [ ] Créer fonction `getFeaturedProducts()`
- [ ] Créer fonction `getLatestProducts()`
- [ ] Implémenter pagination
- [ ] Gérer images produits (chemins dynamiques)
- [ ] Afficher prix avec promotion si applicable

**Fichiers à modifier :**
- `index.php` - Section produits
- Créer `inc/products.php` - Fonctions produits

---

### 4.2 Page Détails Produit
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `single-product.php` (remplacer single-product.html)
- [ ] Récupérer produit par ID ou slug
- [ ] Afficher images multiples (galerie)
- [ ] Afficher stock disponible
- [ ] Afficher avis clients
- [ ] Bouton "Ajouter au panier" fonctionnel
- [ ] Bouton "Ajouter à la wishlist"
- [ ] Produits similaires (même catégorie)
- [ ] Breadcrumb dynamique

**Fonctionnalités :**
- Galerie d'images avec zoom
- Sélection quantité
- Affichage stock (en stock / rupture)
- Prix avec promotion

---

### 4.3 Page Catégories
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `category.php` (remplacer category.html)
- [ ] Filtrer produits par catégorie
- [ ] Afficher catégories dynamiquement dans menu
- [ ] Implémenter filtres (prix, marque, etc.)
- [ ] Tri des produits (prix, nom, nouveauté)
- [ ] Pagination des résultats

**Fonctionnalités :**
- Filtres avancés (slider prix, checkboxes)
- Tri multiple
- Affichage nombre de produits par catégorie

---

### 4.4 Recherche de Produits
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `search.php` pour résultats recherche
- [ ] Traiter requête depuis barre de recherche
- [ ] Recherche dans nom, description, catégorie
- [ ] Recherche avec LIKE et FULLTEXT
- [ ] Afficher résultats avec pagination
- [ ] Suggestions de recherche (autocomplete)
- [ ] Recherche avancée (filtres)

**Fichiers à créer :**
- `pages/search.php`
- `api/search-autocomplete.php` (AJAX)

---

## 🛒 PHASE 5 : SYSTÈME DE PANIER

### 5.1 Gestion du Panier
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `inc/cart.php` - Fonctions panier
- [ ] Ajouter produit au panier (session/BDD)
- [ ] Modifier quantité dans panier
- [ ] Supprimer produit du panier
- [ ] Calculer total panier
- [ ] Persister panier en BDD si utilisateur connecté
- [ ] Fusionner panier session avec panier BDD à la connexion
- [ ] Vérifier stock disponible avant ajout

**Fonctionnalités :**
- Panier persistant (session + BDD)
- Calcul automatique sous-totaux
- Validation stock en temps réel
- Limite quantité selon stock

---

### 5.2 Page Panier
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `cart.php` (remplacer cart.html)
- [ ] Afficher tous les produits du panier
- [ ] Permettre modification quantités
- [ ] Afficher total, sous-total, frais de livraison
- [ ] Bouton "Continuer les achats"
- [ ] Bouton "Passer commande"
- [ ] Calculer frais de livraison
- [ ] Afficher code promo (si applicable)

**Fonctionnalités :**
- Mise à jour AJAX des quantités
- Recalcul automatique du total
- Indication stock limité
- Suggestions produits similaires

---

## 💳 PHASE 6 : PROCESSUS DE COMMANDE

### 6.1 Page Checkout
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `checkout.php` (remplacer checkout.html)
- [ ] Afficher récapitulatif panier
- [ ] Formulaire adresse de livraison
- [ ] Formulaire adresse de facturation
- [ ] Sélection méthode de paiement
- [ ] Validation complète avant soumission
- [ ] Calcul frais de livraison selon adresse
- [ ] Afficher total final

**Fonctionnalités :**
- Sauvegarde adresses pour utilisateurs connectés
- Validation formulaire complète
- Calcul automatique frais

---

### 6.2 Traitement de Commande
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `pages/traitement-commande.php`
- [ ] Valider données commande
- [ ] Vérifier stock de tous les produits
- [ ] Générer numéro de commande unique
- [ ] Enregistrer commande en BDD
- [ ] Enregistrer détails commande
- [ ] Décrémenter stock produits
- [ ] Vider panier après commande
- [ ] Envoyer email confirmation
- [ ] Rediriger vers page confirmation

**Fonctionnalités :**
- Génération numéro commande (ex: CMD-2024-001234)
- Transaction BDD (rollback si erreur)
- Email automatique avec détails

---

### 6.3 Page Confirmation
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `confirmation.php` (remplacer confirmation.html)
- [ ] Afficher détails commande
- [ ] Afficher numéro de commande
- [ ] Lien vers suivi de commande
- [ ] Bouton retour accueil
- [ ] Suggestions produits

---

### 6.4 Suivi de Commande
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `tracking.php` (remplacer tracking.html)
- [ ] Recherche commande par numéro
- [ ] Afficher statut commande
- [ ] Historique des modifications
- [ ] Affichage pour utilisateur connecté (ses commandes)
- [ ] Timeline de progression

**Fonctionnalités :**
- Recherche publique par numéro
- Affichage détaillé pour client connecté
- Mise à jour statuts (admin)

---

## 👥 PHASE 7 : PROFIL UTILISATEUR

### 7.1 Page Profil
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `pages/profile.php`
- [ ] Afficher informations utilisateur
- [ ] Formulaire modification profil
- [ ] Modification mot de passe
- [ ] Gestion adresses (livraison/facturation)
- [ ] Historique des commandes
- [ ] Liste de souhaits (wishlist)

**Fonctionnalités :**
- Édition profil sécurisée
- Validation email unique
- Changement mot de passe avec confirmation

---

### 7.2 Historique des Commandes
**Priorité : MOYENNE**

#### Tâches :
- [ ] Afficher toutes les commandes utilisateur
- [ ] Détails de chaque commande
- [ ] Statut de chaque commande
- [ ] Téléchargement facture (PDF)
- [ ] Filtres (date, statut)
- [ ] Pagination

---

## ⭐ PHASE 8 : WISHLIST ET AVIS

### 8.1 Système de Wishlist
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `inc/wishlist.php` - Fonctions wishlist
- [ ] Ajouter produit à la wishlist
- [ ] Supprimer de la wishlist
- [ ] Afficher wishlist utilisateur
- [ ] Convertir wishlist en panier
- [ ] Bouton wishlist sur pages produits
- [ ] Compteur wishlist dans header

**Fonctionnalités :**
- Ajout/suppression AJAX
- Affichage dans profil
- Conversion multiple en panier

---

### 8.2 Système d'Avis Clients
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `inc/reviews.php` - Fonctions avis
- [ ] Formulaire ajout avis (après achat)
- [ ] Affichage avis sur page produit
- [ ] Système de notation (étoiles 1-5)
- [ ] Modération avis (admin)
- [ ] Calcul moyenne notes produit
- [ ] Avis vérifiés (client ayant acheté)

**Fonctionnalités :**
- Notation étoiles interactive
- Filtres avis (tous, 5 étoiles, etc.)
- Pagination avis

---

## 🔐 PHASE 9 : PANEL ADMINISTRATION

### 9.1 Dashboard Admin
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `admin/index.php` - Dashboard
- [ ] Statistiques (commandes, revenus, produits)
- [ ] Graphiques (ventes, tendances)
- [ ] Commandes récentes
- [ ] Produits populaires
- [ ] Accès restreint (middleware admin)

**Fonctionnalités :**
- Vue d'ensemble complète
- Statistiques temps réel
- Liens rapides vers sections

---

### 9.2 Gestion des Produits (Admin)
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `admin/products.php` - Liste produits
- [ ] Créer `admin/product-add.php` - Ajouter produit
- [ ] Créer `admin/product-edit.php` - Modifier produit
- [ ] Upload images produits
- [ ] Gestion stock
- [ ] Activer/désactiver produits
- [ ] Supprimer produits
- [ ] Recherche et filtres

**Fonctionnalités :**
- Interface CRUD complète
- Upload multiple images
- Éditeur de texte riche (description)
- Gestion catégories

---

### 9.3 Gestion des Commandes (Admin)
**Priorité : HAUTE**

#### Tâches :
- [ ] Créer `admin/orders.php` - Liste commandes
- [ ] Créer `admin/order-details.php` - Détails commande
- [ ] Modifier statut commande
- [ ] Filtrer par statut, date, client
- [ ] Exporter commandes (CSV/Excel)
- [ ] Imprimer facture
- [ ] Recherche commandes

**Fonctionnalités :**
- Mise à jour statuts en temps réel
- Filtres avancés
- Export données

---

### 9.4 Gestion des Utilisateurs (Admin)
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `admin/users.php` - Liste utilisateurs
- [ ] Voir détails utilisateur
- [ ] Modifier rôle (client/admin)
- [ ] Désactiver/activer compte
- [ ] Recherche utilisateurs
- [ ] Statistiques par utilisateur

---

### 9.5 Gestion des Catégories (Admin)
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `admin/categories.php` - Liste catégories
- [ ] Ajouter catégorie
- [ ] Modifier catégorie
- [ ] Supprimer catégorie
- [ ] Upload image catégorie
- [ ] Ordre d'affichage

---

## 📧 PHASE 10 : EMAILS ET NOTIFICATIONS

### 10.1 Système d'Emails
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `inc/email.php` - Fonctions email
- [ ] Configuration SMTP
- [ ] Template email confirmation commande
- [ ] Template email inscription
- [ ] Template email réinitialisation mot de passe
- [ ] Template email changement statut commande
- [ ] Template HTML responsive

**Fonctionnalités :**
- Templates réutilisables
- Support HTML et texte
- Pièces jointes (factures)

---

## 🖼️ PHASE 11 : GESTION DES IMAGES

### 11.1 Upload d'Images
**Priorité : MOYENNE**

#### Tâches :
- [ ] Créer `inc/upload.php` - Fonctions upload
- [ ] Validation type fichier (images uniquement)
- [ ] Validation taille fichier
- [ ] Redimensionnement automatique
- [ ] Génération thumbnails
- [ ] Stockage organisé (dossiers par type)
- [ ] Suppression anciennes images
- [ ] Protection contre upload malveillant

---


## 🎯 ORDRE DE PRIORITÉ RECOMMANDÉ

### Sprint 1 (Fondations)
1. Structure base de données
2. Connexion PHP améliorée
3. Système d'authentification (login/register)
4. Affichage produits dynamiques

### Sprint 2 (E-commerce Core)
5. Système de panier
6. Processus de commande
7. Page détails produit
8. Recherche produits

### Sprint 3 (Expérience Utilisateur)
9. Profil utilisateur
10. Wishlist
11. Avis clients
12. Suivi commandes

### Sprint 4 (Administration)
13. Panel admin
14. Gestion produits (admin)
15. Gestion commandes (admin)

### Sprint 5 (Finalisation)
16. Emails
17. Upload images
18. Optimisations
19. Tests et documentation