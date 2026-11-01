CREATE TABLE pelanggan (
    id_pelanggan INT PRIMARY KEY,
    nama_pelanggan VARCHAR(100)
);

CREATE TABLE pesanan (
    id_pesanan INT PRIMARY KEY,
    id_pelanggan INT,
    tanggal DATE,
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);

CREATE TABLE detail_pesanan (
    id_detail INT PRIMARY KEY,
    id_pesanan INT,
    jumlah INT,
    harga_satuan DECIMAL(10,2),
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan)
);

-- Insert Data Fiktif
INSERT INTO pelanggan VALUES (1, 'Sifa'), (2, 'Andi'), (3, 'Kayla'), (4, 'Caca'), (5, 'Rasya');
INSERT INTO pesanan VALUES (101, 1, '2026-10-01'), (102, 2, '2026-10-02'),  (103, 3, '2026-10-03'), (104, 4, '2026-10-04'), (105, 5, '2026-10-05');
INSERT INTO detail_pesanan VALUES (1, 101, 2, 50000), (2, 101, 1, 150000), (3, 103, 5, 20000), (4, 104, 6, 120000), (5, 105, 3, 40000);
