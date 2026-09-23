USE Monitoring_TA;
GO

-- ======================================================================================
-- 1. Functional Testing - FUNC-01: Menguji Insert Data Valid pada tabel log bimbingan
-- ======================================================================================

-- Langkah 1: Insert data log bimbingan baru
INSERT INTO Log_Bimbingan 
( 
	NIM, 
	NIDN, 
	Tanggal, 
	Materi, 
	Status
)
VALUES 
(
	'20204350011', 
	'0502026801',
	GETDATE(), 
	'Bimbingan Bab 1 - Pendahuluan', 
	'Menunggu'
);
GO

-- Langkah 2: Verifikasi data yang baru diinsert
SELECT * FROM Log_Bimbingan 
WHERE NIM = '20204350011';
GO



-- ======================================================================================
-- 2. Functional Testing - FUNC-02: Menguji Update Data pada tabel utama Pengajuan_Pendadaran
-- ======================================================================================

-- Langkah 1: Cek Data yang Mau Diupdate
SELECT TOP 5 ID_Pengajuan, NIM, Status, Nilai, Ruangan 
FROM Pengajuan_Pendadaran
ORDER BY ID_Pengajuan;
GO

-- Langkah 2: Update status pengajuan dari 'Menunggu' menjadi 'Disetujui'
UPDATE Pengajuan_Pendadaran
SET Status = 'Disetujui', Ruangan = 'Ruang Sidang C'
WHERE ID_Pengajuan = 5;
GO

-- Langkah 3: Verifikasi data setelah update
SELECT ID_Pengajuan, NIM, Status, Ruangan 
FROM Pengajuan_Pendadaran
WHERE ID_Pengajuan = 5;
GO



-- ======================================================================================
-- 3. Functional Testing - FUNC-03: Menguji Stored Procedure
-- ======================================================================================

-- Langkah 1: Cek NIM yang belum dipakai
SELECT TOP 5 NIM FROM Mahasiswa ORDER BY NIM DESC;
GO

-- Langkah 2: Membuat Stored Procedure
CREATE PROCEDURE sp_TambahMahasiswa
    @NIM CHAR(11),
    @Nama VARCHAR(50),
    @Angkatan CHAR(4),
    @Jurusan VARCHAR(20),
    @Email VARCHAR(40),
    @NIDN_Pembimbing CHAR(10)
AS
BEGIN
    INSERT INTO Mahasiswa (NIM, Nama, Angkatan, Jurusan, Email, NIDN_Pembimbing)
    VALUES (@NIM, @Nama, @Angkatan, @Jurusan, @Email, @NIDN_Pembimbing);
END
GO

-- Langkah 3: Eksekusi Stored Procedure untuk menambah mahasiswa baru
EXEC sp_TambahMahasiswa 
    @NIM = '20224350011',
    @Nama = 'Rassya Test Mahasiswa',
    @Angkatan = '2022',
    @Jurusan = 'Teknik Informatika',
    @Email = 'rassya.test@kampus.ac.id',
    @NIDN_Pembimbing = '0502026801';
GO

-- Langkah 4: Verifikasi data berhasil masuk lewat SP
SELECT * FROM Mahasiswa WHERE NIM = '20224350011';
GO



-- ======================================================================================
-- 4. Functional Testing - FUNC-04: Menguji Trigger
-- ======================================================================================

-- Langkah 1: Cek data Pengajuan_Pendadaran yang bisa dipakai (pilih yang NIM-nya juga ada di Monitoring_TA)
SELECT p.ID_Pengajuan, p.NIM, p.Status AS Status_Pengajuan, m.ID_TA, m.Status_TA
FROM Pengajuan_Pendadaran p
JOIN Monitoring_TA m ON p.NIM = m.Nim
ORDER BY p.ID_Pengajuan;
GO

-- Langkah 2: Membuat Trigger
CREATE TRIGGER trg_UpdateStatusTA
ON Pengajuan_Pendadaran
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Status)
    BEGIN
        UPDATE m
        SET m.Status_TA = 'Lulus'
        FROM Monitoring_TA m
        INNER JOIN inserted i ON m.Nim = i.NIM
        WHERE i.Status = 'Selesai';
    END
END
GO

-- Langkah 3: Cek kondisi awal sebelum trigger dipicu
SELECT p.ID_Pengajuan, p.NIM, p.Status AS Status_Pengajuan, m.Status_TA
FROM Pengajuan_Pendadaran p
JOIN Monitoring_TA m ON p.NIM = m.Nim
WHERE p.ID_Pengajuan = 9;
GO

-- Langkah 4: Update status pengajuan menjadi 'Selesai' (ini akan memicu trigger)
UPDATE Pengajuan_Pendadaran
SET Status = 'Selesai'
WHERE ID_Pengajuan = 9;
GO

-- Langkah 5: Verifikasi apakah Status_TA otomatis berubah jadi 'Lulus' oleh trigger
SELECT p.ID_Pengajuan, p.NIM, p.Status AS Status_Pengajuan, m.Status_TA
FROM Pengajuan_Pendadaran p
JOIN Monitoring_TA m ON p.NIM = m.Nim
WHERE p.ID_Pengajuan = 9;
GO



-- ======================================================================================
-- 5. Functional Testing - FUNC-05: Menguji View
-- ======================================================================================

-- Langkah 1: Membuat View
CREATE VIEW vw_MahasiswaPembimbing AS
SELECT 
    mhs.NIM,
    mhs.Nama AS Nama_Mahasiswa,
    mhs.Angkatan,
    mhs.Jurusan,
    dsn.NIDN,
    dsn.Nama AS Nama_Pembimbing,
    dsn.Prodi AS Prodi_Dosen
FROM Mahasiswa mhs
JOIN Dosen dsn ON mhs.NIDN_Pembimbing = dsn.NIDN;
GO

-- Langkah 2: Memanggil View (menggantikan query JOIN manual yang panjang)
SELECT * FROM vw_MahasiswaPembimbing;
GO

-- Langkah 3: Verifikasi View bisa difilter seperti tabel biasa
SELECT * FROM vw_MahasiswaPembimbing WHERE NIM = '20204350011';
GO



-- ======================================================================================
-- 6. Integrity Testing	- INT-PK-01: Menguji duplikasi Primary Key
-- ======================================================================================

-- Langkah 1: Cek Data yang Sudah Ada
SELECT TOP 5 NIP, Nama FROM Staff_TU ORDER BY NIP;
GO

-- Langkah 2: Cek data asli dengan NIP tersebut (sebagai bukti data memang sudah ada)
SELECT * FROM Staff_TU WHERE NIP = '199001012020011001';
GO

-- Langkah 3: Coba insert data BARU dengan NIP yang SAMA (duplikat Primary Key)
INSERT INTO Staff_TU (NIP, Nama, Jabatan, Email, No_HP)
VALUES ('199001012020011001', 'Staff Duplikat Test', 'Admin TU', 'duplikat.test@kampus.ac.id', '081234567890');
GO



-- ======================================================================================
-- 7. Integrity Testing	- INT-FK-01: Menguji aturan Foreign Key (Referential)
-- ======================================================================================

-- Langkah 1: Cek Dulu Aturan FK-nya (NO ACTION atau CASCADE?)
SELECT 
    fk.name AS FK_Name,
    tp.name AS Tabel_Anak,
    tr.name AS Tabel_Induk,
    fk.delete_referential_action_desc AS Aturan_Delete,
    fk.update_referential_action_desc AS Aturan_Update
FROM sys.foreign_keys fk
JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
WHERE fk.name = 'FK_Pengajuan_Mahasiswa';
GO

-- SKENARIO 1: Insert data anak dengan FK tidak valid
-- Langkah 2: Coba insert Pengajuan_Pendadaran dengan NIM yang TIDAK ADA di Mahasiswa
INSERT INTO Pengajuan_Pendadaran 
    (NIM, NIP_Staff, NIDN_Penguji1, NIDN_Penguji2, IPK, SKS_Lulus, Tanggal_Pengajuan, Status)
VALUES 
    ('99999999999', '199001012020011001', '0502026801', '0513039203', 3.50, 144, GETDATE(), 'Menunggu');
GO

-- SKENARIO 2: Hapus data induk yang masih dipakai anak
-- Langkah 3: Cek dulu bahwa NIM ini memang dipakai di Pengajuan_Pendadaran
SELECT * FROM Pengajuan_Pendadaran WHERE NIM = '20214350005';
GO

-- Langkah 4: Coba hapus data mahasiswa yang NIM-nya masih dipakai di tabel anak
DELETE FROM Mahasiswa WHERE NIM = '20214350005';
GO



-- ======================================================================================
-- 8. Integrity Testing	- INT-CHK-01: Menguji aturan Check Constraint / Default
-- ======================================================================================

-- Langkah 1: Insert data Log_Bimbingan TANPA mengisi Tanggal & Status (menguji apakah DEFAULT constraint jalan otomatis)
INSERT INTO Log_Bimbingan (NIM, NIDN, Materi)
VALUES ('20204350011', '0502026801', 'Bimbingan default test');
GO

-- Langkah 2: Verifikasi nilai default yang otomatis terisi
SELECT TOP 1 ID_Log, NIM, NIDN, Tanggal, Materi, Status
FROM Log_Bimbingan
WHERE Materi = 'Bimbingan default test'
ORDER BY ID_Log DESC;
GO

-- Langkah 3: Coba insert dengan Status yang MELANGGAR CHECK constraint (Status harus salah satu dari: Menunggu/Revisi/Disetujui/Ditolak)
INSERT INTO Log_Bimbingan (NIM, NIDN, Materi, Status)
VALUES ('20204350011', '0502026801', 'Bimbingan status invalid test', 'Selesai');
GO



-- ======================================================================================
-- 9. Transaction Testing - TRNS-01: Menguji COMMIT pada Transaksi Multi-Tabel
-- ======================================================================================

-- Langkah 1: Mulai Transaksi
BEGIN TRANSACTION;

-- Langkah 2: Eksekusi Update (Tabel_A: Pengajuan_Pendadaran)
UPDATE Pengajuan_Pendadaran
SET Status = 'Selesai', Nilai = 'A'
WHERE ID_Pengajuan = 9;

-- Langkah 3: Cek Efek Trigger (Tabel_B: Monitoring_TA) - masih di dalam transaksi
SELECT Status_TA 
FROM Monitoring_TA 
WHERE Nim = (SELECT NIM FROM Pengajuan_Pendadaran WHERE ID_Pengajuan = 9);

-- Langkah 4: Commit Transaksi
COMMIT TRANSACTION;
GO

-- Langkah 5: Verifikasi Akhir (setelah commit, harus permanen)
SELECT Status, Nilai FROM Pengajuan_Pendadaran WHERE ID_Pengajuan = 9;
SELECT Status_TA FROM Monitoring_TA 
WHERE Nim = (SELECT NIM FROM Pengajuan_Pendadaran WHERE ID_Pengajuan = 9);
GO



-- ======================================================================================
-- 10. Transaction Testing - TRNS-02: Menguji ROLLBACK pada Transaksi Multi-Tabel
-- ======================================================================================

-- Langkah 1: Mulai Transaksi
BEGIN TRANSACTION;

-- Langkah 2: Eksekusi sukses (Tabel_A: Monitoring_TA)
INSERT INTO Monitoring_TA (Nim, NIDN_Pembimbing, Judul_TA, Status_TA)
VALUES ('20224350011', '0502026801', 'Rollback Test TA', 'Pengajuan Judul');

-- Cek dulu datanya udah masuk (sementara, dalam transaksi)
SELECT * FROM Monitoring_TA WHERE Judul_TA = 'Rollback Test TA';

-- Langkah 3: Eksekusi gagal (Tabel_B: Pengajuan_Pendadaran, NIM sengaja tidak valid -> FK_Invalid)
INSERT INTO Pengajuan_Pendadaran (NIM, NIP_Staff, NIDN_Penguji1, NIDN_Penguji2, IPK, SKS_Lulus, Tanggal_Pengajuan, Status)
VALUES ('99999999999', '199001012020011001', '0502026801', '0513039203', 3.50, 140, GETDATE(), 'Menunggu');

-- Langkah 4: Rollback Transaksi
ROLLBACK TRANSACTION;
GO

-- Langkah 5: Verifikasi - data Langkah 2 harus TIDAK ADA lagi
SELECT * FROM Monitoring_TA WHERE Judul_TA = 'Rollback Test TA';
GO



-- ======================================================================================
-- 11.12. Performance Testing - PERF-01 & PERF-02: Query JOIN dengan/tanpa Index
-- ======================================================================================

-- Langkah 1: SKENARIO A - Tanpa Index Khusus
-- (Sebelum run: tekan Ctrl+M di SSMS untuk aktifkan "Include Actual Execution Plan")
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT P.ID_Pengajuan, P.NIM, M.Nama, M.Jurusan, P.Status, P.Tanggal_Pengajuan
FROM Pengajuan_Pendadaran P
JOIN Mahasiswa M ON P.NIM = M.NIM
WHERE P.Status = 'Menunggu';
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

-- Langkah 2: Tambahkan Index pada kolom yang jadi filter (Status)
CREATE INDEX IX_Pengajuan_Status ON Pengajuan_Pendadaran(Status);
GO

-- Langkah 3: SKENARIO B - Dengan Index
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT P.ID_Pengajuan, P.NIM, M.Nama, M.Jurusan, P.Status, P.Tanggal_Pengajuan
FROM Pengajuan_Pendadaran P
JOIN Mahasiswa M ON P.NIM = M.NIM
WHERE P.Status = 'Menunggu';
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO



-- ==========================================================
-- 12. Security Testing - SEC-01: Simulasi SQL Injection
-- ==========================================================

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