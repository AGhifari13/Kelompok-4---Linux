# Praktikum Modul 12 - Konsep Pemrosesan Query (Redis)

Kelompok: Cornelia Nasywa Puji Agustin (264311065), Muhammad Ahnaf Ghifari (264311075), Neisya Grazia Aulia Firdianty (264311079)

DBMS target: Redis 8.10.3 (Key-Value Store)
Proyek: Sistem Informasi Cuaca bagi Petani

## Cara menjalankan

1. Jalankan Redis (sudo service redis-server start)
2. Jalankan script di folder scripts secara berurutan:
   - 01_migrasi_data_latihan.redis
   - 02_query_transportasi.redis
   - 03_pengujian_dcl.redis
   - 04_rancangan_migrasi_pjbl.redis

## Asumsi

- started_at dianggap UTC; skor Sorted Set = epoch detik
- Password pada script hanyalah placeholder (PASSWORD_PLACEHOLDER)
