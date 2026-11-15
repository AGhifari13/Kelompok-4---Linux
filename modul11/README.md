# Praktikum Modul 11 - Perkembangan DBMS dan Lingkup Penerapan Basis Data

**Mata kuliah:** Praktik Basis Data (RPL24108), Pertemuan 11
**Proyek:** Sistem Informasi Cuaca bagi Petani
**DBMS:** MySQL / MariaDB (utama), dibandingkan dengan PostgreSQL

## Isi repository

| Folder / File | Keterangan |
| --- | --- |
| `sql/01_database.sql` | Identifikasi DBMS (versi, engine, JSON, transaksi) dan pembuatan database `praktikum_modul11` |
| `sql/02_tabel.sql` | Sembilan tabel beserta PRIMARY KEY, FOREIGN KEY, dan kolom JSON |
| `sql/03_data_awal.sql` | Data contoh (fiktif) |
| `sql/04_pengujian_json.sql` | Pengujian JSON (baca, ubah, tambah, hapus, cari), pemetaan objek, transaksi, dan integritas referensial |
| `modul11.sql` | Gabungan seluruh script di atas (satu file, urut dari 01 sampai 04) |
| `diagram/pemodelan_objek.png` | Diagram pemodelan objek (class, attribute, method, inheritance) |
| `dokumentasi/` | Laporan lembar kerja (worksheet) dan dokumen analisis |

## Struktur database

`pengguna`, `wilayah`, `kategori_tanaman`, `tanaman`, `lahan`, `cuaca`, `peringatan_cuaca`, `notifikasi`, `rekomendasi`.

Kolom bertipe JSON:

- `tanaman.spesifikasi`: atribut tanaman yang berbeda-beda (misalnya `kebutuhan_air_mm_per_musim` pada padi, `butuh_mulsa` pada cabai rawit, `umur_panen_bulan` pada tebu).
- `peringatan_cuaca.detail`: detail peringatan yang berbeda untuk tiap jenis (hujan lebat, angin kencang, kekeringan).

## Cara menjalankan

Pastikan MySQL atau MariaDB sudah berjalan (misalnya lewat Laragon), lalu jalankan dari terminal:

```bash
mysql -u root -p < modul11.sql
```

Atau buka `modul11.sql` di DBeaver dan jalankan sebagai script (Alt+X). Script dapat dijalankan berulang kali karena tabel dibuat ulang pada `02_tabel.sql`.

Catatan: tiga perintah pada bagian 10 di `04_pengujian_json.sql` sengaja dibuat sebagai komentar karena akan menghasilkan error (untuk menguji validasi JSON dan foreign key). Hapus tanda `--` untuk mencobanya.

## Catatan MySQL dan MariaDB

Tipe JSON di MySQL bersifat native, sedangkan di MariaDB merupakan alias berbasis teks dengan validasi. Fungsi yang dipakai (`JSON_EXTRACT`, `JSON_SET`, `JSON_REMOVE`, `JSON_CONTAINS`, `JSON_LENGTH`, `JSON_VALID`, `JSON_OBJECT`, `JSON_ARRAY`, `JSON_UNQUOTE`) tersedia pada keduanya, tetapi bunyi pesan error dan tampilan hasil dapat sedikit berbeda.

## Keamanan

Tidak ada password, kredensial database, atau data pribadi nyata pada repository ini. Seluruh data pada script merupakan data contoh.

## Repository

URL repository kelompok: _isi URL repository di sini_
