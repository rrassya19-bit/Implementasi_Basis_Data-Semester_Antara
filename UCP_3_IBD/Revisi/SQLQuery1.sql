USE Monitoring_TA;
GO

-- 1. Daftar semua tabel
SELECT TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- 2. Struktur kolom semua tabel (nama tabel, kolom, tipe data, nullable, default)
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO

-- 3. Primary Key tiap tabel
SELECT 
    tc.TABLE_NAME,
    kcu.COLUMN_NAME,
    tc.CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY tc.TABLE_NAME;
GO

-- 4. Foreign Key (relasi antar tabel) — penting untuk Integrity Testing
SELECT 
    fk.name AS FK_Name,
    tp.name AS Tabel_Anak,
    cp.name AS Kolom_FK,
    tr.name AS Tabel_Induk,
    cr.name AS Kolom_Referensi
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN sys.tables tp ON fkc.parent_object_id = tp.object_id
JOIN sys.tables tr ON fkc.referenced_object_id = tr.object_id
JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id;
GO

-- 5. Check Constraint (misal aturan seperti Harga > 0, atau status tertentu)
SELECT 
    t.name AS Table_Name,
    cc.name AS Constraint_Name,
    cc.definition
FROM sys.check_constraints cc
JOIN sys.tables t ON cc.parent_object_id = t.object_id;
GO

-- 6. Jumlah baris data tiap tabel (untuk lihat mana yang sudah ada isinya)
SELECT 
    t.NAME AS TableName,
    p.rows AS RowCounts
FROM sys.tables t
JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
ORDER BY t.NAME;
GO


SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('Dosen', 'Mahasiswa', 'Staff_TU', 'Monitoring_TA', 'Log_Bimbingan', 'Pengajuan_Pendadaran')
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO



USE Monitoring_TA;
GO

SELECT TOP 3 NIM, Nama FROM Mahasiswa;
SELECT TOP 3 NIDN, Nama FROM Dosen;
SELECT MAX(ID_Log) AS ID_Log_Terakhir FROM Log_Bimbingan;


SELECT @@VERSION;