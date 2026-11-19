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
