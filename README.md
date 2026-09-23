# Implementasi Basis Data (Semester Antara)

[![DBMS](https://img.shields.io/badge/DBMS-Microsoft%20SQL%20Server-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![Language](https://img.shields.io/badge/Language-T--SQL%20%2F%20SQL-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)](https://docs.microsoft.com/sql/t-sql/)
[![IDE](https://img.shields.io/badge/IDE-SSMS%20%2F%20Azure%20Data%20Studio-00599C?style=for-the-badge&logo=visualstudio)](https://docs.microsoft.com/sql/ssms/)
[![Testing](https://img.shields.io/badge/Quality-Database%20Testing%20%26%20Tuning-success?style=for-the-badge&logo=checkmarx)](https://github.com/)

Repositori ini berisi seluruh dokumentasi, modul materi, skrip SQL praktikum, serta berkas evaluasi **Ujian Capaian Pembelajaran (UCP 1, UCP 2, dan UCP 3)** pada mata kuliah **Implementasi Basis Data (Semester Antara)**. 

Seluruh implementasi dibangun dan diuji menggunakan **Microsoft SQL Server (T-SQL)** dengan fokus pada perancangan basis data relasional berkinerja tinggi, pemrograman basis data (*programmability*), manajemen transaksi, optimasi indeks (*performance tuning*), dan pengujian keamanan (*security testing*).

---

## Identitas Mahasiswa

- **Nama** : Ahmad Rassya Maulana
- **NIM** : 20250140157
- **Mata Kuliah** : Implementasi Basis Data (Semester Antara)
- **Topik Proyek** : Sistem Informasi Monitoring & Pendadaran Tugas Akhir (`Monitoring_TA`) & Sistem Retail Toko Hewan (`DB_PetShop`)

---

## Daftar Isi

- [Identitas Mahasiswa](#identitas-mahasiswa)
- [Gambaran Umum Repositori](#gambaran-umum-repositori)
- [Studi Kasus Basis Data](#studi-kasus-basis-data)
  - [1. Database `Monitoring_TA`](#1-database-monitoring_ta)
  - [2. Database `DB_PetShop`](#2-database-db_petshop)
- [Struktur Direktori Repositori](#struktur-direktori-repositori)
- [Silabus & Cakupan Materi Praktikum](#silabus--cakupan-materi-praktikum)
- [Rincian Ujian Capaian Pembelajaran (UCP)](#rincian-ujian-capaian-pembelajaran-ucp)
  - [UCP 1: Perancangan Fisik & Skema Relasional](#ucp-1-perancangan-fisik--skema-relasional)
  - [UCP 2: Query Lanjutan, Programmability & Transaksi](#ucp-2-query-lanjutan-programmability--transaksi)
  - [UCP 3: Pengujian Database, Optimasi Performa & Keamanan](#ucp-3-pengujian-database-optimasi-performa--keamanan)
- [Panduan Penggunaan & Eksekusi Skrip](#panduan-penggunaan--eksekusi-skrip)
- [Teknologi & Lingkungan](#teknologi--lingkungan)

---

## Gambaran Umum Repositori

Repositori ini dirancang sebagai rekam jejak terpadu perkuliahan Implementasi Basis Data yang mencakup:
1. **Perancangan Arsitektur Fisik SQL Server**: Pengelolaan alokasi berkas data primer (`.mdf`), sekunder (`.ndf`), filegroup, dan berkas transaksi log (`.ldf`).
2. **Penegakan Integritas Data (*Integrity Constraints*)**: Penerapan Primary Key (PK), Foreign Key (FK) referensial, Unique (UQ), Check Constraint (CK) berbasis pola Regular Expression/LIKE, dan DEFAULT value.
3. **Manipulasi Data & Pelaporan Tingkat Lanjut**: Implementasi agregasi, CASE Expression, Set Operators, Multi-table JOINs, Subqueries, Common Table Expressions (CTE), dan Window Functions.
4. **Pemrograman Basis Data (*T-SQL Programmability*)**: Pengembangan Stored Procedures dengan penanganan galat (`TRY...CATCH` & `THROW`), Triggers (*AFTER / INSTEAD OF*), User-Defined Functions (UDF), serta Views.
5. **Kontrol Konkurensi & Transaksi**: Manajemen transaksi ACID (`BEGIN TRAN`, `COMMIT`, `ROLLBACK`), pencegahan Deadlock, dan pengaturan Isolation Level.
6. **Pengujian & Penalaan Performa (*Database Quality Assurance*)**: Metodologi pengujian fungsional (*Functional Testing*), integritas (*Integrity Testing*), performa (*Performance Testing* komparasi query berat dengan/tanpa Non-Clustered Index), serta pengujian keamanan (*Security Testing* simulasi dan mitigasi serangan SQL Injection).

---

## Studi Kasus Basis Data

### 1. Database `Monitoring_TA`
Basis data utama yang digunakan untuk evaluasi UCP 1, UCP 2, dan UCP 3. Sistem ini memodelkan alur pengajuan judul tugas akhir, bimbingan berkala mahasiswa dengan dosen, hingga pendaftaran sidang pendadaran dan penilaian.

#### Skema Relasional Entitas:
- **`Dosen`**: Menyimpan master data dosen pembimbing dan penguji (`NIDN`, `Nama`, `Prodi`, `Email`, `No_HP`).
- **`Mahasiswa`**: Menyimpan master data mahasiswa (`NIM`, `Nama`, `Angkatan`, `Jurusan`, `Email`, `NIDN_Pembimbing`).
- **`Staff_TU`**: Menyimpan data staf tata usaha akademik pengelola administrasi (`NIP`, `Nama`, `Jabatan`, `Email`, `No_HP`).
- **`Monitoring_TA`**: Tabel pelacakan status judul tugas akhir per mahasiswa (`ID_TA`, `Nim`, `NIDN_Pembimbing`, `Judul_TA`, `Status_TA`).
- **`Log_Bimbingan`**: Catatan riwayat konsultasi/bimbingan tugas akhir (`ID_Log`, `NIM`, `NIDN`, `Tanggal`, `Materi`, `Status`).
- **`Pengajuan_Pendadaran`**: Transaksi pendaftaran ujian pendadaran (`ID_Pengajuan`, `NIM`, `NIP_Staff`, `NIDN_Penguji1`, `NIDN_Penguji2`, `IPK`, `SKS_Lulus`, `Tanggal_Pengajuan`, `Tanggal_Ujian`, `Ruangan`, `Status`, `Nilai`, `Catatan`).

---

### 2. Database `DB_PetShop`
Basis data yang digunakan untuk modul praktikum mingguan 1 s.d. 8. Sistem ini mengelola operasional penjualan retail produk hewan, manajemen reservasi layanan grooming/klinik, data pelanggan, hewan peliharaan, serta audit stok barang.

#### Skema Relasional Entitas:
- `Pelanggan`, `Hewan`, `Pegawai`, `KategoriProduk`, `Produk`, `Layanan`, `ReservasiLayanan`, `Penjualan`, `DetailPenjualan`, `AuditStok`.

---

## Struktur Direktori Repositori

```text
├── DB_PetShop/                  # Skrip DDL/DML tabel individual untuk basis data DB_PetShop
│   ├── db_petshop_pelanggan.sql
│   ├── db_petshop_hewan.sql
│   ├── db_petshop_pegawai.sql
│   ├── db_petshop_kategoriproduk.sql
│   ├── db_petshop_produk.sql
│   ├── db_petshop_layanan.sql
│   ├── db_petshop_reservasilayanan.sql
│   ├── db_petshop_penjualan.sql
│   ├── db_petshop_detailpenjualan.sql
│   ├── db_petshop_auditstok.sql
│   └── db_petshop_routines.sql
│
├── Praktikum/                   # Modul PDF panduan praktikum laboratorium (Modul 1 s.d. 8)
│   ├── 1 - Modul Praktikum - Query Dasar dan Built-in Function pada SQL Server.pdf
│   ├── 2 - Modul Praktikum - Penerapan Built-in Function dan CASE Expression...pdf
│   ├── Modul Praktikum - CASE Expression, Set Operator, SQL JOIN...pdf
│   ├── Modul Praktikum - Subquery, Common Table Expression (CTE), Window Function...pdf
│   ├── Modul Praktikum - Trigger, Identity, Sequence - SQL Server.pdf
│   ├── Modul Praktikum - Stored Procedure, T-SQL Programming, Try...Catch...pdf
│   ├── Modul Praktikum - Transaction Management, Locking, Deadlock...pdf
│   └── Modul Praktikum - View dan User-Defined Function (UDF)...pdf
│
├── Query_SQL_IBD/               # Skrip SQL solusi latihan praktikum laboratorium
│   ├── Praktikum_1_Create_DataBase_DB_Petshop.sql
│   ├── Praktikum_1_Query_Dasar_(Basic_Query).sql
│   ├── Praktikum_2_Penerapan Built-in Function dan CASE Expression...sql
│   ├── praktikum_3_CASE Expression, Set Operator, SQL JOIN...sql
│   ├── Praktikum_3_Penjelasan.sql
│   ├── Praktikum_4_ Subquery, Common Table Expression (CTE)...sql
│   ├── Praktikum_6_ Trigger, IDENTITY, SEQUENCE.sql
│   ├── Praktikum -7 STORED PROCEDURE, T-SQL PROGRAMING, TRY...CATCH...sql
│   ├── Praktikum - 8 Transaction Management, Locking, Deadlock...sql
│   └── UCP_1_IBD.sql
│
├── Teori/                       # Modul PDF materi perkuliahan teori (Modul 1 s.d. 12)
│   ├── 1 - Modul Teori - Query Dasar dan Built-in Function pada SQL Server.pdf
│   ├── 2 - Modul Teori - Penerapan Built-in Function dan CASE Expression...pdf
│   ├── 5 Modul Teori - CASE Expression, Set Operator, SQL JOIN.pdf
│   ├── 6 Modul Teori - Subquery, CTE, dan Window Function.pdf
│   ├── 8 Modul Teori - View dan User-Defined Function (UDF).pdf
│   ├── 9 Modul Teori - Trigger, Identity, Sequence.pdf
│   ├── 10 Modul Teori - Stored Procedure, T-SQL Programming, Try...Catch.pdf
│   └── 12 Modul Teori - Transaction Management, Locking, Deadlock...pdf
│
├── UCP_1_IBD/                   # Ujian Capaian Pembelajaran 1
│   ├── UCP_1_IBD.sql            # Skrip DDL Database Monitoring_TA, Filegroups, Constraints & DML Sample
│   └── Persiapan_Ujian_Monitoring_TA.docx
│
├── UCP_2_IBD/                   # Ujian Capaian Pembelajaran 2
│   ├── UCP_2.sql                # Skrip implementasi query dasar, built-in, JOIN, CTE, SP, Trigger, UDF
│   ├── Anak_Baik_UCP2.docx      # Laporan resmi hasil pengerjaan UCP 2
│   ├── SOAL_UCP_2.pdf           # Lembar soal evaluasi UCP 2
│   └── Pengecekan_DataBase.sql  # Skrip verifikasi integritas data & pengujian objek
│
├── UCP_3_IBD/                   # Ujian Capaian Pembelajaran 3 (Final Testing & Performance Tuning)
│   ├── FIX/                     # Berkas final yang diserahkan
│   │   ├── UCP_3_IBD_Sistem_Monitoring_TA_Anak_Baik.sql   # Skrip pengujian terpadu lengkap (FUNC, INT, TRNS, PERF, SEC)
│   │   ├── Dokumentasi Pengujian_Sistem_Monitoring_TA_Anak_Baik.docx
│   │   ├── Dokumentasi Pengujian_Sistem_Monitoring_TA_Anak_Baik.pdf
│   │   └── SS Bukti Dokumentasi Query SQL/                # Bukti visual eksekusi pengujian
│   └── Revisi/                  # Skrip & dokumentasi tahap revisi dan modul pengujian
│       ├── Modul Praktikum - Pengujian Database.pdf
│       ├── UCP_3.sql
│       ├── SQLQuery1.sql
│       └── SS-Bukti/
│
└── README.md                    # Dokumentasi utama repositori
```

---

## Silabus & Cakupan Materi Praktikum

| No | Topik Praktikum | Ringkasan Materi & Implementasi | Skrip Terkait |
|:--:|---|---|---|
| **01** | **Query Dasar (Basic Query)** | Pembuatan database `DB_PetShop`, `SELECT`, `WHERE`, `ORDER BY`, `DISTINCT`, filtering kondisi aritmatika & logika. | `Praktikum_1_...sql` |
| **02** | **Built-in Functions & CASE** | Manipulasi teks (`UPPER`, `LOWER`, `CONCAT`, `SUBSTRING`), tanggal (`GETDATE`, `DATEDIFF`, `DATEADD`), numerik (`ROUND`, `CEILING`), dan pengkondisian baris data via `CASE WHEN`. | `Praktikum_2_...sql` |
| **03** | **Set Operator & SQL JOIN** | Penggabungan himpunan baris (`UNION`, `UNION ALL`, `INTERSECT`, `EXCEPT`) dan relasi multi-tabel (`INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL OUTER JOIN`, `CROSS JOIN`). | `praktikum_3_...sql` |
| **04** | **Subquery, CTE & Window Function** | Single & Multi-row Subqueries, Correlated Subqueries, Common Table Expressions (`WITH ... AS`), serta Window Functions (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `PARTITION BY`). | `Praktikum_4_...sql` |
| **06** | **Trigger, IDENTITY & SEQUENCE** | Pembuatan auto-increment dengan `IDENTITY` dan objek independen `SEQUENCE`. Implementasi `AFTER INSERT/UPDATE/DELETE` untuk audit data otomatis dan validasi stok. | `Praktikum_6_...sql` |
| **07** | **Stored Procedure & T-SQL** | Parameter `IN`/`OUT`, variabel T-SQL (`DECLARE`, `SET`), kontrol alur (`IF...ELSE`, `WHILE`), penanganan galat terstruktur (`BEGIN TRY...END TRY`, `BEGIN CATCH...END CATCH`, `THROW`). | `Praktikum -7...sql` |
| **08** | **Transaction & Locking** | Prinsip ACID, `BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK`, *Savepoints*, analisis *Locking mechanism*, simulasi *Deadlock*, dan pengaturan `TRANSACTION ISOLATION LEVEL`. | `Praktikum - 8...sql` |

---

## Rincian Ujian Capaian Pembelajaran (UCP)

### UCP 1: Perancangan Fisik & Skema Relasional
- **Fokus**: Merancang skema fisik dan logis database `Monitoring_TA`.
- **Fitur Implementasi**:
  - Konfigurasi penyimpanan fisik multi-file: Data Primer (`.mdf`), Data Sekunder pada Filegroup Khusus (`.ndf`), dan Transaction Log (`.ldf`) dengan batasan ukuran dan laju pertumbuhan (*filegrowth*).
  - Penegakan integritas ketat (*Constraint Validation*):
    - Validasi format NIM, NIDN, NIP, dan No HP harus numerik (`NOT LIKE '%[^0-9]%'`).
    - Validasi format email universitas (`LIKE '%@%.%'`).
    - Validasi rentang tahun angkatan mahasiswa (`BETWEEN '2015' AND '2030'`).
    - Validasi logika tanggal log bimbingan tidak boleh di masa depan (`Tanggal <= GETDATE()`).
    - Validasi status tahapan skripsi/TA dan sidang pendadaran.
  - Skrip pengisian data uji awal (*sample dataset*).

---

### UCP 2: Query Lanjutan, Programmability & Transaksi
- **Fokus**: Menjawab kebutuhan operasional dan analitik sistem melalui logika pemrograman T-SQL.
- **Fitur Implementasi**:
  1. **Query & Aggregasi**: Pelaporan statistik IPK mahasiswa, jumlah bimbingan, dan rekapitulasi status kelulusan.
  2. **Multi-Table JOINs & Set Operators**: Rekap hubungan mahasiswa, dosen pembimbing, dan dewan penguji sidang.
  3. **Subquery & CTE**: Pencarian mahasiswa dengan IPK di atas rata-rata prodi menggunakan subquery dan CTE hirarkis.
  4. **Window Functions**: Pemeringkatan mahasiswa berdasarkan IPK per angkatan menggunakan `DENSE_RANK() OVER (PARTITION BY ... ORDER BY ...)`.
  5. **Views & User-Defined Functions (UDF)**:
     - `vw_RekapitulasiSidang`: View ringkasan mahasiswa yang siap sidang dan status persetujuannya.
     - `fn_HitungLamaBimbingan`: Scalar UDF untuk menghitung durasi waktu bimbingan mahasiswa.
  6. **Stored Procedures**:
     - `sp_TambahMahasiswa`: Validasi dan input data mahasiswa dengan proteksi duplikasi.
     - `usp_TambahPengajuanPendadaran`: Prosedur pendaftaran sidang dengan verifikasi syarat minimum SKS lulus (>= 138 SKS) dan IPK (>= 2.00).
  7. **Triggers**:
     - `trg_AuditLogBimbingan`: Trigger otomatis mencatat riwayat perubahan status bimbingan.
  8. **Transaction Management**: Eksekusi multi-tabel dengan skenario *commit* saat sukses dan *rollback* otomatis jika terjadi kegagalan validasi.

---

### UCP 3: Pengujian Database, Optimasi Performa & Keamanan
- **Fokus**: Pengujian menyeluruh (*Database Quality Assurance*), penalaan performa indeks (*Performance Tuning*), dan uji ketahanan keamanan terhadap injeksi SQL.

#### Kategori Pengujian yang Dilakukan:
1. **Functional Testing (FUNC)**:
   - `FUNC-01`: Uji penyisipan data valid pada tabel induk (`Dosen`, `Staff_TU`, `Mahasiswa`).
   - `FUNC-02`: Uji pembaruan data relasional (`UPDATE`) pada entitas utama.
   - `FUNC-03`: Uji eksekusi Stored Procedure dengan berbagai variasi parameter.
   - `FUNC-04`: Uji fungsionalitas Trigger saat operasi DML berlangsung.
   - `FUNC-05`: Uji kebenaran data keluaran dari View.
2. **Integrity Testing (INT)**:
   - `INT-PK-01`: Uji penolakan duplikasi Primary Key (`Violation of PRIMARY KEY constraint`).
   - `INT-FK-01`: Uji integritas referensial Foreign Key (penolakan data anak tanpa induk yang valid).
   - `INT-CHK-01`: Uji pelanggaran Check Constraint (format karakter ilegal, rentang nilai tidak sah).
3. **Transaction Testing (TRNS)**:
   - `TRNS-01`: Pengujian `COMMIT` pada transaksi multi-tabel (memastikan seluruh operasi tersimpan permanen).
   - `TRNS-02`: Pengujian `ROLLBACK` pada transaksi multi-tabel saat terjadi *error* (memastikan konsistensi data kembali ke keadaan semula).
4. **Performance Testing (PERF)**:
   - `PERF-01`: Pengujian eksekusi query kompleks (multi-table JOIN dan agregasi berat) **TANPA Non-Clustered Index** -> Menganalisis *Execution Plan* (*Table Scan / Clustered Index Scan*, biaya I/O tinggi).
   - `PERF-02`: Pembuatan **Non-Clustered Index** pada kolom pencarian dan foreign key, lalu menguji ulang query yang sama -> Terjadi peningkatan performa drastis melalui *Index Seek* dan penurunan *Subtree Cost*.
5. **Security Testing (SEC)**:
   - `SEC-01`: Simulasi serangan **SQL Injection** menggunakan *Dynamic SQL* rentan (`' OR '1'='1`).
   - `SEC-02`: Mitigasi dan pembuktian ketahanan sistem dengan menerapkan **Parameterized Queries** dan **Stored Procedures** (`sp_executesql`).

---

## Panduan Penggunaan & Eksekusi Skrip

### 1. Prasyarat Sistem
- **DBMS**: Microsoft SQL Server 2017 / 2019 / 2022 (Express, Developer, atau Enterprise Edition).
- **Client Tools**: SQL Server Management Studio (SSMS) v18+ atau Azure Data Studio.

### 2. Urutan Langkah Setup

#### Langkah 1: Persiapan Folder Direktori Fisik (Opsional / Disesuaikan)
Buka file `UCP_1_IBD/UCP_1_IBD.sql`. Pastikan direktori target penyimpanan berkas database telah dibuat di sistem Anda atau sesuaikan path-nya:
```sql
-- Contoh path default pada script:
FILENAME = 'C:\IBD_DataBase_SQL_Server\MONITORING_TA\MonitoringTA_Primary.mdf'
```
*(Catatan: Buat folder `C:\IBD_DataBase_SQL_Server\MONITORING_TA\` terlebih dahulu jika ingin menggunakan path bawaan).*

#### Langkah 2: Inisialisasi Database & Skema Tabel
Buka dan jalankan seluruh isi file:
```text
UCP_1_IBD/UCP_1_IBD.sql
```
Perintah ini akan membuat database `Monitoring_TA`, filegroup, seluruh tabel, penegakan constraint, serta memasukkan *seed data*.

#### Langkah 3: Eksekusi Objek Programmability
Buka dan jalankan skrip logika lanjutan:
```text
UCP_2_IBD/UCP_2.sql
```
Skrip ini akan membangun view, user-defined functions, stored procedures, dan trigger pada database `Monitoring_TA`.

#### Langkah 4: Menjalankan Pengujian Terpadu (Testing Suite)
Buka dan jalankan skrip pengujian final:
```text
UCP_3_IBD/FIX/UCP_3_IBD_Sistem_Monitoring_TA_Anak_Baik.sql
```
Skrip ini memuat seluruh skenario pengujian fungsional, integritas, transaksi, pembuatan indeks performa, hingga simulasi keamanan SQL injection.

---

## Teknologi & Lingkungan

- **Engine**: Microsoft SQL Server (Transact-SQL)
- **Komponen Utama**:
  - Multi-file Storage Architecture (`.mdf`, `.ndf`, `.ldf`, `FILEGROUP`)
  - Referential Integrity & Domain Integrity (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `DEFAULT`)
  - Procedural T-SQL (`Stored Procedures`, `Triggers`, `UDF`, `TRY...CATCH`, `THROW`)
  - Query Optimization (`Execution Plan`, `Clustered & Non-Clustered Indexes`)
  - Concurrency Control (`ACID Transactions`, `Locking`, `Isolation Level`)
- **Dokumentasi**: Microsoft Word (`.docx`), Adobe PDF (`.pdf`), Markdown (`.md`)

---

*Repositori ini disusun untuk keperluan akademik mata kuliah Implementasi Basis Data. Dilarang menyalahgunakan atau mempublikasikan ulang tanpa izin.*
