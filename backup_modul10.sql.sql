-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 08, 2026 at 12:25 PM
-- Server version: 8.4.3
-- PHP Version: 8.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sdg_rkpl+basdat_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `cuaca`
--

CREATE TABLE `cuaca` (
  `id_cuaca` int NOT NULL,
  `id_wilayah` int DEFAULT NULL,
  `waktu` datetime DEFAULT NULL,
  `jenis_data` varchar(50) DEFAULT NULL,
  `suhu` decimal(5,2) DEFAULT NULL,
  `kelembapan` decimal(5,2) DEFAULT NULL,
  `curah_hujan` decimal(10,2) DEFAULT NULL,
  `kecepatan_angin` decimal(5,2) DEFAULT NULL,
  `kondisi` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `cuaca`
--

INSERT INTO `cuaca` (`id_cuaca`, `id_wilayah`, `waktu`, `jenis_data`, `suhu`, `kelembapan`, `curah_hujan`, `kecepatan_angin`, `kondisi`) VALUES
(1, 1, '2026-11-08 07:00:00', 'observasi', 26.00, 82.00, 2.00, 6.00, 'berawan'),
(2, 1, '2026-11-08 14:00:00', 'observasi', 31.50, 65.00, 0.00, 8.00, 'cerah berawan'),
(3, 2, '2026-11-08 09:00:00', 'observasi', 28.00, 75.00, 5.50, 9.50, 'hujan ringan'),
(4, 5, '2026-11-08 08:00:00', 'observasi', 27.00, 85.00, 14.00, 7.00, 'hujan sedang'),
(5, 6, '2026-11-08 12:00:00', 'observasi', 32.00, 60.00, 0.00, 5.00, 'cerah'),
(6, 7, '2026-11-08 15:00:00', 'observasi', 29.00, 78.00, 8.00, 12.00, 'hujan ringan'),
(7, 1, '2026-11-09 15:00:00', 'prakiraan', 25.00, 90.00, 40.00, 18.00, 'hujan lebat'),
(8, 2, '2026-11-10 12:00:00', 'prakiraan', 29.00, 70.00, 3.00, 25.00, 'berangin'),
(9, 5, '2026-11-12 09:00:00', 'prakiraan', 25.50, 92.00, 55.00, 14.00, 'hujan lebat'),
(10, 9, '2026-11-13 10:00:00', 'prakiraan', 26.00, 88.00, 30.00, 10.00, 'hujan sedang');

-- --------------------------------------------------------

--
-- Table structure for table `lahan`
--

CREATE TABLE `lahan` (
  `id_lahan` int NOT NULL,
  `id_pengguna` int DEFAULT NULL,
  `id_wilayah` int DEFAULT NULL,
  `nama_lahan` varchar(100) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `luas_m2` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lahan`
--

INSERT INTO `lahan` (`id_lahan`, `id_pengguna`, `id_wilayah`, `nama_lahan`, `latitude`, `longitude`, `luas_m2`) VALUES
(1, 1, 1, 'Sawah Budi Dolopo', -7.59210000, 111.60480000, 2400.00),
(2, 2, 2, 'Sawah Siti Mejayan', -7.55320000, 111.65610000, 1800.00),
(3, 4, 3, 'Ladang Yanto Wungu', -7.66410000, 111.61820000, 1500.00),
(4, 5, 4, 'Lahan Slamet Geger', -7.70630000, 111.63340000, 3000.00),
(5, 6, 5, 'Kebun Sri Saradan', -7.52910000, 111.75720000, 5000.00),
(6, 7, 7, 'Sawah Agus Maospati', -7.63120000, 111.43910000, 2000.00),
(7, 8, 8, 'Ladang Wulan Plaosan', -7.66940000, 111.32870000, 900.00),
(8, 9, 9, 'Sawah Joko Paron', -7.45820000, 111.33450000, 2600.00),
(9, 10, 10, 'Lahan Dewi Jetis', -7.84230000, 111.51240000, 1200.00),
(10, 1, 6, 'Kebun Budi Kartoharjo', -7.62840000, 111.52370000, 600.00),
(200, 20, 1, 'Lahan Commit', NULL, NULL, 500.00),
(201, 21, 1, 'Lahan Rollback', NULL, NULL, 500.00);

-- --------------------------------------------------------

--
-- Table structure for table `notifikasi`
--

CREATE TABLE `notifikasi` (
  `id_notifikasi` int NOT NULL,
  `id_pengguna` int DEFAULT NULL,
  `id_peringatan` int DEFAULT NULL,
  `isi_pesan` text,
  `waktu_kirim` datetime DEFAULT NULL,
  `status_baca` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notifikasi`
--

INSERT INTO `notifikasi` (`id_notifikasi`, `id_pengguna`, `id_peringatan`, `isi_pesan`, `waktu_kirim`, `status_baca`) VALUES
(1, 1, 1, 'Peringatan hujan lebat untuk wilayah Dolopo, Kabupaten Madiun.', '2026-11-08 18:00:00', 0),
(2, 2, 2, 'Peringatan angin kencang untuk wilayah Mejayan.', '2026-11-09 17:00:00', 0),
(3, 6, 3, 'Peringatan banjir tingkat Awas untuk wilayah Saradan.', '2026-11-11 18:00:00', 0),
(4, 7, 4, 'Peringatan hujan lebat untuk wilayah Maospati, Magetan.', '2026-11-10 20:00:00', 1),
(5, 9, 5, 'Peringatan genangan air untuk wilayah Paron, Ngawi.', '2026-11-12 16:00:00', 0),
(6, 1, 3, 'Info banjir Saradan, pantau kondisi lahan Anda di wilayah terdekat.', '2026-11-11 18:30:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int NOT NULL,
  `nama` varchar(100) NOT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `kata_sandi` varchar(255) NOT NULL,
  `peran` varchar(50) DEFAULT NULL,
  `tanggal_daftar` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `nama`, `no_hp`, `email`, `kata_sandi`, `peran`, `tanggal_daftar`) VALUES
(1, 'Budi Santoso', '081234567890', 'budi@example.test', 'hash_budi', 'petani', '2026-01-01 08:00:00'),
(2, 'Siti Aminah', '081234567891', 'siti@example.test', 'hash_siti', 'petani', '2026-01-02 09:00:00'),
(3, 'Admin', '081234567892', 'admin@example.test', 'hash_admin', 'admin', '2026-01-03 10:00:00'),
(4, 'Yanto', '086767676891', 'yanto@example.test', 'hash_yanto', 'petani', '2026-02-03 12:00:00'),
(5, 'Slamet Riyadi', '082133445501', 'slamet@example.test', 'hash_slamet', 'petani', '2026-02-10 07:30:00'),
(6, 'Sri Wahyuni', '085233445502', 'sri@example.test', 'hash_sri', 'petani', '2026-02-18 13:15:00'),
(7, 'Agus Prasetyo', '081333445503', 'agus@example.test', 'hash_agus', 'petani', '2026-03-05 09:45:00'),
(8, 'Wulan Sari', '087833445504', 'wulan@example.test', 'hash_wulan', 'petani', '2026-03-21 16:20:00'),
(9, 'Joko Susilo', '081533445505', 'joko@example.test', 'hash_joko', 'petani', '2026-04-02 08:10:00'),
(10, 'Dewi Lestari', '085733445506', 'dewi@example.test', 'hash_dewi', 'petani', '2026-04-14 11:00:00'),
(20, 'Uji Commit', NULL, 'commit@example.test', 'hash_commit', 'petani', NULL),
(21, 'Uji Rollback', NULL, 'rollback@example.test', 'hash_rollback', 'petani', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `peringatan_cuaca`
--

CREATE TABLE `peringatan_cuaca` (
  `id_peringatan` int NOT NULL,
  `id_wilayah` int DEFAULT NULL,
  `jenis_peringatan` varchar(100) DEFAULT NULL,
  `tingkat` varchar(50) DEFAULT NULL,
  `deskripsi` text,
  `waktu_mulai` datetime DEFAULT NULL,
  `waktu_berakhir` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `peringatan_cuaca`
--

INSERT INTO `peringatan_cuaca` (`id_peringatan`, `id_wilayah`, `jenis_peringatan`, `tingkat`, `deskripsi`, `waktu_mulai`, `waktu_berakhir`) VALUES
(1, 1, 'Hujan Lebat', 'Siaga', 'Potensi hujan lebat disertai petir di wilayah Dolopo dan sekitarnya.', '2026-11-09 13:00:00', '2026-11-09 19:00:00'),
(2, 2, 'Angin Kencang', 'Waspada', 'Angin kencang berpotensi merusak tanaman muda di sekitar Mejayan.', '2026-11-10 10:00:00', '2026-11-10 17:00:00'),
(3, 5, 'Banjir', 'Awas', 'Risiko genangan di lahan rendah sekitar Saradan akibat hujan berkepanjangan.', '2026-11-12 06:00:00', '2026-11-13 18:00:00'),
(4, 7, 'Hujan Lebat', 'Waspada', 'Hujan intensitas tinggi di Maospati pada sore hingga malam hari.', '2026-11-11 15:00:00', '2026-11-11 22:00:00'),
(5, 9, 'Genangan Air', 'Waspada', 'Potensi genangan pada lahan sawah di sekitar Paron.', '2026-11-13 08:00:00', '2026-11-14 12:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `rekomendasi`
--

CREATE TABLE `rekomendasi` (
  `id_rekomendasi` int NOT NULL,
  `id_lahan` int DEFAULT NULL,
  `id_tanaman` int DEFAULT NULL,
  `jenis` varchar(50) DEFAULT NULL,
  `tanggal_awal` date DEFAULT NULL,
  `tanggal_akhir` date DEFAULT NULL,
  `alasan` text,
  `dibuat_pada` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `rekomendasi`
--

INSERT INTO `rekomendasi` (`id_rekomendasi`, `id_lahan`, `id_tanaman`, `jenis`, `tanggal_awal`, `tanggal_akhir`, `alasan`, `dibuat_pada`) VALUES
(1, 1, 1, 'tanam', '2026-11-15', '2026-12-15', 'Memasuki musim hujan, curah hujan dan suhu sesuai untuk padi.', '2026-11-08 08:00:00'),
(2, 2, 2, 'tunda', '2026-11-10', '2026-11-17', 'Angin kencang diperkirakan, tunda tanam jagung sampai kondisi stabil.', '2026-11-08 08:30:00'),
(3, 3, 3, 'tanam', '2026-11-12', '2026-12-05', 'Curah hujan sedang, cocok untuk penanaman kedelai.', '2026-11-08 09:00:00'),
(4, 4, 2, 'tanam', '2026-11-14', '2026-12-10', 'Tanah Geger mendukung jagung, suhu dan curah hujan masih dalam rentang.', '2026-11-08 09:15:00'),
(5, 5, 6, 'tunda', '2026-11-12', '2026-11-20', 'Risiko banjir di Saradan, tunda penanaman tebu.', '2026-11-08 09:30:00'),
(6, 6, 1, 'tanam', '2026-11-18', '2026-12-18', 'Hujan lebat sementara, tanam padi setelah genangan surut.', '2026-11-08 10:00:00'),
(7, 7, 4, 'tunda', '2026-11-11', '2026-11-18', 'Hujan lebat berpotensi merusak bibit cabai, tunda penanaman.', '2026-11-08 10:15:00'),
(8, 8, 1, 'tunda', '2026-11-13', '2026-11-22', 'Potensi genangan di Paron, tunggu air surut sebelum tanam padi.', '2026-11-08 10:30:00'),
(9, 9, 5, 'tanam', '2026-11-16', '2026-11-30', 'Lahan Jetis relatif kering, cocok untuk bawang merah.', '2026-11-08 10:45:00'),
(2000, 200, 1, 'tanam', '2026-11-01', '2026-12-01', 'Uji commit', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tanaman`
--

CREATE TABLE `tanaman` (
  `id_tanaman` int NOT NULL,
  `nama_tanaman` varchar(100) NOT NULL,
  `masa_tanam_hari` int DEFAULT NULL,
  `curah_hujan_min` decimal(10,2) DEFAULT NULL,
  `curah_hujan_maks` decimal(10,2) DEFAULT NULL,
  `suhu_min` decimal(5,2) DEFAULT NULL,
  `suhu_maks` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tanaman`
--

INSERT INTO `tanaman` (`id_tanaman`, `nama_tanaman`, `masa_tanam_hari`, `curah_hujan_min`, `curah_hujan_maks`, `suhu_min`, `suhu_maks`) VALUES
(1, 'Padi', 120, 100.00, 300.00, 20.00, 35.00),
(2, 'Jagung', 100, 50.00, 200.00, 18.00, 32.00),
(3, 'Kedelai', 85, 60.00, 200.00, 20.00, 33.00),
(4, 'Cabai Rawit', 110, 60.00, 160.00, 18.00, 32.00),
(5, 'Bawang Merah', 65, 30.00, 120.00, 20.00, 32.00),
(6, 'Tebu', 360, 100.00, 250.00, 22.00, 34.00);

-- --------------------------------------------------------

--
-- Table structure for table `wilayah`
--

CREATE TABLE `wilayah` (
  `id_wilayah` int NOT NULL,
  `kode_wilayah` varchar(50) DEFAULT NULL,
  `provinsi` varchar(100) DEFAULT NULL,
  `kabupaten` varchar(100) DEFAULT NULL,
  `kecamatan` varchar(100) DEFAULT NULL,
  `desa` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `wilayah`
--

INSERT INTO `wilayah` (`id_wilayah`, `kode_wilayah`, `provinsi`, `kabupaten`, `kecamatan`, `desa`) VALUES
(1, 'JTM-01', 'Jawa Timur', 'Madiun', 'Dolopo', 'Dolopo'),
(2, 'JTM-02', 'Jawa Timur', 'Madiun', 'Mejayan', 'Mejayan'),
(3, 'JTM-03', 'Jawa Timur', 'Madiun', 'Wungu', 'Wungu'),
(4, 'JTM-04', 'Jawa Timur', 'Madiun', 'Geger', 'Geger'),
(5, 'JTM-05', 'Jawa Timur', 'Madiun', 'Saradan', 'Saradan'),
(6, 'JTM-06', 'Jawa Timur', 'Kota Madiun', 'Kartoharjo', 'Kartoharjo'),
(7, 'JTM-07', 'Jawa Timur', 'Magetan', 'Maospati', 'Maospati'),
(8, 'JTM-08', 'Jawa Timur', 'Magetan', 'Plaosan', 'Plaosan'),
(9, 'JTM-09', 'Jawa Timur', 'Ngawi', 'Paron', 'Paron'),
(10, 'JTM-10', 'Jawa Timur', 'Ponorogo', 'Jetis', 'Jetis');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cuaca`
--
ALTER TABLE `cuaca`
  ADD PRIMARY KEY (`id_cuaca`),
  ADD KEY `idx_cuaca_waktu` (`waktu`),
  ADD KEY `idx_cuaca_wilayah_waktu` (`id_wilayah`,`waktu`);

--
-- Indexes for table `lahan`
--
ALTER TABLE `lahan`
  ADD PRIMARY KEY (`id_lahan`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `id_wilayah` (`id_wilayah`);

--
-- Indexes for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD PRIMARY KEY (`id_notifikasi`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `id_peringatan` (`id_peringatan`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `peringatan_cuaca`
--
ALTER TABLE `peringatan_cuaca`
  ADD PRIMARY KEY (`id_peringatan`),
  ADD KEY `id_wilayah` (`id_wilayah`);

--
-- Indexes for table `rekomendasi`
--
ALTER TABLE `rekomendasi`
  ADD PRIMARY KEY (`id_rekomendasi`),
  ADD KEY `id_lahan` (`id_lahan`),
  ADD KEY `id_tanaman` (`id_tanaman`);

--
-- Indexes for table `tanaman`
--
ALTER TABLE `tanaman`
  ADD PRIMARY KEY (`id_tanaman`);

--
-- Indexes for table `wilayah`
--
ALTER TABLE `wilayah`
  ADD PRIMARY KEY (`id_wilayah`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cuaca`
--
ALTER TABLE `cuaca`
  MODIFY `id_cuaca` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `lahan`
--
ALTER TABLE `lahan`
  MODIFY `id_lahan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=202;

--
-- AUTO_INCREMENT for table `notifikasi`
--
ALTER TABLE `notifikasi`
  MODIFY `id_notifikasi` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `peringatan_cuaca`
--
ALTER TABLE `peringatan_cuaca`
  MODIFY `id_peringatan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `rekomendasi`
--
ALTER TABLE `rekomendasi`
  MODIFY `id_rekomendasi` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2001;

--
-- AUTO_INCREMENT for table `tanaman`
--
ALTER TABLE `tanaman`
  MODIFY `id_tanaman` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `wilayah`
--
ALTER TABLE `wilayah`
  MODIFY `id_wilayah` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cuaca`
--
ALTER TABLE `cuaca`
  ADD CONSTRAINT `cuaca_ibfk_1` FOREIGN KEY (`id_wilayah`) REFERENCES `wilayah` (`id_wilayah`) ON DELETE CASCADE;

--
-- Constraints for table `lahan`
--
ALTER TABLE `lahan`
  ADD CONSTRAINT `lahan_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE,
  ADD CONSTRAINT `lahan_ibfk_2` FOREIGN KEY (`id_wilayah`) REFERENCES `wilayah` (`id_wilayah`) ON DELETE CASCADE;

--
-- Constraints for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD CONSTRAINT `notifikasi_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifikasi_ibfk_2` FOREIGN KEY (`id_peringatan`) REFERENCES `peringatan_cuaca` (`id_peringatan`) ON DELETE CASCADE;

--
-- Constraints for table `peringatan_cuaca`
--
ALTER TABLE `peringatan_cuaca`
  ADD CONSTRAINT `peringatan_cuaca_ibfk_1` FOREIGN KEY (`id_wilayah`) REFERENCES `wilayah` (`id_wilayah`) ON DELETE CASCADE;

--
-- Constraints for table `rekomendasi`
--
ALTER TABLE `rekomendasi`
  ADD CONSTRAINT `rekomendasi_ibfk_1` FOREIGN KEY (`id_lahan`) REFERENCES `lahan` (`id_lahan`) ON DELETE CASCADE,
  ADD CONSTRAINT `rekomendasi_ibfk_2` FOREIGN KEY (`id_tanaman`) REFERENCES `tanaman` (`id_tanaman`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
