<?php

require_once __DIR__ . '/connexion.php';

if (!function_exists('getCategories')) {
	function getCategories(): array
	{
		$pdo = dbconnect();

		$sql = "SELECT c.id, c.nom, COUNT(p.id) AS produits_total
				FROM categories c
				LEFT JOIN produits p ON p.categorie_id = c.id
				GROUP BY c.id, c.nom
				ORDER BY c.nom";

		$stmt = $pdo->query($sql);

		if ($stmt) {
			return $stmt->fetchAll();
		}

		return [];
	}
}

if (!function_exists('getProducts')) {
	function getProducts(?int $categorieId = null, int $limit = 12): array
	{
		$pdo = dbconnect();

		$sql = "SELECT 
					p.id,
					p.nom,
					p.description,
					p.prix,
					p.images,
					p.categorie_id,
					c.nom AS categorie_nom
				FROM produits p
				LEFT JOIN categories c ON c.id = p.categorie_id";

		$conditions = [];
		$params = [];

		if (!is_null($categorieId) && $categorieId > 0) {
			$conditions[] = 'p.categorie_id = :categorie_id';
			$params['categorie_id'] = $categorieId;
		}

		if (!empty($conditions)) {
			$sql .= ' WHERE ' . implode(' AND ', $conditions);
		}

		$sql .= ' ORDER BY p.id DESC';

		if ($limit > 0) {
			$sql .= ' LIMIT ' . (int) $limit;
		}

		$stmt = $pdo->prepare($sql);
		$stmt->execute($params);

		if ($stmt) {
			return $stmt->fetchAll();
		}

		return [];
	}
}

if (!function_exists('getProductById')) {
	function getProductById(int $productId): ?array
	{
		if ($productId <= 0) {
			return null;
		}

		$pdo = dbconnect();

		$sql = "SELECT 
					p.id,
					p.nom,
					p.description,
					p.prix,
					p.images,
					p.categorie_id,
					c.nom AS categorie_nom
				FROM produits p
				LEFT JOIN categories c ON c.id = p.categorie_id
				WHERE p.id = :product_id
				LIMIT 1";

		$stmt = $pdo->prepare($sql);
		$stmt->execute(['product_id' => $productId]);

		if ($stmt) {
			$result = $stmt->fetch();
		} else {
			$result = false;
		}

		if ($result) {
			return $result;
		}

		return null;
	}
}

