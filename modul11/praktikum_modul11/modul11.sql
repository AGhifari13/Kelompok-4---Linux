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
-- =====================================================================
-- File : 02_tabel.sql  (struktur tabel + PK, FK, JSON)
-- Catatan: kolom bertipe JSON dipakai untuk atribut yang berbeda-beda
--          antarjenis tanaman (tanaman.spesifikasi) dan antarjenis
--          peringatan cuaca (peringatan_cuaca.detail).
-- =====================================================================
USE praktikum_modul11;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS rekomendasi;
DROP TABLE IF EXISTS notifikasi;
DROP TABLE IF EXISTS peringatan_cuaca;
DROP TABLE IF EXISTS cuaca;
DROP TABLE IF EXISTS lahan;
DROP TABLE IF EXISTS tanaman;
DROP TABLE IF EXISTS kategori_tanaman;
DROP TABLE IF EXISTS wilayah;
DROP TABLE IF EXISTS pengguna;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Tabel pengguna (petani / admin)
CREATE TABLE pengguna (
    id_pengguna  INT AUTO_INCREMENT PRIMARY KEY,
    nama         VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    no_hp        VARCHAR(20),
    peran        VARCHAR(20)  NOT NULL DEFAULT 'petani',
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Tabel wilayah
CREATE TABLE wilayah (
    id_wilayah    INT AUTO_INCREMENT PRIMARY KEY,
    nama_wilayah  VARCHAR(100) NOT NULL,
    kecamatan     VARCHAR(100) NOT NULL,
    kabupaten     VARCHAR(100) NOT NULL,
    latitude      DECIMAL(9,6),
    longitude     DECIMAL(9,6)
) ENGINE=InnoDB;

-- 3. Tabel kategori tanaman
CREATE TABLE kategori_tanaman (
    id_kategori    INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori  VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 4. Tabel tanaman (atribut bervariasi disimpan sebagai JSON)
CREATE TABLE tanaman (
    id_tanaman    INT AUTO_INCREMENT PRIMARY KEY,
    id_kategori   INT NOT NULL,
    nama_tanaman  VARCHAR(100) NOT NULL,
    spesifikasi   JSON NOT NULL,
    CONSTRAINT fk_tanaman_kategori
        FOREIGN KEY (id_kategori) REFERENCES kategori_tanaman(id_kategori)
) ENGINE=InnoDB;

-- 5. Tabel lahan
CREATE TABLE lahan (
    id_lahan      INT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna   INT NOT NULL,
    id_wilayah    INT NOT NULL,
    nama_lahan    VARCHAR(100) NOT NULL,
    luas_hektar   DECIMAL(6,2) NOT NULL,
    jenis_tanah   VARCHAR(50),
    CONSTRAINT fk_lahan_pengguna
        FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna),
    CONSTRAINT fk_lahan_wilayah
        FOREIGN KEY (id_wilayah)  REFERENCES wilayah(id_wilayah)
) ENGINE=InnoDB;

-- 6. Tabel cuaca (data observasi / prakiraan)
CREATE TABLE cuaca (
    id_cuaca         INT AUTO_INCREMENT PRIMARY KEY,
    id_wilayah       INT NOT NULL,
    waktu            DATETIME NOT NULL,
    suhu             DECIMAL(4,1),
    kelembapan       DECIMAL(5,2),
    curah_hujan      DECIMAL(6,2),
    kecepatan_angin  DECIMAL(5,2),
    jenis_data       VARCHAR(20) NOT NULL DEFAULT 'observasi',
    CONSTRAINT fk_cuaca_wilayah
        FOREIGN KEY (id_wilayah) REFERENCES wilayah(id_wilayah)
) ENGINE=InnoDB;

-- 7. Tabel peringatan cuaca (detail bervariasi menurut jenis peringatan)
CREATE TABLE peringatan_cuaca (
    id_peringatan    INT AUTO_INCREMENT PRIMARY KEY,
    id_wilayah       INT NOT NULL,
    jenis_peringatan VARCHAR(30) NOT NULL,
    tingkat          VARCHAR(20) NOT NULL,
    waktu_mulai      DATETIME NOT NULL,
    waktu_selesai    DATETIME,
    detail           JSON NOT NULL,
    CONSTRAINT fk_peringatan_wilayah
        FOREIGN KEY (id_wilayah) REFERENCES wilayah(id_wilayah)
) ENGINE=InnoDB;

-- 8. Tabel notifikasi
CREATE TABLE notifikasi (
    id_notifikasi  INT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna    INT NOT NULL,
    id_peringatan  INT NOT NULL,
    pesan          VARCHAR(255) NOT NULL,
    status_baca    TINYINT(1) NOT NULL DEFAULT 0,
    waktu_kirim    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notifikasi_pengguna
        FOREIGN KEY (id_pengguna)   REFERENCES pengguna(id_pengguna),
    CONSTRAINT fk_notifikasi_peringatan
        FOREIGN KEY (id_peringatan) REFERENCES peringatan_cuaca(id_peringatan)
) ENGINE=InnoDB;

-- 9. Tabel rekomendasi (junction lahan - tanaman)
CREATE TABLE rekomendasi (
    id_rekomendasi       INT AUTO_INCREMENT PRIMARY KEY,
    id_lahan             INT NOT NULL,
    id_tanaman           INT NOT NULL,
    alasan               VARCHAR(255),
    tanggal_rekomendasi  DATE NOT NULL,
    CONSTRAINT fk_rekomendasi_lahan
        FOREIGN KEY (id_lahan)   REFERENCES lahan(id_lahan),
    CONSTRAINT fk_rekomendasi_tanaman
        FOREIGN KEY (id_tanaman) REFERENCES tanaman(id_tanaman)
) ENGINE=InnoDB;

SHOW TABLES;
-- =====================================================================
-- File : 03_data_awal.sql  (data contoh / fiktif - bukan data pribadi nyata)
-- =====================================================================
USE praktikum_modul11;

-- Pengguna
INSERT INTO pengguna (nama, email, no_hp, peran) VALUES
('Slamet Riyadi', 'slamet@contoh.test', '081200000001', 'petani'),
('Sri Wahyuni',   'sri@contoh.test',    '081200000002', 'petani'),
('Admin Cuaca',   'admin@contoh.test',  '081200000003', 'admin');

-- Wilayah (koordinat contoh)
INSERT INTO wilayah (nama_wilayah, kecamatan, kabupaten, latitude, longitude) VALUES
('Desa Sidorejo',  'Plaosan',  'Magetan', -7.650000, 111.250000),
('Desa Kebonagung','Maospati', 'Magetan', -7.620000, 111.350000),
('Desa Gondang',   'Parang',   'Magetan', -7.700000, 111.330000);

-- Kategori tanaman
INSERT INTO kategori_tanaman (nama_kategori) VALUES
('Tanaman Pangan'),
('Hortikultura'),
('Perkebunan');

-- Tanaman: tiga kategori berbeda, tiap tanaman punya atribut JSON berbeda
INSERT INTO tanaman (id_kategori, nama_tanaman, spesifikasi) VALUES
(1, 'Padi',
 '{
    "umur_panen_hari": 110,
    "suhu_optimal_c": {"min": 22, "max": 30},
    "kebutuhan_air_mm_per_musim": 1200,
    "ph_tanah": "5.5-7.0",
    "sistem_tanam": "sawah irigasi",
    "musim_tanam": ["Musim Hujan", "Musim Kemarau"],
    "rentan_terhadap": ["banjir", "wereng"]
 }'),
(2, 'Cabai Rawit',
 '{
    "umur_panen_hari": 90,
    "suhu_optimal_c": {"min": 24, "max": 32},
    "ph_tanah": "6.0-7.0",
    "jarak_tanam_cm": "60x50",
    "butuh_mulsa": true,
    "rentan_terhadap": ["hujan lebat", "antraknosa"]
 }'),
(3, 'Tebu',
 '{
    "umur_panen_bulan": 12,
    "curah_hujan_optimal_mm_per_tahun": "1500-2500",
    "ph_tanah": "6.0-7.5",
    "varietas": ["Varietas A", "Varietas B"],
    "rentan_terhadap": ["kekeringan", "angin kencang"]
 }'),
(1, 'Jagung',
 '{
    "umur_panen_hari": 100,
    "suhu_optimal_c": {"min": 21, "max": 34},
    "ph_tanah": "5.6-7.5",
    "rentan_terhadap": ["kekeringan", "angin kencang"]
 }');

-- Lahan
INSERT INTO lahan (id_pengguna, id_wilayah, nama_lahan, luas_hektar, jenis_tanah) VALUES
(1, 1, 'Sawah Pak Slamet', 1.50, 'Aluvial'),
(1, 2, 'Ladang Barat',     0.75, 'Latosol'),
(2, 3, 'Kebun Bu Sri',     1.00, 'Regosol');

-- Cuaca
INSERT INTO cuaca (id_wilayah, waktu, suhu, kelembapan, curah_hujan, kecepatan_angin, jenis_data) VALUES
(1, '2026-11-14 06:00:00', 24.5, 88.00, 12.50,  8.00, 'observasi'),
(1, '2026-11-14 12:00:00', 29.0, 72.00,  0.00, 10.50, 'observasi'),
(2, '2026-11-14 06:00:00', 25.0, 85.00,  5.20,  7.00, 'observasi'),
(3, '2026-11-15 06:00:00', 26.0, 80.00, 30.00, 15.00, 'prakiraan');

-- Peringatan cuaca: detail JSON berbeda untuk tiap jenis
INSERT INTO peringatan_cuaca
    (id_wilayah, jenis_peringatan, tingkat, waktu_mulai, waktu_selesai, detail) VALUES
(1, 'Hujan Lebat', 'Waspada', '2026-11-14 14:00:00', '2026-11-14 18:00:00',
 '{
    "curah_hujan_mm": 85,
    "durasi_jam": 4,
    "potensi_banjir": true,
    "saran": ["Buka saluran drainase", "Tunda pemupukan"]
 }'),
(2, 'Angin Kencang', 'Siaga', '2026-11-15 09:00:00', '2026-11-15 15:00:00',
 '{
    "kecepatan_kmj": 55,
    "arah_angin": "Barat Daya",
    "saran": ["Pasang penyangga tanaman", "Tunda penyemprotan"]
 }'),
(3, 'Kekeringan', 'Waspada', '2026-11-10 00:00:00', '2026-11-24 00:00:00',
 '{
    "hari_tanpa_hujan": 21,
    "indeks_kekeringan": "Tinggi",
    "saran": ["Atur jadwal irigasi", "Gunakan mulsa"]
 }');

-- Notifikasi
INSERT INTO notifikasi (id_pengguna, id_peringatan, pesan, status_baca) VALUES
(1, 1, 'Hujan lebat diperkirakan pukul 14.00 di Desa Sidorejo.', 0),
(1, 2, 'Angin kencang diperkirakan besok di Desa Kebonagung.',   0),
(2, 3, 'Kekeringan di Desa Gondang, atur jadwal irigasi.',       1);

-- Rekomendasi
INSERT INTO rekomendasi (id_lahan, id_tanaman, alasan, tanggal_rekomendasi) VALUES
(1, 1, 'Curah hujan dan irigasi mencukupi untuk padi.',  '2026-11-14'),
(2, 2, 'Suhu dan kelembapan sesuai untuk cabai rawit.',  '2026-11-14'),
(3, 3, 'Wilayah cenderung kering, tebu lebih tahan.',    '2026-11-14');

-- Pemeriksaan data
SELECT * FROM kategori_tanaman;
SELECT * FROM tanaman;
SELECT * FROM peringatan_cuaca;
-- =====================================================================
-- File : 04_pengujian_json.sql
-- Isi  : pengujian JSON (baca, ubah, tambah, hapus, cari), pemetaan
--        objek ke relasional, transaksi, dan integritas referensial
-- =====================================================================
USE praktikum_modul11;

-- ---------------------------------------------------------------------
-- 1. MEMBACA ATRIBUT JSON
-- ---------------------------------------------------------------------
-- Umur panen (tanaman yang memakai satuan hari)
SELECT nama_tanaman,
       JSON_EXTRACT(spesifikasi, '$.umur_panen_hari') AS umur_panen_hari
FROM tanaman;

-- Nilai pH tanah
SELECT nama_tanaman,
       JSON_EXTRACT(spesifikasi, '$.ph_tanah') AS ph_tanah
FROM tanaman;

-- Atribut yang hanya dimiliki satu jenis tanaman (hasil NULL untuk yang lain)
SELECT nama_tanaman,
       JSON_EXTRACT(spesifikasi, '$.butuh_mulsa') AS butuh_mulsa
FROM tanaman;

-- Atribut bersarang (nested object)
SELECT nama_tanaman,
       JSON_UNQUOTE(JSON_EXTRACT(spesifikasi, '$.suhu_optimal_c.min')) AS suhu_min,
       JSON_UNQUOTE(JSON_EXTRACT(spesifikasi, '$.suhu_optimal_c.max')) AS suhu_max
FROM tanaman;

-- Atribut array (elemen pertama)
SELECT nama_tanaman,
       JSON_EXTRACT(spesifikasi, '$.rentan_terhadap[0]') AS rentan_utama
FROM tanaman;

-- ---------------------------------------------------------------------
-- 2. MENGUBAH ATRIBUT JSON (JSON_SET)
-- ---------------------------------------------------------------------
-- Kebutuhan air padi berubah menjadi 1100 mm per musim
UPDATE tanaman
SET spesifikasi = JSON_SET(spesifikasi, '$.kebutuhan_air_mm_per_musim', 1100)
WHERE nama_tanaman = 'Padi';

SELECT nama_tanaman,
       JSON_EXTRACT(spesifikasi, '$.kebutuhan_air_mm_per_musim') AS kebutuhan_air
FROM tanaman
WHERE nama_tanaman = 'Padi';

-- ---------------------------------------------------------------------
-- 3. MENAMBAH ATRIBUT JSON BARU
-- ---------------------------------------------------------------------
UPDATE tanaman
SET spesifikasi = JSON_SET(spesifikasi, '$.rekomendasi_pupuk', 'NPK 15-15-15')
WHERE nama_tanaman = 'Padi';

SELECT nama_tanaman, spesifikasi
FROM tanaman
WHERE nama_tanaman = 'Padi';

-- ---------------------------------------------------------------------
-- 4. MENGHAPUS ATRIBUT JSON (JSON_REMOVE)
-- ---------------------------------------------------------------------
UPDATE tanaman
SET spesifikasi = JSON_REMOVE(spesifikasi, '$.rekomendasi_pupuk')
WHERE nama_tanaman = 'Padi';

SELECT nama_tanaman, spesifikasi
FROM tanaman
WHERE nama_tanaman = 'Padi';

-- ---------------------------------------------------------------------
-- 5. PENCARIAN BERDASARKAN ATRIBUT JSON
-- ---------------------------------------------------------------------
-- Tanaman dengan pH tanah 6.0-7.0
SELECT nama_tanaman, spesifikasi
FROM tanaman
WHERE JSON_UNQUOTE(JSON_EXTRACT(spesifikasi, '$.ph_tanah')) = '6.0-7.0';

-- Tanaman yang rentan terhadap banjir (nilai dalam array)
SELECT nama_tanaman
FROM tanaman
WHERE JSON_CONTAINS(spesifikasi, '"banjir"', '$.rentan_terhadap');

-- Tanaman yang rentan terhadap kekeringan
SELECT nama_tanaman
FROM tanaman
WHERE JSON_CONTAINS(spesifikasi, '"kekeringan"', '$.rentan_terhadap');

-- Peringatan dengan curah hujan >= 50 mm
SELECT id_peringatan, jenis_peringatan, tingkat,
       JSON_EXTRACT(detail, '$.curah_hujan_mm') AS curah_hujan_mm
FROM peringatan_cuaca
WHERE CAST(JSON_UNQUOTE(JSON_EXTRACT(detail, '$.curah_hujan_mm')) AS DECIMAL(6,2)) >= 50;

-- ---------------------------------------------------------------------
-- 6. FUNGSI JSON LAINNYA
-- ---------------------------------------------------------------------
SELECT JSON_OBJECT('nama', 'Slamet', 'peran', 'petani', 'luas_ha', 1.5) AS data_petani;

SELECT JSON_ARRAY('MySQL', 'PostgreSQL', 'MariaDB') AS daftar_dbms;

SELECT JSON_VALID('{"jenis":"Hujan Lebat","curah_hujan_mm":85}') AS json_valid_benar,
       JSON_VALID('{jenis: Hujan Lebat')                         AS json_valid_salah;

SELECT nama_tanaman, JSON_LENGTH(spesifikasi) AS jumlah_atribut
FROM tanaman;

SELECT jenis_peringatan, JSON_LENGTH(detail) AS jumlah_atribut
FROM peringatan_cuaca;

-- ---------------------------------------------------------------------
-- 7. PEMETAAN OBJEK KE RELASIONAL
--    Kelas induk  : PeringatanCuaca (kolom tetap)
--    Kelas turunan: HujanLebat / AnginKencang / Kekeringan
--                   (atribut khusus disimpan pada kolom JSON detail)
-- ---------------------------------------------------------------------
SELECT id_peringatan, tingkat, detail
FROM peringatan_cuaca
WHERE jenis_peringatan = 'Hujan Lebat';

SELECT id_peringatan, tingkat, detail
FROM peringatan_cuaca
WHERE jenis_peringatan = 'Angin Kencang';

SELECT id_peringatan, tingkat, detail
FROM peringatan_cuaca
WHERE jenis_peringatan = 'Kekeringan';

-- ---------------------------------------------------------------------
-- 8. MENGGABUNGKAN DATA RELASIONAL DAN JSON
-- ---------------------------------------------------------------------
SELECT t.id_tanaman,
       t.nama_tanaman,
       k.nama_kategori,
       JSON_EXTRACT(t.spesifikasi, '$.ph_tanah') AS ph_tanah
FROM tanaman t
JOIN kategori_tanaman k ON t.id_kategori = k.id_kategori;

SELECT p.nama AS petani,
       w.nama_wilayah,
       pc.jenis_peringatan,
       pc.tingkat,
       JSON_EXTRACT(pc.detail, '$.saran[0]') AS saran_utama,
       n.pesan,
       n.status_baca
FROM notifikasi n
JOIN pengguna p          ON n.id_pengguna   = p.id_pengguna
JOIN peringatan_cuaca pc ON n.id_peringatan = pc.id_peringatan
JOIN wilayah w           ON pc.id_wilayah   = w.id_wilayah;

SELECT l.nama_lahan,
       w.nama_wilayah,
       t.nama_tanaman,
       r.alasan
FROM rekomendasi r
JOIN lahan l   ON r.id_lahan   = l.id_lahan
JOIN wilayah w ON l.id_wilayah = w.id_wilayah
JOIN tanaman t ON r.id_tanaman = t.id_tanaman;

-- ---------------------------------------------------------------------
-- 9. TRANSAKSI (COMMIT dan ROLLBACK) PADA DATA JSON
-- ---------------------------------------------------------------------
-- 9a. ROLLBACK: perubahan dibatalkan
START TRANSACTION;
UPDATE tanaman
SET spesifikasi = JSON_SET(spesifikasi, '$.umur_panen_hari', 999)
WHERE nama_tanaman = 'Cabai Rawit';
SELECT nama_tanaman, JSON_EXTRACT(spesifikasi, '$.umur_panen_hari') AS sebelum_rollback
FROM tanaman WHERE nama_tanaman = 'Cabai Rawit';
ROLLBACK;
SELECT nama_tanaman, JSON_EXTRACT(spesifikasi, '$.umur_panen_hari') AS sesudah_rollback
FROM tanaman WHERE nama_tanaman = 'Cabai Rawit';

-- 9b. COMMIT: perubahan disimpan permanen
START TRANSACTION;
UPDATE tanaman
SET spesifikasi = JSON_SET(spesifikasi, '$.umur_panen_hari', 95)
WHERE nama_tanaman = 'Cabai Rawit';
COMMIT;
SELECT nama_tanaman, JSON_EXTRACT(spesifikasi, '$.umur_panen_hari') AS sesudah_commit
FROM tanaman WHERE nama_tanaman = 'Cabai Rawit';

-- ---------------------------------------------------------------------
-- 10. PENGUJIAN VALIDASI JSON DAN INTEGRITAS REFERENSIAL
--     Dua perintah di bawah SENGAJA menghasilkan ERROR.
--     Hapus tanda komentar (--) satu per satu untuk menguji.
-- ---------------------------------------------------------------------
-- (a) JSON tidak valid ditolak oleh kolom JSON
-- INSERT INTO tanaman (id_kategori, nama_tanaman, spesifikasi)
-- VALUES (1, 'Uji Gagal', '{umur_panen: seratus');

-- (b) Foreign key menolak data yatim (id_pengguna 99 tidak ada)
-- INSERT INTO lahan (id_pengguna, id_wilayah, nama_lahan, luas_hektar, jenis_tanah)
-- VALUES (99, 1, 'Lahan Yatim', 1.00, 'Aluvial');

-- (c) Foreign key menolak penghapusan data induk yang masih dipakai
-- DELETE FROM wilayah WHERE id_wilayah = 1;
