-- Persiapan
USE DB_Petshop;

-- =========================================================
-- Praktikum 1 - Periksa tabel:
-- =========================================================
SELECT * FROM dbo.Pelanggan;
SELECT * FROM dbo.Penjualan;
SELECT * FROM dbo.DetailPenjualan;
SELECT * FROM dbo.Produk;
SELECT * FROM dbo.AuditStok;



-- =========================================================
-- Praktikum 2 - Mengenal Transaction dan Commit
-- =========================================================
-- 1. JALANKAN TRANSAKSI 
BEGIN TRANSACTION;                                           -- Menandai awal dimulainya blok transaksi database agar perubahan bersifat sementara.

UPDATE dbo.Produk                                            -- Menentukan tabel 'Produk' di dalam skema 'dbo' yang datanya akan diubah.
SET Stok = Stok - 1                                          -- Mengubah nilai kolom 'Stok' dengan mengurangi nilai stok saat ini dengan angka 1.
WHERE KodeProduk = 'PRD001';                                 -- Memfilter agar perubahan hanya diterapkan pada produk yang memiliki kode 'PRD001'.

COMMIT TRANSACTION;                                          -- Menyimpan dan mengesahkan seluruh perubahan data secara permanen ke dalam database.


-- 2. PERIKSA PERUBAHAN DATA - untuk melihat hasil perubahan pada tabel Produk dan AuditStok:
SELECT * FROM dbo.Produk WHERE KodeProduk = 'PRD001';
SELECT * FROM dbo.AuditStok;


-- 3. JELASKAN FUNGSI BEGIN TRANSACTION.
/* 
   BEGIN TRANSACTION berfungsi sebagai penanda awal dimulainya 
   sebuah blok transaksi. Perintah ini menginstruksikan DBMS 
   untuk memantau operasi perubahan data agar belum disimpan 
   secara permanen sebelum ada konfirmasi.
*/


-- 4. JELASKAN FUNGSI COMMIT.
/* 
   COMMIT (atau COMMIT TRANSACTION) berfungsi untuk menyimpan 
   dan mengesahkan seluruh perubahan data secara permanen 
   ke dalam database sehingga transaksi dinyatakan sukses.
*/


-- 5. BUAT TRANSAKSI YANG MENGUBAH SALAH SATU TABEL, LALU SIMPAN DENGAN COMMIT. - Contoh transaksi baru untuk mengubah harga produk PRD002:
BEGIN TRANSACTION;                                           -- Menandai awal dimulainya blok transaksi database untuk memantau proses perubahan data harga produk.

UPDATE dbo.Produk                                            -- Menentukan tabel 'Produk' di dalam skema 'dbo' yang kolom harganya akan dimodifikasi.
SET Harga = 125000.00                                        -- Mengubah nilai pada kolom 'Harga' menjadi 125000.00 untuk produk yang dipilih.
WHERE KodeProduk = 'PRD002';                                 -- Memfilter agar perubahan harga hanya diterapkan pada produk yang memiliki kode 'PRD002'.

COMMIT TRANSACTION;                                          -- Menyimpan dan mengesahkan perubahan harga secara permanen ke dalam database.



-- =========================================================
-- Praktikum 3 - Rollback
-- =========================================================
BEGIN TRANSACTION;

UPDATE dbo.Produk
SET Stok = Stok - 5
WHERE KodeProduk = 'PRD001';

SELECT *
FROM dbo.Produk
WHERE KodeProduk = 'PRD001';

ROLLBACK TRANSACTION;

SELECT *
FROM dbo.Produk
WHERE KodeProduk = 'PRD001';


-- 1. TUGAS: Buktikan bahwa perubahan yang dilakukan dalam transaksi dapat dibatalkan.
BEGIN TRANSACTION;                                           -- Menandai awal dimulainya blok transaksi database agar perubahan bersifat sementara.

-- Ubah data (misalnya kurangi stok produk PRD001 sebanyak 5)
UPDATE dbo.Produk                                            -- Menentukan tabel 'Produk' yang datanya akan diubah.
SET Stok = Stok - 5                                          -- Mengubah nilai kolom 'Stok' dengan mengurangi stok saat ini dengan angka 5.
WHERE KodeProduk = 'PRD001';                                 -- Memfilter hanya pada produk dengan kode 'PRD001'.

-- Periksa kondisi data SEBELUM di-rollback (stok akan terlihat berkurang)
SELECT * FROM dbo.Produk WHERE KodeProduk = 'PRD001';         -- Menampilkan data produk untuk melihat stok yang sudah berubah sementara (menjadi lebih sedikit).

-- Batalkan seluruh perubahan yang telah dilakukan
ROLLBACK TRANSACTION;                                        -- Membatalkan transaksi dan mengembalikan database ke kondisi semula sebelum BEGIN TRANSACTION.

-- Periksa kembali kondisi data SETELAH di-rollback (stok kembali normal seperti sedia kala)
SELECT * FROM dbo.Produk WHERE KodeProduk = 'PRD001';         -- Menampilkan data produk untuk membuktikan bahwa stok kembali ke nilai awal karena perubahan dibatalkan.


-- 2. TUGAS: Buktikan bahwa perubahan yang dilakukan dalam transaksi dapat dibatalkan.
BEGIN TRANSACTION;                                           -- Menandai awal dimulainya blok transaksi database agar perubahan bersifat sementara.

-- Ubah data yang berbeda (misalnya ubah harga produk PRD002 menjadi 150000)
UPDATE dbo.Produk                                            -- Menentukan tabel 'Produk' yang datanya akan diubah.
SET Harga = 150000.00                                        -- Mengubah nilai kolom 'Harga' menjadi 150000.00 secara sementara.
WHERE KodeProduk = 'PRD002';                               -- Memfilter hanya pada produk dengan kode 'PRD002'.

-- Periksa kondisi data SEBELUM di-rollback (harga akan terlihat berubah)
SELECT * FROM dbo.Produk WHERE KodeProduk = 'PRD002';         -- Menampilkan data produk untuk melihat harga yang sudah berubah sementara.

-- Batalkan seluruh perubahan yang telah dilakukan
ROLLBACK TRANSACTION;                                        -- Membatalkan transaksi dan mengembalikan database ke kondisi semula sebelum BEGIN TRANSACTION.

-- Periksa kembali kondisi data SETELAH di-rollback (harga kembali normal seperti sedia kala)
SELECT * FROM dbo.Produk WHERE KodeProduk = 'PRD002';         -- Menampilkan data produk untuk membuktikan bahwa harga kembali ke nilai awal karena dibatalkan.



-- =========================================================
-- Praktikum 4 -  Membandingkan  COMMIT dan ROLLBACK
-- =========================================================
-- Percobaan A
BEGIN TRANSACTION;

UPDATE dbo.Produk
SET Stok = Stok - 2
WHERE KodeProduk = 'PRD001';

COMMIT TRANSACTION;


-- Percobaan B
BEGIN TRANSACTION;

UPDATE dbo.Produk
SET Stok = Stok - 2
WHERE KodeProduk = 'PRD001';

ROLLBACK TRANSACTION;

-- TUGAS: TABEL PENGAMATAN
/*
+-----------+-----------------+---------------------------------------------------+
| Percobaan | Perintah Akhir  | Perubahan Disimpan?                               |
+-----------+-----------------+---------------------------------------------------+
|     A     | COMMIT          | Ya (Disimpan secara permanen ke dalam database)   |  - Perubahan stok berhasil disimpan secara permanen ke dalam database karena menggunakan perintah COMMIT TRANSACTION.
+-----------+-----------------+---------------------------------------------------+
|     B     | ROLLBACK        | Tidak (Dibatalkan dan dikembalikan ke nilai asal) |  - Perubahan stok tidak disimpan permanen, melainkan dibatalkan dan dikembalikan ke nilai semula karena menggunakan perintah ROLLBACK TRANSACTION.
+-----------+-----------------+---------------------------------------------------+
*/



-- =========================================================
-- Praktikum 5 -  Transaction pada Beberapa Operasi
-- =========================================================
BEGIN TRANSACTION;

UPDATE dbo.Produk
SET Stok = Stok - 2
WHERE KodeProduk = 'PRD001';

INSERT INTO dbo.Penjualan
(
    KodePenjualan,
    TanggalPenjualan,
    KodePelanggan,
    KodePegawai,
    MetodeBayar
)
VALUES
(
    'PJL999',
    GETDATE(),
    'PLG001',
    'PGW001',       -- Menggunakan KodePegawai yang valid dari tabel Pegawai
    'Cash'
);

COMMIT TRANSACTION;

-- TUGAS: Transaksi minimal 2 operasi pada 2 tabel yang saling berhubungan
BEGIN TRANSACTION;                                           -- Menandai awal dimulainya blok transaksi database.

-- Operasi 1: Mengubah data pada tabel Produk (mengurangi stok)
UPDATE dbo.Produk                                            
SET Stok = Stok - 3                                          
WHERE KodeProduk = 'PRD001';                                 

-- Operasi 2: Menambahkan data baru pada tabel Penjualan yang berelasi
INSERT INTO dbo.Penjualan
(
    KodePenjualan,
    TanggalPenjualan,
    KodePelanggan,
    KodePegawai,
    MetodeBayar
)
VALUES
(
    'PJL888',                  -- Menggunakan kode baru agar tidak duplikat dengan PJL999
    GETDATE(),
    'PLG001',
    'PGW001',                  -- Menggunakan pegawai yang valid
    'Transfer'
);

COMMIT TRANSACTION;            -- Menyimpan kedua perubahan secara permanen dan sukses.


/*
   Pertanyaan:
   Mengapa kedua operasi tersebut sebaiknya dilakukan dalam satu transaksi?

   Jawaban:
   Kedua operasi tersebut harus dilakukan dalam satu transaksi agar 
   tercapai sifat *Atomicity* (prinsip *all-or-nothing*). 
   Artinya, jika proses penjualan terjadi, maka stok produk harus 
   berkurang secara akurat di saat yang bersamaan. Jika salah satu 
   operasi gagal di tengah jalan, seluruh proses bisa dibatalkan 
   (rollback) sehingga tidak terjadi selisih atau ketidakonsistenan data 
   antara stok fisik di gudang dengan catatan laporan penjualan.
*/



-- =========================================================
-- Praktikum 6 -  SAVE TRANSACTION
-- =========================================================
BEGIN TRANSACTION;

UPDATE dbo.Produk
SET Stok = Stok - 1
WHERE KodeProduk = 'PRD001';

SAVE TRANSACTION Titik1;

UPDATE dbo.Produk
SET Stok = Stok - 2
WHERE KodeProduk = 'PRD002';

ROLLBACK TRANSACTION Titik1;

COMMIT TRANSACTION;


-- TUGAS: Praktikum - 6
-- Mulai transaksi
BEGIN TRANSACTION;

-- 1. Operasi pertama
UPDATE dbo.Produk
SET Stok = Stok - 1
WHERE KodeProduk = 'PRD001';

-- 2. SAVE TRANSACTION
SAVE TRANSACTION Titik1;

-- 3. Operasi kedua
UPDATE dbo.Produk
SET Stok = Stok - 2
WHERE KodeProduk = 'PRD002';

-- 4. ROLLBACK ke savepoint
ROLLBACK TRANSACTION Titik1;

-- 5. COMMIT
COMMIT TRANSACTION;

-- 6. BUKTI HASIL
SELECT * FROM dbo.Produk WHERE KodeProduk IN ('PRD001', 'PRD002');



-- =========================================================
-- Praktikum 7 -  SAVE TRANSACTION dengan beberapa Savepoint
-- =========================================================
BEGIN TRANSACTION;

-- Tahap 1
UPDATE dbo.Produk
SET Stok = Stok - 1
WHERE KodeProduk = 'PRD001';

SAVE TRANSACTION Tahap1;

-- Tahap 2
UPDATE dbo.Produk
SET Stok = Stok - 2
WHERE KodeProduk = 'PRD002';

SAVE TRANSACTION Tahap2;

-- Tahap 3
UPDATE dbo.Produk
SET Stok = Stok - 3
WHERE KodeProduk = 'PRD003';

ROLLBACK TRANSACTION Tahap2;

COMMIT TRANSACTION;

-- Bukti Hasil
SELECT * FROM dbo.Produk WHERE KodeProduk IN ('PRD001', 'PRD002', 'PRD003');


-- TUGAS: Amati hasilnya dan tentukan perubahan mana yang:
/*
   1. Tetap disimpan:
      - Tahap 1 (PRD001) dan Tahap 2 (PRD002).
        Alasan: Kedua tahap ini berada sebelum atau di titik savepoint 
        yang dituju, sehingga aman dan tersimpan permanen saat COMMIT.

   2. Dibatalkan:
      - Tahap 3 (PRD003).
        Alasan: Perubahan ini dibatalkan karena berada setelah savepoint 
        'Tahap2' yang dikenai perintah ROLLBACK TRANSACTION Tahap2.
*/



-- =========================================================
-- Praktikum 8 -  Melihat Informasi
-- =========================================================
--SESSION 1
BEGIN TRANSACTION;

UPDATE dbo.Produk
SET Stok = Stok - 1
WHERE KodeProduk = 'PRD001';

-- SESSION 2
SELECT *
FROM dbo.Produk
WHERE KodeProduk = 'PRD001';

-- SESSION 1
ROLLBACK TRANSACTION;



-- =========================================================
-- Praktikum 9 -  Melihat Informasi Lock
-- =========================================================
SELECT 
    session_id,
    status,
    command,
    wait_type,
    wait_time,
    blocking_session_id
FROM sys.dm_exec_requests
WHERE session_id <> @@SPID;

SELECT 
    request_session_id,
    resource_type,
    resource_database_id,
    request_mode,
    request_status
FROM sys.dm_tran_locks;

-- TUGAS: Identifikasi berdasarkan hasil query (sys.dm_exec_requests & sys.dm_tran_locks):
/*
   1. Session yang sedang aktif: Session ID: 84 dan 101 (terlihat pada tabel lock bawah).
   2. Session yang menunggu: Tidak ada (nilai waiting/blocking bernilai 0 / NULL, karena belum ada transaksi yang saling memblokir).
   3. Jenis resource: DATABASE (terlihat pada kolom resource_type dengan ID database 9).
   4. Mode lock: S (Shared / Shared Lock, terlihat pada kolom request_mode).
   5. Status lock: GRANT (artinya izin penggunaan lock telah diberikan dan aktif digunakan).
*/



-- =========================================================
-- Praktikum 10 -  READ UNCOMMITTED
-- =========================================================
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRANSACTION;

SELECT *
FROM dbo.Produk
WHERE KodeProduk = 'PRD001';

COMMIT TRANSACTION;
-- dirty read



-- =========================================================
-- Praktikum 11 - READ COMMITTED
-- =========================================================
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRANSACTION;

SELECT *
FROM dbo.Produk
WHERE KodeProduk = 'PRD001';

COMMIT TRANSACTION;



-- =========================================================
-- Praktikum 12 - REPEATABLE READ
-- =========================================================
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN TRANSACTION;

SELECT *
FROM dbo.Produk
WHERE KodeProduk = 'PRD001';

-- tunggu dan lakukan pengujian dari Session 2

COMMIT TRANSACTION;



-- =========================================================
-- Praktikum 13 - SERIALIZABLE
-- =========================================================
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRANSACTION;

SELECT *
FROM dbo.Produk
WHERE Stok > 0;

-- lakukan pengujian dari Session 2

COMMIT TRANSACTION;



-- =========================================================
-- PRAKTIKUM 14 - PENGUJIAN DEADLOCK 
-- =========================================================
--SESSION
BEGIN TRANSACTION;

UPDATE dbo.Produk
SET Stok = Stok - 1
WHERE KodeProduk = 'PRD001';

WAITFOR DELAY '00:00:05';

UPDATE dbo.Produk
SET Stok = Stok - 1
WHERE KodeProduk = 'PRD002';

COMMIT TRANSACTION;
--SESSION 2
BEGIN TRANSACTION;

UPDATE dbo.Produk
SET Stok = Stok - 1
WHERE KodeProduk = 'PRD002';

WAITFOR DELAY '00:00:05';

UPDATE dbo.Produk
SET Stok = Stok - 1
WHERE KodeProduk = 'PRD001';

COMMIT TRANSACTION;



-- =========================================================
--PRAKTIKUM 15 - INTEGRASI TRANSACTION = TRY...CATCH
-- =========================================================
-- Gunakan materi sebelumnya untuk membuat
BEGIN TRY

    BEGIN TRANSACTION;

    UPDATE dbo.Produk
    SET Stok = Stok - 1
    WHERE KodeProduk = 'PRD001';

    -- proses lainnya

    COMMIT TRANSACTION;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

END CATCH;

-- TUGAS: