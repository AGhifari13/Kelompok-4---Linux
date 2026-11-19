
-- 1. Tabel PENGGUNA
CREATE TABLE pengguna (
    id_pengguna INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL,
    no_hp VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    kata_sandi VARCHAR(255) NOT NULL,
    peran VARCHAR(50),
    tanggal_daftar DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Tabel WILAYAH
CREATE TABLE wilayah (
    id_wilayah INT PRIMARY KEY AUTO_INCREMENT,
    kode_wilayah VARCHAR(50),
    provinsi VARCHAR(100),
    kabupaten VARCHAR(100),
    kecamatan VARCHAR(100),
    desa VARCHAR(100)
) ENGINE=InnoDB;

-- 3. Tabel TANAMAN
CREATE TABLE tanaman (
    id_tanaman INT PRIMARY KEY AUTO_INCREMENT,
    nama_tanaman VARCHAR(100) NOT NULL,
    masa_tanam_hari INT,
    curah_hujan_min DECIMAL(10,2),
    curah_hujan_maks DECIMAL(10,2),
    suhu_min DECIMAL(5,2),
    suhu_maks DECIMAL(5,2)
) ENGINE=InnoDB;

-- 4. Tabel LAHAN
CREATE TABLE lahan (
    id_lahan INT PRIMARY KEY AUTO_INCREMENT,
    id_pengguna INT NOT NULL,
    id_wilayah INT NOT NULL,
    nama_lahan VARCHAR(100),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    luas_m2 DECIMAL(15,2),
    CONSTRAINT fk_lahan_pengguna
        FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_lahan_wilayah
        FOREIGN KEY (id_wilayah) REFERENCES wilayah(id_wilayah)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Tabel PERINGATAN_CUACA
CREATE TABLE peringatan_cuaca (
    id_peringatan INT PRIMARY KEY AUTO_INCREMENT,
    id_wilayah INT NOT NULL,
    jenis_peringatan VARCHAR(100),
    tingkat VARCHAR(50),
    deskripsi TEXT,
    waktu_mulai DATETIME,
    waktu_berakhir DATETIME,
    CONSTRAINT fk_peringatan_wilayah
        FOREIGN KEY (id_wilayah) REFERENCES wilayah(id_wilayah)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. Tabel CUACA
CREATE TABLE cuaca (
    id_cuaca INT PRIMARY KEY AUTO_INCREMENT,
    id_wilayah INT NOT NULL,
    waktu DATETIME,
    jenis_data VARCHAR(50),
    suhu DECIMAL(5,2),
    kelembapan DECIMAL(5,2),
    curah_hujan DECIMAL(10,2),
    kecepatan_angin DECIMAL(5,2),
    kondisi VARCHAR(100),
    CONSTRAINT fk_cuaca_wilayah
        FOREIGN KEY (id_wilayah) REFERENCES wilayah(id_wilayah)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. Tabel NOTIFIKASI
CREATE TABLE notifikasi (
    id_notifikasi INT PRIMARY KEY AUTO_INCREMENT,
    id_pengguna INT NOT NULL,
    id_peringatan INT NOT NULL,
    isi_pesan TEXT,
    waktu_kirim DATETIME,
    status_baca BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_notifikasi_pengguna
        FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_notifikasi_peringatan
        FOREIGN KEY (id_peringatan) REFERENCES peringatan_cuaca(id_peringatan)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. Tabel REKOMENDASI
CREATE TABLE rekomendasi (
    id_rekomendasi INT PRIMARY KEY AUTO_INCREMENT,
    id_lahan INT NOT NULL,
    id_tanaman INT NOT NULL,
    jenis VARCHAR(50),
    tanggal_awal DATE,
    tanggal_akhir DATE,
    alasan TEXT,
    dibuat_pada DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rekomendasi_lahan
        FOREIGN KEY (id_lahan) REFERENCES lahan(id_lahan)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_rekomendasi_tanaman
        FOREIGN KEY (id_tanaman) REFERENCES tanaman(id_tanaman)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- DATA AWAL
-- =========================================================
 
INSERT INTO pengguna
(id_pengguna, nama, no_hp, email, kata_sandi, peran, tanggal_daftar)
VALUES
(1,  'Budi Santoso',   '081234567890', 'budi@example.test',   'hash_budi',   'petani', '2026-01-01 08:00:00'),
(2,  'Siti Aminah',    '081234567891', 'siti@example.test',   'hash_siti',   'petani', '2026-01-02 09:00:00'),
(3,  'Admin',          '081234567892', 'admin@example.test',  'hash_admin',  'admin',  '2026-01-03 10:00:00'),
(4,  'Yanto',          '086767676891', 'yanto@example.test',  'hash_yanto',  'petani', '2026-02-03 12:00:00'),
(5,  'Slamet Riyadi',  '082133445501', 'slamet@example.test', 'hash_slamet', 'petani', '2026-02-10 07:30:00'),
(6,  'Sri Wahyuni',    '085233445502', 'sri@example.test',    'hash_sri',    'petani', '2026-02-18 13:15:00'),
(7,  'Agus Prasetyo',  '081333445503', 'agus@example.test',   'hash_agus',   'petani', '2026-03-05 09:45:00'),
(8,  'Wulan Sari',     '087833445504', 'wulan@example.test',  'hash_wulan',  'petani', '2026-03-21 16:20:00'),
(9,  'Joko Susilo',    '081533445505', 'joko@example.test',   'hash_joko',   'petani', '2026-04-02 08:10:00'),
(10, 'Dewi Lestari',   '085733445506', 'dewi@example.test',   'hash_dewi',   'petani', '2026-04-14 11:00:00');
 
INSERT INTO wilayah
(id_wilayah, kode_wilayah, provinsi, kabupaten, kecamatan, desa)
VALUES
(1,  'JTM-01', 'Jawa Timur', 'Madiun',       'Dolopo',    'Dolopo'),
(2,  'JTM-02', 'Jawa Timur', 'Madiun',       'Mejayan',   'Mejayan'),
(3,  'JTM-03', 'Jawa Timur', 'Madiun',       'Wungu',     'Wungu'),
(4,  'JTM-04', 'Jawa Timur', 'Madiun',       'Geger',     'Geger'),
(5,  'JTM-05', 'Jawa Timur', 'Madiun',       'Saradan',   'Saradan'),
(6,  'JTM-06', 'Jawa Timur', 'Kota Madiun',  'Kartoharjo','Kartoharjo'),
(7,  'JTM-07', 'Jawa Timur', 'Magetan',      'Maospati',  'Maospati'),
(8,  'JTM-08', 'Jawa Timur', 'Magetan',      'Plaosan',   'Plaosan'),
(9,  'JTM-09', 'Jawa Timur', 'Ngawi',        'Paron',     'Paron'),
(10, 'JTM-10', 'Jawa Timur', 'Ponorogo',     'Jetis',     'Jetis');
 
INSERT INTO tanaman
(id_tanaman, nama_tanaman, masa_tanam_hari, curah_hujan_min, curah_hujan_maks, suhu_min, suhu_maks)
VALUES
(1, 'Padi',         120, 100, 300, 20, 35),
(2, 'Jagung',       100,  50, 200, 18, 32),
(3, 'Kedelai',       85,  60, 200, 20, 33),
(4, 'Cabai Rawit',  110,  60, 160, 18, 32),
(5, 'Bawang Merah',  65,  30, 120, 20, 32),
(6, 'Tebu',         360, 100, 250, 22, 34);
 
INSERT INTO lahan
(id_lahan, id_pengguna, id_wilayah, nama_lahan, latitude, longitude, luas_m2)
VALUES
(1,  1,  1, 'Sawah Budi Dolopo',        -7.59210000, 111.60480000, 2400),
(2,  2,  2, 'Sawah Siti Mejayan',       -7.55320000, 111.65610000, 1800),
(3,  4,  3, 'Ladang Yanto Wungu',       -7.66410000, 111.61820000, 1500),
(4,  5,  4, 'Lahan Slamet Geger',       -7.70630000, 111.63340000, 3000),
(5,  6,  5, 'Kebun Sri Saradan',        -7.52910000, 111.75720000, 5000),
(6,  7,  7, 'Sawah Agus Maospati',      -7.63120000, 111.43910000, 2000),
(7,  8,  8, 'Ladang Wulan Plaosan',     -7.66940000, 111.32870000,  900),
(8,  9,  9, 'Sawah Joko Paron',         -7.45820000, 111.33450000, 2600),
(9,  10, 10,'Lahan Dewi Jetis',         -7.84230000, 111.51240000, 1200),
(10, 1,  6, 'Kebun Budi Kartoharjo',    -7.62840000, 111.52370000,  600);
 
INSERT INTO peringatan_cuaca
(id_peringatan, id_wilayah, jenis_peringatan, tingkat, deskripsi, waktu_mulai, waktu_berakhir)
VALUES
(1, 1, 'Hujan Lebat',   'Siaga',   'Potensi hujan lebat disertai petir di wilayah Dolopo dan sekitarnya.',    '2026-11-09 13:00:00', '2026-11-09 19:00:00'),
(2, 2, 'Angin Kencang', 'Waspada', 'Angin kencang berpotensi merusak tanaman muda di sekitar Mejayan.',        '2026-11-10 10:00:00', '2026-11-10 17:00:00'),
(3, 5, 'Banjir',        'Awas',    'Risiko genangan di lahan rendah sekitar Saradan akibat hujan berkepanjangan.', '2026-11-12 06:00:00', '2026-11-13 18:00:00'),
(4, 7, 'Hujan Lebat',   'Waspada', 'Hujan intensitas tinggi di Maospati pada sore hingga malam hari.',        '2026-11-11 15:00:00', '2026-11-11 22:00:00'),
(5, 9, 'Genangan Air',  'Waspada', 'Potensi genangan pada lahan sawah di sekitar Paron.',                     '2026-11-13 08:00:00', '2026-11-14 12:00:00');
 
INSERT INTO cuaca
(id_cuaca, id_wilayah, waktu, jenis_data, suhu, kelembapan, curah_hujan, kecepatan_angin, kondisi)
VALUES
(1,  1, '2026-11-08 07:00:00', 'observasi', 26.0, 82,  2.0,  6.0, 'berawan'),
(2,  1, '2026-11-08 14:00:00', 'observasi', 31.5, 65,  0.0,  8.0, 'cerah berawan'),
(3,  2, '2026-11-08 09:00:00', 'observasi', 28.0, 75,  5.5,  9.5, 'hujan ringan'),
(4,  5, '2026-11-08 08:00:00', 'observasi', 27.0, 85, 14.0,  7.0, 'hujan sedang'),
(5,  6, '2026-11-08 12:00:00', 'observasi', 32.0, 60,  0.0,  5.0, 'cerah'),
(6,  7, '2026-11-08 15:00:00', 'observasi', 29.0, 78,  8.0, 12.0, 'hujan ringan'),
(7,  1, '2026-11-09 15:00:00', 'prakiraan', 25.0, 90, 40.0, 18.0, 'hujan lebat'),
(8,  2, '2026-11-10 12:00:00', 'prakiraan', 29.0, 70,  3.0, 25.0, 'berangin'),
(9,  5, '2026-11-12 09:00:00', 'prakiraan', 25.5, 92, 55.0, 14.0, 'hujan lebat'),
(10, 9, '2026-11-13 10:00:00', 'prakiraan', 26.0, 88, 30.0, 10.0, 'hujan sedang');
 
INSERT INTO notifikasi
(id_notifikasi, id_pengguna, id_peringatan, isi_pesan, waktu_kirim, status_baca)
VALUES
(1, 1,  1, 'Peringatan hujan lebat untuk wilayah Dolopo, Kabupaten Madiun.',   '2026-11-08 18:00:00', FALSE),
(2, 2,  2, 'Peringatan angin kencang untuk wilayah Mejayan.',                  '2026-11-09 17:00:00', FALSE),
(3, 6,  3, 'Peringatan banjir tingkat Awas untuk wilayah Saradan.',            '2026-11-11 18:00:00', FALSE),
(4, 7,  4, 'Peringatan hujan lebat untuk wilayah Maospati, Magetan.',          '2026-11-10 20:00:00', TRUE),
(5, 9,  5, 'Peringatan genangan air untuk wilayah Paron, Ngawi.',              '2026-11-12 16:00:00', FALSE),
(6, 1,  3, 'Info banjir Saradan, pantau kondisi lahan Anda di wilayah terdekat.', '2026-11-11 18:30:00', TRUE);
 
INSERT INTO rekomendasi
(id_rekomendasi, id_lahan, id_tanaman, jenis, tanggal_awal, tanggal_akhir, alasan, dibuat_pada)
VALUES
(1, 1, 1, 'tanam', '2026-11-15', '2026-12-15', 'Memasuki musim hujan, curah hujan dan suhu sesuai untuk padi.',          '2026-11-08 08:00:00'),
(2, 2, 2, 'tunda', '2026-11-10', '2026-11-17', 'Angin kencang diperkirakan, tunda tanam jagung sampai kondisi stabil.',  '2026-11-08 08:30:00'),
(3, 3, 3, 'tanam', '2026-11-12', '2026-12-05', 'Curah hujan sedang, cocok untuk penanaman kedelai.',                   '2026-11-08 09:00:00'),
(4, 4, 2, 'tanam', '2026-11-14', '2026-12-10', 'Tanah Geger mendukung jagung, suhu dan curah hujan masih dalam rentang.', '2026-11-08 09:15:00'),
(5, 5, 6, 'tunda', '2026-11-12', '2026-11-20', 'Risiko banjir di Saradan, tunda penanaman tebu.',                      '2026-11-08 09:30:00'),
(6, 6, 1, 'tanam', '2026-11-18', '2026-12-18', 'Hujan lebat sementara, tanam padi setelah genangan surut.',            '2026-11-08 10:00:00'),
(7, 7, 4, 'tunda', '2026-11-11', '2026-11-18', 'Hujan lebat berpotensi merusak bibit cabai, tunda penanaman.',         '2026-11-08 10:15:00'),
(8, 8, 1, 'tunda', '2026-11-13', '2026-11-22', 'Potensi genangan di Paron, tunggu air surut sebelum tanam padi.',      '2026-11-08 10:30:00'),
(9, 9, 5, 'tanam', '2026-11-16', '2026-11-30', 'Lahan Jetis relatif kering, cocok untuk bawang merah.',                '2026-11-08 10:45:00');
 

-- =========================================================
-- CRUD
-- =========================================================
-- CREATE
INSERT INTO pengguna (nama, no_hp, email, kata_sandi, peran)
VALUES ('Mundi', '081200000000', 'mundi@example.test', 'hash_mundi', 'petani');

-- READ
SELECT id_pengguna, nama, email, peran FROM pengguna;
SELECT * FROM lahan WHERE luas_m2 > 500;

-- UPDATE
UPDATE pengguna
SET no_hp = '085385543188'
WHERE email = 'mundi@example.test';

SELECT * FROM pengguna WHERE email = 'mundi@example.test';

-- DELETE (pelanggan/pengguna yang belum punya anak)
DELETE FROM pengguna
WHERE email = 'mundi@example.test';

SELECT * FROM pengguna;

-- =========================================================
-- UJI INTEGRITAS REFERENSIAL
-- =========================================================
INSERT INTO lahan (id_pengguna, id_wilayah, nama_lahan)
VALUES (999, 1, 'Uji FK gagal');

START TRANSACTION;
DELETE FROM pengguna WHERE id_pengguna = 1;
SELECT * FROM lahan WHERE id_pengguna = 1;
SELECT * FROM rekomendasi WHERE id_lahan = 1;
ROLLBACK;

-- =========================================================
-- TRANSAKSI: COMMIT
-- =========================================================
START TRANSACTION;

INSERT INTO pengguna
(id_pengguna, nama, email, kata_sandi, peran)
VALUES
(20, 'Uji Commit', 'commit@example.test', 'hash_commit', 'petani');

INSERT INTO lahan
(id_lahan, id_pengguna, id_wilayah, nama_lahan, luas_m2)
VALUES
(200, 20, 1, 'Lahan Commit', 500);

INSERT INTO rekomendasi
(id_rekomendasi, id_lahan, id_tanaman, jenis, tanggal_awal, tanggal_akhir, alasan)
VALUES
(2000, 200, 1, 'tanam', '2026-11-01', '2026-12-01', 'Uji commit');

COMMIT;

SELECT * FROM pengguna WHERE id_pengguna = 20;
SELECT * FROM lahan WHERE id_lahan = 200;
SELECT * FROM rekomendasi WHERE id_rekomendasi = 2000;

-- =========================================================
-- TRANSAKSI: ROLLBACK
-- =========================================================
START TRANSACTION;

INSERT INTO pengguna
(id_pengguna, nama, email, kata_sandi, peran)
VALUES
(21, 'Uji Rollback', 'rollback@example.test', 'hash_rollback', 'petani');

INSERT INTO lahan
(id_lahan, id_pengguna, id_wilayah, nama_lahan, luas_m2)
VALUES
(201, 21, 1, 'Lahan Rollback', 500);

ROLLBACK;

SELECT * FROM pengguna WHERE id_pengguna = 21; 
SELECT * FROM lahan WHERE id_lahan = 201;      

-- =========================================================
-- EXPLAIN SEBELUM INDEX
-- =========================================================
EXPLAIN
SELECT id_cuaca, id_wilayah, waktu, suhu, kondisi
FROM cuaca
WHERE waktu >= '2025-01-01 00:00:00'
  AND waktu <  '2025-02-01 00:00:00';

-- =========================================================
-- MEMBUAT INDEX
-- =========================================================
CREATE INDEX idx_cuaca_waktu
ON cuaca(waktu);

CREATE INDEX idx_cuaca_wilayah_waktu
ON cuaca(id_wilayah, waktu);

SHOW INDEX FROM cuaca;

-- =========================================================
-- EXPLAIN SESUDAH INDEX
-- =========================================================
EXPLAIN
SELECT id_cuaca, id_wilayah, waktu, suhu, kondisi
FROM cuaca
WHERE waktu >= '2025-01-01 00:00:00'
  AND waktu <  '2025-02-01 00:00:00';

EXPLAIN
SELECT w.provinsi, COUNT(*) AS jumlah
FROM cuaca c
JOIN wilayah w ON c.id_wilayah = w.id_wilayah
WHERE c.waktu >= '2025-01-01 00:00:00'
  AND c.waktu <  '2025-02-01 00:00:00'
GROUP BY w.provinsi;

-- =========================================================
-- VALIDASI
-- =========================================================
SHOW TABLES;
SHOW CREATE TABLE lahan;
SHOW CREATE TABLE rekomendasi;

SELECT COUNT(*) AS jumlah_pengguna FROM pengguna;
SELECT COUNT(*) AS jumlah_wilayah FROM wilayah;
SELECT COUNT(*) AS jumlah_cuaca FROM cuaca;
