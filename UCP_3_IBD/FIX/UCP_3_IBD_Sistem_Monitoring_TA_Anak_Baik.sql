USE Monitoring_TA;
GO

-- ======================================================================================
-- 1. Functional Testing - FUNC-01: Menguji Insert Data Valid pada tabel Induk/Utama
-- ======================================================================================

-- Insert Tabel Dosen 
INSERT INTO Dosen (NIDN, Nama, Prodi, Email, No_HP)
VALUES ('0611038501', 'Andi Wijaya', 'Sistem Informasi', 'andi.wijaya@kampus.ac.id', '081234567899');

-- Insert Tabel Staff_TU
INSERT INTO Staff_TU (NIP, Nama, Jabatan, Email, No_HP)
VALUES ('199205152021012002', 'Rina Kusuma', 'Staff Akademik', 'rina.kusuma@kampus.ac.id', '081234567802');

-- Insert Tabel Mahasiswa
INSERT INTO Mahasiswa (NIM, Nama, Angkatan, Jurusan, Email, NIDN_Pembimbing)
VALUES ('20204350099', 'Budi Santoso', '2020', 'Sistem Informasi', 'budi.santoso@student.ac.id', '0611038501');

-- Verifikasi
SELECT * FROM Dosen WHERE NIDN = '0611038501';
SELECT * FROM Staff_TU WHERE NIP = '199205152021012002';
SELECT * FROM Mahasiswa WHERE NIM = '20204350099';




-- ======================================================================================
-- 2. Functional Testing - FUNC-02: Menguji Update Data pada tabel Induk/Utama
-- ======================================================================================

-- 1. Update Dosen (ubah Prodi)
UPDATE Dosen
SET Prodi = 'Teknik Informatika'
WHERE NIDN = '0611038501';

-- 2. Update Staff_TU (ubah Jabatan)
UPDATE Staff_TU
SET Jabatan = 'Kepala Staff Akademik'
WHERE NIP = '199205152021012002';

-- 3. Update Mahasiswa (ubah Jurusan)
UPDATE Mahasiswa
SET Jurusan = 'Teknik Informatika'
WHERE NIM = '20204350099';

-- Verifikasi
SELECT * FROM Dosen WHERE NIDN = '0611038501';
SELECT * FROM Staff_TU WHERE NIP = '199205152021012002';
SELECT * FROM Mahasiswa WHERE NIM = '20204350099';




-- ======================================================================================
-- 3. Functional Testing - FUNC-03: Menguji Stored Procedure
-- ======================================================================================
EXEC sp_helptext 'sp_CariMahasiswa';
GO
EXEC sp_helptext 'sp_TambahMahasiswa';
GO
EXEC sp_helptext 'usp_TambahPengajuanPendadaran';
GO

-- 1. Menguji Stored Procedure sp_CariMahasiswa
EXEC sp_CariMahasiswa @Nama = 'Budi Santoso';

-- 2. Menguji Stored Procedure sp_CariMahasiswa
EXEC sp_TambahMahasiswa
    @NIM = '20204350100',
    @Nama = 'Siti Aminah',
    @Angkatan = '2020',
    @Jurusan = 'Sistem Informasi',
    @Email = 'siti.aminah@student.ac.id',
    @NIDN_Pembimbing = '0502026801';

-- Verifikasi
SELECT * FROM Mahasiswa WHERE NIM = '20204350100';

-- 3. Menguji Stored Procedure usp_TambahPengajuanPendadaran
EXEC usp_TambahPengajuanPendadaran
    @NIM = '20204350099',
    @Tanggal_Ujian = '2026-09-15',
    @Ruangan = 'Ruang Sidang A',
    @NIDN_Penguji1 = '0502026801',
    @NIP_Staff = '199205152021012002',
    @NIDN_Penguji2 = '0513039203',
    @SKS_Lulus = 140,
    @Tanggal_Pengajuan = '2026-08-28',
    @IPK = 3.50;

-- Verifikasi
SELECT * FROM Pengajuan_Pendadaran WHERE NIM = '20204350099';




-- ======================================================================================
-- 4. Functional Testing - FUNC-04: Menguji Trigger
-- ======================================================================================
EXEC sp_helptext 'trg_UpdateStatusTA';
GO
EXEC sp_helptext 'trg_ValidasiTanggalPendadaran';
GO

-- 1. Menguji Trigger trg_UpdateStatusTA
-- Cek kondisi sebelum trigger jalan
SELECT Status_TA FROM Monitoring_TA WHERE Nim = '20204350099';

-- Update Status jadi Selesai untuk memicu trigger
UPDATE Pengajuan_Pendadaran
SET Status = 'Selesai'
WHERE Nim = '20204350099';

-- Verifikasi trigger bekerja
SELECT Status_TA FROM Monitoring_TA WHERE Nim = '20204350099';


-- 2. Menguji Trigger trg_ValidasiTanggalPendadaran
-- Cek NIM ini belum ada pengajuan
SELECT * FROM Pengajuan_Pendadaran WHERE NIM = '20204350100';

-- insert dengan Tanggal_Ujian = hari Minggu (harus gagal)
INSERT INTO Pengajuan_Pendadaran (NIM, NIP_Staff, NIDN_Penguji1, NIDN_Penguji2, SKS_Lulus, Tanggal_Pengajuan, Tanggal_Ujian, Ruangan, Status, IPK)
VALUES ('20204350100', '199205152021012002', '0502026801', '0513039203', 140, '2026-08-28', '2026-08-30', 'Ruang Sidang B', 'Menunggu', 3.60);

-- Verifikasi tidak ada data yang masuk
SELECT * FROM Pengajuan_Pendadaran WHERE NIM = '20204350100';




-- ======================================================================================
-- 5. Functional Testing - FUNC-05: Menguji View
-- ======================================================================================
EXEC sp_helptext 'vw_LaporanStatusPendadaranLengkap';
GO
EXEC sp_helptext 'vw_MahasiswaPembimbing';
GO

-- View vw_LaporanStatusPendadaranLengkap
SELECT * FROM vw_LaporanStatusPendadaranLengkap WHERE NIM = '20204350099';

-- View vw_MahasiswaPembimbing
SELECT * FROM vw_MahasiswaPembimbing WHERE NIM = '20204350099';




-- ======================================================================================
-- 6. Integrity Testing	- INT-PK-01: Menguji duplikasi Primary Key
-- ======================================================================================
-- Menguji Duplikasi PK di Dosen 
INSERT INTO Dosen (NIDN, Nama, Prodi, Email, No_HP)
VALUES ('0611038501', 'Nama Lain', 'Prodi Lain', 'lain.dosen@kampus.ac.id', '081200000001');

-- Menguji Duplikasi PK di Staff_TU 
INSERT INTO Staff_TU (NIP, Nama, Jabatan, Email, No_HP)
VALUES ('199205152021012002', 'Nama Lain', 'Jabatan Lain', 'lain.staff@kampus.ac.id', '081200000002');

-- Menguji Duplikasi PK di Mahasiswa 
INSERT INTO Mahasiswa (NIM, Nama, Angkatan, Jurusan, Email, NIDN_Pembimbing)
VALUES ('20204350099', 'Nama Lain', '2021', 'Jurusan Lain', 'lain.mhs@student.ac.id', '0611038501');




-- ======================================================================================
-- 7. Integrity Testing	- INT-FK-01: Menguji aturan Foreign Key (Referential)
-- ======================================================================================

-- 1. Menguji aturan Foreign Key pada tabel anak Log_Bimbingan
INSERT INTO Log_Bimbingan (NIM, NIDN, Materi, Status)
VALUES ('20204350099', '9999999999', 'Konsultasi Bab 1', 'Menunggu');

DELETE FROM Dosen WHERE NIDN = '0611038501';


-- 2. Menguji aturan Foreign Key pada tabel anak Mahasiswa
INSERT INTO Mahasiswa (NIM, Nama, Angkatan, Jurusan, Email, NIDN_Pembimbing)
VALUES ('20204350101', 'Fajar Nugroho', '2020', 'Sistem Informasi', 'fajar.nugroho@student.ac.id', '9999999999');

DELETE FROM Dosen WHERE NIDN = '0611038501';


-- 3. Menguji aturan Foreign Key pada tabel anak Monitoring_TA
INSERT INTO Monitoring_TA (Nim, NIDN_Pembimbing, Judul_TA, Status_TA)
VALUES ('99999999999', '0611038501', 'Judul Uji FK Invalid', 'Pengajuan Judul');

DELETE FROM Mahasiswa WHERE NIM = '20204350099';

-- 4. Menguji aturan Foreign Key pada tabel anak Pengajuan_Pendadaran
INSERT INTO Pengajuan_Pendadaran (NIM, NIP_Staff, NIDN_Penguji1, NIDN_Penguji2, SKS_Lulus, Tanggal_Pengajuan, Tanggal_Ujian, Ruangan, Status, IPK)
VALUES ('20204350100', '999999999999999999', '0502026801', '0513039203', 140, '2026-08-29', '2026-09-20', 'Ruang Sidang C', 'Menunggu', 3.40);

DELETE FROM Staff_TU WHERE NIP = '199205152021012002';




-- ======================================================================================
-- 8. Integrity Testing	- INT-CHK-01: Menguji aturan Check Constraint / Default
-- ======================================================================================

-- Tabel Dosen
-- 1. Ubah No_HP menjadi format tidak valid (mengandung huruf)
UPDATE Dosen SET No_HP = '08123ABC45' WHERE NIDN = '0611038501';


-- Tabel Log_Bimbingan
-- 1. Ubah NIDN menjadi format tidak valid (mengandung huruf)
UPDATE Log_Bimbingan SET NIDN = '061103850A' WHERE NIM = '20204350099';

-- 2. Ubah NIM menjadi format tidak valid (mengandung huruf)
UPDATE Log_Bimbingan SET NIM = '2020435009A' WHERE NIDN = '0611038501';

-- 3. Ubah Status menjadi nilai di luar daftar yang diizinkan
UPDATE Log_Bimbingan SET Status = 'Proses' WHERE NIM = '20204350099';

-- 4. Ubah Tanggal menjadi tanggal di masa depan
UPDATE Log_Bimbingan SET Tanggal = DATEADD(DAY, 10, GETDATE()) WHERE NIM = '20204350099';


-- Tabel Mahasiswa
-- 1. Ubah Angkatan menjadi nilai di luar rentang yang diizinkan
UPDATE Mahasiswa SET Angkatan = '2010' WHERE NIM = '20204350099';

-- 2. Ubah Email menjadi format tidak valid
UPDATE Mahasiswa SET Email = 'emailsalah' WHERE NIM = '20204350099';

-- 3. Insert data mahasiswa baru dengan NIM format tidak valid (mengandung huruf)
INSERT INTO Mahasiswa (NIM, Nama, Angkatan, Jurusan, Email, NIDN_Pembimbing)
VALUES ('2020435010A', 'Test NIM Invalid', '2020', 'Sistem Informasi', 'test@student.ac.id', '0611038501');


-- Tabel Monitoring_TA
-- 1. Ubah NIDN_Pembimbing menjadi format tidak valid (mengandung huruf)
UPDATE Monitoring_TA SET NIDN_Pembimbing = '061103850A' WHERE Nim = '20204350099';

-- 2. Ubah Nim menjadi format tidak valid (mengandung huruf)
UPDATE Monitoring_TA SET Nim = '2020435009A' WHERE Nim = '20204350099';

-- 3. Ubah Status_TA menjadi nilai di luar daftar yang diizinkan
UPDATE Monitoring_TA SET Status_TA = 'Selesai Total' WHERE Nim = '20204350099';


-- Tabel Pengajuan_Pendadaran
-- 1. Ubah IPK menjadi nilai di luar rentang yang diizinkan
UPDATE Pengajuan_Pendadaran SET IPK = 1.50 WHERE NIM = '20204350099';

-- 2. Ubah NIDN_Penguji1 menjadi format tidak valid (mengandung huruf)
UPDATE Pengajuan_Pendadaran SET NIDN_Penguji1 = '050202680A' WHERE NIM = '20204350099';

-- 3. Ubah NIDN_Penguji2 menjadi format tidak valid (mengandung huruf)
UPDATE Pengajuan_Pendadaran SET NIDN_Penguji2 = '051303920A' WHERE NIM = '20204350099';

-- 4. Ubah Nilai menjadi nilai di luar daftar yang diizinkan
UPDATE Pengajuan_Pendadaran SET Nilai = 'F' WHERE NIM = '20204350099';

-- 5. Ubah NIM menjadi format tidak valid (mengandung huruf)
UPDATE Pengajuan_Pendadaran SET NIM = '2020435009A' WHERE NIM = '20204350099';

-- 6. Ubah NIP_Staff menjadi format tidak valid (mengandung huruf)
UPDATE Pengajuan_Pendadaran SET NIP_Staff = '19920515202101200A' WHERE NIM = '20204350099';

-- 7. Ubah SKS_Lulus menjadi nilai di luar rentang yang diizinkan
UPDATE Pengajuan_Pendadaran SET SKS_Lulus = 120 WHERE NIM = '20204350099';

-- 8. Ubah Status menjadi nilai di luar daftar yang diizinkan
UPDATE Pengajuan_Pendadaran SET Status = 'Batal' WHERE NIM = '20204350099';

-- 9. Ubah Tanggal_Ujian menjadi lebih awal dari Tanggal_Pengajuan
UPDATE Pengajuan_Pendadaran SET Tanggal_Ujian = '2026-01-01' WHERE NIM = '20204350099';

-- 10. Ubah NIDN_Penguji2 menjadi sama dengan NIDN_Penguji1
UPDATE Pengajuan_Pendadaran SET NIDN_Penguji2 = NIDN_Penguji1 WHERE NIM = '20204350099';

-- 11. Ubah Tanggal_Pengajuan menjadi tanggal di masa depan
UPDATE Pengajuan_Pendadaran SET Tanggal_Pengajuan = DATEADD(DAY, 10, GETDATE()) WHERE NIM = '20204350099';


-- Tabel Staff_TU
-- 1. Ubah Email menjadi format tidak valid
UPDATE Staff_TU SET Email = 'emailsalah' WHERE NIP = '199205152021012002';

-- 2. Insert data staff baru dengan NIP format tidak valid (mengandung huruf)
INSERT INTO Staff_TU (NIP, Nama, Jabatan, Email, No_HP)
VALUES ('19920515202101200A', 'Test NIP Invalid', 'Staff Test', 'test@staff.ac.id', '081234567890');

-- 3. Ubah No_HP menjadi format tidak valid (mengandung huruf)
UPDATE Staff_TU SET No_HP = '0812ABCD5678' WHERE NIP = '199205152021012002';




-- ======================================================================================
-- 9. Transaction Testing - TRNS-01: Menguji COMMIT pada Transaksi Multi-Tabel
-- ======================================================================================

-- 1. Mulai Transaksi
BEGIN TRANSACTION;

-- 2. Insert data bimbingan baru 
INSERT INTO Log_Bimbingan (NIM, NIDN, Materi, Status)
VALUES ('20204350099', '0611038501', 'Konsultasi Bab 2', 'Menunggu');

-- 3. Update status bimbingan 
UPDATE Log_Bimbingan
SET Status = 'Disetujui'
WHERE NIM = '20204350099' AND Materi = 'Konsultasi Bab 2';

-- 4. Commit Transaksi (simpan permanen)
COMMIT TRANSACTION;

-- 5. Verifikasi data tersimpan permanen
SELECT * FROM Log_Bimbingan WHERE Materi = 'Konsultasi Bab 2';




-- ======================================================================================
-- 10. Transaction Testing - TRNS-02: Menguji ROLLBACK pada Transaksi Multi-Tabel
-- ======================================================================================

-- 1. Mulai Transaksi
BEGIN TRANSACTION;

-- 2. Eksekusi sukses: Insert data bimbingan baru (valid)
INSERT INTO Log_Bimbingan (NIM, NIDN, Materi, Status)
VALUES ('20204350099', '0611038501', 'Konsultasi Bab 3', 'Menunggu');

-- 3. Eksekusi gagal (error): NIDN tidak valid (FK invalid)
INSERT INTO Log_Bimbingan (NIM, NIDN, Materi, Status)
VALUES ('20204350099', '9999999999', 'Konsultasi Bab 4', 'Menunggu');

-- 4. Rollback Transaksi karena langkah 3 gagal
ROLLBACK TRANSACTION;

-- 5. Verifikasi data dari langkah 2 TIDAK ADA (karena di-rollback)
SELECT * FROM Log_Bimbingan WHERE Materi = 'Konsultasi Bab 3';




-- ============================
-- 11.12. Performance Testing
-- ============================

-- Insert 5000 Data Dummy ke Tabel Pengajuan_Pendadaran
SET NOCOUNT ON;

DECLARE @i INT = 1;
DECLARE @Target INT = 5000;
DECLARE @CurrentCount INT = (SELECT COUNT(*) FROM Pengajuan_Pendadaran);
DECLARE @ToInsert INT = @Target - @CurrentCount;

DECLARE @StatusList TABLE (Status VARCHAR(25));
INSERT INTO @StatusList VALUES ('Menunggu'), ('Disetujui'), ('Ditolak'), ('Selesai');

DECLARE @NIMList TABLE (NIM CHAR(11));
INSERT INTO @NIMList SELECT NIM FROM Mahasiswa;

WHILE @i <= @ToInsert
BEGIN
    DECLARE @NIM CHAR(11) = (SELECT TOP 1 NIM FROM @NIMList ORDER BY NEWID());
    DECLARE @Status VARCHAR(25) = (SELECT TOP 1 Status FROM @StatusList ORDER BY NEWID());
    DECLARE @TglPengajuan DATE = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 365), GETDATE());
    DECLARE @TglUjian DATE = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 30) + 1, @TglPengajuan);

    -- Menghindari hari Minggu: kalau Hari Minggu, maka geser ke hari Senin
    IF DATEPART(WEEKDAY, @TglUjian) = 1
        SET @TglUjian = DATEADD(DAY, 1, @TglUjian);

    DECLARE @IPK DECIMAL(3,2) = 2.00 + (ABS(CHECKSUM(NEWID())) % 200) / 100.0;
    DECLARE @SKS INT = 130 + (ABS(CHECKSUM(NEWID())) % 21);

    INSERT INTO Pengajuan_Pendadaran
        (NIM, NIP_Staff, NIDN_Penguji1, NIDN_Penguji2, SKS_Lulus, Tanggal_Pengajuan, Tanggal_Ujian, Ruangan, Status, IPK)
    VALUES
        (@NIM, '199205152021012002', '0502026801', '0513039203', @SKS, @TglPengajuan, @TglUjian, 'Ruang Dummy', @Status, @IPK);

    SET @i += 1;
END;

-- Cek total data sekarang
SELECT COUNT(*) AS Total_Pengajuan FROM Pengajuan_Pendadaran;
SELECT Status, COUNT(*) AS Jumlah FROM Pengajuan_Pendadaran GROUP BY Status;


-- ======================================================================================
-- 11. Performance Testing - PERF-01: Menguji eksekusi query berat TANPA Index
-- ======================================================================================
SET STATISTICS IO ON;
SET STATISTICS TIME ON;


SELECT P.ID_Pengajuan, M.Nama, P.Status, P.Tanggal_Pengajuan
FROM Pengajuan_Pendadaran P
JOIN Mahasiswa M ON P.NIM = M.NIM
WHERE P.Status = 'Disetujui'
ORDER BY P.Tanggal_Pengajuan DESC;




-- ======================================================================================
-- 12. Performance Testing - PERF-02: Menguji eksekusi query berat dengan Index
-- ======================================================================================
CREATE NONCLUSTERED INDEX idx_Pengajuan_Status ON Pengajuan_Pendadaran(Status);

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT P.ID_Pengajuan, M.Nama, P.Status, P.Tanggal_Pengajuan
FROM Pengajuan_Pendadaran P
JOIN Mahasiswa M ON P.NIM = M.NIM
WHERE P.Status = 'Disetujui'
ORDER BY P.Tanggal_Pengajuan DESC;



-- ======================================================================================
-- 13. Security Testing - SEC-01: Simulasi SQL Injection
-- ======================================================================================

-- Langkah 1: Simulasi Query RENTAN (String Concatenation)
DECLARE @NamaInput VARCHAR(100);
DECLARE @SQL VARCHAR(MAX);

-- Input yang dikirim "penyerang": ' OR '1'='1
SET @NamaInput = '''' + ' OR ''1''=''1';

SET @SQL = 'SELECT NIM, Nama, Jurusan FROM Mahasiswa WHERE Nama = ''' + @NamaInput + '''';
PRINT @SQL;
EXEC(@SQL);
GO

-- Langkah 2: Buat versi AMAN pakai Stored Procedure + Parameter
CREATE PROCEDURE sp_CariMahasiswa @Nama VARCHAR(100)
AS
BEGIN
    SELECT NIM, Nama, Jurusan FROM Mahasiswa WHERE Nama = @Nama;
END
GO

-- Langkah 3: Simulasi Query AMAN – kirim payload yang SAMA lewat parameter
EXEC sp_CariMahasiswa @Nama = ''' OR ''1''=''1';
GO