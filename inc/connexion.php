<?php
ini_set('display_errors', 1);

if (!function_exists('dbconnect')) {
    /**
     * Retourne une instance PDO configurée pour l'application.
     *
     * @return PDO
     * @throws PDOException
     */
    function dbconnect(): PDO
    {
        static $pdo = null;

        if ($pdo instanceof PDO) {
            return $pdo;
        }

        $host = 'localhost';
        $dbname = 'karma';
        $user = 'root';
        $pass = '';

        $dsn = sprintf('mysql:host=%s;dbname=%s;charset=utf8mb4', $host, $dbname);

        $options = [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ];

        $pdo = new PDO($dsn, $user, $pass, $options);

        return $pdo;
    }
}