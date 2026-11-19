-- =====================================================================
-- Praktikum Modul 11 - Perkembangan DBMS dan Lingkup Penerapan Basis Data
-- Proyek : Sistem Informasi Cuaca bagi Petani
-- File   : 01_database.sql  (identifikasi DBMS + pembuatan database)
-- DBMS   : MySQL / MariaDB
-- =====================================================================

-- ---------------------------------------------------------------------
-- A. IDENTIFIKASI DBMS (Tahap 1 - bagian 4)
-- ---------------------------------------------------------------------
SELECT VERSION()          AS versi_dbms;
SELECT @@version_comment  AS informasi_dbms;
SHOW DATABASES;
SHOW ENGINES;
SHOW VARIABLES LIKE 'character_set_server';
SHOW VARIABLES LIKE 'collation_server';

-- Fasilitas transaksi dan keamanan
SHOW VARIABLES LIKE 'autocommit';
SHOW VARIABLES LIKE '%isolation%';
SHOW GRANTS FOR CURRENT_USER();

-- Memeriksa dukungan fungsi JSON
SELECT
    JSON_VALID('{"nama":"Budi"}')            AS json_valid,
    JSON_EXTRACT('{"nama":"Budi"}', '$.nama') AS nama;

SELECT NOW();

-- ---------------------------------------------------------------------
-- B. MEMBUAT DATABASE
-- ---------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS praktikum_modul11
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE praktikum_modul11;

SELECT DATABASE() AS database_aktif;
