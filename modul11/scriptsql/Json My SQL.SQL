-- =====================================================================
-- BAGIAN 1. IDENTIFIKASI DBMS (01_database.sql)
-- =====================================================================
SELECT VERSION() AS versi_dbms;
SELECT @@version_comment AS informasi_dbms;
SHOW ENGINES;
SHOW VARIABLES LIKE 'character_set_server';
SHOW VARIABLES LIKE 'collation_server';
SHOW VARIABLES LIKE 'autocommit';
SHOW VARIABLES LIKE '%isolation%';

-- Pemeriksaan dukungan JSON
SELECT JSON_VALID('{"nama":"Budi"}')                    AS json_valid,
       JSON_EXTRACT('{"nama":"Budi"}', '$.nama')        AS nilai_nama;


-- =====================================================================
-- BAGIAN 2. MEMBUAT DATABASE DAN TABEL (02_tabel.sql)
-- =====================================================================
-- Hapus tanda komentar baris di bawah HANYA jika ingin mengulang dari awal:
-- DROP DATABASE IF EXISTS praktikum_modul11;

CREATE DATABASE IF NOT EXISTS praktikum_modul11
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE praktikum_modul11;

CREATE TABLE pengguna (
    id_pengguna  INT AUTO_INCREMENT PRIMARY KEY,
    nama         VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    peran        VARCHAR(20)  NOT NULL DEFAULT 'petani',   -- petani / admin
    no_telepon   VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE wilayah (
    id_wilayah    INT AUTO_INCREMENT PRIMARY KEY,
    nama_wilayah  VARCHAR(100) NOT NULL,
    kabupaten     VARCHAR(100) NOT NULL,
    latitude      DECIMAL(9,6),
    longitude     DECIMAL(9,6)
) ENGINE=InnoDB;

CREATE TABLE kategori_tanaman (
    id_kategori    INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori  VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE tanaman (
    id_tanaman    INT AUTO_INCREMENT PRIMARY KEY,
    id_kategori   INT NOT NULL,
    nama_tanaman  VARCHAR(100) NOT NULL,
    spesifikasi   JSON NOT NULL,
    CONSTRAINT fk_tanaman_kategori
        FOREIGN KEY (id_kategori) REFERENCES kategori_tanaman(id_kategori)
) ENGINE=InnoDB;

CREATE TABLE lahan (
    id_lahan     INT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna  INT NOT NULL,
    id_wilayah   INT NOT NULL,
    nama_lahan   VARCHAR(100) NOT NULL,
    luas_hektar  DECIMAL(6,2) NOT NULL,
    jenis_tanah  VARCHAR(50),
    CONSTRAINT fk_lahan_pengguna
        FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna),
    CONSTRAINT fk_lahan_wilayah
        FOREIGN KEY (id_wilayah)  REFERENCES wilayah(id_wilayah)
) ENGINE=InnoDB;

CREATE TABLE cuaca (
    id_cuaca             INT AUTO_INCREMENT PRIMARY KEY,
    id_wilayah           INT NOT NULL,
    waktu_data           DATETIME NOT NULL,
    jenis_data           VARCHAR(20) NOT NULL DEFAULT 'observasi', -- observasi / prakiraan
    suhu_c               DECIMAL(4,1),
    kelembapan_persen    DECIMAL(5,2),
    curah_hujan_mm       DECIMAL(6,2),
    kecepatan_angin_kmj  DECIMAL(5,2),
    CONSTRAINT fk_cuaca_wilayah
        FOREIGN KEY (id_wilayah) REFERENCES wilayah(id_wilayah),
    INDEX idx_cuaca_wilayah_waktu (id_wilayah, waktu_data)
) ENGINE=InnoDB;

CREATE TABLE peringatan_cuaca (
    id_peringatan     INT AUTO_INCREMENT PRIMARY KEY,
    id_wilayah        INT NOT NULL,
    jenis_peringatan  VARCHAR(30) NOT NULL,
    tingkat           VARCHAR(20) NOT NULL,
    waktu_mulai       DATETIME NOT NULL,
    waktu_selesai     DATETIME,
    detail            JSON NOT NULL,
    CONSTRAINT fk_peringatan_wilayah
        FOREIGN KEY (id_wilayah) REFERENCES wilayah(id_wilayah)
) ENGINE=InnoDB;

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

CREATE TABLE rekomendasi (
    id_rekomendasi  INT AUTO_INCREMENT PRIMARY KEY,
    id_lahan        INT NOT NULL,
    id_peringatan   INT,
    isi_rekomendasi VARCHAR(255) NOT NULL,
    dibuat_pada     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rekomendasi_lahan
        FOREIGN KEY (id_lahan)      REFERENCES lahan(id_lahan),
    CONSTRAINT fk_rekomendasi_peringatan
        FOREIGN KEY (id_peringatan) REFERENCES peringatan_cuaca(id_peringatan)
) ENGINE=InnoDB;

SHOW TABLES;          -- sembilan tabel
DESCRIBE tanaman;


-- =====================================================================
-- BAGIAN 3. MENGISI DATA (03_data_awal.sql)
-- Semua data adalah data contoh (fiktif).
-- =====================================================================
INSERT INTO wilayah (nama_wilayah, kabupaten, latitude, longitude) VALUES
('Kecamatan Kartoharjo', 'Kota Madiun', -7.629000, 111.523000),
('Kecamatan Maospati',   'Magetan',     -7.620000, 111.350000),
('Kecamatan Geneng',     'Ngawi',       -7.450000, 111.350000);

INSERT INTO pengguna (nama, email, peran, no_telepon) VALUES
('Slamet',        'slamet@contoh.id', 'petani', '081200000001'),
('Siti Rahayu',   'siti@contoh.id',   'petani', '081200000002'),
('Admin Sistem',  'admin@contoh.id',  'admin',  '081200000003');

INSERT INTO lahan (id_pengguna, id_wilayah, nama_lahan, luas_hektar, jenis_tanah) VALUES
(1, 1, 'Sawah Kartoharjo', 1.50, 'Aluvial'),
(2, 2, 'Kebun Cabai Maospati', 0.75, 'Latosol'),
(1, 3, 'Ladang Geneng', 2.00, 'Regosol');

INSERT INTO cuaca (id_wilayah, waktu_data, jenis_data, suhu_c, kelembapan_persen, curah_hujan_mm, kecepatan_angin_kmj) VALUES
(1, '2026-11-13 12:00:00', 'observasi', 31.5, 70.00,  2.50, 12.00),
(2, '2026-11-13 12:00:00', 'observasi', 32.0, 65.00,  0.00, 25.00),
(3, '2026-11-13 12:00:00', 'observasi', 34.5, 55.00,  0.00,  8.00),
(1, '2026-11-14 14:00:00', 'prakiraan', 27.0, 88.00, 85.00, 20.00);

-- 5.2 Mengisi data (INSERT) dengan atribut JSON berbeda
INSERT INTO kategori_tanaman (nama_kategori) VALUES
('Tanaman Pangan'), ('Hortikultura'), ('Perkebunan');

INSERT INTO tanaman (id_kategori, nama_tanaman, spesifikasi) VALUES
(1, 'Padi', '{"umur_panen_hari": 110, "suhu_optimal_c": {"min": 22, "max": 30},
  "kebutuhan_air_mm_per_musim": 1200, "ph_tanah": "5.5-7.0", "sistem_tanam": "sawah irigasi",
  "musim_tanam": ["Musim Hujan", "Musim Kemarau"], "rentan_terhadap": ["banjir", "wereng"]}'),
(2, 'Cabai Rawit', '{"umur_panen_hari": 90, "suhu_optimal_c": {"min": 24, "max": 32},
  "ph_tanah": "6.0-7.0", "jarak_tanam_cm": "60x50", "butuh_mulsa": true,
  "rentan_terhadap": ["hujan lebat", "antraknosa"]}'),
(3, 'Tebu', '{"umur_panen_bulan": 12, "curah_hujan_optimal_mm_per_tahun": "1500-2500",
  "ph_tanah": "6.0-7.5", "varietas": ["Varietas A", "Varietas B"],
  "rentan_terhadap": ["kekeringan", "angin kencang"]}'),
(1, 'Jagung', '{"umur_panen_hari": 100, "suhu_optimal_c": {"min": 21, "max": 34},
  "ph_tanah": "5.6-7.5", "rentan_terhadap": ["kekeringan", "angin kencang"]}');

INSERT INTO peringatan_cuaca (id_wilayah, jenis_peringatan, tingkat, waktu_mulai, waktu_selesai, detail) VALUES
(1, 'Hujan Lebat', 'Waspada', '2026-11-14 14:00:00', '2026-11-14 18:00:00',
  '{"curah_hujan_mm": 85, "durasi_jam": 4, "potensi_banjir": true,
    "saran": ["Buka saluran drainase", "Tunda pemupukan"]}'),
(2, 'Angin Kencang', 'Siaga', '2026-11-15 09:00:00', '2026-11-15 15:00:00',
  '{"kecepatan_kmj": 55, "arah_angin": "Barat Daya",
    "saran": ["Pasang penyangga tanaman", "Tunda penyemprotan"]}'),
(3, 'Kekeringan', 'Waspada', '2026-11-10 00:00:00', '2026-11-24 00:00:00',
  '{"hari_tanpa_hujan": 21, "indeks_kekeringan": "Tinggi",
    "saran": ["Atur jadwal irigasi", "Gunakan mulsa"]}');

INSERT INTO notifikasi (id_pengguna, id_peringatan, pesan, status_baca) VALUES
(1, 1, 'Peringatan hujan lebat di Kecamatan Kartoharjo, siapkan drainase sawah.', 0),
(2, 2, 'Peringatan angin kencang di Kecamatan Maospati, pasang penyangga tanaman.', 1),
(1, 3, 'Peringatan kekeringan di Kecamatan Geneng, atur jadwal irigasi.', 0);

INSERT INTO rekomendasi (id_lahan, id_peringatan, isi_rekomendasi) VALUES
(1, 1, 'Buka saluran drainase dan tunda pemupukan sampai hujan reda.'),
(3, 3, 'Atur jadwal irigasi dan gunakan mulsa untuk menjaga kelembapan tanah.');

SELECT * FROM tanaman;
SELECT * FROM peringatan_cuaca;


-- =====================================================================
-- BAGIAN 4. PENGUJIAN JSON (04_pengujian_json.sql)
-- =====================================================================

-- 5.3 Membaca atribut JSON (SELECT)
SELECT nama_tanaman, JSON_EXTRACT(spesifikasi, '$.umur_panen_hari') AS umur_panen_hari FROM tanaman;
SELECT nama_tanaman, JSON_EXTRACT(spesifikasi, '$.ph_tanah') AS ph_tanah FROM tanaman;
SELECT nama_tanaman, JSON_EXTRACT(spesifikasi, '$.butuh_mulsa') AS butuh_mulsa FROM tanaman;
SELECT nama_tanaman,
       JSON_UNQUOTE(JSON_EXTRACT(spesifikasi, '$.suhu_optimal_c.min')) AS suhu_min,
       JSON_UNQUOTE(JSON_EXTRACT(spesifikasi, '$.suhu_optimal_c.max')) AS suhu_max FROM tanaman;

-- 5.4 Mengubah atribut JSON (UPDATE dengan JSON_SET)
UPDATE tanaman
SET spesifikasi = JSON_SET(spesifikasi, '$.kebutuhan_air_mm_per_musim', 1100)
WHERE nama_tanaman = 'Padi';
SELECT nama_tanaman, JSON_EXTRACT(spesifikasi, '$.kebutuhan_air_mm_per_musim') AS kebutuhan_air
FROM tanaman WHERE nama_tanaman = 'Padi';

-- 5.5 Menambah atribut JSON baru
UPDATE tanaman
SET spesifikasi = JSON_SET(spesifikasi, '$.rekomendasi_pupuk', 'NPK 15-15-15')
WHERE nama_tanaman = 'Padi';
SELECT nama_tanaman, spesifikasi FROM tanaman WHERE nama_tanaman = 'Padi';

-- 5.6 Menghapus atribut JSON (JSON_REMOVE)
UPDATE tanaman
SET spesifikasi = JSON_REMOVE(spesifikasi, '$.rekomendasi_pupuk')
WHERE nama_tanaman = 'Padi';
SELECT nama_tanaman, spesifikasi FROM tanaman WHERE nama_tanaman = 'Padi';

-- 5.7 Pencarian berdasarkan atribut JSON
-- pH tanah 6.0-7.0
SELECT nama_tanaman, spesifikasi FROM tanaman
WHERE JSON_UNQUOTE(JSON_EXTRACT(spesifikasi, '$.ph_tanah')) = '6.0-7.0';
-- tanaman yang rentan terhadap banjir (nilai di dalam array)
SELECT nama_tanaman FROM tanaman
WHERE JSON_CONTAINS(spesifikasi, '"banjir"', '$.rentan_terhadap');
-- tanaman yang rentan terhadap kekeringan
SELECT nama_tanaman FROM tanaman
WHERE JSON_CONTAINS(spesifikasi, '"kekeringan"', '$.rentan_terhadap');
-- peringatan dengan curah hujan >= 50 mm
SELECT id_peringatan, jenis_peringatan, tingkat,
       JSON_EXTRACT(detail, '$.curah_hujan_mm') AS curah_hujan_mm
FROM peringatan_cuaca
WHERE CAST(JSON_UNQUOTE(JSON_EXTRACT(detail, '$.curah_hujan_mm')) AS DECIMAL(6,2)) >= 50;

-- 5.8 Fungsi JSON lainnya
SELECT JSON_OBJECT('nama', 'Slamet', 'peran', 'petani', 'luas_ha', 1.5) AS data_petani;
SELECT JSON_ARRAY('MySQL', 'PostgreSQL', 'MariaDB') AS daftar_dbms;
SELECT JSON_VALID('{"jenis":"Hujan Lebat","curah_hujan_mm":85}') AS json_valid_benar,
       JSON_VALID('{jenis: Hujan Lebat') AS json_valid_salah;
SELECT nama_tanaman, JSON_LENGTH(spesifikasi) AS jumlah_atribut FROM tanaman;
SELECT jenis_peringatan, JSON_LENGTH(detail) AS jumlah_atribut FROM peringatan_cuaca;


-- =====================================================================
-- BAGIAN 5. MENGGABUNGKAN DATA RELASIONAL DAN JSON (5.9)
-- =====================================================================
SELECT t.id_tanaman, t.nama_tanaman, k.nama_kategori,
       JSON_EXTRACT(t.spesifikasi, '$.ph_tanah') AS ph_tanah
FROM tanaman t
JOIN kategori_tanaman k ON t.id_kategori = k.id_kategori;

SELECT p.nama AS petani, w.nama_wilayah, pc.jenis_peringatan, pc.tingkat,
       JSON_EXTRACT(pc.detail, '$.saran[0]') AS saran_utama, n.pesan, n.status_baca
FROM notifikasi n
JOIN pengguna p          ON n.id_pengguna   = p.id_pengguna
JOIN peringatan_cuaca pc ON n.id_peringatan = pc.id_peringatan
JOIN wilayah w           ON pc.id_wilayah   = w.id_wilayah;


-- =====================================================================
-- BAGIAN 6. PENGUJIAN TRANSAKSI PADA DATA JSON (5.10)
-- =====================================================================
-- ROLLBACK: perubahan dibatalkan
START TRANSACTION;
UPDATE tanaman SET spesifikasi = JSON_SET(spesifikasi, '$.umur_panen_hari', 999)
WHERE nama_tanaman = 'Cabai Rawit';
SELECT JSON_EXTRACT(spesifikasi, '$.umur_panen_hari') AS sebelum_rollback
FROM tanaman WHERE nama_tanaman = 'Cabai Rawit';
ROLLBACK;
SELECT JSON_EXTRACT(spesifikasi, '$.umur_panen_hari') AS sesudah_rollback
FROM tanaman WHERE nama_tanaman = 'Cabai Rawit';

-- COMMIT: perubahan disimpan permanen
START TRANSACTION;
UPDATE tanaman SET spesifikasi = JSON_SET(spesifikasi, '$.umur_panen_hari', 95)
WHERE nama_tanaman = 'Cabai Rawit';
COMMIT;
SELECT JSON_EXTRACT(spesifikasi, '$.umur_panen_hari') AS sesudah_commit
FROM tanaman WHERE nama_tanaman = 'Cabai Rawit';


-- =====================================================================
-- BAGIAN 7. PEMETAAN OBJEK KE RELASIONAL (6.4)
-- Pengambilan data berdasarkan jenis objek (kelas turunan)
-- =====================================================================
SELECT id_peringatan, tingkat, detail FROM peringatan_cuaca WHERE jenis_peringatan = 'Hujan Lebat';
SELECT id_peringatan, tingkat, detail FROM peringatan_cuaca WHERE jenis_peringatan = 'Angin Kencang';
SELECT id_peringatan, tingkat, detail FROM peringatan_cuaca WHERE jenis_peringatan = 'Kekeringan';


-- =====================================================================
-- BAGIAN 8. PENGUJIAN VALIDASI JSON DAN INTEGRITAS REFERENSIAL (5.11)
-- SENGAJA ERROR - jalankan satu per satu, jangan sebagai satu script.
-- Ketiganya harus ditolak oleh DBMS.
-- =====================================================================
-- (a) JSON tidak valid harus ditolak
INSERT INTO tanaman (id_kategori, nama_tanaman, spesifikasi)
VALUES (1, 'Uji Gagal', '{umur_panen: seratus');

-- (b) FOREIGN KEY menolak data yatim (id_pengguna 99 tidak ada) -> error 1452
INSERT INTO lahan (id_pengguna, id_wilayah, nama_lahan, luas_hektar, jenis_tanah)
VALUES (99, 1, 'Lahan Yatim', 1.00, 'Aluvial');

-- (c) FOREIGN KEY menolak penghapusan data induk yang masih dipakai -> error 1451
DELETE FROM wilayah WHERE id_wilayah = 1;

