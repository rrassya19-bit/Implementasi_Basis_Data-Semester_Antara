-- =========================================================
-- PRAKTIKUM 1
-- Query Dasar dan Built-in Function pada SQL Server
-- =========================================================
 
-- ================= PEMBUATAN DATABASE & TABEL =================
 
CREATE DATABASE DB_Petshop;
 
USE DB_Petshop;
 
CREATE TABLE Pelanggan
(
    KodePelanggan CHAR(6) NOT NULL,
    NamaPelanggan VARCHAR(100) NOT NULL,
    JenisKelamin CHAR(1) NOT NULL,
    Alamat VARCHAR(200),
    NoHP VARCHAR(13) NOT NULL,
    CONSTRAINT PK_Pelanggan
        PRIMARY KEY (KodePelanggan),
    CONSTRAINT CK_Pelanggan_JK
        CHECK (JenisKelamin IN ('L','P')),
    CONSTRAINT CK_Pelanggan_NoHP
        CHECK
        (
            LEN(NoHP) BETWEEN 10 AND 13
            AND NoHP LIKE '08%'
            AND NoHP NOT LIKE '%[^0-9]%'
        )
);
 
CREATE TABLE Hewan
(
    KodeHewan CHAR(6) NOT NULL,
    NamaHewan VARCHAR(100) NOT NULL,
    JenisHewan VARCHAR(50) NOT NULL,
    Ras VARCHAR(50),
    TanggalLahir DATE,
    KodePelanggan CHAR(6) NOT NULL,
    CONSTRAINT PK_Hewan PRIMARY KEY (KodeHewan),
    CONSTRAINT FK_Hewan_Pelanggan
        FOREIGN KEY (KodePelanggan)
        REFERENCES Pelanggan(KodePelanggan)
);
 
CREATE TABLE KategoriProduk
(
    KodeKategori CHAR(6) NOT NULL,
    NamaKategori VARCHAR(100) NOT NULL,
    Keterangan VARCHAR(200),
    CONSTRAINT PK_KategoriProduk PRIMARY KEY (KodeKategori)
);
 
CREATE TABLE Produk
(
    KodeProduk CHAR(6) NOT NULL,
    NamaProduk VARCHAR(100) NOT NULL,
    KodeKategori CHAR(6) NOT NULL,
    Harga DECIMAL(18,2) NOT NULL,
    Stok INT NOT NULL,
    CONSTRAINT PK_Produk PRIMARY KEY (KodeProduk),
    CONSTRAINT FK_Produk_KategoriProduk
        FOREIGN KEY (KodeKategori)
        REFERENCES KategoriProduk(KodeKategori),
    CONSTRAINT CK_Produk_Harga CHECK (Harga >= 0),
    CONSTRAINT CK_Produk_Stok CHECK (Stok >= 0)
);
 
CREATE TABLE Pegawai
(
    KodePegawai CHAR(6) NOT NULL,
    NamaPegawai VARCHAR(100) NOT NULL,
    Jabatan VARCHAR(50) NOT NULL,
    NoHP VARCHAR(20),
    CONSTRAINT PK_Pegawai PRIMARY KEY (KodePegawai)
);
 
CREATE TABLE Layanan
(
    KodeLayanan CHAR(6) NOT NULL,
    NamaLayanan VARCHAR(100) NOT NULL,
    HargaLayanan DECIMAL(18,2) NOT NULL,
    DurasiMenit INT NOT NULL,
    CONSTRAINT PK_Layanan PRIMARY KEY (KodeLayanan),
    CONSTRAINT CK_Layanan_Harga CHECK (HargaLayanan >= 0),
    CONSTRAINT CK_Layanan_Durasi CHECK (DurasiMenit > 0)
);
 
CREATE TABLE Penjualan
(
    KodePenjualan CHAR(6) NOT NULL,
    TanggalPenjualan DATE NOT NULL,
    KodePelanggan CHAR(6) NOT NULL,
    KodePegawai CHAR(6) NOT NULL,
    MetodeBayar VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Penjualan PRIMARY KEY (KodePenjualan),
    CONSTRAINT FK_Penjualan_Pelanggan
        FOREIGN KEY (KodePelanggan)
        REFERENCES Pelanggan(KodePelanggan),
    CONSTRAINT FK_Penjualan_Pegawai
        FOREIGN KEY (KodePegawai)
        REFERENCES Pegawai(KodePegawai),
    CONSTRAINT CK_Penjualan_MetodeBayar
        CHECK (MetodeBayar IN ('Cash','Transfer','QRIS','Debit'))
);
 
CREATE TABLE DetailPenjualan
(
    KodePenjualan CHAR(6) NOT NULL,
    KodeProduk CHAR(6) NOT NULL,
    Jumlah INT NOT NULL,
    HargaJual DECIMAL(18,2) NOT NULL,
    Diskon DECIMAL(18,2) DEFAULT 0,
    CONSTRAINT PK_DetailPenjualan
        PRIMARY KEY (KodePenjualan, KodeProduk),
    CONSTRAINT FK_DetailPenjualan_Penjualan
        FOREIGN KEY (KodePenjualan)
        REFERENCES Penjualan(KodePenjualan),
    CONSTRAINT FK_DetailPenjualan_Produk
        FOREIGN KEY (KodeProduk)
        REFERENCES Produk(KodeProduk),
    CONSTRAINT CK_DetailPenjualan_Jumlah CHECK (Jumlah > 0),
    CONSTRAINT CK_DetailPenjualan_HargaJual CHECK (HargaJual >= 0),
    CONSTRAINT CK_DetailPenjualan_Diskon CHECK (Diskon >= 0)
);
 
CREATE TABLE ReservasiLayanan
(
    KodeReservasi CHAR(6) NOT NULL,
    TanggalReservasi DATE NOT NULL,
    JamReservasi TIME NOT NULL,
    KodePelanggan CHAR(6) NOT NULL,
    KodeHewan CHAR(6) NOT NULL,
    KodeLayanan CHAR(6) NOT NULL,
    KodePegawai CHAR(6) NOT NULL,
    StatusReservasi VARCHAR(20) NOT NULL,
    CONSTRAINT PK_ReservasiLayanan PRIMARY KEY (KodeReservasi),
    CONSTRAINT FK_Reservasi_Pelanggan
        FOREIGN KEY (KodePelanggan)
        REFERENCES Pelanggan(KodePelanggan),
    CONSTRAINT FK_Reservasi_Hewan
        FOREIGN KEY (KodeHewan)
        REFERENCES Hewan(KodeHewan),
    CONSTRAINT FK_Reservasi_Layanan
        FOREIGN KEY (KodeLayanan)
        REFERENCES Layanan(KodeLayanan),
    CONSTRAINT FK_Reservasi_Pegawai
        FOREIGN KEY (KodePegawai)
        REFERENCES Pegawai(KodePegawai),
    CONSTRAINT CK_Reservasi_Status
        CHECK (StatusReservasi IN ('Booking','Selesai','Batal'))
);
 
CREATE TABLE AuditStok
(
    KodeAudit CHAR(6) NOT NULL,
    KodeProduk CHAR(6) NOT NULL,
    TanggalAudit DATETIME NOT NULL,
    StokSebelum INT NOT NULL,
    StokSesudah INT NOT NULL,
    Keterangan VARCHAR(200),
    CONSTRAINT PK_AuditStok PRIMARY KEY (KodeAudit),
    CONSTRAINT FK_AuditStok_Produk
        FOREIGN KEY (KodeProduk)
        REFERENCES Produk(KodeProduk)
);
 
-- ================= INSERT DATA =================
 
INSERT INTO Pelanggan VALUES
('PLG001', 'Andi Saputra', 'L', 'Yogyakarta', '081111111111'),
('PLG002', 'Citra Lestari', 'P', 'Sleman', '082222222222'),
('PLG003', 'Budi Santoso', 'L', 'Bantul', '083333333333');
 
INSERT INTO Hewan VALUES
('HWN001', 'Milo', 'Kucing', 'Persia', '2022-03-10', 'PLG001'),
('HWN002', 'Bruno', 'Anjing', 'Golden Retriever', '2021-07-15', 'PLG002'),
('HWN003', 'Oyen', 'Kucing', 'Domestik', '2023-01-20', 'PLG003');
 
INSERT INTO KategoriProduk VALUES
('KTG001', 'Makanan Hewan', 'Produk makanan kucing dan anjing'),
('KTG002', 'Aksesoris', 'Kalung, kandang, mainan'),
('KTG003', 'Obat dan Vitamin', 'Produk kesehatan hewan');
 
INSERT INTO Produk VALUES
('PRD001', 'Whiskas Tuna 1kg', 'KTG001', 75000, 30),
('PRD002', 'Dog Food Premium 2kg', 'KTG001', 120000, 20),
('PRD003', 'Kalung Kucing', 'KTG002', 25000, 50),
('PRD004', 'Vitamin Bulu Kucing', 'KTG003', 45000, 25),
('PRD005', 'Mainan Bola Kucing', 'KTG002', 30000, 40);
 
INSERT INTO Pegawai VALUES
('PGW001', 'Dina Rahmawati', 'Kasir', '084444444444'),
('PGW002', 'Eko Prasetyo', 'Groomer', '085555555555'),
('PGW003', 'Sari Melati', 'Admin', '086666666666');
 
INSERT INTO Layanan VALUES
('LYN001', 'Grooming Kucing', 80000, 60),
('LYN002', 'Grooming Anjing', 120000, 90),
('LYN003', 'Potong Kuku', 30000, 20),
('LYN004', 'Mandi Anti Kutu', 100000, 75);
 
INSERT INTO Penjualan VALUES
('PJL001', '2025-01-05', 'PLG001', 'PGW001', 'Cash'),
('PJL002', '2025-01-06', 'PLG002', 'PGW001', 'QRIS'),
('PJL003', '2025-01-07', 'PLG003', 'PGW003', 'Transfer');
 
INSERT INTO DetailPenjualan VALUES
('PJL001', 'PRD001', 2, 75000, 0),
('PJL001', 'PRD003', 1, 25000, 0),
('PJL002', 'PRD002', 1, 120000, 10000),
('PJL003', 'PRD004', 2, 45000, 0),
('PJL003', 'PRD005', 1, 30000, 0);
 
INSERT INTO ReservasiLayanan VALUES
('RSV001', '2025-01-08', '09:00', 'PLG001', 'HWN001', 'LYN001', 'PGW002', 'Selesai'),
('RSV002', '2025-01-09', '10:30', 'PLG002', 'HWN002', 'LYN002', 'PGW002', 'Booking'),
('RSV003', '2025-01-10', '13:00', 'PLG003', 'HWN003', 'LYN003', 'PGW002', 'Selesai');
 
INSERT INTO AuditStok VALUES
('AUD001', 'PRD001', '2025-01-05 10:00:00', 32, 30, 'Penjualan produk'),
('AUD002', 'PRD003', '2025-01-05 10:05:00', 51, 50, 'Penjualan produk'),
('AUD003', 'PRD002', '2025-01-06 11:00:00', 21, 20, 'Penjualan produk');
 