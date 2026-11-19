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
