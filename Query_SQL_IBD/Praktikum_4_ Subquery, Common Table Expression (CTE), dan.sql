-- ============================================================
-- PRAKTIKUM 4
-- Subquery, Common Table Expression (CTE), dan Window Function
-- ============================================================


-- ============================================================
-- Praktikum 1 - Scalar Subquery
-- ============================================================

-- 1. Menghitung Rata-Rata Harga
SELECT AVG(Harga) AS RataRataHarga
FROM Produk;
-- AVG adalah fungsi agregasi di SQL untuk menghitung nilai rata-rata dari sekumpulan angka pada suatu kolom.


-- 2. Produk dengan Harga di Atas Rata-Rata
SELECT
    KodeProduk,
    NamaProduk,
    Harga,
    Stok
FROM Produk
WHERE Harga >
(
    SELECT AVG(Harga)
    FROM Produk
)
ORDER BY Harga DESC;
-- AVG adalah fungsi agregasi di SQL untuk menghitung nilai rata-rata dari sekumpulan angka pada suatu kolom.
-- ORDER BY Harga DESC = untuk mengurutkan hasil query berdasarkan kolom Harga, dari yang paling besar ke paling kecil (descending / menurun).


-- 3. Menampilkan Rata-Rata sebagai Kolom Tambahan
SELECT
    KodeProduk,
    NamaProduk,
    Harga,
    (
        SELECT AVG(Harga)
        FROM Produk
    ) AS RataRataHarga
FROM Produk
ORDER BY Harga DESC;
-- AVG adalah fungsi agregasi di SQL untuk menghitung nilai rata-rata dari sekumpulan angka pada suatu kolom.
-- ORDER BY Harga DESC = untuk mengurutkan hasil query berdasarkan kolom Harga, dari yang paling besar ke paling kecil (descending / menurun).


-- 4. Menampilkan Selisih Harga
SELECT
    KodeProduk,
    NamaProduk,
    Harga,
    (
        SELECT AVG(Harga)
        FROM Produk
    ) AS RataRataHarga,
    Harga -
    (
        SELECT AVG(Harga)
        FROM Produk
    ) AS SelisihHarga
FROM Produk
ORDER BY SelisihHarga DESC;
-- AVG adalah fungsi agregasi di SQL untuk menghitung nilai rata-rata dari sekumpulan angka pada suatu kolom.
-- ORDER BY Harga DESC = untuk mengurutkan hasil query berdasarkan kolom SelisihHarga, dari yang paling besar ke paling kecil (descending / menurun).



-- ============================================================
-- Praktikum 2 - Multiple-Row Subquery
-- ============================================================

-- 1. Daftar Kode Pelanggan dalam Penjualan
SELECT DISTINCT KodePelanggan
FROM Penjualan;
-- SELECT DISTINCT itu adalah perintah untuk mengambil data tanpa duplikat — kalau ada nilai yang sama muncul berkali-kali, cuma ditampilkan satu kali saja.


-- 2. Pelanggan yang Pernah Bertransaksi
SELECT
    KodePelanggan,
    NamaPelanggan,
    Alamat,
    NoHP
FROM Pelanggan
WHERE KodePelanggan IN
(
    SELECT KodePelanggan
    FROM Penjualan
)
ORDER BY NamaPelanggan;
-- ORDER BY NamaPelanggan = untuk mengurutkan hasil query berdasarkan kolom NamaPelanggan, dari yang huruf paling besar ke paling kecil (descending / menurun). (A - Z)


-- 3. Pelanggan yang Belum Pernah Bertransaksi
SELECT
    KodePelanggan,
    NamaPelanggan,
    Alamat,
    NoHP
FROM Pelanggan
WHERE KodePelanggan NOT IN
(
    SELECT KodePelanggan
    FROM Penjualan
)
ORDER BY NamaPelanggan;
-- ORDER BY NamaPelanggan = untuk mengurutkan hasil query berdasarkan kolom NamaPelanggan, dari yang huruf paling besar ke paling kecil (descending / menurun). (A - Z)


-- 4. Produk yang Pernah Terjual
SELECT
    KodeProduk,
    NamaProduk,
    Harga,
    Stok
FROM Produk
WHERE KodeProduk IN
(
    SELECT KodeProduk
    FROM DetailPenjualan
)
ORDER BY NamaProduk;
-- ORDER BY NamaProduk = untuk mengurutkan hasil query berdasarkan kolom NamaProduk, dari yang huruf paling besar ke paling kecil (descending / menurun). (A - Z)


-- 5. Produk yang Belum Pernah Terjual
SELECT
    KodeProduk,
    NamaProduk,
    Harga,
    Stok
FROM Produk
WHERE KodeProduk NOT IN
(
    SELECT KodeProduk
    FROM DetailPenjualan
)
ORDER BY NamaProduk;
-- ORDER BY NamaProduk = untuk mengurutkan hasil query berdasarkan kolom NamaProduk, dari yang huruf paling besar ke paling kecil (descending / menurun). (A - Z)


-- 6. Pelanggan yang Pernah Membeli dan Melakukan Reservasi
SELECT
    KodePelanggan,
    NamaPelanggan
FROM Pelanggan
WHERE KodePelanggan IN
(
    SELECT KodePelanggan
    FROM Penjualan
)
AND KodePelanggan IN
(
    SELECT KodePelanggan
    FROM ReservasiLayanan
);



-- ============================================================
-- Praktikum 3 - EXISTS dan NOT EXISTS
-- ============================================================

-- 1. Pelanggan yang Memiliki Hewan
SELECT
    p.KodePelanggan,
    p.NamaPelanggan
FROM Pelanggan AS p
WHERE EXISTS
(
    SELECT 1
    FROM Hewan AS h
    WHERE h.KodePelanggan = p.KodePelanggan
);
-- WHERE EXISTS itu cara memeriksa apakah subquery menghasilkan minimal satu baris atau tidak. Kalau ada (minimal 1 baris), kondisinya dianggap TRUE dan baris itu ditampilkan. Kalau kosong (tidak ada baris sama sekali), dianggap FALSE dan tidak ditampilkan.
-- h.KodePelanggan = p.KodePelanggan ini adalah kondisi penghubung (correlation condition) antara subquery dan tabel luar. Ini yang bikin subquery-nya jadi correlated subquery — subquery yang "nyambung" ke tabel di luar dirinya.


-- 2. Pelanggan yang Tidak Memiliki Hewan
SELECT
    p.KodePelanggan,
    p.NamaPelanggan
FROM Pelanggan AS p
WHERE NOT EXISTS
(
    SELECT 1
    FROM Hewan AS h
    WHERE h.KodePelanggan = p.KodePelanggan
);
-- WHERE NOT EXISTS itu adalah menampilkan baris di mana subquery-nya tidak menghasilkan apa-apa (kosong, tidak ada baris yang cocok).
-- h.KodePelanggan = p.KodePelanggan ini adalah kondisi penghubung (correlation condition) antara subquery dan tabel luar. Ini yang bikin subquery-nya jadi correlated subquery — subquery yang "nyambung" ke tabel di luar dirinya.

-- 3. Produk yang Pernah Terjual
SELECT
    pr.KodeProduk,
    pr.NamaProduk,
    pr.Harga
FROM Produk AS pr
WHERE EXISTS
(
    SELECT 1
    FROM DetailPenjualan AS dp
    WHERE dp.KodeProduk = pr.KodeProduk
);
-- WHERE NOT EXISTS itu adalah menampilkan baris di mana subquery-nya tidak menghasilkan apa-apa (kosong, tidak ada baris yang cocok).
-- dp.KodeProduk = pr.KodeProduk ini adalah kondisi penghubung (correlation condition) antara subquery dan tabel luar. Ini yang bikin subquery-nya jadi correlated subquery — subquery yang "nyambung" ke tabel di luar dirinya.



-- ============================================================
-- Praktikum 4 - Correlated Subquery
-- ============================================================

-- 1. Menghitung rata-rata yang berbeda untuk setiap kategori produk
SELECT
    pr.KodeProduk,
    pr.NamaProduk,
    pr.KodeKategori,
    pr.Harga
FROM Produk AS pr
WHERE pr.Harga >
(
    SELECT AVG(pr2.Harga)
    FROM Produk AS pr2
    WHERE pr2.KodeKategori = pr.KodeKategori
)
ORDER BY pr.KodeKategori, pr.Harga DESC;
-- AVG adalah fungsi agregasi di SQL untuk menghitung nilai rata-rata dari sekumpulan angka pada suatu kolom.
-- pr2.KodeKategori = pr.KodeKategori ini adalah kondisi penghubung (correlation condition) antara subquery dan tabel luar. Ini yang bikin subquery-nya jadi correlated subquery — subquery yang "nyambung" ke tabel di luar dirinya.
-- ORDER BY pr.KodeKategori, pr.Harga DESC adalah Mengurutkan hasil query bertingkat dua level:
-- 1. Diurutkan dulu berdasarkan pr.KodeKategori secara ascending (default ASC, A-Z / kecil ke besar)
-- 2. Di dalam kategori yang sama, diurutkan lagi berdasarkan pr.Harga secara descending (DESC, harga termahal ke termurah)


-- 2. Menampilkan Rata-Rata Kategori
SELECT
    pr.KodeProduk,
    pr.NamaProduk,
    pr.KodeKategori,
    pr.Harga,
    (
        SELECT AVG(pr2.Harga)
        FROM Produk AS pr2
        WHERE pr2.KodeKategori = pr.KodeKategori
    ) AS RataRataHargaKategori
FROM Produk AS pr
ORDER BY pr.KodeKategori, pr.Harga DESC;
-- pr2.KodeKategori = pr.KodeKategori ini adalah kondisi penghubung (correlation condition) antara subquery dan tabel luar. Ini yang bikin subquery-nya jadi correlated subquery — subquery yang "nyambung" ke tabel di luar dirinya.
-- ORDER BY pr.KodeKategori, pr.Harga DESC adalah Mengurutkan hasil query bertingkat dua level:
-- 1. Diurutkan dulu berdasarkan pr.KodeKategori secara ascending (default ASC, A-Z / kecil ke besar)
-- 2. Di dalam kategori yang sama, diurutkan lagi berdasarkan pr.Harga secara descending (DESC, harga termahal ke termurah)


-- 3. Pelanggan dengan Lebih dari Satu Hewan
SELECT
    p.KodePelanggan,
    p.NamaPelanggan
FROM Pelanggan AS p
WHERE
(
    SELECT COUNT(*)
    FROM Hewan AS h
    WHERE h.KodePelanggan = p.KodePelanggan
) > 1;
-- COUNT(*) itu fungsi agregasi untuk menghitung jumlah baris.



-- ============================================================
-- Praktikum 5 - CTE Dasar
-- ============================================================

-- 1. Daftar Produk dan Kategori
WITH DataProduk AS
(
    SELECT
        pr.KodeProduk,
        pr.NamaProduk,
        kp.NamaKategori,
        pr.Harga,
        pr.Stok
    FROM Produk AS pr
    INNER JOIN KategoriProduk AS kp
        ON pr.KodeKategori = kp.KodeKategori
)
SELECT
    KodeProduk,
    NamaProduk,
    NamaKategori,
    Harga,
    Stok
FROM DataProduk
ORDER BY NamaKategori, NamaProduk;
-- INNER JOIN itu perintah untuk menggabungkan dua tabel berdasarkan kolom yang berhubungan, dan hanya menampilkan baris yang punya pasangan cocok di kedua tabel.
-- ON pr.KodeKategori = kp.KodeKategori = Syarat penggabungan (join condition) untuk INNER JOIN, mencocokkan baris dari tabel Produk (pr) dan KategoriProduk (kp) yang nilai KodeKategori-nya sama

-- ORDER BY NamaKategori, NamaProduk adalah Mengurutkan hasil query bertingkat dua level (keduanya default ASC, A-Z):
-- 1. Diurutkan dulu berdasarkan NamaKategori
-- 2. Di dalam kategori yang sama, diurutkan lagi berdasarkan NamaProduk


-- 2. Produk dengan Harga di Atas Rata-Rata
WITH RataRataProduk AS
(
    SELECT AVG(Harga) AS RataRataHarga
    FROM Produk
)
SELECT
    pr.KodeProduk,
    pr.NamaProduk,
    pr.Harga,
    rr.RataRataHarga,
    pr.Harga - rr.RataRataHarga AS SelisihHarga
FROM Produk AS pr
CROSS JOIN RataRataProduk AS rr
WHERE pr.Harga > rr.RataRataHarga
ORDER BY pr.Harga DESC;
-- CROSS JOIN RataRataProduk AS rr adalah Menggabungkan tabel Produk (pr) dengan CTE RataRataProduk (rr) tanpa syarat ON, karena RataRataProduk cuma punya SATU baris (hasil AVG keseluruhan), setiap baris di Produk otomatis "dipasangkan" dengan nilai rata-rata itu (bukan mengalikan jumlah baris)
-- WHERE pr.Harga > rr.RataRataHarga adalah Menyaring baris: hanya produk yang harganya (pr.Harga) lebih besar dari rata-rata harga (rr.RataRataHarga) yang ditampilkan
-- ORDER BY pr.Harga DESC adalah Mengurutkan hasil dari harga termahal ke termurah (descending)



-- ============================================================
-- Praktikum 6 - CTE dengan Agregasi
-- ============================================================

-- 1. Total Setiap Transaksi
WITH TotalTransaksi AS
(
    SELECT
        dp.KodePenjualan,
        SUM((dp.Jumlah * dp.HargaJual) - dp.Diskon) AS TotalPenjualan
    FROM DetailPenjualan AS dp
    GROUP BY dp.KodePenjualan
)
SELECT
    pj.KodePenjualan,
    pj.TanggalPenjualan,
    p.NamaPelanggan,
    pg.NamaPegawai,
    tt.TotalPenjualan,
    pj.MetodeBayar
FROM TotalTransaksi AS tt
INNER JOIN Penjualan AS pj
    ON tt.KodePenjualan = pj.KodePenjualan
INNER JOIN Pelanggan AS p
    ON pj.KodePelanggan = p.KodePelanggan
INNER JOIN Pegawai AS pg
    ON pj.KodePegawai = pg.KodePegawai
ORDER BY tt.TotalPenjualan DESC;
-- INNER JOIN itu perintah untuk menggabungkan dua tabel berdasarkan kolom yang berhubungan, dan hanya menampilkan baris yang punya pasangan cocok di kedua tabel.
-- SUM(...) itu adalah fungsi agregasi untuk menjumlahkan nilai-nilai dari sekumpulan baris jadi satu total. Bedanya dengan AVG yang menghitung rata-rata, SUM menjumlahkan semuanya.
-- ORDER BY tt.TotalPenjualan DESC adalah Mengurutkan hasil query berdasarkan kolom TotalPenjualan (dari CTE TotalTransaksi, alias tt) secara descending, dari nilai penjualan TERBESAR ke terkecil


-- 2. Total Pembelian Setiap Pelanggan
WITH TotalTransaksi AS
(
    SELECT
        dp.KodePenjualan,
        SUM((dp.Jumlah * dp.HargaJual) - dp.Diskon) AS TotalPenjualan
    FROM DetailPenjualan AS dp
    GROUP BY dp.KodePenjualan
),
TotalPelanggan AS
(
    SELECT
        pj.KodePelanggan,
        COUNT(pj.KodePenjualan) AS JumlahTransaksi,
        SUM(tt.TotalPenjualan) AS TotalPembelian
    FROM Penjualan AS pj
    INNER JOIN TotalTransaksi AS tt
        ON pj.KodePenjualan = tt.KodePenjualan
    GROUP BY pj.KodePelanggan
)
SELECT
    p.KodePelanggan,
    p.NamaPelanggan,
    COALESCE(tp.JumlahTransaksi, 0) AS JumlahTransaksi,
    COALESCE(tp.TotalPembelian, 0) AS TotalPembelian
FROM Pelanggan AS p
LEFT JOIN TotalPelanggan AS tp
    ON p.KodePelanggan = tp.KodePelanggan
ORDER BY TotalPembelian DESC;
-- INNER JOIN itu perintah untuk menggabungkan dua tabel berdasarkan kolom yang berhubungan, dan hanya menampilkan baris yang punya pasangan cocok di kedua tabel.
-- SUM((dp.Jumlah * dp.HargaJual) - dp.Diskon) AS TotalPenjualan adalah  Menghitung total bersih per baris detail penjualan (jumlah x harga jual, dikurangi diskon), lalu dijumlahkan menjadi satu nilai TotalPenjualan (sudah dibahas sebelumnya)
-- GROUP BY dp.KodePenjualan adalah Mengelompokkan baris-baris DetailPenjualan berdasarkan KodePenjualan, supaya SUM di atas dihitung PER TRANSAKSI, bukan dijumlahkan semua sekaligus
-- COUNT(pj.KodePenjualan) AS JumlahTransaksi adalah Menghitung ADA BERAPA baris/transaksi penjualan (dari tabel Penjualan, alias pj) untuk tiap kelompok (di sini dikelompokkan per pelanggan) → hasilnya jumlah transaksi
-- SUM(tt.TotalPenjualan) AS TotalPembelian adalah Menjumlahkan kolom TotalPenjualan dari CTE TotalTransaksi (alias tt) yang sudah dihitung sebelumnya, lalu dijumlahkan lagi per pelanggan → hasilnya total belanja keseluruhan pelanggan itu
-- LEFT JOIN artinya: semua baris dari tabel kiri (Pelanggan, karena ditulis duluan sebelum kata JOIN) tetap ditampilkan, walaupun tidak ada pasangannya di tabel kanan (TotalPelanggan). Kalau tidak ketemu pasangan, kolom-kolom dari tabel kanan diisi NULL
-- COALESCE itu fungsi untuk mengganti nilai NULL dengan nilai default yang kamu tentukan
-- ON p.KodePelanggan = tp.KodePelanggan adalah Syarat penggabungan untuk LEFT JOIN, mencocokkan baris tabel Pelanggan (p) dengan CTE TotalPelanggan (tp) berdasarkan kesamaan KodePelanggan. Karena LEFT JOIN, kalau pelanggan tidak punya pasangan di tp (belum pernah belanja), baris pelanggan tetap muncul dengan kolom dari tp bernilai NULL
-- ORDER BY TotalPembelian DESC adalah Mengurutkan hasil akhir berdasarkan kolom TotalPembelian (yang sudah dibersihkan pakai COALESCE sebelumnya), dari nilai pembelian TERBESAR ke terkecil. Pelanggan yang belum pernah belanja (TotalPembelian = 0) akan muncul di bagian bawah



-- ============================================================
-- Praktikum 7 - CTE untuk Audit Data
-- ============================================================

-- 1. Produk yang Belum Pernah Terjual
WITH ProdukTerjual AS
(
    SELECT DISTINCT KodeProduk
    FROM DetailPenjualan
)
SELECT
    pr.KodeProduk,
    pr.NamaProduk,
    pr.Harga,
    pr.Stok
FROM Produk AS pr
LEFT JOIN ProdukTerjual AS pt
    ON pr.KodeProduk = pt.KodeProduk
WHERE pt.KodeProduk IS NULL;
-- LEFT JOIN artinya: semua baris dari tabel kiri (Pelanggan, karena ditulis duluan sebelum kata JOIN) tetap ditampilkan, walaupun tidak ada pasangannya di tabel kanan (TotalPelanggan). Kalau tidak ketemu pasangan, kolom-kolom dari tabel kanan diisi NULL
-- SELECT DISTINCT KodeProduk adalah mengambil daftar KodeProduk yang unik (tanpa duplikat) dari tabel DetailPenjualan
-- WHERE pt.KodeProduk IS NULL adalah Menyaring baris: hanya menampilkan produk yang TIDAK punya pasangan di CTE ProdukTerjual (karena LEFT JOIN, produk yang belum pernah terjual akan punya pt.KodeProduk = NULL) Artinya: hasil akhirnya adalah produk yang BELUM PERNAH terjual
-- ON pr.KodeProduk = pt.KodeProduk adlah Syarat penggabungan untuk LEFT JOIN, mencocokkan baris tabel Produk (pr) dengan CTE ProdukTerjual (pt) berdasarkan kesamaan KodeProduk. Karena LEFT JOIN, produk yang tidak punya pasangan di pt (belum pernah terjual) tetap muncul, dengan kolom dari pt bernilai NULL

-- 2. Riwayat Audit Produk
WITH RiwayatAudit AS
(
    SELECT
        a.KodeAudit,
        a.KodeProduk,
        a.TanggalAudit,
        a.StokSebelum,
        a.StokSesudah,
        a.StokSesudah - a.StokSebelum AS PerubahanStok,
        a.Keterangan
    FROM AuditStok AS a
)
SELECT
    ra.KodeAudit,
    pr.NamaProduk,
    ra.TanggalAudit,
    ra.StokSebelum,
    ra.StokSesudah,
    ra.PerubahanStok,
    ra.Keterangan
FROM RiwayatAudit AS ra
INNER JOIN Produk AS pr
    ON ra.KodeProduk = pr.KodeProduk
ORDER BY ra.TanggalAudit DESC;
-- INNER JOIN Produk AS pr adalah Menggabungkan hasil CTE RiwayatAudit (ra) dengan tabel Produk (pr), karena NamaProduk yang mau ditampilkan hanya ada di tabel Produk
-- ON ra.KodeProduk = pr.KodeProduk adalah Syarat penggabungan: mencocokkan baris RiwayatAudit dan Produk yang KodeProduk-nya sama. Karena INNER JOIN, catatan audit untuk produk yang sudah tidak ada di tabel Produk (misal sudah dihapus) tidak akan muncul di hasil akhir
-- ORDER BY ra.TanggalAudit DESC adalah Mengurutkan hasil dari tanggal audit TERBARU ke TERLAMA (descending)



-- ============================================================
-- Praktikum 8 - Fungsi Agregasi dengan OVER
-- ============================================================

-- 1. Total Stok Seluruh Produk
SELECT
    KodeProduk,
    NamaProduk,
    Stok,
    SUM(Stok) OVER () AS TotalSeluruhStok
FROM Produk
ORDER BY KodeProduk;
-- SUM(Stok) OVER () AS TotalSeluruhStok adalah Window Function: menghitung total SELURUH Stok dari semua baris tabel Produk, tapi TETAP menampilkan setiap baris produk secara individual (tidak diringkas seperti SUM + GROUP BY biasa). Tanda kurung kosong OVER () artinya dihitung dari seluruh tabel, tanpa dikelompokkan. Nilai TotalSeluruhStok akan SAMA di setiap baris


-- 2. Agregasi Berdasarkan Kategori
SELECT
    pr.KodeProduk,
    pr.NamaProduk,
    kp.NamaKategori,
    pr.Harga,
    AVG(pr.Harga) OVER
    (
        PARTITION BY pr.KodeKategori
    ) AS RataRataHargaKategori,
    SUM(pr.Stok) OVER
    (
        PARTITION BY pr.KodeKategori
    ) AS TotalStokKategori
FROM Produk AS pr
INNER JOIN KategoriProduk AS kp
    ON pr.KodeKategori = kp.KodeKategori
ORDER BY kp.NamaKategori, pr.Harga DESC;
-- AVG(pr.Harga) OVER (PARTITION BY pr.KodeKategori) AS RataRataHargaKategori
-- Window Function: menghitung rata-rata Harga, tapi dipecah per kelompok KodeKategori
-- (PARTITION BY = mirip GROUP BY, tapi tetap menampilkan semua baris asli, tidak diringkas). Setiap produk akan menampilkan rata-rata harga KATEGORINYA sendiri, bukan rata-rata seluruh tabel

-- SUM(pr.Stok) OVER (PARTITION BY pr.KodeKategori) AS TotalStokKategori
-- Window Function: menghitung total Stok, juga dipecah per kelompok KodeKategori.
-- Setiap produk akan menampilkan total stok KATEGORINYA sendiri (bukan total seluruh produk)

-- INNER JOIN KategoriProduk AS kp
-- Menggabungkan tabel Produk (pr) dengan tabel KategoriProduk (kp),
-- karena NamaKategori yang mau ditampilkan hanya ada di tabel KategoriProduk

-- ON pr.KodeKategori = kp.KodeKategori
-- Syarat penggabungan: mencocokkan baris Produk dan KategoriProduk yang KodeKategori-nya sama

-- ORDER BY kp.NamaKategori, pr.Harga DESC;
-- Mengurutkan hasil bertingkat dua level:
-- 1. Diurutkan dulu berdasarkan NamaKategori (default ASC, A-Z)
-- 2. Di dalam kategori yang sama, diurutkan lagi berdasarkan Harga dari termahal ke termurah (DESC)


-- 3. Perbandingan GROUP BY dan OVER
-- Menggunakan GROUP BY
SELECT
    KodeKategori,
    AVG(Harga) AS RataRataHarga
FROM Produk
GROUP BY KodeKategori;

-- Menggunakan OVER
SELECT
    KodeProduk,
    NamaProduk,
    KodeKategori,
    Harga,
    AVG(Harga) OVER
    (
        PARTITION BY KodeKategori
    ) AS RataRataHargaKategori
FROM Produk;
-- AVG(Harga) AS RataRataHarga
-- Menghitung rata-rata Harga (fungsi agregasi biasa)

-- GROUP BY KodeKategori
-- Mengelompokkan baris berdasarkan KodeKategori, sehingga AVG dihitung PER KATEGORI.
-- Hasilnya diringkas: hanya SATU baris ditampilkan untuk setiap kategori,
-- detail tiap produk (KodeProduk, NamaProduk) HILANG dari hasil

-- AVG(Harga) OVER (PARTITION BY KodeKategori) AS RataRataHargaKategori
-- Window Function: menghitung rata-rata Harga per kelompok KodeKategori,
-- TAPI tetap menampilkan SEMUA baris produk secara individual (KodeProduk, NamaProduk, Harga
-- masing-masing tetap terlihat). Nilai rata-rata kategori diulang di setiap baris produk
-- yang termasuk kategori itu



-- ============================================================
-- Praktikum 9 - ROW_NUMBER
-- ============================================================

-- 1. Nomor Urut Produk Berdasarkan Harga
SELECT
    ROW_NUMBER() OVER
    (
        ORDER BY Harga DESC, KodeProduk ASC
    ) AS NomorUrut,
    KodeProduk,
    NamaProduk,
    Harga,
    Stok
FROM Produk;
-- ROW_NUMBER() OVER (ORDER BY Harga DESC, KodeProduk ASC) AS NomorUrut
-- Window Function: memberi nomor urut 1, 2, 3, dst ke setiap baris,
-- berdasarkan urutan Harga dari TERBESAR ke terkecil (DESC).
-- Kalau ada dua produk dengan Harga SAMA, KodeProduk (ASC) dipakai sebagai
-- penentu urutan tambahan, supaya nomor urutnya tetap konsisten setiap query dijalankan


-- 2. Reservasi Terbaru Setiap Pelanggan
WITH UrutanReservasi AS
(
    SELECT
        rl.KodeReservasi,
        rl.KodePelanggan,
        rl.TanggalReservasi,
        rl.JamReservasi,
        rl.KodeLayanan,
        rl.StatusReservasi,
        ROW_NUMBER() OVER
        (
            PARTITION BY rl.KodePelanggan
            ORDER BY
                rl.TanggalReservasi DESC,
                rl.JamReservasi DESC,
                rl.KodeReservasi DESC
        ) AS NomorUrut
    FROM ReservasiLayanan AS rl
)
SELECT
    ur.KodeReservasi,
    p.NamaPelanggan,
    ur.TanggalReservasi,
    ur.JamReservasi,
    l.NamaLayanan,
    ur.StatusReservasi
FROM UrutanReservasi AS ur
INNER JOIN Pelanggan AS p
    ON ur.KodePelanggan = p.KodePelanggan
INNER JOIN Layanan AS l
    ON ur.KodeLayanan = l.KodeLayanan
WHERE ur.NomorUrut = 1;
-- ROW_NUMBER() OVER adalah Window Function: memberi nomor urut 1, 2, 3, dst ke setiap baris

-- PARTITION BY rl.KodePelanggan
-- Membagi data jadi kelompok per KodePelanggan, nomor urut di-RESET ulang mulai dari 1
-- untuk setiap pelanggan (mirip GROUP BY, tapi tetap menampilkan semua baris asli)

-- ORDER BY
--     rl.TanggalReservasi DESC,
--     rl.JamReservasi DESC,
--     rl.KodeReservasi DESC
-- Menentukan urutan pemberian nomor DI DALAM tiap kelompok pelanggan, bertingkat tiga level:
-- 1. TanggalReservasi DESC -> tanggal reservasi TERBARU diberi nomor lebih kecil (duluan)
-- 2. JamReservasi DESC     -> kalau tanggal sama, jam TERAKHIR duluan
-- 3. KodeReservasi DESC    -> kalau tanggal & jam sama, KodeReservasi terbesar duluan
--    (memastikan hasil tetap konsisten kalau ada nilai yang sama persis)

-- INNER JOIN Pelanggan AS p
-- Menggabungkan hasil CTE UrutanReservasi (ur) dengan tabel Pelanggan (p),
-- karena NamaPelanggan yang mau ditampilkan hanya ada di tabel Pelanggan

-- ON ur.KodePelanggan = p.KodePelanggan
-- Syarat penggabungan: mencocokkan baris UrutanReservasi dan Pelanggan
-- yang KodePelanggan-nya sama

-- INNER JOIN Layanan AS l
-- Menggabungkan lagi dengan tabel Layanan (l), karena NamaLayanan
-- yang mau ditampilkan hanya ada di tabel Layanan

-- ON ur.KodeLayanan = l.KodeLayanan
-- Syarat penggabungan: mencocokkan baris UrutanReservasi dan Layanan
-- yang KodeLayanan-nya sama

-- WHERE ur.NomorUrut = 1;
-- Menyaring hasil: hanya menampilkan baris dengan NomorUrut = 1,
-- yaitu reservasi PALING BARU dari setiap pelanggan (hasil dari ROW_NUMBER
-- yang di-reset per pelanggan sebelumnya)



-- ============================================================
-- Praktikum 10 - RANK dan DENSE_RANK
-- ============================================================

-- 1. Perbandingan Peringkat Harga Produk
SELECT
    KodeProduk,
    NamaProduk,
    Harga,
    ROW_NUMBER() OVER
    (
        ORDER BY Harga DESC, KodeProduk
    ) AS NomorUrut,
    RANK() OVER
    (
        ORDER BY Harga DESC
    ) AS PeringkatRank,
    DENSE_RANK() OVER
    (
        ORDER BY Harga DESC
    ) AS PeringkatDenseRank
FROM Produk
ORDER BY Harga DESC, KodeProduk;
-- ROW_NUMBER() OVER (ORDER BY Harga DESC, KodeProduk) AS NomorUrut
-- Memberi nomor urut 1, 2, 3, dst secara UNIK ke setiap baris, urut dari Harga
-- terbesar ke terkecil. KodeProduk dipakai sebagai penentu tambahan kalau Harga sama.
-- Kalau ada 2 produk dengan Harga SAMA, NomorUrut-nya tetap BEDA (misal 6 dan 7),
-- tidak ada nomor yang diulang

-- RANK() OVER (ORDER BY Harga DESC) AS PeringkatRank
-- Memberi PERINGKAT berdasarkan Harga terbesar ke terkecil.
-- Kalau ada 2 produk dengan Harga SAMA, keduanya dapat peringkat yang SAMA,
-- tapi peringkat berikutnya akan LONCAT sesuai jumlah baris yang seri
-- (misal 2 produk sama-sama peringkat 6, maka produk setelahnya langsung peringkat 8, bukan 7)

-- DENSE_RANK() OVER (ORDER BY Harga DESC) AS PeringkatDenseRank
-- Sama seperti RANK, produk dengan Harga sama dapat peringkat sama,
-- TAPI peringkat berikutnya TIDAK loncat, tetap berurutan rapat
-- (misal 2 produk sama-sama peringkat 6, maka produk setelahnya dapat peringkat 7, bukan 8)

-- ORDER BY Harga DESC, KodeProduk;
-- Mengurutkan hasil TAMPILAN akhir query bertingkat dua level:
-- 1. Diurutkan dulu berdasarkan Harga dari TERBESAR ke terkecil (DESC)
-- 2. Kalau ada Harga yang SAMA, diurutkan lagi berdasarkan KodeProduk (default ASC)
--    supaya urutan tampilan tetap konsisten setiap query dijalankan


-- 2. Peringkat Produk Berdasarkan Jumlah Terjual
WITH PenjualanProduk AS
(
    SELECT
        pr.KodeProduk,
        pr.NamaProduk,
        COALESCE(SUM(dp.Jumlah), 0) AS TotalTerjual
    FROM Produk AS pr
    LEFT JOIN DetailPenjualan AS dp
        ON pr.KodeProduk = dp.KodeProduk
    GROUP BY
        pr.KodeProduk,
        pr.NamaProduk
)
SELECT
    KodeProduk,
    NamaProduk,
    TotalTerjual,
    RANK() OVER
    (
        ORDER BY TotalTerjual DESC
    ) AS PeringkatRank,
    DENSE_RANK() OVER
    (
        ORDER BY TotalTerjual DESC
    ) AS PeringkatDenseRank
FROM PenjualanProduk
ORDER BY TotalTerjual DESC, NamaProduk;
-- COALESCE(SUM(dp.Jumlah), 0) AS TotalTerjual
-- SUM(dp.Jumlah) menjumlahkan kolom Jumlah dari tabel DetailPenjualan (total barang terjual).
-- Karena pakai LEFT JOIN, produk yang belum pernah terjual tidak punya baris pasangan
-- di DetailPenjualan, sehingga SUM-nya akan menghasilkan NULL.
-- COALESCE mengganti NULL itu menjadi 0, supaya produk yang belum pernah terjual
-- tetap tampil dengan TotalTerjual = 0 (bukan kosong/NULL)

-- LEFT JOIN DetailPenjualan AS dp
-- Menggabungkan tabel Produk (pr) dengan DetailPenjualan (dp), tapi tetap menampilkan
-- SEMUA produk walau tidak punya transaksi penjualan sama sekali
-- (beda dengan INNER JOIN yang akan menghilangkan produk yang belum pernah terjual)

-- ON pr.KodeProduk = dp.KodeProduk
-- Syarat penggabungan: mencocokkan baris Produk dan DetailPenjualan
-- yang KodeProduk-nya sama

-- RANK() OVER (ORDER BY TotalTerjual DESC) AS PeringkatRank
-- Memberi peringkat berdasarkan TotalTerjual dari yang PALING LAKU ke paling sedikit.
-- Produk dengan TotalTerjual SAMA dapat peringkat sama, tapi peringkat berikutnya
-- akan LONCAT sesuai jumlah baris yang seri

-- DENSE_RANK() OVER (ORDER BY TotalTerjual DESC) AS PeringkatDenseRank
-- Sama seperti RANK, produk dengan TotalTerjual sama dapat peringkat sama,
-- TAPI peringkat berikutnya TIDAK loncat, tetap berurutan rapat

-- ORDER BY TotalTerjual DESC, NamaProduk;
-- Mengurutkan hasil tampilan akhir bertingkat dua level:
-- 1. Diurutkan dulu berdasarkan TotalTerjual dari TERBESAR ke terkecil (DESC)
-- 2. Kalau ada TotalTerjual yang SAMA, diurutkan lagi berdasarkan NamaProduk (default ASC)
--    supaya urutan tampilan konsisten



-- ============================================================
-- Praktikum 11 - NTILE
-- ============================================================

-- Membagi Produk Menjadi Empat Kelompok Harga
SELECT
    KodeProduk,
    NamaProduk,
    Harga,
    NTILE(4) OVER
    (
        ORDER BY Harga DESC, KodeProduk
    ) AS KelompokHarga
FROM Produk
ORDER BY KelompokHarga, Harga DESC;
-- NTILE(4) OVER (ORDER BY Harga DESC, KodeProduk) AS KelompokHarga
-- Window Function: membagi SELURUH baris produk menjadi 4 KELOMPOK yang jumlahnya
-- seimbang/merata, berdasarkan urutan Harga dari TERBESAR ke terkecil (DESC).
-- KodeProduk dipakai sebagai penentu tambahan kalau Harga sama.
-- Kelompok 1 berisi produk dengan HARGA TERTINGGI (karena urutannya DESC),
-- kelompok 4 berisi produk dengan harga TERENDAH

-- ORDER BY KelompokHarga, Harga DESC;
-- Mengurutkan hasil tampilan akhir bertingkat dua level:
-- 1. Diurutkan dulu berdasarkan KelompokHarga (default ASC, kelompok 1 duluan)
-- 2. Di dalam kelompok yang sama, diurutkan lagi berdasarkan Harga dari terbesar ke terkecil



-- ============================================================
-- Praktikum 12 - LAG
-- ============================================================

-- Membandingkan Harga Produk dengan Harga Kode Produk Sebelumnya
SELECT
    KodeProduk,
    NamaProduk,
    Harga,
    LAG(Harga, 1) OVER
    (
        ORDER BY Harga ASC, KodeProduk
    ) AS HargaSebelumnya,
    Harga - LAG(Harga, 1) OVER
    (
        ORDER BY Harga ASC, KodeProduk
    ) AS SelisihHarga
FROM Produk
ORDER BY Harga ASC, KodeProduk;
-- LAG(Harga, 1) OVER (ORDER BY Harga ASC, KodeProduk) AS HargaSebelumnya
-- Window Function: mengambil nilai Harga dari SATU BARIS SEBELUMNYA (angka 1 = geser
-- mundur 1 baris), berdasarkan urutan Harga dari TERKECIL ke terbesar (ASC).
-- Baris PALING PERTAMA tidak punya "baris sebelumnya", jadi hasilnya NULL

-- Harga - LAG(Harga, 1) OVER (ORDER BY Harga ASC, KodeProduk) AS SelisihHarga
-- Menghitung selisih antara Harga baris saat ini DENGAN Harga baris sebelumnya
-- (hasil dari LAG di atas). Menunjukkan seberapa besar kenaikan harga dibanding
-- produk sebelumnya dalam urutan tersebut

-- ORDER BY Harga ASC, KodeProduk;
-- Mengurutkan hasil tampilan akhir bertingkat dua level:
-- 1. Diurutkan dulu berdasarkan Harga dari TERKECIL ke terbesar (ASC)
-- 2. Kalau ada Harga yang sama, diurutkan lagi berdasarkan KodeProduk (default ASC)



-- ============================================================
-- Praktikum 13 - LEAD
-- ============================================================

-- Reservasi Berikutnya Setiap Pegawai
-- Ditentukan Berdasarkan Jadwal Kode Reservasi Setelahnya
SELECT
    rl.KodePegawai,
    pg.NamaPegawai,
    rl.KodeReservasi,
    rl.TanggalReservasi,
    rl.JamReservasi,
    LEAD(rl.TanggalReservasi, 1) OVER
    (
        PARTITION BY rl.KodePegawai
        ORDER BY
            rl.TanggalReservasi,
            rl.JamReservasi,
            rl.KodeReservasi
    ) AS TanggalReservasiBerikutnya,
    LEAD(rl.JamReservasi, 1) OVER
    (
        PARTITION BY rl.KodePegawai
        ORDER BY
            rl.TanggalReservasi,
            rl.JamReservasi,
            rl.KodeReservasi
    ) AS JamReservasiBerikutnya
FROM ReservasiLayanan AS rl
INNER JOIN Pegawai AS pg
    ON rl.KodePegawai = pg.KodePegawai
ORDER BY
    rl.KodePegawai,
    rl.TanggalReservasi,
    rl.JamReservasi;
-- LEAD(rl.TanggalReservasi, 1) OVER
-- Window Function: mengambil nilai TanggalReservasi dari SATU BARIS SETELAHNYA
-- (angka 1 = geser maju 1 baris)

-- PARTITION BY rl.KodePegawai
-- Membagi data jadi kelompok per KodePegawai. LEAD hanya mengambil baris berikutnya
-- DI DALAM kelompok pegawai yang sama, tidak "nyebrang" ke jadwal pegawai lain

-- ORDER BY
--     rl.TanggalReservasi,
--     rl.JamReservasi,
--     rl.KodeReservasi
-- Menentukan urutan "mana baris berikutnya" di dalam tiap kelompok pegawai, bertingkat:
-- urut dulu berdasarkan tanggal, lalu jam, lalu kode reservasi (semua default ASC,
-- dari yang paling awal ke paling akhir)

-- LEAD(rl.JamReservasi, 1) OVER (...)
-- Sama seperti di atas, tapi mengambil nilai JamReservasi dari baris berikutnya
-- (memakai PARTITION BY dan ORDER BY yang sama persis)

-- INNER JOIN Pegawai AS pg
-- Menggabungkan tabel ReservasiLayanan (rl) dengan tabel Pegawai (pg),
-- karena NamaPegawai yang mau ditampilkan hanya ada di tabel Pegawai

-- ON rl.KodePegawai = pg.KodePegawai
-- Syarat penggabungan: mencocokkan baris ReservasiLayanan dan Pegawai
-- yang KodePegawai-nya sama

-- ORDER BY
--     rl.KodePegawai,
--     rl.TanggalReservasi,
--     rl.JamReservasi;
-- Mengurutkan hasil tampilan akhir bertingkat tiga level:
-- 1. Dikelompokkan dulu per pegawai (KodePegawai)
-- 2. Di dalam pegawai yang sama, urut berdasarkan TanggalReservasi
-- 3. Kalau tanggal sama, urut lagi berdasarkan JamReservasi