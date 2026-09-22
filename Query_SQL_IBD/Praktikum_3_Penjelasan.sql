/* ============================================================
   PRAKTIKUM 3
   CASE Expression, Set Operator (UNION, UNION ALL, INTERSECT, EXCEPT),
   SQL JOIN (INNER, LEFT, RIGHT, FULL)
   Database: DB_Petshop
   ============================================================
   Set Operator bekerja pada RESULT SET (hasil query), bukan pada
   tabel secara langsung. Sedangkan JOIN bekerja berdasarkan RELASI
   ANTAR KOLOM (Primary Key - Foreign Key) pada tabel.
   ============================================================ */


/* ============================================================
   PRAKTIKUM 1 - UNION
   ------------------------------------------------------------
   Kebutuhan: Manajemen ingin menampilkan daftar pelanggan UNIK
   yang pernah melakukan pembelian produk ATAU melakukan
   reservasi layanan.

   Sesuai teori: UNION menggabungkan dua atau lebih result set
   menjadi satu result set baru dengan MENGHILANGKAN DATA DUPLIKAT.
   Jika ada baris yang sama persis pada kedua query, hanya
   ditampilkan satu kali pada hasil akhir.
   ============================================================ */

-- Versi dasar
SELECT
    p.KodePelanggan,
    p.NamaPelanggan
FROM Pelanggan AS p
INNER JOIN Penjualan AS pj
    ON p.KodePelanggan = pj.KodePelanggan

UNION

SELECT
    p.KodePelanggan,
    p.NamaPelanggan
FROM Pelanggan AS p
INNER JOIN ReservasiLayanan AS rl
    ON p.KodePelanggan = rl.KodePelanggan;

-- Versi dengan keterangan aktivitas
-- Catatan : pada versi ini, pelanggan yang melakukan DUA jenis aktivitas (beli produk & reservasi) tetap bisa muncul DUA KALI, karena nilai kolom JenisAktivitas berbeda antar baris, sehingga baris tersebut tidak dianggap duplikat oleh UNION.

SELECT
    p.KodePelanggan,
    p.NamaPelanggan,
    'Pembelian Produk' AS JenisAktivitas
FROM pelanggan p
INNER JOIN penjualan AS pj
    ON p.KodePelanggan = pj.KodePelanggan

UNION

SELECT
    p.KodePelanggan,
    p.NamaPelanggan,
    'Reservasi Layanan' AS JenisAktivitas
FROM pelanggan p
INNER JOIN reservasilayanan AS rl
    ON p.KodePelanggan = rl.KodePelanggan;


/* ============================================================
   PRAKTIKUM 2 - UNION ALL
   ------------------------------------------------------------
   Kebutuhan: Manajemen ingin menampilkan SELURUH aktivitas
   pelanggan, termasuk pelanggan yang melakukan transaksi atau
   reservasi BERULANG KALI.

   Sesuai teori: UNION ALL menggabungkan dua atau lebih result set
   TANPA menghapus data duplikat. Semua baris ditampilkan apa
   adanya. Cocok dipakai ketika seluruh data harus ditampilkan,
   duplikat diperbolehkan, dan performa query menjadi prioritas
   (karena tidak perlu proses pengecekan duplikat).
   ============================================================ */

SELECT
    p.KodePelanggan,
    p.NamaPelanggan,
    pj.TanggalPenjualan AS TanggalAktivitas,
    'Penjualan' AS JenisAktivitas
FROM Pelanggan AS p
INNER JOIN Penjualan AS pj
    ON p.KodePelanggan = pj.KodePelanggan

UNION ALL

SELECT
    p.KodePelanggan,
    p.NamaPelanggan,
    rl.TanggalReservasi AS TanggalAktivitas,
    'Reservasi Layanan' AS JenisAktivitas
FROM Pelanggan AS p
INNER JOIN ReservasiLayanan AS rl
    ON p.KodePelanggan = rl.KodePelanggan;

-- Mengurutkan hasil UNION ALL di atas
-- Sesuai teori (Aturan 5): setelah beberapa result set digabungkan
-- dengan Set Operator, hasil akhirnya hanya SATU result set.
-- Oleh karena itu ORDER BY hanya boleh dituliskan SATU KALI,
-- ditempatkan di bagian paling akhir query (di luar subquery).
-- Menaruh ORDER BY di masing-masing query akan menyebabkan
-- kesalahan sintaks atau hasil yang tidak sesuai.
SELECT
    Aktivitas.KodePelanggan,
    Aktivitas.NamaPelanggan,
    Aktivitas.TanggalAktivitas,
    Aktivitas.JenisAktivitas
FROM
(
    SELECT
        p.KodePelanggan,
        p.NamaPelanggan,
        pj.TanggalPenjualan AS TanggalAktivitas,
        'Penjualan' AS JenisAktivitas
    FROM Pelanggan AS p
    INNER JOIN Penjualan AS pj
        ON p.KodePelanggan = pj.KodePelanggan

    UNION ALL

    SELECT
        p.KodePelanggan,
        p.NamaPelanggan,
        rl.TanggalReservasi AS TanggalAktivitas,
        'Reservasi Layanan' AS JenisAktivitas
    FROM Pelanggan AS p
    INNER JOIN ReservasiLayanan AS rl
        ON p.KodePelanggan = rl.KodePelanggan
) AS Aktivitas
ORDER BY
    Aktivitas.TanggalAktivitas,
    Aktivitas.NamaPelanggan;


/* ============================================================
   PRAKTIKUM 3 - INTERSECT
   ------------------------------------------------------------
   Kebutuhan: Manajemen ingin mengetahui pelanggan yang PERNAH
   MEMBELI PRODUK DAN JUGA PERNAH MELAKUKAN RESERVASI LAYANAN.

   Sesuai teori: INTERSECT menerapkan konsep IRISAN HIMPUNAN
   (intersection) — hanya menampilkan baris data yang MUNCUL
   PADA KEDUA result set (query pertama DAN query kedua sekaligus).
   Cocok untuk menjawab pertanyaan "siapa saja yang ada di kedua
   daftar?" atau "pelanggan mana yang memenuhi kedua kriteria
   sekaligus?".
   ============================================================ */

SELECT
    p.KodePelanggan,
    p.NamaPelanggan
FROM Pelanggan AS p
INNER JOIN Penjualan AS pj
    ON p.KodePelanggan = pj.KodePelanggan

INTERSECT

SELECT
    p.KodePelanggan,
    p.NamaPelanggan
FROM Pelanggan AS p
INNER JOIN ReservasiLayanan AS rl
    ON p.KodePelanggan = rl.KodePelanggan;


/* ============================================================
   PRAKTIKUM 4 - EXCEPT
   ------------------------------------------------------------
   Kebutuhan: Menampilkan pelanggan yang PERNAH MELAKUKAN
   PEMBELIAN TETAPI BELUM PERNAH MELAKUKAN RESERVASI LAYANAN.

   Sesuai teori: EXCEPT menampilkan seluruh baris data yang
   terdapat pada result set PERTAMA tetapi TIDAK terdapat pada
   result set KEDUA. Urutan query berpengaruh: A EXCEPT B tidak
   sama dengan B EXCEPT A. Cocok untuk pertanyaan seperti
   "pelanggan mana yang belum pernah menggunakan layanan?"
   dan bermanfaat untuk proses monitoring/evaluasi.
   ============================================================ */

SELECT
    p.KodePelanggan,
    p.NamaPelanggan
FROM Pelanggan AS p
INNER JOIN Penjualan AS pj
    ON p.KodePelanggan = pj.KodePelanggan

EXCEPT

SELECT
    p.KodePelanggan,
    p.NamaPelanggan
FROM Pelanggan AS p
INNER JOIN ReservasiLayanan AS rl
    ON p.KodePelanggan = rl.KodePelanggan;


/* ============================================================
   PRAKTIKUM 5 - INNER JOIN
   ------------------------------------------------------------
   Kebutuhan: Menampilkan data Penjualan dan Pelanggan.

   Sesuai teori: INNER JOIN hanya menampilkan data yang memiliki
   PASANGAN (matching record) pada KEDUA tabel. Jika suatu baris
   pada salah satu tabel tidak punya pasangan, baris tersebut
   TIDAK ditampilkan sama sekali.
   ============================================================ */

SELECT
    pj.KodePenjualan,
    pj.TanggalPenjualan,
    p.KodePelanggan,
    p.NamaPelanggan,
    pj.MetodeBayar
FROM Penjualan AS pj
INNER JOIN Pelanggan AS p
    ON pj.KodePelanggan = p.KodePelanggan;


/* ============================================================
   PRAKTIKUM 6 - LEFT OUTER JOIN
   ------------------------------------------------------------
   Kebutuhan: Menampilkan seluruh pelanggan dan transaksinya.

   Sesuai teori: LEFT OUTER JOIN menampilkan SELURUH data dari
   tabel KIRI (Pelanggan), beserta data yang punya pasangan di
   tabel KANAN (Penjualan). Jika pelanggan tidak punya pasangan
   transaksi, pelanggan tersebut TETAP ditampilkan, sedangkan
   kolom dari tabel kanan bernilai NULL.
   ============================================================ */

SELECT
    p.KodePelanggan,
    p.NamaPelanggan,
    pj.KodePenjualan,
    pj.TanggalPenjualan,
    pj.MetodeBayar
FROM Pelanggan AS p
LEFT OUTER JOIN Penjualan AS pj
    ON p.KodePelanggan = pj.KodePelanggan
ORDER BY p.KodePelanggan;


/* ============================================================
   PRAKTIKUM 7 - RIGHT OUTER JOIN
   ------------------------------------------------------------
   Kebutuhan: Karena tabel Produk ditempatkan di sebelah kanan,
   seluruh produk harus tetap ditampilkan meskipun belum pernah
   terjual.

   Sesuai teori: RIGHT OUTER JOIN menampilkan SELURUH data dari
   tabel KANAN (Produk), beserta data yang punya pasangan di
   tabel KIRI (DetailPenjualan). Jika produk belum pernah terjual
   (tidak ada pasangan di tabel kiri), produk tetap muncul dan
   kolom dari tabel kiri bernilai NULL.
   ============================================================ */

SELECT
    dp.KodePenjualan,
    dp.Jumlah,
    dp.HargaJual,
    pr.KodeProduk,
    pr.NamaProduk,
    pr.Stok
FROM DetailPenjualan AS dp
RIGHT OUTER JOIN Produk AS pr
    ON dp.KodeProduk = pr.KodeProduk
ORDER BY pr.KodeProduk;


/* ============================================================
   PRAKTIKUM 8 - FULL OUTER JOIN
   ------------------------------------------------------------
   Kebutuhan: Audit pelanggan dan penjualan.

   Sesuai teori: FULL OUTER JOIN menampilkan SELURUH data dari
   KEDUA tabel, baik yang memiliki pasangan maupun yang tidak.
   Merupakan gabungan konsep LEFT OUTER JOIN dan RIGHT OUTER JOIN.
   Kolom dari tabel yang tidak punya pasangan akan bernilai NULL.
   ============================================================ */

SELECT
    p.KodePelanggan,
    p.NamaPelanggan,
    pj.KodePenjualan,
    pj.TanggalPenjualan,
    pj.MetodeBayar
FROM Pelanggan AS p
FULL OUTER JOIN Penjualan AS pj
    ON p.KodePelanggan = pj.KodePelanggan
ORDER BY p.KodePelanggan;


/* ============================================================
   PRAKTIKUM 9 - CROSS JOIN
   ------------------------------------------------------------
   Kebutuhan: Manajemen ingin membentuk seluruh kemungkinan
   kombinasi pegawai dan layanan.

   Sesuai teori: CROSS JOIN menghasilkan seluruh KOMBINASI
   kemungkinan antara setiap baris tabel pertama dengan setiap
   baris tabel kedua (perkalian), TANPA mempertimbangkan relasi
   antar kolom. Jumlah baris hasil = jumlah baris tabel 1 x
   jumlah baris tabel 2.
   ============================================================ */

SELECT
    pg.KodePegawai,
    pg.NamaPegawai,
    l.KodeLayanan,
    l.NamaLayanan,
    l.DurasiMenit
FROM Pegawai AS pg
CROSS JOIN Layanan AS l
ORDER BY pg.KodePegawai, l.KodeLayanan;


/* ============================================================
   PRAKTIKUM 10 - SELF JOIN
   ------------------------------------------------------------
   Sesuai teori: SELF JOIN menghubungkan sebuah tabel dengan
   tabel itu sendiri. SQL Server memperlakukannya seolah ada dua
   salinan tabel berbeda melalui ALIAS. Karena tabel Pegawai pada
   struktur awal belum memiliki kolom relasi supervisor, struktur
   tabel perlu dikembangkan terlebih dahulu.
   ============================================================ */

-- Menambahkan kolom KodeSupervisor pada tabel Pegawai
ALTER TABLE Pegawai
ADD KodeSupervisor CHAR(6) NULL;

-- Menambahkan relasi Foreign Key ke tabel Pegawai itu sendiri
ALTER TABLE Pegawai
ADD CONSTRAINT FK_Pegawai_Supervisor
FOREIGN KEY (KodeSupervisor)
REFERENCES Pegawai(KodePegawai);

-- Query SELF JOIN: memasangkan pegawai dengan nama supervisornya.
-- Tabel Pegawai "digandakan secara logis" melalui alias pg (data
-- utama/pegawai) dan sp (data pembanding/supervisor).
SELECT
    pg.KodePegawai,
    pg.NamaPegawai,
    pg.Jabatan,
    sp.NamaPegawai AS NamaSupervisor
FROM Pegawai AS pg
LEFT OUTER JOIN Pegawai AS sp
    ON pg.KodeSupervisor = sp.KodePegawai;


/* ============================================================
   PRAKTIKUM 11 - MULTIPLE JOIN
   ------------------------------------------------------------
   Kebutuhan: Laporan detail penjualan lengkap dengan
   menggabungkan 6 tabel: Pelanggan, Penjualan, Pegawai,
   DetailPenjualan, Produk, KategoriProduk.

   Sesuai teori: JOIN menggabungkan informasi dari BEBERAPA
   TABEL berdasarkan relasi antar kolom (PK-FK), sehingga jumlah
   kolom hasil bisa bertambah karena mengambil kolom dari banyak
   tabel sekaligus.
   Catatan dari modul: query ini menganggap Diskon sebagai NILAI
   NOMINAL. Apabila Diskon dimaksudkan sebagai PERSENTASE, rumus
   Subtotal perlu diubah.
   ============================================================ */

SELECT
    pj.KodePenjualan,
    pj.TanggalPenjualan,
    p.KodePelanggan,
    p.NamaPelanggan,
    pg.NamaPegawai,
    pr.KodeProduk,
    pr.NamaProduk,
    kp.NamaKategori,
    dp.Jumlah,
    dp.HargaJual,
    dp.Diskon,
    dp.Jumlah * dp.HargaJual AS TotalKotor,
    dp.Jumlah * dp.HargaJual - dp.Diskon AS Subtotal
FROM Penjualan AS pj
INNER JOIN Pelanggan AS p
    ON pj.KodePelanggan = p.KodePelanggan
INNER JOIN Pegawai AS pg
    ON pj.KodePegawai = pg.KodePegawai
INNER JOIN DetailPenjualan AS dp
    ON pj.KodePenjualan = dp.KodePenjualan
INNER JOIN Produk AS pr
    ON dp.KodeProduk = pr.KodeProduk
INNER JOIN KategoriProduk AS kp
    ON pr.KodeKategori = kp.KodeKategori
ORDER BY
    pj.TanggalPenjualan,
    pj.KodePenjualan,
    pr.NamaProduk;
-- ORDER BY adalah perintah untuk mengurutkan hasil query, berdasarkan kolom yang kamu tentukan.
-- Laporan reservasi layanan lengkap: menghubungkan 5 tabel
-- (ReservasiLayanan, Pelanggan, Hewan, Layanan, Pegawai)
SELECT
    rl.KodeReservasi,
    rl.TanggalReservasi,
    rl.JamReservasi,
    p.NamaPelanggan,
    h.NamaHewan,
    h.JenisHewan,
    h.Ras,
    l.NamaLayanan,
    l.HargaLayanan,
    l.DurasiMenit,
    pg.NamaPegawai,
    rl.StatusReservasi
FROM ReservasiLayanan AS rl
INNER JOIN Pelanggan AS p
    ON rl.KodePelanggan = p.KodePelanggan
INNER JOIN Hewan AS h
    ON rl.KodeHewan = h.KodeHewan
INNER JOIN Layanan AS l
    ON rl.KodeLayanan = l.KodeLayanan
INNER JOIN Pegawai AS pg
    ON rl.KodePegawai = pg.KodePegawai
ORDER BY
    rl.TanggalReservasi,
    rl.JamReservasi;
-- ORDER BY adalah perintah untuk mengurutkan hasil query, berdasarkan kolom yang kamu tentukan.

/* ============================================================
   PRAKTIKUM 12 - JOIN DENGAN FUNGSI AGREGASI
   ------------------------------------------------------------
   JOIN tidak hanya dipakai untuk menampilkan data mentah, tapi
   juga bisa dikombinasikan dengan fungsi agregasi (SUM, dsb)
   dan GROUP BY untuk menghasilkan laporan ringkasan.
   ============================================================ */

-- Total nilai setiap transaksi
SELECT
    pj.KodePenjualan,
    pj.TanggalPenjualan,
    p.NamaPelanggan,
    SUM(dp.Jumlah * dp.HargaJual - dp.Diskon) AS TotalPenjualan
FROM Penjualan AS pj
INNER JOIN Pelanggan AS p
    ON pj.KodePelanggan = p.KodePelanggan
INNER JOIN DetailPenjualan AS dp
    ON pj.KodePenjualan = dp.KodePenjualan
GROUP BY
    pj.KodePenjualan,
    pj.TanggalPenjualan,
    p.NamaPelanggan
ORDER BY pj.TanggalPenjualan;

-- Produk terlaris (diurutkan dari yang paling banyak terjual)
SELECT
    pr.KodeProduk,
    pr.NamaProduk,
    SUM(dp.Jumlah) AS TotalTerjual
FROM Produk AS pr
INNER JOIN DetailPenjualan AS dp
    ON pr.KodeProduk = dp.KodeProduk
GROUP BY
    pr.KodeProduk,
    pr.NamaProduk
ORDER BY TotalTerjual DESC;
-- ORDER BY adalah perintah untuk mengurutkan hasil query, berdasarkan kolom yang kamu tentukan.
-- GROUP BY adalah perintah untuk mengelompokkan baris-baris data yang punya nilai sama pada satu atau beberapa kolom, supaya bisa dihitung/diringkas jadi satu baris per kelompok — biasanya dipakai bareng fungsi agregasi seperti SUM, COUNT, AVG, MAX, MIN.

/* ============================================================
   DAFTAR ALIAS TABEL - DB_Petshop
   ============================================================
   p   = Pelanggan           -> Data pelanggan
   pj  = Penjualan           -> Data transaksi penjualan
   pg  = Pegawai             -> Data pegawai
   pr  = Produk              -> Data produk
   rl  = ReservasiLayanan    -> Data reservasi layanan (grooming, dll)
   h   = Hewan               -> Data hewan peliharaan pelanggan
   l   = Layanan             -> Data jenis layanan (grooming, potong kuku, dll)
   kp  = KategoriProduk      -> Data kategori/jenis produk
   dp  = DetailPenjualan     -> Rincian item per transaksi penjualan
   sp  = Pegawai (alias ke-2)-> Khusus SELF JOIN, mewakili "Supervisor Pegawai"
   ============================================================ */