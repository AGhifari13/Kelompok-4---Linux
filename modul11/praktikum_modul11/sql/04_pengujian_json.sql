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
