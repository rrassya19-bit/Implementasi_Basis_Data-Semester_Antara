SELECT * FROM Pelanggan;
SELECT * FROM Produk;
SELECT * FROM Penjualan;
SELECT * FROM DetailPenjualan;
SELECT * FROM ReservasiLayanan;

-- ==========================================================
-- Praktikum 1 - Membuat Laporan Produk
-- ==========================================================
SELECT
    KodeProduk,
    UPPER(NamaProduk) AS NamaProduk,
    Harga,
    CASE
        WHEN Harga < 50000 THEN 'Murah'
        WHEN Harga <= 100000 THEN 'Sedang'
        ELSE 'Mahal'
    END AS KategoriHarga,
    CASE
        WHEN Stok = 0 THEN 'Habis'
        WHEN Stok < 10 THEN 'Menipis'
        WHEN Stok <= 30 THEN 'Cukup'
        ELSE 'Aman'
    END AS StatusStok
FROM Produk;
-- UPPER adalah mengubah semua huruf dalam sebuah teks jadi huruf kapital semua



-- ==========================================================
-- Praktikum 2 - Membuat Kode Singkat Produk
-- ==========================================================
SELECT
    KodeProduk,
    NamaProduk,
    CONCAT(
        UPPER(LEFT(NamaProduk, 3)),
        '-',
        RIGHT(KodeProduk, 3)
    ) AS KodeSingkat
FROM Produk;
-- LEFT adalah mengambil 3 huruf pertama dari nama produk, dihitung dari kiri
-- UPPER adalah mengubah 3 huruf tadi jadi huruf kapital semua
-- RIGHT adalah mengambil 3 karakter terakhir dari kode produk, dihitung dari kanan
-- CONCAT adalah menggabungkan semua bagian jadi satu teks: hasil UPPER + tanda strip + hasil RIGHT



-- ==========================================================
-- Praktikum 3 - Menampilkan Informasi Harga
-- ==========================================================
SELECT
    NamaProduk,
    Harga,
    ROUND(Harga, 0) AS HargaBulat,
    CONCAT('Rp ', CAST(Harga AS INT)) AS HargaTeks
FROM Produk;
-- ROUND adalah membulatkan angka (dibulatkan sampai 0 angka di belakang koma, alias jadi bilangan bulat tanpa desimal)
-- CONCAT adalah menggabungkan semua bagian jadi satu teks



-- ==========================================================
-- Praktikum 4 - Membuat Laporan Reservasi
-- ==========================================================
SELECT
    KodeReservasi,
    CONVERT(VARCHAR(10), TanggalReservasi, 103) AS Tanggal,
    CONVERT(VARCHAR(5), JamReservasi, 108) AS Jam,
    CASE StatusReservasi
        WHEN 'Booking' THEN 'Menunggu Pelayanan'
        WHEN 'Selesai' THEN 'Sudah Dilayani'
        WHEN 'Batal' THEN 'Dibatalkan'
    END AS Status
FROM ReservasiLayanan;
-- CONVERT adalah mengubah suatu data dari satu tipe ke tipe lain



-- ==========================================================
-- Praktikum 5 - Menentukan Umur Hewan
-- ==========================================================
SELECT
    NamaHewan,
    JenisHewan,
    DATEDIFF(YEAR, TanggalLahir, GETDATE()) AS Umur,
    CASE
        WHEN DATEDIFF(YEAR, TanggalLahir, GETDATE()) < 1 THEN 'Anak'
        WHEN DATEDIFF(YEAR, TanggalLahir, GETDATE()) <= 5 THEN 'Dewasa'
        ELSE 'Senior'
    END AS KategoriUmur
FROM Hewan;
-- DATEDIFF adalah menghitung selisih antara dua tanggal.



-- ==========================================================
-- Praktikum 6 - Menampilkan Informasi Pelanggan
-- ==========================================================
SELECT
    NamaPelanggan,
    ISNULL(NoHP, 'Belum Diisi') AS NomorHP
FROM Pelanggan;
-- ISNULL adalah mengganti nilai NULL (data kosong/tidak ada isinya) dengan nilai pengganti yang kita tentukan sendiri



-- ==========================================================
-- Praktikum 7 - Menghitung Nilai Penjualan
-- ==========================================================
SELECT
    KodePenjualan,
    KodeProduk,
    Jumlah,
    HargaJual,
    Diskon,
    Jumlah * HargaJual AS TotalHarga,
    (Jumlah * HargaJual) - ISNULL(Diskon, 0) AS Subtotal
FROM DetailPenjualan;



-- ==========================================================
-- Praktikum 8 - Menentukan Status Diskon
-- ==========================================================
SELECT
    KodePenjualan,
    KodeProduk,
    Diskon,
    CASE
        WHEN Diskon = 0 THEN 'Harga Normal'
        ELSE 'Harga Promo'
    END AS StatusHarga
FROM DetailPenjualan;



-- ==========================================================
-- Praktikum 9 - Menampilkan Tanggal Cetak Laporan
-- ==========================================================
SELECT
    NamaProduk,
    CONVERT(VARCHAR(10), GETDATE(), 103) AS TanggalCetak,
    CONVERT(VARCHAR(8), GETDATE(), 108) AS JamCetak
FROM Produk;
-- CONVERT adalah mengubah suatu data dari satu tipe ke tipe lain



-- ==========================================================
-- Praktikum 10 - Membuat Laporan Produk Lengkap
-- ==========================================================
SELECT
    KodeProduk,
    UPPER(NamaProduk) AS NamaProduk,
    Harga,
    ROUND(Harga, 0) AS HargaBulat,
    CASE
        WHEN Harga < 50000 THEN 'Murah'
        WHEN Harga <= 100000 THEN 'Sedang'
        ELSE 'Mahal'
    END AS KategoriHarga,
    CASE
        WHEN Stok = 0 THEN 'Habis'
        WHEN Stok < 10 THEN 'Menipis'
        WHEN Stok <= 30 THEN 'Cukup'
        ELSE 'Aman'
    END AS StatusStok,
    CONVERT(VARCHAR(10), GETDATE(), 103) AS TanggalCetak
FROM Produk;
-- UPPER adalah mengubah 3 huruf tadi jadi huruf kapital semua
-- ROUND adalah membulatkan angka (dibulatkan sampai 0 angka di belakang koma, alias jadi bilangan bulat tanpa desimal)
-- CONVERT adalah mengubah suatu data dari satu tipe ke tipe lain



-- ==========================================================
-- Praktikum 11 - Membuat Dashboard Mini
-- ==========================================================
SELECT
    COUNT(*) AS JumlahProduk,
    SUM(Stok) AS TotalStok,
    MAX(Harga) AS HargaTertinggi,
    MIN(Harga) AS HargaTerendah,
    AVG(Harga) AS HargaRataRata
FROM Produk;
-- COUNT(*) = Menghitung jumlah baris/data yang ada di tabel. Tanda * artinya hitung semua baris, nggak peduli isi kolomnya apa. Kalau ada 5 produk di tabel, hasilnya 5.
-- SUM(Stok) = Menjumlahkan semua nilai di kolom Stok dari seluruh baris. Kalau stok produk-produknya 50, 30, 40, 20, 25 — hasilnya dijumlah semua jadi 165.
-- MAX(Harga) = Mencari nilai paling besar di kolom Harga dari semua baris. Jadi otomatis nyari harga produk termahal.
-- MIN(Harga) = Kebalikannya, mencari nilai paling kecil — harga produk termurah.
-- AVG(Harga) = Menghitung rata-rata dari semua nilai di kolom Harga (jumlah semua harga dibagi banyaknya data).



-- ==========================================================
-- Praktikum 12 - Mengkombinasikan Function
-- ==========================================================
SELECT
    CONCAT(
        UPPER(LEFT(NamaProduk, 3)),
        '-', RIGHT(KodeProduk, 3)
    ) AS KodeProdukBaru,
    ROUND(Harga, 0) AS Harga,
    CASE
        WHEN Harga > 100000 THEN 'Premium'
        ELSE 'Reguler'
    END AS Kategori,
    CASE
        WHEN Stok < 10 THEN 'Segera Restok'
        ELSE 'Stok Aman'
    END AS Informasi,
    CONVERT(VARCHAR(10), GETDATE(), 103) AS Tanggal
FROM Produk;
-- CONCAT adalah menggabungkan semua bagian jadi satu teks
-- UPPER adalah mengubah semua huruf dalam sebuah teks jadi huruf kapital semua
-- ROUND adalah membulatkan angka (dibulatkan sampai 0 angka di belakang koma, alias jadi bilangan bulat tanpa desimal)
-- CONVERT adalah mengubah suatu data dari satu tipe ke tipe lain