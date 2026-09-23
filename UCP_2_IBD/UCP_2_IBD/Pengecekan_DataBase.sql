SELECT 
    TABLE_NAME, 
    COLUMN_NAME, 
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

SELECT ID_Pengajuan, NIM, IPK 
FROM dbo.Pengajuan_Pendadaran;

ALTER TABLE dbo.Pengajuan_Pendadaran
ALTER COLUMN IPK DECIMAL(3,2);

SELECT * 
FROM dbo.Pengajuan_Pendadaran;

SELECT 
    p.ID_Pengajuan,
    p.NIM,
    m.Nama AS NamaMahasiswa,
    p.Tanggal_Ujian,
    p.Ruangan,
    p.Status,
    p.NIDN_Penguji1
FROM dbo.Pengajuan_Pendadaran AS p
LEFT JOIN dbo.Mahasiswa AS m ON p.NIM = m.NIM;

-- ========================================
-- QUERY CEK KOLOM NOT NULL PADA TABEL
-- ========================================
SELECT 
    COLUMN_NAME AS Nama_Kolom,
    DATA_TYPE AS Tipe_Data,
    IS_NULLABLE AS Boleh_Kosong
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'Pengajuan_Pendadaran';
GO


-- 1. Query untuk melihat definisi aturan (Constraint) yang membatasi NIP_Staff
SELECT 
    OBJECT_NAME(parent_object_id) AS Nama_Tabel,
    name AS Nama_Constraint,
    definition AS Aturan_Validasi
FROM sys.check_constraints
WHERE name = 'CK_Pengajuan_NIP_Staff_Angka';
GO

SELECT * FROM dbo.Staff_TU; -- atau sesuaikan dengan nama tabel staff Anda