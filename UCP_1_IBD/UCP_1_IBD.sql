
-- ====================================================
-- DATABASE SISTEMPENGEJUAN TUGAS AKHIR (MONITORING_TA)
-- ====================================================

CREATE DATABASE Monitoring_TA
ON PRIMARY (
    -- File Utama (.mdf)
    NAME = 'MonitoringTA_Primary',
    FILENAME = 'C:\IBD_DataBase_SQL_Server\MONITORING_TA\MonitoringTA_Primary.mdf',
    SIZE = 50MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB
),
FILEGROUP FG_Monitoring_TA (
    -- File Sekunder (.ndf)
    NAME = 'MonitoringTA_Secondary',
    FILENAME = 'C:\IBD_DataBase_SQL_Server\MONITORING_TA\MonitoringTA_Secondary.ndf',
    SIZE = 50MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB
)
LOG ON (
    -- Log File (.ldf)
    NAME = 'MonitoringTA_Log',
    FILENAME = 'C:\IBD_DataBase_SQL_Server\MONITORING_TA\MonitoringTA_Log.ldf',
    SIZE = 50MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB
);
GO
/*
Fungsi Masing-masing File:
    •	.mdf (Primary Data File): File utama yang berisi data startup dan tabel sistem (metadata). Setiap database wajib memiliki satu file .mdf.
    •	.ndf (Secondary Data File): File tambahan untuk menyimpan data. Digunakan jika data sudah sangat besar sehingga perlu dipecah ke disk yang berbeda untuk meningkatkan performa I/O.
    •	.ldf (Transaction Log File): Menyimpan catatan semua transaksi yang terjadi di database. Ini krusial untuk proses recovery atau rollback data jika terjadi kegagalan sistem.
*/

USE Monitoring_TA;


-- Verifikasi Database Sudah Masuk di Daftar Server
SELECT name, database_id, create_date 
FROM sys.databases 
WHERE name = 'Monitoring_TA';
GO


-- Verifikasi Detail Lokasi File Utama (.mdf), Sekunder (.ndf), dan Log (.ldf)
SELECT 
    name AS LogicalName, 
    physical_name AS PhysicalLocation, 
    type_desc AS FileType, 
    size * 8 / 1024 AS SizeMB 
FROM sys.database_files;
GO



-- ====================================================
-- 1. Tabel Dosen
-- ====================================================
CREATE TABLE Dosen (
    NIDN   CHAR(10)    NOT NULL,
    Nama   VARCHAR(50) NOT NULL,
    Prodi  VARCHAR(30) NOT NULL,
    Email  VARCHAR(40) NOT NULL,
    No_HP  VARCHAR(15) NOT NULL,

    CONSTRAINT PK_Dosen PRIMARY KEY (NIDN),
    CONSTRAINT UQ_Dosen_Email UNIQUE (Email),
    CONSTRAINT UQ_Dosen_NoHP UNIQUE (No_HP),
    CONSTRAINT CK_Dosen_NoHP CHECK (No_HP NOT LIKE '%[^0-9]%')  -- Memastikan No_HP isinya HANYA ANGKA saja, selain itu akan ditolak database
);
GO
 

-- ====================================================
-- 2. Tabel Mahasiswa
-- ====================================================
CREATE TABLE Mahasiswa (
    NIM              CHAR(11)    NOT NULL,
    Nama             VARCHAR(50) NOT NULL,
    Angkatan         CHAR(4)     NOT NULL,
    Jurusan          VARCHAR(20) NOT NULL,
    Email            VARCHAR(40) NOT NULL,
    NIDN_Pembimbing  CHAR(10)    NOT NULL,                        -- FK ke Dosen Pembimbing

    CONSTRAINT PK_Mahasiswa PRIMARY KEY (NIM),
    CONSTRAINT UQ_Mahasiswa_Email UNIQUE (Email),
    CONSTRAINT CK_Mahasiswa_Email CHECK (Email LIKE '%@%.%'),     -- Memastikan format email valid dengan minimal harus mengandung karakter '@' dan titik '.' di bagian domain
    CONSTRAINT FK_Mahasiswa_Dosen FOREIGN KEY (NIDN_Pembimbing)
        REFERENCES Dosen (NIDN),
    CONSTRAINT CK_Mahasiswa_NIM CHECK (NIM NOT LIKE '%[^0-9]%'),  -- Memastikan NIM isinya HANYA ANGKA saja, 
    CONSTRAINT CK_Mahasiswa_Angkatan CHECK (Angkatan NOT LIKE '%[^0-9]%' AND Angkatan BETWEEN '2015' AND '2030') -- Memastikan isinya HANYA ANGKA dan berada di rentang tahun 2015 sampai 2030 saja
);
GO


-- ====================================================
-- 3. Tabel Staff_TU
-- ====================================================
CREATE TABLE Staff_TU (
    NIP      CHAR(18)    NOT NULL,
    Nama     VARCHAR(50) NOT NULL,
    Jabatan  VARCHAR(30) NOT NULL,
    Email    VARCHAR(40) NOT NULL,
    No_HP    VARCHAR(15) NOT NULL,
    CONSTRAINT PK_Staff_TU PRIMARY KEY (NIP),
    CONSTRAINT CK_Staff_NIP CHECK (NIP NOT LIKE '%[^0-9]%'),     -- Memastikan NIP HANYA ANGKA saja
    CONSTRAINT UQ_Staff_Email UNIQUE (Email),
    CONSTRAINT CK_Staff_Email CHECK (Email LIKE '%@%.%'),        -- Memastikan format email valid dengan minimal harus mengandung karakter '@' dan titik '.' di bagian domain
    CONSTRAINT UQ_Staff_NoHP UNIQUE (No_HP),
    CONSTRAINT CK_Staff_NoHP CHECK (No_HP NOT LIKE '%[^0-9]%'),  -- Memastikan No_HP HANYA ANGKA saja
);
GO
 

-- ====================================================
-- 4. Tabel Monitoring_TA
-- ====================================================
CREATE TABLE Monitoring_TA (
    ID_TA            INT IDENTITY(1,1) NOT NULL,
    Nim              CHAR(11)     NOT NULL,
    NIDN_Pembimbing  CHAR(10)     NOT NULL,
    Judul_TA         VARCHAR(255) NOT NULL,
    Status_TA        VARCHAR(25)  NOT NULL,
    
    CONSTRAINT PK_Monitoring_TA PRIMARY KEY (ID_TA),
    CONSTRAINT FK_Monitoring_Mahasiswa FOREIGN KEY (Nim) REFERENCES Mahasiswa(Nim),
    CONSTRAINT UQ_Monitoring_Nim UNIQUE (Nim), 
    CONSTRAINT CK_Monitoring_Nim_Angka CHECK (Nim NOT LIKE '%[^0-9]%'),                   -- Memastikan NIM isinya HANYA ANGKA saja
    CONSTRAINT FK_Monitoring_Dosen FOREIGN KEY (NIDN_Pembimbing) REFERENCES Dosen(NIDN),
    CONSTRAINT CK_Monitoring_NIDN_Angka CHECK (NIDN_Pembimbing NOT LIKE '%[^0-9]%'),      -- Memastikan NIDN HANYA ANGKA saja 
    CONSTRAINT UQ_Monitoring_Judul UNIQUE (Judul_TA),
    CONSTRAINT CK_Monitoring_Status CHECK (Status_TA IN ('Pengajuan Judul', 'Bimbingan Proposal', 'Sempro', 'Penelitian', 'Siap Sidang', 'Sidang', 'Revisi Sidang', 'Lulus'))
);
GO


-- ====================================================
-- 5. Tabel Log_Bimbingan
-- ====================================================
CREATE TABLE Log_Bimbingan (
    ID_Log   INT             NOT NULL IDENTITY(1,1),
    NIM      CHAR(11)        NOT NULL,                -- FK ke Mahasiswa
    NIDN     CHAR(10)        NOT NULL,                -- FK ke Dosen
    Tanggal  DATE            NOT NULL DEFAULT GETDATE(),
    Materi   VARCHAR(255)    NOT NULL,
    Status   VARCHAR(25)     NOT NULL DEFAULT 'Menunggu',

    CONSTRAINT PK_Log_Bimbingan PRIMARY KEY (ID_Log),
    CONSTRAINT FK_Log_Mahasiswa FOREIGN KEY (NIM) REFERENCES Mahasiswa(Nim),
    CONSTRAINT CK_Log_NIM_Angka CHECK (NIM NOT LIKE '%[^0-9]%'),              -- Memastikan NIM isinya HANYA ANGKA saja
    CONSTRAINT FK_Log_Dosen FOREIGN KEY (NIDN) REFERENCES Dosen(NIDN),
    CONSTRAINT CK_Log_NIDN_Angka CHECK (NIDN NOT LIKE '%[^0-9]%'),            -- Memastikan NIDN HANYA ANGKA saja
    CONSTRAINT CK_Log_Tanggal CHECK (Tanggal <= GETDATE()),                   -- Memastikan tanggal bimbingan tidak boleh di masa depan, karna ini Log_Bimbingan yang artinya adalah tempat menginput catatan setelah bimbingan itu selesai dilaksanakan
    CONSTRAINT CK_Log_Status CHECK (Status IN ('Menunggu', 'Revisi', 'Disetujui', 'Ditolak'))
);
GO
 

-- ====================================================
-- 6. Tabel Pengajuan_Pendadaran
-- ====================================================
CREATE TABLE Pengajuan_Pendadaran (
    ID_Pengajuan       INT             NOT NULL IDENTITY(1,1),
    NIM                CHAR(11)        NOT NULL,                -- FK ke Mahasiswa
    NIP_Staff          CHAR(18)        NOT NULL,                -- FK ke Staff_TU 
    NIDN_Penguji1      CHAR(10)        NOT NULL,                -- FK ke Dosen
    NIDN_Penguji2      CHAR(10)        NOT NULL,                -- FK ke Dosen
    IPK                DECIMAL(4,2)    NOT NULL,
    SKS_Lulus          INT             NOT NULL,
    Tanggal_Pengajuan  DATE            NOT NULL DEFAULT GETDATE(),
    Tanggal_Ujian      DATE            NULL,
    Ruangan            VARCHAR(30)     NULL,
    Status             VARCHAR(25)     NOT NULL DEFAULT 'Menunggu',
    Nilai              CHAR(2)         NULL,
    Catatan            VARCHAR(255)    NULL,

    CONSTRAINT PK_Pengajuan_Pendadaran PRIMARY KEY (ID_Pengajuan),
    CONSTRAINT FK_Pengajuan_Mahasiswa FOREIGN KEY (NIM) REFERENCES Mahasiswa(Nim),
    CONSTRAINT CK_Pengajuan_NIM_Angka CHECK (NIM NOT LIKE '%[^0-9]%'),                                         -- Memastikan NIM isinya HANYA ANGKA saja
    CONSTRAINT FK_Pengajuan_Staff FOREIGN KEY (NIP_Staff) REFERENCES Staff_TU(NIP),
    CONSTRAINT CK_Pengajuan_NIP_Staff_Angka CHECK (NIP_Staff NOT LIKE '%[^0-9]%'),                             -- Memastikan NIDN HANYA ANGKA saja
    CONSTRAINT FK_Pengajuan_DosenPenguji1 FOREIGN KEY (NIDN_Penguji1) REFERENCES Dosen(NIDN),
    CONSTRAINT CK_Pengajuan_NIDN_Penguji1_Angka CHECK (NIDN_Penguji1 NOT LIKE '%[^0-9]%'),
    CONSTRAINT CK_Penguji_Tidak_Boleh_Sama CHECK (NIDN_Penguji1 <> NIDN_Penguji2),                             -- Memastikan agar penguji tidak boleh orang yang sama
    CONSTRAINT FK_Pengajuan_DosenPenguji2 FOREIGN KEY (NIDN_Penguji2) REFERENCES Dosen(NIDN),
    CONSTRAINT CK_Pengajuan_NIDN_Penguji2_Angka CHECK (NIDN_Penguji2 NOT LIKE '%[^0-9]%'),                     -- Memastikan NIDN HANYA ANGKA saja
    CONSTRAINT CK_Pengajuan_IPK CHECK (IPK >= 2.00 AND IPK <= 4.00),                                           -- IPK dibatasi antara 0.00 sampai 4.00 untuk mencegah salah input nilai
    CONSTRAINT CK_Pengajuan_SKS CHECK (SKS_Lulus >= 130 AND SKS_Lulus <= 150),                                 -- SKS dibatasi minimal 130 SKS (syarat pendadaran) dan maksimal 150 
    CONSTRAINT CK_Tanggal_Pengajuan_Valid CHECK (Tanggal_Pengajuan <= GETDATE()),                              -- Constraint untuk mencegah Tanggal Pengajuan berada di masa depan (Tanggal pengajuan harus hari ini atau tanggal lampau saat berkas fisik diserahkan)
    CONSTRAINT CK_Pengajuan_TanggalUjian CHECK (Tanggal_Ujian IS NULL OR Tanggal_Ujian >= Tanggal_Pengajuan),  -- Memastikan Tanggal Ujian tidak mendahului Tanggal Pengajuan (Alur administrasi: Mahasiswa mengajukan berkas terlebih dahulu, baru kemudian dijadwalkan ujian)
    CONSTRAINT CK_Pengajuan_Status CHECK (Status IN ('Menunggu', 'Disetujui', 'Ditolak', 'Selesai')),
    CONSTRAINT CK_Pengajuan_Nilai CHECK (Nilai IS NULL OR Nilai IN ('A', 'AB', 'B', 'BC', 'C', 'D', 'E')),
);
GO
/*
1. Tanggal ujian, boleh sebelum atau sesudah pengajuan?
TIDAK BOLEH, karna di dunia nyata harus mengajukan/mendaftar berkas dulu ke prodi. Setelah berkas diverifikasi dan disetujui, baru kemudian prodi menjadwalkan kapan saya akan ujian

2. Tanggal pengajuan, boleh sebelum atau sesudah tanggal input data?
Bisa jadi, tergantung, karna Boleh Sebelum (Kondisi Keterlambatan Administrasi): Misalnya, mahasiswa menyerahkan berkas fisik pengajuan tanggal 10, tetapi karena admin sibuk atau internet error, datanya baru diinput ke komputer pada tanggal 12. Berarti Tanggal Pengajuannya (10) berada sebelum Tanggal Input Data (12)
dan Tidak Boleh Sesudah: Tidak mungkin mahasiswa mengajukan berkas pada tanggal 15, tetapi diinput ke komputer pada tanggal 12 
*/

-- Verifikasi Melihat Semua Tabel beserta Kolom dan Tipenya
SELECT 
    t.name AS Nama_Tabel,
    c.name AS Nama_Kolom,
    ty.name AS Tipe_Data,
    c.max_length AS Panjang_Maksimum,
    CASE WHEN c.is_nullable = 1 THEN 'Yes' ELSE 'No' END AS Boleh_Null
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
JOIN sys.types ty ON c.system_type_id = ty.system_type_id AND c.user_type_id = ty.user_type_id
ORDER BY t.name, c.column_id;




-- ====================================================
-- 1. Tambah Data Dosen
-- ====================================================
INSERT INTO Dosen (NIDN, Nama, Prodi, Email, No_HP) VALUES
('0502026801', 'Dr. Ir. Dwijoko Purbohadi, M.T.', 'Teknologi Informasi', 'dwijoko.p@mail.umy.ac.id', '081234567801'),
('0509087801', 'Prof. Ir. Slamet Riyadi, S.T., M.Sc., Ph.D.', 'Teknologi Informasi', 'slamet.riyadi@mail.umy.ac.id', '081234567802'),
('0518077402', 'Winny Setyonugroho, S.Ked., M.T., Ph.D.', 'Teknologi Informasi', 'winny.setyonugroho@mail.umy.ac.id', '081234567803'),
('0522046701', 'Ir. Eko Prasetyo, M.Eng., Ph.D.', 'Teknologi Informasi', 'eko.prasetyo@mail.umy.ac.id', '081234567804'),
('0527029004', 'Nurwahyu Alamsyah, S.Kom., M.Kom., M.I.M., Ph.D.', 'Teknologi Informasi', 'nurwahyu.a@mail.umy.ac.id', '081234567805'),
('0707108402', 'Chayadi Oktomy N.S., S.T., M.Eng., Ph.D.', 'Teknologi Informasi', 'chayadi.oktomy@mail.umy.ac.id', '081234567806'),
('0506098902', 'Titis Wisnu Wijaya, S.Pd., M.Pd.', 'Teknologi Informasi', 'titis.wisnu@mail.umy.ac.id', '081234567807'),
('0516058701', 'Asep Setiawan, S.Th.I., M.Ud.', 'Teknologi Informasi', 'asep.setiawan@mail.umy.ac.id', '081234567808'),
('0511019001', 'Haris Setyawan, S.T., M.T.', 'Teknologi Informasi', 'haris.setyawan@mail.umy.ac.id', '081234567809'),
('0512029102', 'Apriliya Kurnianti, S.T., M.Eng.', 'Teknologi Informasi', 'apriliya.kurnianti@mail.umy.ac.id', '081234567810'),
('0513039203', 'Ir. Asroni, S.T., M.Eng.', 'Teknologi Informasi', 'asroni@mail.umy.ac.id', '081234567811'),
('0514049304', 'Cahya Damarjati, S.T., M.Eng., Ph.D.', 'Teknologi Informasi', 'cahya.damarjati@mail.umy.ac.id', '081234567812'),
('0515059405', 'Etik Irijanti, S.T., M.Sc.', 'Teknologi Informasi', 'etik.irijanti@mail.umy.ac.id', '081234567813'),
('0516069506', 'Laila Ma’rifatul Azizah, S.Kom., M.I.M.', 'Teknologi Informasi', 'laila.marifatul@mail.umy.ac.id', '081234567814'),
('0517079607', 'Dr. Reza Giga Isnanda, S.T., M.Sc.', 'Teknologi Informasi', 'reza.giga@mail.umy.ac.id', '081234567815'),
('0519089708', 'Muhammad Abdul Haq, S.Tr.T., M.Eng.', 'Teknologi Informasi', 'muhammad.haq@mail.umy.ac.id', '081234567816'),
('0520099809', 'Tri Andi, S.T., M.Kom.', 'Teknologi Informasi', 'tri.andi@mail.umy.ac.id', '081234567817'),
('0521109910', 'Dr. Nasy’an Taufiq Al Ghifari, S.T., M.T.', 'Teknologi Informasi', 'nasyan.taufiq@mail.umy.ac.id', '081234567818'),
('0522110011', 'Dosen Cadangan 1, M.Kom.', 'Teknologi Informasi', 'dosen.cad1@mail.umy.ac.id', '081234567819'),
('0523120122', 'Dosen Cadangan 2, M.T.', 'Teknologi Informasi', 'dosen.cad2@mail.umy.ac.id', '081234567820');
GO


-- ====================================================
-- 2. Tambah Data Mahasiswa
-- ====================================================
INSERT INTO Mahasiswa (NIM, Nama, Angkatan, Jurusan, Email, NIDN_Pembimbing) VALUES
('20214350001', 'Reza Pahlevi', '2021', 'Teknologi Informasi', 'reza.p@mail.umy.ac.id', '0502026801'),
('20214350002', 'Anisa Puspita', '2021', 'Teknologi Informasi', 'anisa.p@mail.umy.ac.id', '0509087801'),
('20214350003', 'Bayu Segara', '2021', 'Teknologi Informasi', 'bayu.s@mail.umy.ac.id', '0518077402'),
('20214350004', 'Dinda Kirana', '2021', 'Teknologi Informasi', 'dinda.k@mail.umy.ac.id', '0522046701'),
('20214350005', 'Fikri Haikal', '2021', 'Teknologi Informasi', 'fikri.h@mail.umy.ac.id', '0527029004'),
('20224350006', 'Gita Gutawa', '2022', 'Teknologi Informasi', 'gita.g@mail.umy.ac.id', '0707108402'),
('20224350007', 'Iqbaal Ramadhan', '2022', 'Teknologi Informasi', 'iqbaal.r@mail.umy.ac.id', '0506098902'),
('20224350008', 'Jefri Nichol', '2022', 'Teknologi Informasi', 'jefri.n@mail.umy.ac.id', '0516058701'),
('20224350009', 'Kezia Karamoy', '2022', 'Teknologi Informasi', 'kezia.k@mail.umy.ac.id', '0511019001'),
('20224350010', 'Lukman Sardi', '2022', 'Teknologi Informasi', 'lukman.s@mail.umy.ac.id', '0512029102'),
('20204350011', 'Maudy Ayunda', '2020', 'Teknologi Informasi', 'maudy.a@mail.umy.ac.id', '0513039203'),
('20204350012', 'Nicholas Saputra', '2020', 'Teknologi Informasi', 'nicholas.s@mail.umy.ac.id', '0514049304'),
('20204350013', 'Pevita Pearce', '2020', 'Teknologi Informasi', 'pevita.p@mail.umy.ac.id', '0515059405'),
('20204350014', 'Qory Sandioriva', '2020', 'Teknologi Informasi', 'qory.s@mail.umy.ac.id', '0516069506'),
('20204350015', 'Rangga Azof', '2020', 'Teknologi Informasi', 'rangga.a@mail.umy.ac.id', '0517079607'),
('20214350016', 'Shandy Aulia', '2021', 'Teknologi Informasi', 'shandy.a@mail.umy.ac.id', '0519089708'),
('20214350017', 'Tanta Ginting', '2021', 'Teknologi Informasi', 'tanta.g@mail.umy.ac.id', '0520099809'),
('20214350018', 'Utary Panjaitan', '2021', 'Teknologi Informasi', 'utary.p@mail.umy.ac.id', '0521109910'),
('20214350019', 'Vino G. Bastian', '2021', 'Teknologi Informasi', 'vino.b@mail.umy.ac.id', '0522110011'),
('20214350020', 'Yayan Ruhian', '2021', 'Teknologi Informasi', 'yayan.r@mail.umy.ac.id', '0523120122');
GO


-- ====================================================
-- 3. Tambah Data Staff_TU
-- ====================================================
INSERT INTO Staff_TU (NIP, Nama, Jabatan, Email, No_HP) VALUES
('199001012020011001', 'Septivari Dina Putri Nurliva, S.E.', 'Staff Administratif', 'septivari.nurliva@mail.umy.ac.id', '081333444501'),
('199102022020012002', 'Berliana Sofia Haya, S.Ak.', 'Staff Administratif', 'berliana.haya@mail.umy.ac.id', '081333444502'),
('199203032021011003', 'Faries Anantama N.F., S.Ak.', 'Staff Keuangan', 'faries.anantama@mail.umy.ac.id', '081333444503'),
('199304042021011004', 'Andhy Kurniawan L.P., S.T.', 'Staff Laboran', 'andhy.kurniawan@mail.umy.ac.id', '081333444504'),
('199405052022011005', 'Haris Firandita Saputra, S.I.Kom.', 'Staff Laboran', 'haris.firandita@mail.umy.ac.id', '081333444505'),
('199506062022012006', 'Staff Cadangan 1, S.Kom.', 'Staff Administratif', 'staff.cad1@mail.umy.ac.id', '081333444506'),
('199607072023011007', 'Staff Cadangan 2, S.E.', 'Staff Keuangan', 'staff.cad2@mail.umy.ac.id', '081333444507'),
('199708082023012008', 'Staff Cadangan 3, S.T.', 'Staff Laboran', 'staff.cad3@mail.umy.ac.id', '081333444508'),
('199809092024011009', 'Staff Cadangan 4, M.Kom.', 'Staff Administratif', 'staff.cad4@mail.umy.ac.id', '081333444509'),
('199910102024012010', 'Staff Cadangan 5, S.Ak.', 'Staff Keuangan', 'staff.cad5@mail.umy.ac.id', '081333444510'),
('200011112025011011', 'Staff Cadangan 6, S.I.Kom.', 'Staff Laboran', 'staff.cad6@mail.umy.ac.id', '081333444511'),
('200112122025012012', 'Staff Cadangan 7, S.M.', 'Staff Administratif', 'staff.cad7@mail.umy.ac.id', '081333444512'),
('200201132026011013', 'Staff Cadangan 8, S.Sos.', 'Staff Keuangan', 'staff.cad8@mail.umy.ac.id', '081333444513'),
('200302142026012014', 'Staff Cadangan 9, A.Md.', 'Staff Laboran', 'staff.cad9@mail.umy.ac.id', '081333444514'),
('200403152026011015', 'Staff Cadangan 10, S.Kom.', 'Staff Administratif', 'staff.cad10@mail.umy.ac.id', '081333444515'),
('200504162026012016', 'Staff Cadangan 11, S.E.', 'Staff Keuangan', 'staff.cad11@mail.umy.ac.id', '081333444516'),
('200605172026011017', 'Staff Cadangan 12, S.T.', 'Staff Laboran', 'staff.cad12@mail.umy.ac.id', '081333444517'),
('200706182026012018', 'Staff Cadangan 13, S.Ak.', 'Staff Administratif', 'staff.cad13@mail.umy.ac.id', '081333444518'),
('200807192026011019', 'Staff Cadangan 14, S.I.Kom.', 'Staff Keuangan', 'staff.cad14@mail.umy.ac.id', '081333444519'),
('200908202026012020', 'Staff Cadangan 15, S.T.', 'Staff Laboran', 'staff.cad15@mail.umy.ac.id', '081333444520');
GO


-- ====================================================
-- 4. Tambah Data Monitoring_TA 
-- ====================================================
INSERT INTO Monitoring_TA (NIM, NIDN_Pembimbing, Judul_TA, Status_TA) VALUES
('20214350001', '0502026801', 'Implementasi Machine Learning untuk Prediksi Harga Rumah', 'Penelitian'),
('20214350002', '0509087801', 'Rancang Bangun E-Commerce Berbasis Microservices', 'Bimbingan Proposal'),
('20214350003', '0518077402', 'Sistem Pakar Diagnosa Penyakit Tanaman Kopi', 'Sempro'),
('20214350004', '0522046701', 'Analisis Sentimen Opini Publik pada Twitter', 'Siap Sidang'),
('20214350005', '0527029004', 'Penerapan Metode Agile pada Pengembangan SIMAK', 'Pengajuan Judul'),
('20224350006', '0707108402', 'Aplikasi Presensi Karyawan Menggunakan Face Recognition', 'Penelitian'),
('20224350007', '0506098902', 'Deteksi Hoaks Berita Menggunakan Deep Learning', 'Bimbingan Proposal'),
('20224350008', '0516058701', 'Sistem Inventory Barang Gudang Berbasis IoT', 'Sempro'),
('20224350009', '0511019001', 'Optimalisasi Rute Distribusi Menggunakan Algoritma Genetika', 'Siap Sidang'),
('20224350010', '0512029102', 'Chatbot Pelayanan Akademik Menggunakan NLP', 'Sidang'),
('20204350011', '0513039203', 'Keamanan Jaringan Komputer Menggunakan Metode Port Knocking', 'Lulus'),
('20204350012', '0514049304', 'Sistem Pendukung Keputusan Pemilihan Beasiswa Mahasiswa', 'Lulus'),
('20204350013', '0515059405', 'Rancang Bangun Game Edukasi Sejarah Nusantara', 'Revisi Sidang'),
('20204350014', '0516069506', 'Visualisasi Data Persebaran Kasus DBD Berbasis Web GIS', 'Penelitian'),
('20204350015', '0517079607', 'Aplikasi Monitoring Suhu Ruangan Server Berbasis Arduino', 'Siap Sidang'),
('20214350016', '0519089708', 'Analisis Kinerja Server Menggunakan Load Balancing', 'Bimbingan Proposal'),
('20214350017', '0520099809', 'Sistem E-Voting Berbasis Blockchain', 'Sempro'),
('20214350018', '0521109910', 'Pencarian Rute Terpendek Menggunakan Algoritma Dijkstra', 'Penelitian'),
('20214350019', '0522110011', 'Sistem Manajemen Keuangan UMKM Berbasis Android', 'Pengajuan Judul'),
('20214350020', '0523120122', 'Deteksi Kerusakan Jalan Menggunakan Computer Vision', 'Sidang');
GO


-- ====================================================
-- 5. Tambah Data Log_Bimbingan
-- ====================================================
INSERT INTO Log_Bimbingan (NIM, NIDN, Tanggal, Materi, Status) VALUES
('20214350001', '0502026801', '2026-05-01', 'Diskusi Bab 1 Pendahuluan', 'Disetujui'),
('20214350002', '0509087801', '2026-05-02', 'Revisi rumusan masalah proposal', 'Revisi'),
('20214350003', '0518077402', '2026-05-03', 'Pengumpulan data training sistem', 'Disetujui'),
('20214350004', '0522046701', '2026-05-04', 'Evaluasi hasil pengujian akurasi', 'Disetujui'),
('20214350005', '0527029004', '2026-05-05', 'Konsultasi judul awal TA', 'Menunggu'),
('20224350006', '0707108402', '2026-05-06', 'Perancangan Diagram UML', 'Disetujui'),
('20224350007', '0506098902', '2026-05-07', 'Penyusunan latar belakang masalah', 'Revisi'),
('20224350008', '0516058701', '2026-05-08', 'Desain skema database relasional', 'Disetujui'),
('20224350009', '0511019001', '2026-05-09', 'Pengujian fungsionalitas aplikasi', 'Disetujui'),
('20224350010', '0512029102', '2026-05-10', 'Simulasi presentasi sidang', 'Disetujui'),
('20204350011', '0513039203', '2026-04-10', 'Finalisasi laporan akhir TA', 'Disetujui'),
('20204350012', '0514049304', '2026-04-12', 'Pengecekan lembar pengesahan', 'Disetujui'),
('20204350013', '0515059405', '2026-05-11', 'Revisi bab pembahasan pasca sidang', 'Revisi'),
('20204350014', '0516069506', '2026-05-12', 'Validasi kuesioner penelitian', 'Disetujui'),
('20204350015', '0517079607', '2026-05-13', 'Pengecekan koding program mikrokontroler', 'Disetujui'),
('20214350016', '0519089708', '2026-05-14', 'Konsultasi arsitektur jaringan', 'Menunggu'),
('20214350017', '0520099809', '2026-05-15', 'Studi literatur teknologi blockchain', 'Disetujui'),
('20214350018', '0521109910', '2026-05-16', 'Penerapan logika graf grafik', 'Disetujui'),
('20214350019', '0522110011', '2026-05-17', 'Pembuatan mockup UI/UX aplikasi', 'Menunggu'),
('20214350020', '0523120122', '2026-05-18', 'Persiapan demo alat uji coba', 'Disetujui');
GO


-- ====================================================
-- 6. Tambah Data Pengajuan_Pendadaran
-- ====================================================
INSERT INTO Pengajuan_Pendadaran (NIM, NIP_Staff, NIDN_Penguji1, NIDN_Penguji2, IPK, SKS_Lulus, Tanggal_Pengajuan, Tanggal_Ujian, Ruangan, Status, Nilai, Catatan) VALUES
('20214350001', '199001012020011001', '0509087801', '0518077402', 3.55, 144, '2026-05-01', '2026-05-10', 'Lab TI 1', 'Selesai', 'A', 'Lulus dengan pujian'),
('20214350002', '199102022020012002', '0502026801', '0522046701', 3.40, 138, '2026-05-02', '2026-05-12', 'Lab Jaringan', 'Selesai', 'AB', 'Perbaiki daftar pustaka'),
('20214350003', '199203032021011003', '0527029004', '0707108402', 3.25, 135, '2026-05-03', '2026-05-13', 'Ruang Sidang A', 'Disetujui', NULL, 'Jadwal telah ditetapkan'),
('20214350004', '199304042021011004', '0506098902', '0516058701', 3.70, 146, '2026-05-04', '2026-05-14', 'Ruang Sidang B', 'Selesai', 'A', 'Sangat baik'),
('20214350005', '199405052022011005', '0511019001', '0512029102', 2.95, 132, '2026-05-05', NULL, NULL, 'Menunggu', NULL, 'Berkas sedang diverifikasi'),
('20224350006', '199506062022012006', '0513039203', '0514049304', 3.60, 142, '2026-05-06', '2026-05-16', 'Lab TI 2', 'Disetujui', NULL, 'Siap ujian'),
('20224350007', '199607072023011007', '0515059405', '0516069506', 3.10, 134, '2026-05-07', NULL, NULL, 'Menunggu', NULL, 'Menunggu kuota penguji'),
('20224350008', '199708082023012008', '0517079607', '0519089708', 3.85, 148, '2026-05-08', '2026-05-18', 'Ruang Sidang A', 'Selesai', 'A', 'Memuaskan'),
('20224350009', '199809092024011009', '0520099809', '0521109910', 3.30, 136, '2026-05-09', '2026-05-19', 'Lab Komputer 3', 'Disetujui', NULL, 'Harap hadir tepat waktu'),
('20224350010', '199910102024012010', '0522110011', '0523120122', 3.50, 140, '2026-05-10', '2026-05-20', 'Ruang Sidang C', 'Selesai', 'B', 'Revisi kecil pada demo program'),
('20204350011', '200011112025011011', '0502026801', '0527029004', 3.75, 150, '2026-04-01', '2026-04-08', 'Ruang Sidang A', 'Selesai', 'A', 'Lulus predikat cumlaude'),
('20204350012', '200112122025012012', '0509087801', '0707108402', 3.45, 144, '2026-04-02', '2026-04-09', 'Lab TI 1', 'Selesai', 'AB', 'Lulus'),
('20204350013', '200201132026011013', '0518077402', '0506098902', 3.15, 133, '2026-05-11', '2026-05-21', 'Ruang Sidang B', 'Disetujui', NULL, 'Jadwal ujian keluar'),
('20204350014', '200302142026012014', '0522046701', '0516058701', 3.20, 135, '2026-05-12', NULL, NULL, 'Menunggu', NULL, 'Melengkapi transkrip nilai'),
('20204350015', '200403152026011015', '0511019001', '0514049304', 3.90, 149, '2026-05-13', '2026-05-23', 'Lab Jaringan', 'Disetujui', NULL, 'Siap diuji'),
('20214350016', '200504162026012016', '0512029102', '0515059405', 2.85, 131, '2026-05-14', NULL, NULL, 'Ditolak', NULL, 'IPK atau syarat SKS kurang maksimal'),
('20214350017', '200605172026011017', '0516069506', '0520099809', 3.55, 141, '2026-05-15', '2026-05-25', 'Ruang Sidang C', 'Disetujui', NULL, 'Jadwal terkonfirmasi'),
('20214350018', '200706182026012018', '0517079607', '0521109910', 3.35, 139, '2026-05-16', NULL, NULL, 'Menunggu', NULL, 'Menunggu validasi pembimbing'),
('20214350019', '200807192026011019', '0519089708', '0522110011', 3.05, 130, '2026-05-17', NULL, NULL, 'Menunggu', NULL, 'Pengajuan baru masuk'),
('20214350020', '200908202026012020', '0523120122', '0509087801', 3.65, 145, '2026-05-18', '2026-05-28', 'Lab TI 2', 'Disetujui', NULL, 'Sidang akhir bulan');
GO


-- Verifikasi menghitung dan melihat jumlah total baris (row count) data yang ada di setiap tabel secara bersamaan
SELECT 'Dosen' AS Nama_Tabel, COUNT(*) AS Jumlah_Data FROM Dosen
UNION ALL
SELECT 'Mahasiswa', COUNT(*) FROM Mahasiswa
UNION ALL
SELECT 'Staff_TU', COUNT(*) FROM Staff_TU
UNION ALL
SELECT 'Monitoring_TA', COUNT(*) FROM Monitoring_TA
UNION ALL
SELECT 'Log_Bimbingan', COUNT(*) FROM Log_Bimbingan
UNION ALL
SELECT 'Pengajuan_Pendadaran', COUNT(*) FROM Pengajuan_Pendadaran;
GO


-- Verifikasi menampilkan seluruh isi data (seluruh baris dan kolom) dari setiap tabel secara berurutan
SELECT * FROM Dosen;
SELECT * FROM Mahasiswa;
SELECT * FROM Staff_TU;
SELECT * FROM Monitoring_TA;
SELECT * FROM Log_Bimbingan;
SELECT * FROM Pengajuan_Pendadaran;
GO




-- ====================================================
-- SOAL 1 - (SELECT, WHERE, ORDER BY)
-- ====================================================

-- Menampilkan Daftar Mahasiswa Berdasarkan Angkatan 2021 dan Mengurutkan Nama Secara Alfabetis dari A ke Z
SELECT NIM, Nama, Angkatan, Jurusan, Email 
FROM Mahasiswa 
WHERE Angkatan = '2021' 
ORDER BY Nama ASC;
GO


-- Menampilkan Data Pengajuan Pendadaran yang Sudah Selesai Diurutkan Berdasarkan IPK Paling Tinggi ke yang Paling Rendah
SELECT NIM, IPK, SKS_Lulus, Tanggal_Ujian, Nilai, Catatan 
FROM Pengajuan_Pendadaran 
WHERE Status = 'Selesai' 
ORDER BY IPK DESC;
GO




-- ====================================================
-- SOAL 2 - (GROUP BY, HAVING, Aggregate Function)
-- ====================================================
-- Laporan Menampilkan Jurusan yang Memiliki Mahasiswa Lebih dari 5 Orang
SELECT Jurusan, COUNT(NIM) AS Total_Mahasiswa -- COUNT(NIM) = Berfungsi sebagai fungsi agregat untuk menghitung jumlah total mahasiswa di setiap kelompok jurusan
FROM Mahasiswa
GROUP BY Jurusan                               -- GROUP BY Jurusan = Berfungsi untuk mengelompokkan data berdasarkan jurusan masing-masing
HAVING COUNT(NIM) > 5;                         -- HAVING COUNT(NIM) > 5 = Berfungsi untuk menyaring hasil pengelompokan dan agregasi agar hanya menampilkan jurusan yang jumlah mahasiswanya lebih dari 5 orang
GO


-- Laporan Menampilkan Dosen Pembimbing yang Membimbing Lebih dari 1 Mahasiswa
SELECT NIDN, COUNT(NIM) AS Jumlah_Bimbingan    -- COUNT(NIM) = Berfungsi untuk menghitung jumlah total mahasiswa bimbingan dari setiap dosen
FROM Log_Bimbingan
GROUP BY NIDN                                  -- GROUP BY NIDN = Berfungsi untuk mengelompokkan data berdasarkan NIDN dosen pembimbing
HAVING COUNT(NIM) > 1;                         -- HAVING COUNT(NIM) > 1 = Berfungsi untuk menyaring hasil perhitungan agar hanya menampilkan dosen yang membimbing lebih dari 1 mahasiswa
GO


-- Laporan Menampilkan Rata-rata IPK Mahasiswa Berdasarkan Status Pengajuan Pendadaran 
SELECT Status, AVG(IPK) AS Rata_Rata_IPK       -- AVG(IPK) = Berfungsi sebagai fungsi agregat untuk mencari nilai rata-rata IPK di setiap kelompok status pengajuan pendadaran
FROM Pengajuan_Pendadaran
GROUP BY Status                                -- GROUP BY Status = Berfungsi untuk mengelompokkan data berdasarkan status pengajuan pendadaran
HAVING AVG(IPK) > 3.10;                        -- HAVING AVG(IPK) > 3.10 = Berfungsi untuk menyaring hasil perhitungan rata-rata agar hanya menampilkan status yang rata-rata IPK-nya di atas 3.10
GO                

/*
Aggregate Function (Fungsi Agregat): Fungsi yang digunakan untuk menghitung sekelompok baris data dan menghasilkan satu nilai ringkasan:
    COUNT(): Untuk menghitung jumlah baris/data.
    AVG(): Untuk mencari nilai rata-rata.
    SUM(): Untuk menjumlahkan nilai angka.
    MAX() / MIN(): Untuk mencari nilai tertinggi atau terendah.
GROUP BY: Digunakan untuk mengelompokkan data yang memiliki nilai yang sama menjadi satu kelompok/kategori. (Misalnya: mengelompokkan mahasiswa berdasarkan jurusannya, atau mengelompokkan tugas akhir berdasarkan statusnya).
WHERE: Menyaring data sebelum dikelompokkan.
HAVING: Menyaring data setelah proses GROUP BY dan fungsi agregat selesai dihitung. (Biasanya HAVING dipakai berpasangan dengan fungsi agregat seperti COUNT > 5 atau AVG > 3.30).
*/




-- ====================================================
-- SOAL 3 - (String, Numeric, Date, Conversion, & NULL Functions)
-- ====================================================
-- Analisis Data Mahasiswa & Waktu Pendaftaran
SELECT 
    CAST(NIM AS VARCHAR(50)) AS NIM_String,                   -- CAST(NIM AS VARCHAR(50)) = Berfungsi untuk mengubah tipe data kolom NIM menjadi string/varchar
    UPPER(Nama) AS Nama_Kapital,                              -- UPPER(Nama) = Berfungsi untuk mengubah semua huruf pada teks nama menjadi huruf kapital
    SUBSTRING(Jurusan, 1, 3) AS Kode_Jurusan,                 -- SUBSTRING(Jurusan, 1, 3) = Berfungsi untuk mengambil sebagian karakter dari teks jurusan (mulai karakter ke-1 sebanyak 3 huruf)
    CAST(RIGHT(NIM, 2) AS INT) % 10 AS Sisa_Bagi_NIM,         -- CAST(RIGHT(NIM, 2) AS INT) % 10 = Berfungsi mengambil 2 digit terakhir NIM, diubah ke angka, lalu dihitung sisa baginya dengan 10 (mengatasi overflow integer)
    YEAR(GETDATE()) AS Tahun_Sekarang,                        -- YEAR(GETDATE()) = Berfungsi untuk mengambil tahun dari waktu sistem saat ini
    DATEDIFF(DAY, '2024-01-01', GETDATE()) AS Hari_Berjalan,  -- DATEDIFF(DAY, '2024-01-01', GETDATE()) = Berfungsi untuk menghitung selisih jumlah hari antara tanggal tertentu dengan hari ini
    COALESCE(Email, 'email@belumada.com') AS Email_Valid      -- COALESCE(Email, 'email@belumada.com') = Berfungsi untuk mengganti nilai NULL pada kolom email dengan teks alternatif jika kosong
FROM Mahasiswa;
GO


-- Analisis Pengajuan Pendadaran & Penilaian Sidang
SELECT 
    NIM,
    CONCAT('IPK: ', CAST(IPK AS VARCHAR(10))) AS Info_IPK,  -- CAST(IPK AS VARCHAR(10)) = (mengubah tipe data IPK menjadi string/varchar)
    CONCAT(Status, ' - Sidang') AS Status_Lengkap,          -- CONCAT(Status, ' - Sidang') = (menggabungkan teks)
    LEN(Catatan) AS Panjang_Catatan,                        -- LEN(Catatan) = (menghitung panjang karakter string)
    FLOOR(IPK) AS IPK_Bulat_Bawah,                          -- FLOOR(IPK) = (pembulatan angka ke bawah)
    ABS(-5) AS Contoh_Nilai_Absolut,                        -- ABS(-5) = (menghitung nilai absolut angka)
    DATENAME(MONTH, Tanggal_Pengajuan) AS Bulan_Pengajuan,  -- DATENAME(MONTH, Tanggal_Pengajuan) = (mengambil nama bulan dari tanggal)
    DATEADD(DAY, 7, Tanggal_Pengajuan) AS Estimasi_Selesai, -- DATEADD(DAY, 7, Tanggal_Pengajuan) = (menambahkan jumlah hari pada tanggal)
    ISNULL(Ruangan, 'Belum Dijadwalkan') AS Ruangan_Sidang  -- ISNULL(Ruangan, 'Belum Dijadwalkan') = (mengganti nilai NULL dengan teks alternatif)
FROM Pengajuan_Pendadaran;
GO

/*
String Function (Fungsi Teks): Fungsi yang digunakan untuk memanipulasi, mengubah, atau mengolah data yang bertipe teks/karakter (string):
UPPER(): Mengubah huruf teks menjadi huruf besar semua.
LOWER(): Mengubah teks menjadi huruf kecil semua.
SUBSTRING(): Mengambil sebagian kecil teks dari sekumpulan karakter (misal: mengambil 3 huruf pertama dari kata "Teknik" jadi "Tek").
CONCAT(): Menggabungkan dua atau lebih teks menjadi satu.

Numeric Function (Fungsi Angka / Matematika): Fungsi yang digunakan untuk melakukan perhitungan matematis atau memanipulasi data angka (numeric):
ROUND(): Membulatkan angka ke desimal terdekat (misal: angka 3.75 dibulatkan jadi 4).
FLOOR(): Membulatkan angka ke bawah secara otomatis.
ABS(): Mengubah angka negatif menjadi angka positif (nilai mutlak).
Operator (%) / Modulo: Mencari sisa hasil bagi dari pembagian angka (di SQL Server menggunakan operator %).

Date Function (Fungsi Tanggal & Waktu): Fungsi yang digunakan untuk mengolah data yang berkaitan dengan tanggal, hari, bulan, atau tahun:
YEAR(): Mengambil tahunnya saja dari sebuah tanggal.
DATENAME(): Mengambil nama bulan (contoh: May atau January) dari sebuah tanggal.
DATEDIFF(): Menghitung selisih waktu/hari antara dua tanggal yang berbeda (membutuhkan argumen satuan di awal, misal: DAY).
DATEADD(): Menambahkan waktu/hari tertentu ke dalam suatu tanggal (misal: Tanggal pengajuan ditambah 7 hari).

Conversion Function (Fungsi Konversi Tipe Data): Fungsi yang digunakan untuk mengubah tipe data suatu kolom menjadi tipe data jenis lain (misalnya mengubah angka menjadi teks, atau sebaliknya).
CAST() atau CONVERT(): Digunakan untuk mengubah format. Contohnya mengubah kolom NIM yang tadinya berupa angka (integer) diubah sementara menjadi teks (varchar) agar bisa digabungkan dengan teks lain.

NULL Function (Fungsi Penanganan Data Kosong): Fungsi khusus yang digunakan untuk mendeteksi dan mengganti nilai NULL (kosong) dengan nilai pengganti lain yang lebih informatif agar tidak tampil kosong atau error saat dibaca.
ISNULL() atau COALESCE(): Artinya, "Jika kolom ini isinya NULL (kosong), maka ganti dan tampilkan teks tertentu (misalnya: 'Belum Ada Ruangan')"
*/




-- ====================================================
-- SOAL 4 - (CASE Expression)
-- ====================================================
-- CASE Expression untuk mengkategorikan IPK mahasiswa (diambil dari tabel Pengajuan_Pendadaran)
SELECT 
    NIM,
    IPK,
    CASE 
        WHEN IPK >= 3.50 THEN 'Cum Laude'
        WHEN IPK >= 3.00 THEN 'Sangat Memuaskan'
        ELSE 'Memuaskan'
    END AS Kategori_IPK
FROM Pengajuan_Pendadaran;
GO


-- Menentukan status kelayakan sidang berdasarkan SKS_Lulus dan IPK (diambil dari tabel Pengajuan_Pendadaran)
SELECT 
    NIM,
    SKS_Lulus,
    IPK,
    CASE 
        WHEN SKS_Lulus >= 130 AND IPK >= 2.75 THEN 'Layak Sidang'
        ELSE 'Belum Layak Sidang'
    END AS Status_Kelayakan
FROM Pengajuan_Pendadaran;
GO


-- Menentukan tindak lanjut berdasarkan status pengajuan (diambil dari tabel Pengajuan_Pendadaran)
SELECT 
    NIM,
    Status,
    CASE Status
        WHEN 'Disetujui' THEN 'Jadwal Sidang Segera Dibuat'
        WHEN 'Revisi' THEN 'Harap Perbaiki Dokumen'
        ELSE 'Menunggu Verifikasi'
    END AS Tindak_Lanjut
FROM Pengajuan_Pendadaran;
GO

/*
CASE: Kata kunci utama untuk memulai blok ekspresi logika percabangan. 
WHEN: Bagian untuk menentukan kondisi atau kriteria tertentu yang ingin diuji 
THEN: Hasil atau nilai yang akan dikeluarkan jika kondisi pada WHEN bernilai benar (TRUE).
ELSE: Kondisi cadangan, Jika seluruh kondisi WHEN di atasnya ternyata tidak ada yang benar, maka program akan mengeksekusi nilai yang ada di dalam ELSE.
END: Kata kunci penutup yang wajib ditulis untuk mengakhiri seluruh blok pernyataan CASE.

Jenis-Jenis CASE Expression:
- Simple CASE: Mengevaluasi satu kolom atau ekspresi tertentu dibandingkan dengan beberapa nilai secara langsung.
- Searched CASE: Mengevaluasi serangkaian kondisi boolean yang berbeda-beda (bisa melibatkan operator perbandingan seperti >, <, >=, AND, OR).
*/




-- ====================================================
-- SOAL 5 - (INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN - Min 3 Tabel)
-- ====================================================
-- INNER JOIN (Menampilkan data mahasiswa, dosen pembimbingnya, dan pengajuan pendadaran yang memiliki data berelasi lengkap di ke-3 tabel)
SELECT 
    M.NIM,
    M.Nama AS Nama_Mahasiswa,
    D.Nama AS Dosen_Pembimbing,
    P.Status AS Status_Pendadaran
FROM Mahasiswa AS M
INNER JOIN Dosen AS D ON M.NIDN_Pembimbing = D.NIDN     -- untuk menggabungkan tabel Mahasiswa dengan tabel Dosen berdasarkan kolom relasi NIDN pembimbing
INNER JOIN Pengajuan_Pendadaran AS P ON M.NIM = P.NIM;  -- menggabungkan hasil dari tabel sebelumnya dengan tabel Pengajuan_Pendadaran menggunakan kolom NIM sebagai kunci relasi
GO


-- LEFT JOIN (Menampilkan seluruh data Mahasiswa dari tabel kiri beserta dosen dan pengajuannya, meskipun mahasiswa tersebut belum pernah mengajukan pendadaran)
SELECT 
    M.NIM,
    M.Nama AS Nama_Mahasiswa,
    D.Nama AS Dosen_Pembimbing,
    P.Status AS Status_Pendadaran
FROM Mahasiswa AS M
LEFT JOIN Dosen AS D ON M.NIDN_Pembimbing = D.NIDN      -- untuk mengambil seluruh data mahasiswa beserta data dosen pembimbingnya; jika ada mahasiswa yang belum memiliki dosen pembimbing, datanya tetap ditampilkan dengan nilai NULL pada kolom dosen
LEFT JOIN Pengajuan_Pendadaran AS P ON M.NIM = P.NIM;   -- menggabungkan hasilnya dengan tabel Pengajuan_Pendadaran; seluruh data mahasiswa utama tetap akan muncul meskipun mahasiswa tersebut belum pernah mengajukan pendadaran
GO


-- RIGHT JOIN (Menampilkan seluruh data dari tabel kanan 'Pengajuan_Pendadaran', meskipun data mahasiswanya tidak terdaftar)
SELECT 
    M.NIM,
    M.Nama AS Nama_Mahasiswa,
    D.Nama AS Dosen_Pembimbing,
    P.Status AS Status_Pendadaran
FROM Mahasiswa AS M
RIGHT JOIN Dosen AS D ON M.NIDN_Pembimbing = D.NIDN      -- untuk mengambil seluruh data dari tabel kanan (Dosen) beserta data mahasiswa yang memiliki relasi pembimbing, dan menampilkan nilai NULL pada sisi mahasiswa jika ada dosen yang belum membimbing mahasiswa
RIGHT JOIN Pengajuan_Pendadaran AS P ON M.NIM = P.NIM;   -- menggabungkan hasilnya dengan tabel Pengajuan_Pendadaran secara RIGHT JOIN; memastikan seluruh data pengajuan pendadaran tetap tampil meskipun mahasiswanya tidak terdaftar atau tidak cocok di tabel kiri
GO


-- FULL OUTER JOIN (Menampilkan seluruh data secara keseluruhan dari tabel Mahasiswa, Dosen, dan Pengajuan_Pendadaran baik yang berpasangan maupun tidak)
SELECT 
    M.NIM,
    M.Nama AS Nama_Mahasiswa,
    D.Nama AS Dosen_Pembimbing,
    P.Status AS Status_Pendadaran
FROM Mahasiswa AS M
FULL OUTER JOIN Dosen AS D ON M.NIDN_Pembimbing = D.NIDN      -- untuk menggabungkan seluruh data dari tabel Mahasiswa dan Dosen secara menyeluruh; jika ada data di salah satu tabel yang tidak memiliki pasangan relasi, maka akan tetap ditampilkan dengan nilai NULL di sisi yang kosong
FULL OUTER JOIN Pengajuan_Pendadaran AS P ON M.NIM = P.NIM;   -- menggabungkan hasilnya secara FULL OUTER JOIN dengan tabel Pengajuan_Pendadaran; memastikan seluruh data dari ketiga tabel (Mahasiswa, Dosen, dan Pengajuan Pendadaran) ditampilkan secara utuh baik yang berpasangan maupun yang tidak
GO

/*
JOIN: Perintah yang digunakan untuk menggabungkan dua tabel atau lebih di dalam database berdasarkan kolom yang saling berelasi (memiliki nilai yang sama).
INNER JOIN: Jenis join yang hanya akan menampilkan baris data dari kedua tabel atau lebih jika terdapat nilai yang cocok (berpasangan) di semua tabel yang dihubungkan. Jika ada data yang tidak punya pasangan, maka data tersebut akan disembunyikan.
LEFT JOIN (atau LEFT OUTER JOIN): Jenis join yang menampilkan seluruh data dari tabel sebelah kiri (tabel pertama yang disebut setelah FROM), meskipun tidak ada pasangan data yang cocok di tabel sebelah kanan. Jika tidak ada pasangan, kolom dari tabel kanan akan bernilai NULL.
RIGHT JOIN (atau RIGHT OUTER JOIN): Jenis join yang menampilkan seluruh data dari tabel sebelah kanan, meskipun tidak ada pasangan data yang cocok di tabel sebelah kiri. Jika tidak ada pasangan, kolom dari tabel kiri akan bernilai NULL.
FULL JOIN (atau FULL OUTER JOIN): Jenis join yang menampilkan seluruh data dari kedua belah pihak (tabel kiri maupun tabel kanan). Data yang memiliki pasangan akan digabungkan, dan data yang tidak memiliki pasangan di salah satu sisi tetap akan ditampilkan dengan memunculkan nilai NULL pada sisi yang kosong.
Alias Tabel (AS M, AS P, AS D): Pemberian nama singkat atau pengganti untuk sebuah tabel di dalam query (tabel Mahasiswa disingkat M), (tabel Pengajuan_Pendadaran disingkat P), (tabel Dosen disingkat D)
*/




-- ====================================================
-- SOAL 6 - (Set Operator: UNION, UNION ALL, INTERSECT, EXCEPT)
-- ====================================================
-- UNION (Menggabungkan mahasiswa angkatan 2021 dengan jurusan Teknologi Informasi, otomatis menghilangkan data duplikat)
SELECT NIM, Nama, Angkatan, Jurusan FROM Mahasiswa WHERE Angkatan = '2021'
UNION
SELECT NIM, Nama, Angkatan, Jurusan FROM Mahasiswa WHERE Jurusan = 'Teknologi Informasi';
GO


-- UNION ALL (Menggabungkan seluruh mahasiswa angkatan 2021 dengan mahasiswa jurusan Teknologi Informasi termasuk menampilkan data yang sama dua kali jika ada)
SELECT NIM, Nama, Angkatan, Jurusan FROM Mahasiswa WHERE Angkatan = '2021'
UNION ALL
SELECT NIM, Nama, Angkatan, Jurusan FROM Mahasiswa WHERE Jurusan = 'Teknologi Informasi';
GO


-- INTERSECT (Menampilkan data mahasiswa angkatan 2021 yang juga memiliki jurusan Teknologi Informasi / data yang beririsan di kedua kondisi)
SELECT NIM, Nama, Angkatan, Jurusan FROM Mahasiswa WHERE Angkatan = '2021'
INTERSECT
SELECT NIM, Nama, Angkatan, Jurusan FROM Mahasiswa WHERE Jurusan = 'Teknologi Informasi';
GO


-- EXCEPT (Menampilkan data mahasiswa dari query pertama yang tidak termasuk dalam kondisi query kedua)
SELECT NIM, Nama, Angkatan, Jurusan FROM Mahasiswa WHERE Jurusan = 'Teknologi Informasi'
EXCEPT
SELECT NIM, Nama, Angkatan, Jurusan FROM Mahasiswa WHERE Angkatan = '2021';
GO

/*
Set Operator: untuk menggabungkan hasil dari beberapa query SELECT menjadi satu kesatuan data. Syarat: Jumlah kolom, urutan, dan tipe data antar query harus sama.
UNION: Menggabungkan data dari beberapa query dan otomatis menghapus data yang duplikat (kembar).
3. UNION ALL: Menggabungkan data dari beberapa query apa adanya tanpa menghapus data duplikat (semua baris ditampilkan).
4. INTERSECT: Hanya menampilkan data yang sama atau beririsan yang muncul di kedua query.
5. EXCEPT: Menampilkan data dari query pertama yang tidak ada di dalam hasil query kedua.
*/