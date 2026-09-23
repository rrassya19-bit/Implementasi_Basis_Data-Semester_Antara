-- ========================================
-- | UCP 2 - Implementasi Basis Data      |
-- | Nama : Ahmad Rassya Maulana          |
-- | NIM  : 20250140157                   |
-- ========================================
USE Monitoring_TA;
GO

-- ========================================
-- TUGAS 1 — QUERY DASAR
-- ========================================

-- 1. SELECT + WHERE - (Menampilkan NIM dan IPK mahasiswa yang memiliki IPK di atas 3.50)
SELECT 
    NIM, 
    IPK, 
    Tanggal_Ujian, 
    Status
FROM dbo.Pengajuan_Pendadaran
WHERE IPK > 3.50;
GO


-- 2. ORDER BY - (Menampilkan data mahasiswa dengan IPK di atas 3.50, diurutkan dari IPK tertinggi)
SELECT 
    NIM, 
    IPK, 
    Tanggal_Ujian, 
    Status
FROM dbo.Pengajuan_Pendadaran
WHERE IPK > 3.50
ORDER BY IPK DESC; -- mengurutkan data hasil kolom IPK dengan urutan menurun (Descending), yaitu dari nilai IPK yang paling tinggi ke nilai IPK yang paling rendah
GO


-- 3. GROUP BY + Aggregate - (Menampilkan ringkasan jumlah mahasiswa, rata-rata, IPK terendah dan tertinggi berdasarkan Status pengajuan)
SELECT 
    Status,                       -- Agregasi adalah proses meringkas atau menggabungkan banyak baris data menjadi satu nilai kesimpulan
    COUNT(NIM) AS TotalMahasiswa, -- menghitung jumlah mahasiswa
    AVG(IPK) AS RataRataIPK,      -- mencari rata-rata IPK
    MIN(IPK) AS IPKTerendah,      -- mencari IPK paling rendah
    MAX(IPK) AS IPKTertinggi      -- mencari IPK paling tinggi
FROM dbo.Pengajuan_Pendadaran
GROUP BY Status;                  -- Mengelompokkan data berdasarkan status pengajuan
GO


-- 4. HAVING - (Menampilkan ringkasan data berdasarkan Status, namun hanya menampilkan status yang memiliki total mahasiswa lebih dari 2 orang)
SELECT 
    Status,                          -- Having adalah berfungsi untuk menyaring atau memfilter hasil data yang sudah melalui proses pengelompokan (GROUP BY).
    COUNT(NIM) AS TotalMahasiswa,    -- Menghitung jumlah mahasiswa
    AVG(IPK) AS RataRataIPK,         -- Mencari rata-rata IPK
    MIN(IPK) AS IPKTerendah,         -- Mencari IPK paling rendah
    MAX(IPK) AS IPKTertinggi         -- Mencari IPK paling tinggi
FROM dbo.Pengajuan_Pendadaran
GROUP BY Status                      -- Mengelompokkan data berdasarkan status pengajuan
HAVING COUNT(NIM) > 2;               -- Menyaring hasil kelompok: hanya status dengan mahasiswa > 2 yang ditampilkan
GO




-- ========================================
-- TUGAS 2 — BUILT-IN FUNCTION
-- ========================================

-- 1. String Function (CONCAT / UPPER)
-- Nama Function: CONCAT() = Menggabungkan beberapa kolom teks atau string menjadi satu kesatuan teks yang menyambung
-- Tujuan Penggunaan: Menggabungkan NIM dan Nama Mahasiswa serta mengubah nama menjadi huruf kapital semua untuk keperluan cetak laporan.
-- Hasil yang diharapkan: Menghasilkan satu kolom teks gabungan dengan format "NIM - NAMA MAHASISWA (HURUF BESAR)".
SELECT  
    CONCAT               -- Menggabungkan NIM, tanda pemisah ' - ', dan Nama mahasiswa yang sudah diubah menjadi huruf besar semuanya, lalu hasil gabungan tersebut diberi nama kolom alias (panggilan) baru yaitu IdentitasMahasiswa
    (
        NIM,             -- Mengambil data NIM mahasiswa
        ' - ',           -- Menambahkan teks pemisah berupa tanda strip (-)
        UPPER(Nama)      -- Mengubah data Nama mahasiswa menjadi huruf kapital semua
    ) 
   AS IdentitasMahasiswa 
FROM dbo.Mahasiswa;
GO


-- 2. Date-Time Function (GETDATE / DATEDIFF)
-- Nama Function: DATEDIFF() = Menghitung selisih atau jarak antara dua waktu/tanggal berdasarkan satuan tertentu (hari, bulan, tahun)
-- Tujuan Penggunaan: Menghitung selisih hari antara tanggal pengajuan pendadaran dengan tanggal hari ini (waktu sistem).
-- Hasil yang diharapkan: Menghasilkan angka integer yang menunjukkan sudah berapa lama (dalam satuan hari) pengajuan tersebut dibuat.
SELECT  
    NIM,                   -- Mengambil data NIM mahasiswa yang mengajukan
    Tanggal_Pengajuan,     -- Menampilkan tanggal awal pengajuan pendadaran
    DATEDIFF               -- Menghitung selisih jarak waktu antara tanggal pengajuan dengan tanggal hari ini
    (
        day,               -- Satuan waktu yang dihitung (dalam satuan hari)
        Tanggal_Pengajuan, -- Titik awal waktu (tanggal pengajuan dibuat)
        GETDATE()          -- Titik akhir waktu (tanggal sistem hari ini)
    ) 
    AS LamaHariSejakPengajuan 
FROM dbo.Pengajuan_Pendadaran;
GO


-- 3. Aggregate Function (COUNT)
-- Nama Function: COUNT() = Menghitung jumlah baris atau total data yang ada di dalam suatu tabel atau kolom tertentu
-- Tujuan Penggunaan: Menghitung total keseluruhan jumlah mahasiswa yang terdaftar di dalam database.
-- Hasil yang diharapkan: Menghasilkan satu nilai angka kumulatif dari total seluruh baris mahasiswa.
SELECT  
    COUNT     -- Menghitung jumlah data baris secara keseluruhan
    (
        NIM   -- Kolom NIM pada tabel Mahasiswa yang dijadikan acuan hitung
    ) 
    AS TotalKeseluruhanMahasiswa 
FROM dbo.Mahasiswa;
GO


-- 4. NULL Function (ISNULL)
-- Nama Function: ISNULL() = Mengecek apakah suatu kolom bernilai NULL (kosong), dan jika ya, menggantinya dengan nilai alternatif yang ditentukan
-- Tujuan Penggunaan: Mengganti nilai NULL (kosong/belum diisi) pada kolom Ruangan dengan teks pengganti agar laporan tidak menampilkan kosong.
-- Hasil yang diharapkan: Jika kolom Ruangan pada tabel Pengajuan_Pendadaran bernilai NULL, maka akan otomatis tertulis teks 'Belum Ditentukan'.
SELECT  
    ID_Pengajuan,          -- Menampilkan ID pengajuan pendadaran
    ISNULL                 -- Mengecek data pada kolom, jika kosong maka ganti dengan teks lain
    (
        Ruangan,           -- Kolom yang diperiksa apakah bernilai NULL atau tidak
        'Belum Ditentukan' -- Teks pengganti yang akan dimunculkan jika kolom Ruangan kosong
    ) 
    AS RuanganPendadaran   
FROM dbo.Pengajuan_Pendadaran;
GO




-- ========================================
-- TUGAS 3 — CASE EXPRESSION
-- ========================================

-- CASE EXPRESSION - (Mengklasifikasikan predikat IPK mahasiswa berdasarkan nilai IPK pada pengajuan pendadaran)
SELECT  
    NIM,                                         -- Mengambil data NIM mahasiswa
    IPK,                                         -- Menampilkan nilai IPK mahasiswa yang bersangkutan
    Status,                                      -- Menampilkan status pengajuan pendadaran
    PredikatIPK = CASE                           -- Memulai ekspresi CASE untuk membuat kolom klasifikasi baru
        WHEN IPK >= 3.75 THEN 'Cumlaude'         -- Jika IPK di atas atau sama dengan 3.75
        WHEN IPK >= 3.50 THEN 'Sangat Memuaskan' -- Jika IPK di antara 3.50 sampai 3.74
        WHEN IPK >= 3.00 THEN 'Memuaskan'        -- Jika IPK di antara 3.00 sampai 3.49
        ELSE 'Cukup'                             -- Jika IPK di bawah 3.00
    END                     
FROM dbo.Pengajuan_Pendadaran
ORDER BY IPK DESC;                               -- Mengurutkan data dari IPK tertinggi ke terendah
GO




-- ========================================
-- TUGAS 4 — SQL JOIN
-- ========================================

-- 1. INNER JOIN adalah proses Mengambil dan menampilkan hanya data yang memiliki kecocokan (berpasangan) di kedua tabel yang dihubungkan. 
-- 2. LEFT JOIN / LEFT OUTER JOIN Mengambil seluruh data dari tabel sebelah kiri (tabel pertama), dan hanya mengambil data yang cocok dari tabel sebelah kanan. Jika tidak ada pasangan di kanan, maka hasilnya bernilai NULL (kosong).
-- 3. RIGHT JOIN / RIGHT OUTER JOIN adalah proses Kebalikan dari Left Join. Mengambil seluruh data dari tabel sebelah kanan (tabel kedua), dan hanya mengambil data yang cocok dari tabel sebelah kiri. Jika tidak ada pasangan di kiri, maka hasilnya bernilai NULL.
-- 4. FULL JOIN / FULL OUTER JOIN adalah proses Mengambil seluruh data dari kedua tabel secara bersamaan (kiri dan kanan). Baris yang cocok digabungkan, sedangkan baris yang tidak punya pasangan tetap dimunculkan dengan mengisi bagian yang kosong dengan NULL.
-- 5. CROSS JOIN (Tambahan) adalah proses Menggabungkan setiap baris dari tabel pertama dengan setiap baris dari tabel kedua secara berpasangan (perkalian Cartesian), sehingga menghasilkan total kombinasi silang.

-- Penjelasan Komponen JOIN:
-- 1. Tabel yang digunakan: dbo.Mahasiswa dan dbo.Pengajuan_Pendadaran
-- 2. Kolom yang menjadi relasi: NIM (menghubungkan tabel Mahasiswa dengan tabel Pengajuan_Pendadaran)
-- 3. Alasan menggunakan jenis JOIN: Menggunakan INNER JOIN agar hanya menampilkan data mahasiswa yang benar-benar sudah mengajukan pendadaran saja (baris yang memiliki kecocokan NIM di kedua tabel).


-- Menampilkan Laporan Gabungan Data Mahasiswa dan Pengajuan Pendadaran Menggunakan INNER JOIN
SELECT  
    m.NIM,                              
    m.Nama,                             
    m.Jurusan,                           
    p.Tanggal_Pengajuan,                
    p.Ruangan,                           
    p.Status                             
FROM dbo.Mahasiswa AS m
INNER JOIN dbo.Pengajuan_Pendadaran AS p -- Menghubungkan dan menggabungkan tabel 'Pengajuan_Pendadaran', hanya mengambil data yang memiliki NIM yang cocok/berpasangan dengan tabel sebelumnya(dbo.Mahasiswa AS m)
    ON m.NIM = p.NIM                     -- Kolom relasi penghubung antar kedua tabel
ORDER BY p.Tanggal_Pengajuan DESC;       -- Mengurutkan data berdasarkan tanggal pengajuan terbaru
GO




-- ========================================
-- TUGAS 5 — VIEW
-- ========================================

-- Penjelasan Komponen View:
-- 1. Nama View: vw_LaporanStatusPendadaranLengkap
-- 2. Tabel yang digunakan: Mahasiswa, Pengajuan_Pendadaran, dan Dosen (Melibatkan 3 tabel)
-- 3. Jenis JOIN: Menggunakan INNER JOIN untuk menggabungkan data mahasiswa dengan detail pengajuan pendadaran serta nama dosen penguji.
-- 4. Tujuan Penggunaan: Menyediakan laporan rekapitulasi pendadaran yang mencantumkan nama mahasiswa, status pengajuan, ruangan, dan siapa dosen penguji pertamanya agar mudah dibaca oleh bagian tata usaha atau dosen terkait.


CREATE OR ALTER VIEW vw_LaporanStatusPendadaranLengkap AS -- digunakan untuk membuat sebuah View baru jika View tersebut belum ada, atau memperbarui (mengubah) View tersebut jika sudah ada di dalam database
SELECT
    m.NIM,                      
    m.Nama AS NamaMahasiswa,   
    p.Tanggal_Ujian,           
    p.Ruangan,                  
    p.Status AS StatusPendadaran,
    d.Nama AS NamaDosenPenguji1 
FROM Mahasiswa AS m                  -- Menentukan tabel utama (tabel kiri) yaitu Mahasiswa dengan alias 'm'       = TABEL KIRI (Tabel Utama/Induk)
INNER JOIN Pengajuan_Pendadaran AS p -- Menggabungkan dengan tabel Pengajuan_Pendadaran alias 'p'                  = TABEL KANAN (Tabel Kedua)
    ON m.NIM = p.NIM                 -- Menghubungkan berdasarkan kolom NIM yang sama                              
INNER JOIN Dosen AS d                -- Menggabungkan dengan tabel Dosen alias 'd' untuk mendapatkan nama dosen    = TABEL KANAN (Tabel Ketiga)
    ON p.NIDN_Penguji1 = d.NIDN;     -- Menghubungkan NIDN penguji di tabel Pengajuan dengan NIDN di tabel Dosen
GO


-- Memanggil VIEW:
SELECT * FROM vw_LaporanStatusPendadaranLengkap WHERE Ruangan <> 'Lab Komputer 1' ORDER BY Tanggal_Ujian DESC;
GO




-- ========================================
-- TUGAS 6 — SCALAR USER-DEFINED FUNCTION
-- ========================================

-- Scalar User-Defined Function adalah fungsi yang menerima nol atau beberapa parameter masukan, melakukan suatu proses atau perhitungan di dalamnya, dan mengembalikan tepat satu nilai tunggal (seperti angka, teks, atau tanggal).
-- Penjelasan Komponen Function:
-- 1. Nama Fungsi: dbo.ufn_HitungTotalBimbingan
-- 2. Parameter Input: @NIM CHAR(11) (Menerima input NIM mahasiswa sepanjang 11 karakter sesuai skema tabel)
-- 3. Proses/Perhitungan: Menghitung jumlah baris data bimbingan mahasiswa tersebut di tabel Log_Bimbingan menggunakan fungsi agregasi COUNT.
-- 4. Nilai yang dikembalikan: Mengembalikan satu nilai bilangan bulat (INT) berupa total bimbingan.


-- Perhitungan Otomatis Total Bimbingan Mahasiswa (ufn_HitungTotalBimbingan)
CREATE OR ALTER FUNCTION dbo.ufn_HitungTotalBimbingan -- Proses untuk membuat fungsi baru atau memperbarui secara otomatis jika fungsi dengan nama tersebut sudah ada di database
(
    @NIM CHAR(11)                       -- Mendeklarasikan parameter input @NIM dengan tipe data CHAR(11) 
)
RETURNS INT                             -- Menentukan bahwa fungsi ini wajib mengembalikan satu nilai tunggal bertipe integer
AS
BEGIN                                   
    DECLARE @TotalBimbingan INT;        -- Mendeklarasikan variabel lokal untuk menampung hasil perhitungan total bimbingan

    -- Proses perhitungan: Mengambil dan menjumlahkan total baris bimbingan berdasarkan NIM
    SELECT @TotalBimbingan = COUNT(*)   -- Menghitung jumlah seluruh baris data dari tabel log bimbingan
    FROM dbo.Log_Bimbingan              -- Mengambil sumber data dari tabel Log_Bimbingan yang ada di skema dbo
    WHERE NIM = @NIM;                   -- Menyaring data hanya untuk baris yang NIM-nya sesuai dengan parameter input

    -- Mengembalikan satu nilai hasil akhir perhitungan
    RETURN ISNULL(@TotalBimbingan, 0);  -- ISNULL memastikan jika mahasiswa belum pernah bimbingan (hasilnya NULL), dikembalikan angka 0
END;                                    
GO                                      


-- Memanggil SCALAR
SELECT 
    m.NIM,
    m.Nama AS NamaMahasiswa,
    m.Jurusan,
    dbo.ufn_HitungTotalBimbingan(m.NIM) AS TotalBimbinganMahasiswa
FROM dbo.Mahasiswa AS m
ORDER BY TotalBimbinganMahasiswa ASC;
GO




-- ========================================
-- TUGAS 7 — TRIGGER
-- ========================================

-- Trigger adalah objek khusus pada database yang akan dieksekusi atau dijalankan secara otomatis oleh sistem ketika terjadi suatu peristiwa (event) atau aksi manipulasi data tertentu pada sebuah tabel, seperti penambahan data (INSERT), perubahan data (UPDATE), atau penghapusan data (DELETE).
-- Validasi Otomatis Tanggal Ujian Pendadaran (Mencegah Hari Minggu)
CREATE OR ALTER TRIGGER trg_ValidasiTanggalPendadaran -- Proses untuk membuat trigger baru atau memperbarui trigger yang sudah ada di database
ON dbo.Pengajuan_Pendadaran                           -- Menentukan bahwa trigger ini dipasang (melekat) pada tabel Pengajuan_Pendadaran
AFTER INSERT, UPDATE                                  -- Menentukan kapan trigger aktif, yaitu otomatis setelah ada penambahan (INSERT) atau perubahan (UPDATE) data
AS
BEGIN                                  
    -- Melakukan pengecekan apakah ada data baru yang dimasukkan/diubah dengan kriteria tertentu
    IF EXISTS (                                    -- untuk mengecek apakah query di dalam kurung menghasilkan baris data
        SELECT 1 
        FROM inserted                              -- Tabel virtual 'inserted' menampung data baru yang sedang dimasukkan atau diperbarui
        WHERE DATEPART(WEEKDAY, Tanggal_Ujian) = 1 -- Mengecek apakah hari dari Tanggal_Ujian adalah hari Minggu (angka 1 dalam fungsi DATEPART)
    )
    BEGIN                                     
        -- Memunculkan pesan error kustom ke layar jika validasi gagal
        RAISERROR('Gagal: Ujian pendadaran tidak boleh dijadwalkan pada hari Minggu!', 16, 1);
        
        -- Membatalkan seluruh proses penyimpanan atau perubahan data ke database agar data tidak masuk
        ROLLBACK TRANSACTION;
    END                                  
END;                                    
GO     


-- 1. UJI COBA GAGAL (Sengaja memasukkan tanggal ujian hari Minggu: '2026-05-17'), Trigger akan otomatis mencegat dan membatalkan (ROLLBACK) penyimpanan data ini
INSERT INTO dbo.Pengajuan_Pendadaran 
(
    NIM, 
    NIP_Staff, 
    NIDN_Penguji1, 
    NIDN_Penguji2, 
    IPK, 
    SKS_Lulus, 
    Tanggal_Pengajuan, 
    Tanggal_Ujian, 
    Ruangan, 
    Status, 
    Nilai, 
    Catatan
)

VALUES 
(
    '20214350005', 
    '199001012020011001', 
    '0511019001', 
    '0512029102', 
    3.50, 
    135, 
    '2026-05-01', 
    '2026-05-16', 
    'Lab Komputer 1', 
    'Menunggu',
    NULL, 
    'Uji Coba Hari Minggu (Ditolak Trigger)'
);
GO


-- 2. UJI COBA BERHASIL (Memasukkan tanggal ujian hari Senin / hari kerja: '2026-05-18') Karena bukan hari Minggu, validasi trigger lolos dan data berhasil masuk ke database
INSERT INTO dbo.Pengajuan_Pendadaran 
(
    NIM, 
    NIP_Staff,
    NIDN_Penguji1,
    NIDN_Penguji2, 
    IPK,
    SKS_Lulus, 
    Tanggal_Pengajuan, 
    Tanggal_Ujian
    , Ruangan,
    Status, 
    Nilai, 
    Catatan
)

VALUES 
(
    '20214350016',
    '199102022020012002', 
    '0512029102', 
    '0515059405', 
    2.85,
    131,
    '2026-05-01',
    '2026-05-18', 
    'Lab Komputer 1', 
    'Menunggu', 
    NULL,
    'Uji Coba Hari Senin (Lolos)'
);
GO


-- 3. MELIHAT HASILNYA DI DATABASE
SELECT 
    ID_Pengajuan,
    NIM, 
    Tanggal_Ujian, 
    Ruangan, 
    Status, 
    Catatan 
FROM dbo.Pengajuan_Pendadaran 
WHERE Ruangan = 'Lab Komputer 1';
GO


-- Penjelasan
-- 1. Trigger dibuat pada tabel apa?
-- Trigger dibuat pada tabel dbo.Pengajuan_Pendadaran.

-- 2. Trigger aktif pada INSERT, UPDATE, atau DELETE?
-- Trigger ini aktif pada saat operasi INSERT (penambahan data pengajuan baru) 
-- dan UPDATE (perubahan data, khususnya jadwal tanggal ujian).

-- 3. Mengapa Trigger diperlukan?
-- Trigger diperlukan sebagai validasi tingkat lanjut (database-level validation) 
-- untuk menegakkan aturan bisnis akademik secara otomatis. Hal ini mencegah 
-- kesalahan manusia (human error) saat penginputan tanggal ujian tanpa harus 
-- bergantung sepenuhnya pada validasi dari aplikasi luar.

-- 4. Apa yang terjadi ketika kondisi Trigger terpenuhi?
-- Ketika ada data baru atau perubahan data yang tanggal ujiannya jatuh pada hari Minggu, maka:
-- - Sistem otomatis membatalkan seluruh proses penyimpanan menggunakan ROLLBACK TRANSACTION.
-- - SQL Server menampilkan pesan peringatan error kepada pengguna bahwa jadwal tidak valid.




-- ========================================
-- TUGAS 8 — STORED PROCEDURE
-- ========================================

-- Menambahkan Data Pengajuan Pendadaran Mahasiswa Baru ke Database dengan Validasi Duplikasi Data
CREATE OR ALTER PROCEDURE dbo.usp_TambahPengajuanPendadaran -- Proses untuk membuat stored procedure baru atau memperbarui secara otomatis jika sudah ada di database, nama stored procedure menggunakan awalan usp (User-Stored Procedure)
    @NIM CHAR(11),                                          -- Parameter input pertama: NIM mahasiswa dengan tipe data CHAR(11)
    @Tanggal_Ujian DATE,                                    -- Parameter input kedua: Tanggal rencana ujian pendadaran
    @Ruangan VARCHAR(50),                                   -- Parameter input ketiga: Lokasi ruangan pelaksanaan ujian
    @NIDN_Penguji1 CHAR(10),                                -- Parameter input keempat: NIDN dosen penguji pertama
    @NIP_Staff CHAR(18),                                    -- Parameter input kelima: NIP staff TU (10 digit angka sesuai constraint)
    @NIDN_Penguji2 CHAR(10),                                -- Parameter input keenam: NIDN dosen penguji kedua
    @SKS_Lulus INT,                                         -- Parameter input ketujuh: Jumlah SKS yang sudah lulus
    @Tanggal_Pengajuan DATE,                                -- Parameter input kedelapan: Tanggal saat pengajuan dibuat
    @IPK DECIMAL(3,2)                                       -- Parameter input kesembilan: Nilai IPK mahasiswa
AS
BEGIN                                       
    -- Untuk mencegah pengiriman pesan jumlah baris (row count) yang terpengaruh oleh suatu perintah SQL ke klien atau layar
    SET NOCOUNT ON;

    -- Validasi 1: Mengecek apakah mahasiswa dengan NIM tersebut sudah pernah mengajukan pendadaran sebelumnya
    IF EXISTS (SELECT 1 FROM dbo.Pengajuan_Pendadaran WHERE NIM = @NIM)
    BEGIN
        -- Jika sudah ada, gagalkan proses dan tampilkan pesan error kustom ke layar
        RAISERROR('Gagal: Mahasiswa dengan NIM tersebut sudah memiliki pengajuan pendadaran!', 16, 1);
        RETURN;                                             -- Menghentikan eksekusi prosedur agar perintah INSERT di bawahnya tidak dijalankan
    END

    -- Proses Bisnis Utama: Menambahkan data pengajuan pendadaran baru ke tabel Pengajuan_Pendadaran dengan menyertakan seluruh kolom wajib (NOT NULL)
    INSERT INTO dbo.Pengajuan_Pendadaran 
    (
        NIM, 
        NIP_Staff, 
        NIDN_Penguji1, 
        NIDN_Penguji2, 
        SKS_Lulus, 
        Tanggal_Pengajuan, 
        Tanggal_Ujian, 
        Ruangan, 
        Status, 
        IPK
    )

    VALUES 
    (
        @NIM, 
        @NIP_Staff, 
        @NIDN_Penguji1, 
        @NIDN_Penguji2, 
        @SKS_Lulus, 
        @Tanggal_Pengajuan, 
        @Tanggal_Ujian, 
        @Ruangan, 
        'Menunggu', 
        @IPK
    ); 

    -- Memberikan informasi pesan sukses ke layar bahwa data berhasil disimpan
    PRINT 'Sukses: Pengajuan pendadaran berhasil ditambahkan ke dalam database.';
END;                        
GO                                         


-- Memanggil STORED PROCEDURE
EXEC dbo.usp_TambahPengajuanPendadaran 
    @NIM = '20214350001',               -- Mengisi parameter NIM mahasiswa (Vino G. Bastian)
    @Tanggal_Ujian = '2026-05-18',      -- Mengisi tanggal rencana ujian (Hari Senin / Valid)
    @Ruangan = 'Lab Komputer 1',        -- Mengisi parameter Lokasi Ruangan
    @NIDN_Penguji1 = '0519089708',      -- Mengisi parameter NIDN Dosen Penguji 1
    @NIP_Staff = '199001012020011001',  -- Mengisi parameter NIP Staff (10 digit angka)
    @NIDN_Penguji2 = '0512029102',      -- Mengisi parameter NIDN Dosen Penguji 2
    @SKS_Lulus = 130,                   -- Mengisi parameter jumlah SKS lulus
    @Tanggal_Pengajuan = '2026-05-01',  -- Mengisi parameter tanggal pengajuan
    @IPK = 3.05;                        -- Mengisi parameter nilai IPK mahasiswa
GO


-- Melihat hasilnya di database
SELECT * FROM dbo.Pengajuan_Pendadaran WHERE NIM = '20214350019';
GO




-- ========================================
-- TUGAS 9 — T-SQL PROGRAMMING
-- ========================================

-- Penambahan Data Pengajuan Pendadaran Mahasiswa Baru dengan Validasi
CREATE OR ALTER PROCEDURE dbo.usp_TambahPengajuanPendadaranTugas9  -- Membuat atau memperbarui Stored Procedure di dalam database
    @NIM CHAR(11),                        -- Parameter input untuk menerima data NIM mahasiswa
    @Tanggal_Ujian DATE,                  -- Parameter input untuk menerima data tanggal rencana ujian pendadaran
    @Ruangan VARCHAR(50),                 -- Parameter input untuk menerima data lokasi ruangan ujian
    @NIDN_Penguji1 CHAR(10),              -- Parameter input untuk menerima data NIDN dosen penguji pertama
    @NIP_Staff CHAR(18),                  -- Parameter input untuk menerima data NIP Staff (Wajib diisi)
    @NIDN_Penguji2 CHAR(10),              -- Parameter input untuk menerima data NIDN dosen penguji kedua (Wajib diisi)
    @SKS_Lulus INT,                       -- Parameter input untuk menerima data SKS lulus (Wajib diisi)
    @Tanggal_Pengajuan DATE,              -- Parameter input untuk menerima data tanggal pengajuan (Wajib diisi)
    @IPK DECIMAL(4,2)                     -- Parameter input untuk menerima data IPK (Wajib diisi)
AS
BEGIN
    -- Mencegah pengiriman pesan informasi jumlah baris terpengaruh ke klien agar optimal
    SET NOCOUNT ON;

    -- 1. DECLARE: Mendeklarasikan variabel lokal tipe data INT untuk menampung jumlah pengajuan mahasiswa
    DECLARE @JumlahPengajuan INT;

    -- 2. SELECT: Mengisi nilai variabel @JumlahPengajuan dengan menghitung baris data di tabel berdasarkan NIM yang diinput
    SELECT @JumlahPengajuan = COUNT(*) 
    FROM dbo.Pengajuan_Pendadaran 
    WHERE NIM = @NIM; -- Perintah untuk menyaring baris data dari tabel Pengajuan_Pendadaran di nilai kolom NIM pada tabel sama persis dengan nilai yang tersimpan di dalam variabel parameter input @NIM

    -- 3. IF...ELSE: Menggunakan struktur pengambilan keputusan untuk validasi data
    IF @JumlahPengajuan > 0  -- Struktur percabangan IF untuk memeriksa apakah nilai variabel @JumlahPengajuan bernilai lebih dari 0 
        BEGIN
            -- Memunculkan error kustom secara manual menggunakan THROW jika mahasiswa sudah pernah mendaftar
            ;THROW 50001, 'Gagal: Mahasiswa dengan NIM tersebut sudah memiliki pengajuan pendadaran!', 1;
        END
    ELSE
        BEGIN
            -- Proses Utama: Memasukkan data baru ke dalam tabel jika validasi lolos (belum pernah mendaftar)
            INSERT INTO dbo.Pengajuan_Pendadaran 
            (
                NIM, 
                Tanggal_Ujian, 
                Ruangan, 
                Status, 
                NIDN_Penguji1, 
                NIP_Staff, 
                NIDN_Penguji2, 
                SKS_Lulus, 
                Tanggal_Pengajuan, 
                IPK
            )
            VALUES 
            (
                @NIM, 
                @Tanggal_Ujian, 
                @Ruangan, 
                'Menunggu', 
                @NIDN_Penguji1, 
                @NIP_Staff, 
                @NIDN_Penguji2, 
                @SKS_Lulus, 
                @Tanggal_Pengajuan, 
                @IPK
            );

            -- Menampilkan pesan informasi sukses ke layar bahwa data telah berhasil ditambahkan
            PRINT 'Sukses: Pengajuan pendadaran berhasil ditambahkan ke dalam database.';
        END
    END;
GO


-- 1. Uji Coba Pertama: Berhasil (Mengeksekusi prosedur untuk memasukkan data pengajuan baru dengan NIM mahasiswa yang belum terdaftar)
EXEC dbo.usp_TambahPengajuanPendadaranTugas9 
    @NIM = '20224350007',               -- Mengisi parameter NIM dengan data mahasiswa baru (Iqbaal Ramadhan)
    @Tanggal_Ujian = '2026-05-18',      -- Mengisi parameter tanggal rencana ujian pendadaran
    @Ruangan = 'Lab Jaringan',          -- Mengisi parameter lokasi ruangan ujian
    @NIDN_Penguji1 = '0515059405',      -- Mengisi parameter NIDN dosen penguji pertama
    @NIP_Staff = '199102022020012002',  -- Mengisi parameter NIP Staff
    @NIDN_Penguji2 = '0512029102',      -- Mengisi parameter NIDN dosen penguji kedua
    @SKS_Lulus = 132,                   -- Mengisi parameter SKS lulus
    @Tanggal_Pengajuan = '2026-05-02',  -- Mengisi parameter tanggal pengajuan
    @IPK = 3.45;                        -- Mengisi parameter IPK
GO  


-- 2. Cek data di tabel (Perintah untuk menampilkan dan memverifikasi baris data yang baru saja dimasukkan ke dalam tabel database)
SELECT * FROM dbo.Pengajuan_Pendadaran WHERE NIM = '20224350007';
GO                   


-- 3. Uji Coba Kedua: Gagal (Mengeksekusi ulang prosedur dengan NIM yang sama untuk memicu validasi IF...ELSE dan pesan THROW)
EXEC dbo.usp_TambahPengajuanPendadaranTugas9  
    @NIM = '20224350007',               -- Menggunakan NIM yang sama persis agar terdeteksi sudah ada
    @Tanggal_Ujian = '2026-05-20',      -- Tanggal ujian baru (akan ditolak oleh validasi IF...ELSE)
    @Ruangan = 'Ruang Sidang A',        -- Ruangan baru
    @NIDN_Penguji1 = '0515059405',      -- NIDN dosen penguji pertama
    @NIP_Staff = '199102022020012002',  -- NIP Staff
    @NIDN_Penguji2 = '0512029102',      -- NIDN dosen penguji kedua
    @SKS_Lulus = 132,                   -- SKS lulus
    @Tanggal_Pengajuan = '2026-05-02',  -- Tanggal pengajuan
    @IPK = 3.45;                        -- IPK
GO




-- ========================================
-- TUGAS 10 — TRY...CATCH
-- ========================================

-- Penanganan Error dan Transaksi Aman Menggunakan Blok TRY...CATCH
CREATE OR ALTER PROCEDURE dbo.usp_TambahPengajuanPendadaranTugas10 -- Perintah untuk membuat stored procedure baru atau memperbarui secara otomatis jika sudah ada di dalam database
    @NIM CHAR(11),                        -- Parameter input untuk menerima data NIM mahasiswa
    @Tanggal_Ujian DATE,                  -- Parameter input untuk menerima data tanggal rencana ujian pendadaran
    @Ruangan VARCHAR(50),                 -- Parameter input untuk menerima data lokasi ruangan ujian
    @NIDN_Penguji1 CHAR(10),              -- Parameter input untuk menerima data NIDN dosen penguji pertama
    @NIP_Staff CHAR(18),                  -- Parameter input untuk menerima data NIP Staff (Wajib diisi)
    @NIDN_Penguji2 CHAR(10),              -- Parameter input untuk menerima data NIDN dosen penguji kedua (Wajib diisi)
    @SKS_Lulus INT,                       -- Parameter input untuk menerima data SKS lulus (Wajib diisi)
    @Tanggal_Pengajuan DATE,              -- Parameter input untuk menerima data tanggal pengajuan (Wajib diisi)
    @IPK DECIMAL(4,2)                     -- Parameter input untuk menerima data IPK (Wajib diisi)
AS
BEGIN
    -- Mencegah pengiriman pesan informasi jumlah baris terpengaruh ke klien agar performa eksekusi optimal
    SET NOCOUNT ON;

    -- Membungkus seluruh proses utama dengan blok pemantauan error (TRY) agar penanganan kesalahan dapat dikelola dengan rapi
    BEGIN TRY
        -- Proses Bisnis Utama: Menambahkan data baru ke tabel Pengajuan_Pendadaran dengan menyertakan seluruh kolom wajib
        INSERT INTO dbo.Pengajuan_Pendadaran 
        (
            NIM, 
            Tanggal_Ujian, 
            Ruangan, 
            Status, 
            NIDN_Penguji1,
            NIP_Staff,
            NIDN_Penguji2,
            SKS_Lulus,
            Tanggal_Pengajuan,
            IPK
        )
        VALUES 
        (
            @NIM, 
            @Tanggal_Ujian, 
            @Ruangan, 
            'Menunggu', 
            @NIDN_Penguji1,
            @NIP_Staff,
            @NIDN_Penguji2,
            @SKS_Lulus,
            @Tanggal_Pengajuan,
            @IPK
        );

        -- Menampilkan pesan informasi sukses ke layar bahwa data berhasil disimpan ke database
        PRINT 'Sukses: Data berhasil disimpan ke dalam database.';
    END TRY

    -- Menandai awal blok penanganan error (CATCH) yang otomatis berjalan jika terjadi kegagalan/error di dalam blok TRY
    BEGIN CATCH
        -- Menangkap dan menampilkan rincian nomor kode serta teks pesan error dari sistem database
        SELECT
            ERROR_NUMBER() AS ErrorNumber, -- Kolom untuk menampilkan nomor kode unik error
            ERROR_MESSAGE() AS PesanError; -- Kolom untuk menampilkan teks deskripsi pesan kesalahan dari sistem
    END CATCH
END;
GO


-- LANGKAH 1: Uji Coba Kondisi BERHASIL - Memasukkan data dengan data valid 
EXEC dbo.usp_TambahPengajuanPendadaranTugas10 
    @NIM = '20214350005',                -- Mengisi parameter NIM mahasiswa
    @Tanggal_Ujian = '2026-05-15',       -- Mengisi tanggal ujian
    @Ruangan = 'Lab Komputer 1',         -- Mengisi ruangan ujian
    @NIDN_Penguji1 = '0511019001',       -- Mengisi NIDN dosen yang valid/terdaftar
    @NIP_Staff = '199001012020011001',   -- Mengisi NIP Staff yang valid
    @NIDN_Penguji2 = '0512029102',       -- Mengisi NIDN penguji kedua yang valid
    @SKS_Lulus = 130,                    -- Mengisi jumlah SKS lulus
    @Tanggal_Pengajuan = '2026-05-01',   -- Mengisi tanggal pengajuan
    @IPK = 3.50;                         -- Mengisi nilai IPK
GO


-- LANGKAH 2: Cek tabel untuk memastikan data berhasil masuk
SELECT * FROM dbo.Pengajuan_Pendadaran WHERE NIM = '20214350005';
GO


-- LANGKAH 3: Uji Coba Kondisi GAGAL (Memicu Blok CATCH) - Mengisi NIDN Dosen dengan kode yang tidak ada di tabel Dosen untuk memicu error Foreign Key
EXEC dbo.usp_TambahPengajuanPendadaranTugas10 
    @NIM = '20214350006',                -- NIM mahasiswa
    @Tanggal_Ujian = '2026-05-20',       -- Tanggal ujian baru
    @Ruangan = 'Ruang Sidang A',         -- Ruangan baru
    @NIDN_Penguji1 = '9999999999',       -- Sengaja mengisi NIDN ngawur untuk memicu error sistem (Foreign Key Violation)
    @NIP_Staff = '199001012020011001',   -- Mengisi NIP Staff valid
    @NIDN_Penguji2 = '0512029102',       -- Mengisi NIDN penguji kedua valid
    @SKS_Lulus = 130,                    -- Mengisi SKS lulus
    @Tanggal_Pengajuan = '2026-05-01',   -- Mengisi tanggal pengajuan
    @IPK = 3.50;                         -- Mengisi IPK
GO