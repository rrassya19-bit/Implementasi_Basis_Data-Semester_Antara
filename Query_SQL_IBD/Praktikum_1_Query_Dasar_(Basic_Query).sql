-- =========================================================
--                Query Dasar (Basic Query)
-- =========================================================

-- =========================================================
-- Praktikum 1 — SELECT
-- =========================================================
 
-- 1. Menampilkan seluruh data pelanggan
SELECT *
FROM Pelanggan;


-- 2. Menampilkan kolom tertentu
SELECT
    KodePelanggan,
    NamaPelanggan,
    NoHP
FROM Pelanggan;
 

-- 3. Menampilkan data produk
SELECT
    KodeProduk,
    NamaProduk,
    Harga,
    Stok
FROM Produk;
 

-- 4. Menggunakan alias kolom
SELECT
    NamaProduk AS Nama_Barang,
    Harga AS Harga_Jual,
    Stok AS Jumlah_Stok
FROM Produk;
 
 


-- =========================================================
-- Praktikum 2 - WHERE Clause
-- =========================================================
 
-- 1. Menampilkan pelanggan laki-laki
SELECT *
FROM Pelanggan
WHERE JenisKelamin = 'L';
 

-- 2. Menampilkan produk dengan stok lebih dari 25
SELECT *
FROM Produk
WHERE Stok > 25;
 

-- 3. Menampilkan produk dengan harga di bawah 50.000
SELECT *
FROM Produk
WHERE Harga < 50000;
 

-- 4. Menampilkan produk pada kategori tertentu
SELECT *
FROM Produk
WHERE KodeKategori = 'KTG001';
 

-- 5. Menampilkan reservasi dengan status Booking
SELECT *
FROM ReservasiLayanan
WHERE StatusReservasi = 'Booking';
 

-- 6. Menggunakan BETWEEN
SELECT *
FROM Produk
WHERE Harga BETWEEN 30000 AND 100000;
 

-- 7. Menggunakan IN
SELECT *
FROM Produk
WHERE KodeKategori IN ('KTG001', 'KTG002');
 

-- 8. Menggunakan LIKE
SELECT *
FROM Pelanggan
WHERE NamaPelanggan LIKE 'A%';
 
 


-- =========================================================
-- Praktikum 3 - ORDER BY
-- =========================================================
 
-- 1. Mengurutkan produk berdasarkan harga termurah
SELECT *
FROM Produk
ORDER BY Harga ASC;


-- 2. Mengurutkan produk berdasarkan harga termahal
SELECT *
FROM Produk
ORDER BY Harga DESC;


-- 3. Mengurutkan pelanggan berdasarkan nama
SELECT *
FROM Pelanggan
ORDER BY NamaPelanggan ASC;


-- 4. Mengurutkan produk berdasarkan kategori dan stok
SELECT *
FROM Produk
ORDER BY KodeKategori ASC, Stok DESC;
 
 


-- =========================================================
-- Praktikum 4 - GROUP BY
-- =========================================================
 
-- 1. Menghitung jumlah produk per kategori
SELECT
    KodeKategori,
    COUNT(*) AS JumlahProduk
FROM Produk
GROUP BY KodeKategori;
 

-- 2. Menghitung total stok per kategori
SELECT
    KodeKategori,
    SUM(Stok) AS TotalStok
FROM Produk
GROUP BY KodeKategori;
 

-- 3. Menghitung rata-rata harga produk per kategori
SELECT
    KodeKategori,
    AVG(Harga) AS RataRataHarga
FROM Produk
GROUP BY KodeKategori;
 

-- 4. Menghitung jumlah hewan berdasarkan jenis hewan
SELECT
    JenisHewan,
    COUNT(*) AS JumlahHewan
FROM Hewan
GROUP BY JenisHewan;
 

-- 5. Menghitung jumlah reservasi berdasarkan status
SELECT
    StatusReservasi,
    COUNT(*) AS JumlahReservasi
FROM ReservasiLayanan
GROUP BY StatusReservasi;
 
 


-- =========================================================
-- Praktikum 5 – HAVING
-- =========================================================
 
-- 1. Menampilkan kategori dengan jumlah produk lebih dari 1
SELECT
    KodeKategori,
    COUNT(*) AS JumlahProduk
FROM Produk
GROUP BY KodeKategori
HAVING COUNT(*) > 1;
 

-- 2. Menampilkan kategori dengan total stok lebih dari 40
SELECT
    KodeKategori,
    SUM(Stok) AS TotalStok
FROM Produk
GROUP BY KodeKategori
HAVING SUM(Stok) > 40;
 

-- 3. Menampilkan jenis hewan yang jumlahnya lebih dari 1
SELECT
    JenisHewan,
    COUNT(*) AS JumlahHewan
FROM Hewan
GROUP BY JenisHewan
HAVING COUNT(*) > 1;
 
 


-- =========================================================
-- Praktikum 6 - Built-in Function SQL Server
-- =========================================================
 
-- 1. Mengubah nama pelanggan menjadi huruf kapital
SELECT
    NamaPelanggan,
    UPPER(NamaPelanggan) AS NamaKapital
FROM Pelanggan;
 

-- 2. Mengubah nama produk menjadi huruf kecil
SELECT
    NamaProduk,
    LOWER(NamaProduk) AS NamaKecil
FROM Produk;
 

-- 3. Menghitung panjang nama pelanggan
SELECT
    NamaPelanggan,
    LEN(NamaPelanggan) AS PanjangNama
FROM Pelanggan;
 

-- 4. Mengambil 3 karakter pertama kode produk
SELECT
    KodeProduk,
    LEFT(KodeProduk, 3) AS AwalanKode
FROM Produk;
 

-- 5. Mengambil 3 karakter terakhir kode produk
SELECT
    KodeProduk,
    RIGHT(KodeProduk, 3) AS NomorUrut
FROM Produk;
 

-- 6. Menggabungkan nama pelanggan dan nomor HP
SELECT
    CONCAT(NamaPelanggan, ' - ', NoHP) AS DataKontak
FROM Pelanggan;
 

-- 7. Mengganti kata pada nama produk
SELECT
    NamaProduk,
    REPLACE(NamaProduk, 'Kucing', 'Cat') AS NamaProdukBaru
FROM Produk;
 



-- =========================================================
-- Numeric Function 
-- =========================================================
-- 1. Membulatkan harga produk
SELECT
    NamaProduk,
    Harga,
    ROUND(Harga, 0) AS HargaBulat
FROM Produk;
 

-- 2. Menggunakan CEILING
SELECT
    CEILING(12.3) AS PembulatanKeAtas;
 

-- 3. Menggunakan FLOOR
SELECT
    FLOOR(12.9) AS PembulatanKeBawah;
 

-- 4. Menggunakan ABS
SELECT
    ABS(-50000) AS NilaiAbsolut;
 

-- 5. Menghitung subtotal penjualan
SELECT
    KodePenjualan,
    KodeProduk,
    Jumlah,
    HargaJual,
    Diskon,
    (Jumlah * HargaJual) - Diskon AS Subtotal
FROM DetailPenjualan;
 



-- =========================================================
-- Date-Time Function 
-- =========================================================

-- 1. Menampilkan tanggal dan waktu saat ini
SELECT GETDATE() AS TanggalSekarang;
 

-- 2. Mengambil tahun dari tanggal penjualan
SELECT
    KodePenjualan,
    TanggalPenjualan,
    YEAR(TanggalPenjualan) AS TahunPenjualan
FROM Penjualan;
 

-- 3. Mengambil bulan dari tanggal reservasi
SELECT
    KodeReservasi,
    TanggalReservasi,
    MONTH(TanggalReservasi) AS BulanReservasi
FROM ReservasiLayanan;
 

-- 4. Mengambil hari dari tanggal reservasi
SELECT
    KodeReservasi,
    TanggalReservasi,
    DAY(TanggalReservasi) AS HariReservasi
FROM ReservasiLayanan;
 

-- 5. Menambah 7 hari dari tanggal reservasi
SELECT
    KodeReservasi,
    TanggalReservasi,
    DATEADD(DAY, 7, TanggalReservasi) AS TanggalKontrol
FROM ReservasiLayanan;
 

-- 6. Menghitung umur hewan berdasarkan tanggal lahir
SELECT
    NamaHewan,
    TanggalLahir,
    DATEDIFF(YEAR, TanggalLahir, GETDATE()) AS PerkiraanUmur
FROM Hewan;
 



-- ========================================================= 
-- Conversion Function
-- =========================================================

-- 1. Mengubah harga menjadi tipe INT
SELECT
    NamaProduk,
    Harga,
    CAST(Harga AS INT) AS HargaInteger
FROM Produk;
 

-- 2. Mengubah tanggal menjadi format VARCHAR
SELECT
    KodePenjualan,
    CONVERT(VARCHAR, TanggalPenjualan, 103) AS TanggalFormatIndonesia
FROM Penjualan;
 

-- 3. Menggunakan TRY_CAST
SELECT
    TRY_CAST('12345' AS INT) AS HasilKonversi;
 

-- 4. Contoh TRY_CAST gagal
SELECT
    TRY_CAST('ABC123' AS INT) AS HasilKonversi;
 
-- Keterangan:
-- Jika konversi gagal, TRY_CAST akan menghasilkan nilai NULL.
 



-- =========================================================
-- Aggregate Function 
-- =========================================================

-- 1. Menghitung jumlah produk
SELECT
    COUNT(*) AS JumlahProduk
FROM Produk;
 

-- 2. Menghitung total stok produk
SELECT
    SUM(Stok) AS TotalStok
FROM Produk;
 

-- 3. Menghitung rata-rata harga produk
SELECT
    AVG(Harga) AS RataRataHarga
FROM Produk;
 

-- 4. Menampilkan harga produk tertinggi
SELECT
    MAX(Harga) AS HargaTertinggi
FROM Produk;
 

-- 5. Menampilkan harga produk terendah
SELECT
    MIN(Harga) AS HargaTerendah
FROM Produk;
 

-- 6. Menghitung total pendapatan dari detail penjualan
SELECT
    SUM((Jumlah * HargaJual) - Diskon) AS TotalPendapatan
FROM DetailPenjualan;
 



-- =========================================================
-- NULL Function 
-- =========================================================

-- 1. Menggunakan ISNULL pada kolom Ras hewan
SELECT
    NamaHewan,
    ISNULL(Ras, 'Tidak Ada Data') AS RasHewan
FROM Hewan;
 

-- 2. Menggunakan ISNULL pada kolom NoHP
SELECT
    NamaPelanggan,
    ISNULL(NoHP, 'Nomor HP belum diisi') AS NomorHP
FROM Pelanggan;
 

-- 3. Menggunakan COALESCE
SELECT
    COALESCE(NULL, NULL, 'Data tersedia') AS Hasil;
 

-- 4. Menggunakan NULLIF
SELECT
    NULLIF(100, 100) AS HasilNULLIF;
 
 


-- =========================================================
-- Praktikum Gabungan
-- =========================================================
 
-- 1. Laporan produk dengan status stok
SELECT
    KodeProduk,
    NamaProduk,
    Harga,
    Stok,
    CASE
        WHEN Stok = 0 THEN 'Habis'
        WHEN Stok < 10 THEN 'Menipis'
        ELSE 'Aman'
    END AS StatusStok
FROM Produk;
 

-- 2. Rekap penjualan per transaksi
SELECT
    KodePenjualan,
    SUM((Jumlah * HargaJual) - Diskon) AS TotalTransaksi
FROM DetailPenjualan
GROUP BY KodePenjualan;
 

-- 3. Rekap produk terjual
SELECT
    KodeProduk,
    SUM(Jumlah) AS TotalTerjual
FROM DetailPenjualan
GROUP BY KodeProduk
ORDER BY TotalTerjual DESC;
 

-- 4. Reservasi layanan berdasarkan status
SELECT
    StatusReservasi,
    COUNT(*) AS JumlahReservasi
FROM ReservasiLayanan
GROUP BY StatusReservasi
ORDER BY JumlahReservasi DESC;
 