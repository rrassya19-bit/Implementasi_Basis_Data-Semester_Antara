/* =========================================================
   PRAKTIKUM 6 - TRIGGER, IDENTITY, SEQUENCE
   ========================================================= */

USE DB_Petshop;
GO


/* =========================================================
   PRAKTIKUM 1 - Membuat Tabel Menggunakan IDENTITY
   ========================================================= */

-- Buat tabel log sederhana
CREATE TABLE LogAktivitas
(
    IdLog INT IDENTITY(1,1) PRIMARY KEY,
    Aktivitas VARCHAR(100),
    Waktu DATETIME DEFAULT GETDATE()
);
GO

-- Menambahkan data
INSERT INTO LogAktivitas (Aktivitas)
VALUES
('Login Admin'),
('Input Produk'),
('Update Stok');
GO


/* =========================================================
   PRAKTIKUM 2 - Menggunakan SEQUENCE
   ========================================================= */

-- Membuat Objek Sequence Baru
CREATE SEQUENCE Seq_Reservasi                        -- CREATE SEQUENCE = Perintah untuk membuat objek sequence baru dengan nama Seq_Reservasi[cite: 1, 2]
AS INT                                              -- AS INT = Menentukan tipe data angka yang digunakan adalah integer (bilangan bulat)[cite: 2]
START WITH 1                                        -- START WITH 1 = Menentukan angka awal atau pertama saat sequence mulai digunakan[cite: 1, 2]
INCREMENT BY 1;                                     -- INCREMENT BY 1 = Menentukan besar penambahan nilai sebesar 1 setiap kali sequence dipanggil[cite: 1, 2]
GO

-- Melihat Nilai Berikutnya dari Sequence
SELECT NEXT VALUE FOR Seq_Reservasi                 -- NEXT VALUE FOR Seq_Reservasi = Fungsi untuk mengambil dan menaikkan nilai berurutan dari sequence[cite: 1, 2]
AS NilaiBerikutnya;                                 -- AS NilaiBerikutnya = Memberikan alias atau nama kolom hasil tampilan menjadi NilaiBerikutnya
GO

-- Menggunakan Sequence dengan Format Teks (Kode Transaksi)
SELECT 
    'RSV' + RIGHT('000' + CAST(NEXT VALUE FOR Seq_Reservasi AS VARCHAR(3)), 3) AS KodeReservasi -- Menggabungkan teks 'RSV' dengan angka sequence berformat rata kanan 3 digit (contoh: RSV001)[cite: 1, 2]
GO


/* =========================================================
   PRAKTIKUM 3 - Trigger Audit UPDATE Stok Produk
   (Tabel AuditStok diasumsikan sudah tersedia di database)
   ========================================================= */

CREATE TRIGGER trg_AuditUpdateStok
ON Produk                                           -- ON Produk = Menentukan bahwa trigger ini dipasang dan mengawasi tabel Produk
AFTER UPDATE                                        -- AFTER UPDATE = Trigger akan otomatis dijalankan setelah operasi UPDATE berhasil dilakukan pada tabel Produk
AS                                                  -- AS = Menandai dimulainya blok kode program trigger
BEGIN                                              
    SET NOCOUNT ON;

    INSERT INTO AuditStok
    (
        KodeAudit,
        KodeProduk,
        TanggalAudit,
        StokSebelum,
        StokSesudah,
        Keterangan
    )
    SELECT                                                             -- SELECT = Mengambil data sumber untuk dimasukkan ke tabel AuditStok[cite: 1]
        'AUD' + RIGHT(CONVERT(VARCHAR(8), ABS(CHECKSUM(NEWID()))), 3), -- Membuat kode audit acak berawalan 'AUD' diikuti 3 digit angka unik[cite: 1]
        i.KodeProduk,                                                  -- i.KodeProduk = Mengambil kode produk dari tabel virtual 'inserted' (data baru)[cite: 1]
        GETDATE(),                                                     -- GETDATE() = Mengambil tanggal dan waktu sistem saat ini[cite: 1]
        d.Stok,                                                        -- d.Stok = Mengambil nilai stok lama dari tabel virtual 'deleted'[cite: 1]
        i.Stok,                                                        -- i.Stok = Mengambil nilai stok baru dari tabel virtual 'inserted'[cite: 1]
        'Perubahan stok produk'                                        -- Keterangan atau deskripsi teks standar untuk aktivitas audit ini[cite: 1]
    FROM inserted i                                                    -- FROM inserted i = Mengambil data dari tabel virtual inserted (merepresentasikan data setelah update) dengan alias 'i'[cite: 1]
    INNER JOIN deleted d                                               -- INNER JOIN deleted d = Menggabungkannya dengan tabel virtual deleted (merepresentasikan data sebelum update) dengan alias 'd'[cite: 1]
        ON i.KodeProduk = d.KodeProduk                                 -- ON i.KodeProduk = d.KodeProduk = Kondisi join berdasarkan kecocokan kode produk[cite: 1]
    WHERE i.Stok <> d.Stok;                                            -- WHERE i.Stok <> d.Stok = Hanya memproses dan mencatat data apabila benar-benar terjadi perubahan nilai stok (stok baru tidak sama dengan stok lama)[cite: 1]
END;
go

-- Uji Trigger
UPDATE Produk
SET Stok = Stok - 2
WHERE KodeProduk = 'PRD001';
GO

-- Lihat hasil
SELECT *
FROM AuditStok
ORDER BY TanggalAudit DESC;
GO

/* Exercise - 1
1. Mengapa hanya perubahan stok yang dicatat?
2. Apa fungsi tabel inserted?
3. Apa fungsi tabel deleted?
*/


/* =========================================================
   PRAKTIKUM 4 - Trigger AFTER INSERT
   ========================================================= */

-- Buat tabel log
CREATE TABLE LogProduk
(
    IdLog INT IDENTITY(1,1),
    KodeProduk CHAR(6),
    Aktivitas VARCHAR(100),
    Waktu DATETIME
);
GO

-- Trigger
CREATE TRIGGER trg_InsertProduk
ON Produk                                           -- ON Produk = Menentukan bahwa trigger ini dipasang dan mengawasi tabel Produk[cite: 1, 2]
AFTER INSERT                                        -- AFTER INSERT = Trigger akan otomatis dijalankan setelah proses penambahan data (INSERT) berhasil pada tabel Produk[cite: 1, 2]
AS
BEGIN
    INSERT INTO LogProduk                           -- INSERT INTO LogProduk = Perintah untuk memasukkan data pencatatan ke dalam tabel LogProduk[cite: 1]
    SELECT                                          -- SELECT = Mengambil data yang baru saja ditambahkan untuk dimasukkan ke log[cite: 1]
        KodeProduk,                                 -- KodeProduk = Mengambil kode produk dari data baru[cite: 1]
        'Produk baru ditambahkan',                  -- Keterangan atau deskripsi teks bahwa telah terjadi penambahan produk baru[cite: 1]
        GETDATE()                                   -- GETDATE() = Mengambil tanggal dan waktu sistem saat proses penambahan terjadi[cite: 1]
    FROM inserted;                                  -- FROM inserted = Mengambil data dari tabel virtual 'inserted' yang berisi baris data baru yang baru saja di-insert[cite: 1, 2]
END;
GO

-- Uji
INSERT INTO Produk
VALUES
('PRD999', 'Produk Baru', 'KTG001', 25000, 15);
GO

-- Melihat log
SELECT * FROM LogProduk;
GO


/* =========================================================
   PRAKTIKUM 5 - Trigger AFTER DELETE
   ========================================================= */

-- Buat tabel baru
CREATE TABLE ProdukDihapus
(
    Id INT IDENTITY,
    KodeProduk CHAR(6),
    NamaProduk VARCHAR(100),
    TanggalHapus DATETIME
);
GO

-- Trigger
CREATE TRIGGER trg_DeleteProduk
ON Produk                                           -- ON Produk = Menentukan bahwa trigger ini dipasang dan mengawasi tabel Produk[cite: 1, 2]
AFTER DELETE                                        -- AFTER DELETE = Trigger akan otomatis dijalankan setelah proses penghapusan data (DELETE) berhasil pada tabel Produk[cite: 1, 2]
AS
BEGIN
    INSERT INTO ProdukDihapus
    SELECT
        KodeProduk,
        NamaProduk,
       GETDATE()                                   -- GETDATE() = Mengambil tanggal dan waktu sistem saat proses penghapusan terjadi[cite: 1]
    FROM deleted;                                  -- FROM deleted = Mengambil data dari tabel virtual 'deleted' yang menyimpan baris data lama sebelum dihapus[cite: 1, 2]
END;
GO

-- Uji
DELETE FROM Produk
WHERE KodeProduk = 'PRD999';
GO

-- Melihat hasil
SELECT * FROM ProdukDihapus;
GO


/* =========================================================
   PRAKTIKUM 6 - Trigger Validasi Harga
   ========================================================= */

-- Trigger menolak harga negatif
CREATE TRIGGER trg_CekHarga
ON Produk                                           -- ON Produk = Menentukan bahwa trigger ini dipasang dan mengawasi tabel Produk[cite: 1, 2]
AFTER INSERT, UPDATE                                -- AFTER INSERT, UPDATE = Trigger dijalankan setelah operasi penambahan atau pembaruan data pada tabel Produk[cite: 1]
AS
BEGIN
    IF EXISTS                                       -- IF EXISTS = Memeriksa apakah ada baris data yang memenuhi kondisi di dalam kueri SELECT di bawah[cite: 1]
    (                                               -- Memulai blok subquery pengecekan data[cite: 1]
        SELECT *                                    -- SELECT * = Mengambil seluruh kolom dari baris yang bermasalah[cite: 1]
        FROM inserted                               -- FROM inserted = Memeriksa tabel virtual inserted (data baru yang baru dimasukkan/diubah)[cite: 1, 2]
        WHERE Harga < 0                             -- WHERE Harga < 0 = Filter kondisi untuk mencari apakah ada harga produk yang bernilai negatif (< 0)[cite: 1]
    )
    BEGIN
        ROLLBACK TRANSACTION;                       -- ROLLBACK TRANSACTION = Membatalkan seluruh transaksi atau perubahan data yang sedang berjalan agar tidak tersimpan ke database[cite: 1]
        THROW 50001,                                -- THROW 50001 = Memunculkan pesan error kustom dengan nomor error 50001[cite: 1]
            'Harga tidak boleh negatif.',           -- Pesan teks error yang akan ditampilkan kepada pengguna[cite: 1]
            1;                                      -- Nomor state error (tingkat status error)[cite: 1]
    END
END;
GO

-- Uji
UPDATE Produk
SET Harga = -1000
WHERE KodeProduk = 'PRD001';
GO
-- Perhatikan pesan error yang muncul.

/* 
   Analisis:
   - Pesan error yang muncul BUKAN berasal dari trigger trg_CekHarga, melainkan dari CHECK constraint CK_Produk_Harga yang sudah terpasang langsung pada kolom Harga di tabel Produk.
   - SQL Server memvalidasi constraint (CHECK/PK/FK) terlebih dahulu sebelum menjalankan AFTER TRIGGER. Karena Harga = -1000 melanggar CK_Produk_Harga, statement langsung ditolak di tahap constraint checking, sehingga trigger trg_CekHarga tidak pernah sempat dieksekusi.
   - Ini membuktikan bahwa constraint memiliki prioritas validasi lebih tinggi/lebih awal dibanding trigger AFTER pada urutan eksekusi SQL Server.
*/


/* =========================================================
   PRAKTIKUM 7 - Trigger Validasi Stok
   ========================================================= */

-- Buat trigger
CREATE TRIGGER trg_CekStok
ON Produk                                           -- ON Produk = Menentukan bahwa trigger ini dipasang dan mengawasi tabel Produk[cite: 1, 2]
AFTER UPDATE                                        -- AFTER UPDATE = Trigger akan dijalankan setelah operasi pembaruan data (UPDATE) berhasil pada tabel Produk[cite: 1, 2]
AS
BEGIN
    IF EXISTS                                       -- IF EXISTS = Memeriksa apakah ada baris data yang memenuhi kondisi kueri di bawah[cite: 1]
    (                                             
        SELECT *                                    -- SELECT * = Mengambil seluruh kolom dari baris yang bermasalah[cite: 1]
        FROM inserted                               -- FROM inserted = Memeriksa tabel virtual inserted yang berisi data stok baru setelah di-update[cite: 1, 2]
        WHERE Stok < 0                              -- WHERE Stok < 0 = Filter kondisi untuk memeriksa apakah ada nilai stok produk yang kurang dari 0 (negatif)[cite: 1]
    )
    BEGIN
        ROLLBACK;                                   -- ROLLBACK = Membatalkan seluruh transaksi atau perubahan data yang sedang berjalan agar tidak tersimpan ke database[cite: 1]
        THROW 50002,                                -- THROW 50002 = Memunculkan pesan error kustom dengan nomor error 50002[cite: 1]
            'Stok tidak boleh negatif.',            -- Pesan teks error yang akan ditampilkan kepada pengguna[cite: 1]
            1;                                      -- Nomor state error (tingkat status error)[cite: 1]
    END
END;
GO

-- Uji
UPDATE Produk
SET Stok = -5
WHERE KodeProduk = 'PRD002';
GO

/*
   Hasil: Msg 547 - "The UPDATE statement conflicted with the 
   CHECK constraint 'CK_Produk_Stok'..."

   Analisis:
   - Sama seperti kasus trg_CekHarga, pesan error ini berasal dari CHECK constraint CK_Produk_Stok yang sudah terpasang pada kolom Stok di tabel Produk, BUKAN dari trigger trg_CekStok.
   - SQL Server memvalidasi constraint (CHECK/PK/FK) sebelum menjalankan AFTER TRIGGER. Karena Stok = -5 melanggar CK_Produk_Stok, statement langsung ditolak di tahap constraint checking, sehingga trigger trg_CekStok tidak pernah sempat dieksekusi.
   - Ini menguatkan kesimpulan sebelumnya: constraint memiliki prioritas validasi lebih awal dibanding trigger AFTER dalam urutan eksekusi SQL Server, sehingga trigger validasi seperti ini sebenarnya menjadi "lapisan kedua" yang baru aktif kalau constraint-nya tidak ada.
*/


/* =========================================================
   PRAKTIKUM 8 - Melihat inserted dan deleted
   (Trigger ini hanya untuk demonstrasi)
   ========================================================= */

CREATE TRIGGER trg_Test
ON Produk
AFTER UPDATE
AS
BEGIN
    SELECT *
    FROM inserted;

    SELECT *
    FROM deleted;
END;
GO

-- Jalankan
UPDATE Produk
SET Harga = Harga + 5000
WHERE KodeProduk = 'PRD003';
GO




/* =========================================================
   TUGAS 1 - Trigger Audit Perubahan HARGA Produk
   -> Mencatat setiap perubahan harga ke tabel AuditStok
      dengan keterangan "Perubahan Harga Produk"
   ========================================================= */

CREATE TRIGGER trg_AuditUpdateHarga
ON Produk                                           -- ON Produk = Menentukan bahwa trigger ini dipasang dan mengawasi tabel Produk[cite: 1, 2]
AFTER UPDATE                                        -- AFTER UPDATE = Trigger berjalan otomatis setelah operasi pembaruan data berhasil pada tabel Produk[cite: 1, 2]
AS
BEGIN
    SSET NOCOUNT ON;                                 -- SET NOCOUNT ON = Mencegah pengiriman pesan jumlah baris yang terpengaruh agar eksekusi bersih

    IF NOT UPDATE(Harga)                            -- IF NOT UPDATE(Harga) = Memeriksa apakah pembaruan data menyentuh kolom 'Harga'. Jika kolom harga tidak diubah...
        RETURN;                                     -- RETURN = ...maka eksekusi trigger langsung dihentikan (keluar dari blok)

    INSERT INTO AuditStok                           -- INSERT INTO AuditStok = Perintah untuk memasukkan data catatan audit ke dalam tabel AuditStok[cite: 1]
    (
        KodeAudit,
        KodeProduk,
        TanggalAudit,
        StokSebelum,
        StokSesudah,
        Keterangan
    )
    SELECT                                                                           -- SELECT = Mengambil data sumber untuk dimasukkan ke tabel audit[cite: 1]
        'AUD' + RIGHT('0000' + CAST(NEXT VALUE FOR Seq_KodeAudit AS VARCHAR(4)), 4), -- Menggabungkan teks 'AUD' dengan angka urut dari Sequence (Seq_KodeAudit) yang diformat rata kanan 4 digit (dijamin unik sehingga tidak error Primary Key)[cite: 1]
        i.KodeProduk,                                                                -- i.KodeProduk = Mengambil kode produk dari tabel virtual inserted (data baru)[cite: 1]
        GETDATE(),                                                                   -- GETDATE() = Mengambil tanggal dan waktu sistem saat ini[cite: 1]
        d.Harga,                                                                     -- d.Harga = Mengambil nilai harga lama dari tabel virtual deleted[cite: 1]
        i.Harga,                                                                     -- i.Harga = Mengambil nilai harga baru dari tabel virtual inserted[cite: 1]
        'Perubahan Harga Produk'                                                     -- Keterangan kustom sesuai permintaan soal praktikum[cite: 1]
    FROM inserted i                                                                  -- FROM inserted i = Mengambil data dari tabel virtual inserted (data setelah update) dengan alias 'i'[cite: 1]
    INNER JOIN deleted d                                                             -- INNER JOIN deleted d = Digabungkan dengan tabel virtual deleted (data sebelum update) dengan alias 'd'[cite: 1]
        ON i.KodeProduk = d.KodeProduk                                               -- ON i.KodeProduk = d.KodeProduk = Kondisi relasi join berdasarkan kesamaan kode produk[cite: 1]
    WHERE i.Harga <> d.Harga;                                                        -- WHERE i.Harga <> d.Harga = Hanya mencatat data apabila nilai harga baru benar-benar berbeda dengan harga lama[cite: 1]
END;
GO

-- Uji
UPDATE Produk
SET Harga = Harga + 2000
WHERE KodeProduk = 'PRD001';
GO

-- Lihat hasil
SELECT * FROM AuditStok
WHERE Keterangan = 'Perubahan Harga Produk'
ORDER BY TanggalAudit DESC;
GO


/* =========================================================
   TUGAS 2 - Trigger Otomatis Ubah StatusReservasi jadi "Selesai"
   -> Saat data reservasi diperbarui dan TanggalLayanan sudah lewat

   Asumsi struktur tabel Reservasi:
   Reservasi (KodeReservasi, KodePelanggan, TanggalLayanan,
              StatusReservasi, ...)
   Sesuaikan nama kolom jika berbeda di database Anda.
   ========================================================= */

CREATE TRIGGER trg_AutoSelesaiReservasi
ON ReservasiLayanan                                 
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;                                 -- SET NOCOUNT ON = Mencegah pengiriman pesan jumlah baris yang terpengaruh agar eksekusi bersih

    IF UPDATE(StatusReservasi)                      -- IF UPDATE(StatusReservasi) = Memeriksa apakah kolom StatusReservasi sedang diubah secara langsung
        RETURN;                                     -- RETURN = Jika kolom StatusReservasi sedang di-update, hentikan eksekusi trigger untuk mencegah terjadinya infinite loop (perulangan tak terbatas)

    UPDATE r                                        -- UPDATE r = Memperbarui data pada tabel ReservasiLayanan (dengan alias 'r')
    SET r.StatusReservasi = 'Selesai'               -- SET r.StatusReservasi = 'Selesai' = Mengubah nilai kolom StatusReservasi menjadi 'Selesai'
    FROM ReservasiLayanan r                         -- FROM ReservasiLayanan r = Mengambil data dari tabel utama ReservasiLayanan
    INNER JOIN inserted i                           -- INNER JOIN inserted i = Digabungkan dengan tabel virtual 'inserted' (data baru hasil pembaruan) dengan alias 'i'[cite: 1, 2]
        ON r.KodeReservasi = i.KodeReservasi                                                                     -- ON r.KodeReservasi = i.KodeReservasi = Kondisi relasi join berdasarkan kesamaan kode reservasi[cite: 1]
    WHERE DATEADD(SECOND, DATEDIFF(SECOND, 0, i.JamReservasi), CAST(i.TanggalReservasi AS DATETIME)) < GETDATE() -- WHERE ... < GETDATE() = Kondisi filter jika gabungan tanggal dan jam reservasi sudah terlewat dari waktu sistem saat ini
      AND i.StatusReservasi <> 'Selesai';                                                                        -- AND i.StatusReservasi <> 'Selesai' = Filter tambahan agar hanya memproses reservasi yang statusnya belum 'Selesai'
END;
GO

-- Uji
UPDATE ReservasiLayanan                              
SET TanggalReservasi = '2026-08-01'                 
WHERE KodeReservasi = 'RSV001';
GO

-- Lihat hasil
SELECT KodeReservasi, TanggalReservasi, JamReservasi, StatusReservasi
FROM ReservasiLayanan
WHERE KodeReservasi = 'RSV001';
GO


/* =========================================================
   TUGAS 3 - Trigger Menolak Penghapusan Pelanggan
   -> Jika pelanggan masih punya data di tabel Penjualan

   Asumsi struktur tabel:
   Pelanggan (KodePelanggan, NamaPelanggan, ...)
   Penjualan (KodePenjualan, KodePelanggan, ...)
   ========================================================= */

CREATE TRIGGER trg_CegahHapusPelanggan
ON Pelanggan
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;                                 -- SET NOCOUNT ON = Mencegah pengiriman pesan jumlah baris yang terpengaruh agar eksekusi bersih

    IF EXISTS                                       -- IF EXISTS = Memeriksa apakah ditemukan data yang cocok dengan kondisi di dalam subquery di bawah[cite: 1]
    (                                               -- Memulai blok subquery pengecekan relasi data[cite: 1]
        SELECT 1                                    -- SELECT 1 = Mengambil nilai penanda jika data ditemukan di relasi tabel[cite: 1]
        FROM deleted d                              -- FROM deleted d = Mengambil data dari tabel virtual 'deleted' (data baris pelanggan yang ingin dihapus) dengan alias 'd'[cite: 1, 2]
        INNER JOIN Penjualan p                      -- INNER JOIN Penjualan p = Digabungkan dengan tabel Penjualan dengan alias 'p'[cite: 1]
            ON d.KodePelanggan = p.KodePelanggan  -- ON d.KodePelanggan = p.KodePelanggan = Kondisi relasi penghubung berdasarkan kesamaan kode pelanggan[cite: 1]
    )                                               -- Menutup blok subquery pengecekan relasi[cite: 1]
    BEGIN                                           -- BEGIN = Menandai awal blok perintah jika kondisi IF bernilai benar (pelanggan masih memiliki transaksi)[cite: 1, 2]
        ROLLBACK;                                   -- ROLLBACK = Membatalkan seluruh transaksi penghapusan data[cite: 1]
        THROW 50003,                                -- THROW 50003 = Memunculkan pesan error kustom dengan nomor error 50003[cite: 1]
            'Pelanggan tidak dapat dihapus karena masih memiliki data transaksi di tabel Penjualan.', -- Pesan teks error yang akan ditampilkan ke pengguna[cite: 1]
            1;                                      -- Nomor state error (tingkat status error)[cite: 1]
    END
    ELSE
    BEGIN
        
        DELETE FROM Pelanggan                       -- DELETE FROM Pelanggan = ...maka jalankan perintah penghapusan data yang sebenarnya pada tabel Pelanggan[cite: 1]
        WHERE KodePelanggan IN (SELECT KodePelanggan FROM deleted); -- WHERE ... IN (...) = Menghapus baris pelanggan yang sesuai dengan data yang tadinya dikirim ke tabel virtual deleted[cite: 1]
    END
END;
GO

-- Uji: hapus pelanggan yang MASIH punya transaksi (harus gagal)
DELETE FROM Pelanggan
WHERE KodePelanggan = 'PLG001';
GO

-- Uji: hapus pelanggan yang TIDAK punya transaksi (harus berhasil)
DELETE FROM Pelanggan
WHERE KodePelanggan = 'PLG999';
GO

-- Cek pelanggan yang PUNYA transaksi (harus MASIH ADA setelah percobaan delete gagal)
SELECT 'Cek PLG001 (harus masih ada)' AS Keterangan, *
FROM Pelanggan
WHERE KodePelanggan = 'PLG001';

-- Cari daftar pelanggan yang TIDAK punya transaksi (kandidat aman untuk dihapus)
SELECT 'Kandidat pelanggan tanpa transaksi' AS Keterangan,
       p.KodePelanggan, p.NamaPelanggan
FROM Pelanggan p
LEFT JOIN Penjualan pj ON p.KodePelanggan = pj.KodePelanggan
WHERE pj.KodePelanggan IS NULL;

-- Rekap jumlah transaksi per pelanggan (buat cross-check logic trigger)
SELECT 'Rekap transaksi per pelanggan' AS Keterangan,
       KodePelanggan, COUNT(*) AS JumlahTransaksi
FROM Penjualan
GROUP BY KodePelanggan;
GO

-- =========================================================
-- CEK SEMUA TRIGGER DI DATABASE
-- =========================================================

-- cek Daftar semua trigger + tabel induk + status aktif
SELECT 
    t.name AS NamaTrigger,
    OBJECT_NAME(t.parent_id) AS TabelInduk,
    CASE WHEN t.is_disabled = 0 THEN 'Aktif' ELSE 'Nonaktif' END AS Status,
    t.create_date AS TanggalDibuat,
    t.modify_date AS TerakhirDiubah
FROM sys.triggers t
ORDER BY TabelInduk, NamaTrigger;
GO

-- cek Event type per trigger (INSERT/UPDATE/DELETE, dan INSTEAD OF vs AFTER)
SELECT 
    t.name AS NamaTrigger,
    OBJECT_NAME(t.parent_id) AS TabelInduk,
    te.type_desc AS EventType,
    CASE WHEN t.is_instead_of_trigger = 1 THEN 'INSTEAD OF' ELSE 'AFTER' END AS Jenis
FROM sys.triggers t
INNER JOIN sys.trigger_events te ON t.object_id = te.object_id
ORDER BY TabelInduk, NamaTrigger;
GO

/* =========================================================
   PERTANYAAN ANALISIS
   =========================================================
   1. Apa perbedaan IDENTITY dan SEQUENCE?
      - IDENTITY melekat pada satu kolom di satu tabel saja, dan sedangkan SEQUENCE adalah objek independen yang bisa dipakaibersama oleh banyak tabel/kolom.
      - IDENTITY otomatis terisi saat INSERT tanpa perlu ditulis dan sedangkan SEQUENCE harus diambil manual denga NEXT VALUE FOR sebelum dipakai.
      - IDENTITY sulit di-reset/dilompat di tengah transaksi dan sedangkan SEQUENCE bisa diatur ulang (RESTART), diberi MIN/MAX, dan diberi siklus (CYCLE).
      - Nilai SEQUENCE bisa dicek terlebih dahulu sebelum dipakai (NEXT VALUE FOR), sedangkan nilai IDENTITY baru diketahui setelah proses INSERT dilakukan.

   2. Kapan lebih tepat menggunakan IDENTITY dibandingkan
      SEQUENCE?
      - IDENTITY lebih tepat ketika nomor urut hanya dibutuhkan untuk satu kolom primary key pada satu tabel saja (contoh: IdLog pada LogAktivitas), dan saat menginginkan cara paling sederhana & otomatis.
      - SEQUENCE lebih tepat ketika nomor urut perlu dipakai bersama oleh beberapa tabel, ketika format kode akhir bukan angka murni (misalnya RSV001, RSV002), atau saat dibutuhkan kontrol lebih fleksibel seperti RESTART, MIN/MAX, dan CYCLE.

   3. Apa fungsi tabel virtual inserted dan deleted pada Trigger?
      - inserted: berisi salinan baris data yang BARU; dipakai pada AFTER INSERT (baris yang baru ditambahkan) dan AFTER UPDATE (nilai baru setelah diubah).
      - deleted: berisi salinan baris data yang LAMA; dipakai pada AFTER DELETE (baris yang baru dihapus) dan AFTER UPDATE (nilai sebelum diubah).
      - Pada AFTER UPDATE, kedua tabel di-JOIN berdasarkan primary key untuk mengetahui kolom mana yang berubah, dengan membandingkan nilai lama (deleted) dan nilai baru (inserted).
      - Kedua tabel ini hanya bisa diakses di dalam badan trigger, tidak bisa diakses langsung seperti tabel biasa.
   ========================================================= */

   /* 
   =========================================================
   Exercise - 1  (terkait trg_AuditUpdateStok, Praktikum 3)
   ========================================================= 

   1. Mengapa hanya perubahan stok yang dicatat?
      - Karena trigger ini memakai klausa WHERE i.Stok <> d.Stok di baris terakhir SELECT.
      - Baris WHERE ini membandingkan nilai stok baru (dari tabel inserted) dengan nilai stok lama (dari tabel deleted); hanya baris yang nilainya benar-benar berbeda yang lolos dan ikut di-INSERT ke tabel AuditStok.
      - Kalau UPDATE dilakukan ke kolom lain (misalnya Harga atau NamaProduk) tanpa mengubah Stok, maka i.Stok akan sama dengan d.Stok, sehingga baris itu tidak lolos filter dan tidak dicatat sebagai audit stok.

   2. Apa fungsi tabel inserted?
      - inserted adalah tabel virtual (magic table) yang otomatis dibuat SQL Server di dalam trigger, berisi salinan data versi BARU/SETELAH perubahan.
      - Untuk AFTER INSERT: inserted berisi baris-baris yang baru ditambahkan.
      - Untuk AFTER UPDATE: inserted berisi nilai kolom SETELAH di-update.
      - Tabel ini hanya bisa diakses di dalam badan trigger, tidak bisa dipanggil seperti tabel biasa dari luar trigger.

   3. Apa fungsi tabel deleted?
      - deleted adalah tabel virtual yang berisi salinan data versi LAMA/SEBELUM perubahan.
      - Untuk AFTER DELETE: deleted berisi baris-baris yang baru saja dihapus.
      - Untuk AFTER UPDATE: deleted berisi nilai kolom SEBELUM di-update.
      - Dengan menggabungkan (JOIN) inserted dan deleted berdasarkan primary key (contoh: KodeProduk), trigger bisa membandingkan nilai lama vs nilai baru untuk mengetahui kolom apa saja yang berubah.
*/


/*
   =========================================================
   Exercise - 2  (terkait trg_Test, Praktikum 8)
   ========================================================= 

   Perhatikan hasil kedua tabel virtual. Apa yang dapat Anda simpulkan?

      - Saat trigger trg_Test dijalankan setelah UPDATE Produk SET Harga = Harga + 5000 WHERE KodeProduk = 'PRD003', hasil SELECT * FROM inserted menampilkan baris PRD003 dengan Harga yang SUDAH ditambah 5000 (nilai baru/terkini).
      - Sedangkan SELECT * FROM deleted menampilkan baris PRD003 yang sama, tetapi dengan Harga SEBELUM ditambah 5000 (nilai lama/sebelum update).
      - Kesimpulan: pada trigger AFTER UPDATE, SQL Server menyediakan DUA salinan data dari baris yang sama secara bersamaan — inserted untuk kondisi setelah perubahan, deleted untuk kondisi sebelum perubahan.
      - Ini membuktikan bahwa proses UPDATE di SQL Server sebenarnya diperlakukan sebagai kombinasi DELETE (baris lama) + INSERT (baris baru), sehingga kedua tabel virtual ini terisi sekaligus dalam satu event UPDATE, dan trigger bisa memanfaatkan keduanya untuk mendeteksi apa saja yang berubah.
*/