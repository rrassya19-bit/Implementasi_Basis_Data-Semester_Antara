/* =========================================================================================================
   CASE Expression, Set Operator (UNION, UNION ALL, INTERSECT, EXCEPT), SQL JOIN (INNER, LEFT, RIGHT, FULL)
   ========================================================================================================= */
 

/* ============================================================
   PRAKTIKUM 1 - UNION (Daftar pelanggan unik yang pernah membeli produk atau melakukan reservasi layanan)
   ============================================================ */
/* 
UNION menggabungkan dua atau lebih result set
menjadi satu result set baru dengan MENGHILANGKAN DATA DUPLIKAT.
Jika ada baris yang sama persis pada kedua query, hanya
ditampilkan satu kali pada hasil akhir 

INNER JOIN : Ini adalah perintah yang memberi tahu SQL Server: "gabungkan dua tabel ini, tapi cuma ambil baris yang punya pasangan di kedua tabel."Kalau nggak ada pasangannya, baris itu dibuang, nggak ditampilkan sama sekali.
ON : Ini adalah syarat pencocokan — kolom mana yang harus sama nilainya supaya dua baris dianggap "berjodoh" dan digabung
*/ 

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


/* ============================================================
   PRAKTIKUM 1 - UNION (versi dengan keterangan aktivitas)
   ============================================================ */
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
   PRAKTIKUM 2 - UNION ALL (Seluruh aktivitas pelanggan, termasuk transaksi/reservasi berulang)
   ============================================================ */
/* 
UNION ALL menggabungkan dua atau lebih result set TANPA menghapus data duplikat. 
Semua baris ditampilkan apa adanya. Cocok dipakai ketika seluruh data harus ditampilkan,
duplikat diperbolehkan, dan performa query menjadi prioritas
(karena tidak perlu proses pengecekan duplikat).
*/ 

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


/* ============================================================
   PRAKTIKUM 2 - UNION ALL (Mengurutkan hasil)
   ============================================================ */
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
   Pelanggan yang pernah membeli produk DAN pernah reservasi layanan
   ============================================================ */
/*
INTERSECT menerapkan konsep IRISAN HIMPUNAN
(intersection) — hanya menampilkan baris data yang MUNCUL
PADA KEDUA result set (query pertama DAN query kedua sekaligus).
Cocok untuk menjawab pertanyaan "siapa saja yang ada di kedua
daftar?" atau "pelanggan mana yang memenuhi kedua kriteria sekaligus?".
*/

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
   Pelanggan yang pernah membeli produk TAPI belum pernah reservasi layanan
   ============================================================ */
/*
   EXCEPT menampilkan seluruh baris data yang
   terdapat pada result set PERTAMA tetapi TIDAK terdapat pada
   result set KEDUA. Urutan query berpengaruh: A EXCEPT B tidak
   sama dengan B EXCEPT A. Cocok untuk pertanyaan seperti
   "pelanggan mana yang belum pernah menggunakan layanan?"
   dan bermanfaat untuk proses monitoring/evaluasi.
*/

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
   Penjualan dan pelanggan
   ============================================================ */
/*
INNER JOIN hanya menampilkan data yang memiliki
PASANGAN (matching record) pada KEDUA tabel. Jika suatu baris
pada salah satu tabel tidak punya pasangan, baris tersebut
TIDAK ditampilkan sama sekali
*/

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
   Seluruh pelanggan dan transaksi
   ============================================================ */
/*
LEFT OUTER JOIN menampilkan SELURUH data dari
   tabel KIRI (Pelanggan), beserta data yang punya pasangan di
   tabel KANAN (Penjualan). Jika pelanggan tidak punya pasangan
   transaksi, pelanggan tersebut TETAP ditampilkan, sedangkan
   kolom dari tabel kanan bernilai NULL.
*/

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
   Karena tabel Produk di sebelah kanan, semua produk ditampilkan
   ============================================================ */
/*
RIGHT OUTER JOIN menampilkan SELURUH data dari
   tabel KANAN (Produk), beserta data yang punya pasangan di
   tabel KIRI (DetailPenjualan). Jika produk belum pernah terjual
   (tidak ada pasangan di tabel kiri), produk tetap muncul dan
   kolom dari tabel kiri bernilai NULL.
*/

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
   Audit pelanggan dan penjualan
   ============================================================ */
/*
FULL OUTER JOIN menampilkan SELURUH data dari
   KEDUA tabel, baik yang memiliki pasangan maupun yang tidak.
   Merupakan gabungan konsep LEFT OUTER JOIN dan RIGHT OUTER JOIN.
   Kolom dari tabel yang tidak punya pasangan akan bernilai NULL.
*/

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
   Seluruh kemungkinan kombinasi pegawai dan layanan
   ============================================================ */
/*
ROSS JOIN menghasilkan seluruh KOMBINASI
   kemungkinan antara setiap baris tabel pertama dengan setiap
   baris tabel kedua (perkalian), TANPA mempertimbangkan relasi
   antar kolom. Jumlah baris hasil = jumlah baris tabel 1 x
   jumlah baris tabel 2.
*/

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
   Persiapan struktur tabel: tambah kolom KodeSupervisor
   ============================================================ */
/*
SELF JOIN menghubungkan sebuah tabel dengan
   tabel itu sendiri. SQL Server memperlakukannya seolah ada dua
   salinan tabel berbeda melalui ALIAS. Karena tabel Pegawai pada
   struktur awal belum memiliki kolom relasi supervisor, struktur
   tabel perlu dikembangkan terlebih dahulu.
*/
ALTER TABLE Pegawai
ADD KodeSupervisor CHAR(6) NULL;

ALTER TABLE Pegawai
ADD CONSTRAINT FK_Pegawai_Supervisor
FOREIGN KEY (KodeSupervisor)
REFERENCES Pegawai(KodePegawai);
GO 

-- Query supervisor (SELF JOIN)
SELECT
    pg.KodePegawai,
    pg.NamaPegawai,
    pg.Jabatan,
    sp.NamaPegawai AS NamaSupervisor
FROM Pegawai AS pg
LEFT OUTER JOIN Pegawai AS sp
    ON pg.KodeSupervisor = sp.KodePegawai;


/* ============================================================
   PRAKTIKUM 11 - Multiple JOIN
   Laporan detail penjualan lengkap (6 tabel)
   ============================================================ */
/*
JOIN menggabungkan informasi dari BEBERAPA
   TABEL berdasarkan relasi antar kolom (PK-FK), sehingga jumlah
   kolom hasil bisa bertambah karena mengambil kolom dari banyak
   tabel sekaligus.
   Catatan dari modul: query ini menganggap Diskon sebagai NILAI
   NOMINAL. Apabila Diskon dimaksudkan sebagai PERSENTASE, rumus
   Subtotal perlu diubah.
*/

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


/* ============================================================
   PRAKTIKUM 11 - Laporan reservasi layanan lengkap (5 tabel)
   ============================================================ */
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


/* ============================================================
   PRAKTIKUM 12 - JOIN dengan Fungsi Agregasi
   Total nilai setiap transaksi
   ============================================================ */
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


/* ============================================================
   PRAKTIKUM 12 - Produk terlaris
   ============================================================ */
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