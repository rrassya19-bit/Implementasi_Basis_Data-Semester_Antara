-- ======================================================================
-- PRAKTIKUM 7 STORED PROCEDURE, T-SQL PROGRAMING, TRY...CATCH DAN THROW
-- ======================================================================

-- Praktikum 1
CREATE OR ALTER PROCEDURE dbo.usp_TampilProduk  -- Membuat stored procedure baru atau memperbarui jika sudah ada dengan nama 'usp_TampilProduk' di dalam skema 'dbo'
AS
BEGIN
	SET NOCOUNT ON;                             -- Mencegah pengiriman pesan jumlah baris (row count) yang terpengaruh ke klien agar performa lebih optimal

	SELECT
		KodeProduk,
		NamaProduk,
		KodeKategori,
		Harga,
		Stok
	FROM dbo.Produk;
END;
GO


-- Menjalankan SP
EXEC dbo.usp_TampilProduk;                      -- untuk menjalankan atau memanggil stored procedure dengan nama 'usp_TampilProduk' yang berada di dalam skema 'dbo'


-- Praktikum 2 - Stored Procedure dengan Parameter Input
CREATE OR ALTER PROCEDURE dbo.usp_CariProduk    -- Membuat stored procedure baru atau memperbarui jika sudah ada dengan nama 'usp_CariProduk' di dalam skema 'dbo'
(
	@kodeProduk CHAR (6)                        -- Mendeklarasikan parameter input bernama '@kodeProduk' dengan tipe data CHAR dan panjang 6 karakter
)
AS
BEGIN
SELECT *                                        -- Perintah untuk mengambil dan menampilkan seluruh kolom (*) dari tabel
	FROM dbo.Produk                             -- Sumber data diambil dari tabel 'Produk' yang berada di skema 'dbo'
	WHERE @kodeProduk=@kodeProduk;              -- Kondisi penyaringan data (filter); membandingkan parameter dengan dirinya sendiri 
END;
GO


-- Menjalankan SP
EXEC dbo.usp_CariProduk 'PRD001';               -- untuk menjalankan atau memanggil stored procedure dengan nama 'usp_CariProduk' yang berada di dalam skema 'dbo'


-- Praktikum 3 - Parameter Output
CREATE OR ALTER PROCEDURE dbo.usp_TotalProduk   -- Membuat atau memperbarui stored procedure 'usp_TotalProduk'
@Total INT OUTPUT                               -- Parameter output bertipe integer untuk mengembalikan nilai hasil perhitungan
AS
BEGIN                                         
	SELECT                                    
	@Total=COUNT(*)                             -- Menghitung jumlah seluruh baris data dan menyimpannya ke parameter @Total
	FROM dbo.Produk;                            -- Mengambil data dari tabel 'Produk'
END;                                          
GO                                            


-- Menjalankan
DECLARE @Jumlah INT;                    -- Mendeklarasikan variabel lokal bernama '@Jumlah' dengan tipe data integer untuk menampung hasil
EXEC dbo.usp_TotalProduk                -- Menjalankan stored procedure 'usp_TotalProduk'
@Jumlah OUTPUT;                         -- Mengirimkan variabel '@Jumlah' sebagai parameter output untuk menerima nilai kembalian
SELECT @Jumlah;                         -- Menampilkan nilai isi dari variabel '@Jumlah' ke layar


-- Praktikum 4 - DECLARE dan SET
DECLARE                                 -- Memulai deklarasi variabel
@Nama VARCHAR (100),                    -- Mendeklarasikan variabel '@Nama' dengan tipe data VARCHAR sepanjang 100 karakter
@Harga DECIMAL (18,2);                  -- Mendeklarasikan variabel '@Harga' dengan tipe data DECIMAL (18 digit total, 2 di belakang koma)
SET @Nama='Whiskas Tuna 1kg';           -- Memberikan nilai teks 'Whiskas Tuna 1kg' ke dalam variabel '@Nama'
SET @Harga=75000;                       -- Memberikan nilai angka 75000 ke dalam variabel '@Harga'
SELECT                                  -- Memerintahkan SQL untuk menampilkan data
@Nama,                                  -- Menampilkan nilai dari variabel '@Nama'
@Harga;                                 -- Menampilkan nilai dari variabel '@Harga'


-- Praktikum 5 - SELECT ke Variable
DECLARE                                 -- Memulai deklarasi variabel
@Stok INT;                              -- Mendeklarasikan variabel '@Stok' dengan tipe data integer untuk menampung nilai stok
SELECT                                  -- Memulai perintah pengambilan data dari tabel
@Stok=Stok                              -- Mengambil nilai dari kolom 'Stok' dan menyimpannya ke dalam variabel '@Stok'
FROM dbo.Produk                         -- Mengambil data dari tabel 'Produk' yang ada di skema 'dbo'
WHERE KodeProduk='PRD001';              -- Menyaring data hanya untuk produk yang memiliki 'KodeProduk' bernilai 'PRD001'
SELECT @Stok;                           -- Menampilkan nilai isi dari variabel '@Stok' ke layar


-- Praktikum 6 - IF...ELSE
DECLARE                                 -- Memulai deklarasi variabel
@Stok INT;                              -- Mendeklarasikan variabel '@Stok' dengan tipe data integer
SELECT                                  
@Stok=Stok                              -- Mengisi variabel '@Stok' dengan nilai kolom Stok dari database
FROM dbo.Produk                         
WHERE KodeProduk='PRD001';              -- Menyaring data berdasarkan 'KodeProduk' bernilai 'PRD001'
	IF @stok<10                         
BEGIN                                   
	PRINT 'Stok Hampir Habis';          
END                                     
	ELSE                                
BEGIN PRINT 'Stok Aman';                
END;                                    

-- Praktikum 7 - Nested IF
DECLARE
@Harga DECIMAL(18,2);                   -- Mendeklarasikan variabel '@Harga' dengan tipe data decimal (18 digit total, 2 desimal)
SELECT                                 
@Harga=Harga                            -- Mengambil nilai dari kolom 'Harga' dan menyimpannya ke dalam variabel '@Harga'
FROM dbo.Produk                         
WHERE KodeProduk='PRD001';              -- Menyaring data berdasarkan 'KodeProduk' bernilai 'PRD001'
	IF @Harga<50000                     
		PRINT 'Murah'                   
	ELSE IF @Harga<100000               
		PRINT 'Sedang'                 
	ELSE
		PRINT 'Mahal';


-- Praktikum 8 - WHILE
DECLARE                                          -- Memulai deklarasi variabel
@No INT=1;                                       -- Mendeklarasikan variabel '@No' bertipe integer dan langsung mengisinya dengan nilai awal 1
	WHILE @No<=5                                 -- Perulangan WHILE: akan terus berulang selama nilai '@No' kurang dari atau sama dengan 5
BEGIN                                            
	PRINT 'Perulangan ke-'+CAST(@No AS VARCHAR); -- Mencetak teks dengan menggabungkan string dan nilai variabel '@No' (yang diubah dulu menjadi VARCHAR)
SET @No=@No+1;                                   -- Menambahkan nilai '@No' dengan 1 pada setiap iterasi agar perulangan bisa berhenti (counter increment)
END;



-- Praktikum 9 - TRY...CATCH
BEGIN TRY                               -- Memulai blok kode yang dipantau untuk mendeteksi adanya error
    SELECT 10/0;                        -- Perintah yang memicu error pembagian dengan angka nol (division by zero)
END TRY                                 -- Mengakhiri blok pemantauan TRY
BEGIN CATCH                             -- Memulai blok kode yang dijalankan jika terjadi error di blok TRY
    SELECT                              -- Memulai perintah untuk mengambil informasi detail error
    ERROR_NUMBER() AS NomorError,       -- Mengambil kode nomor identifikasi error dan menamainya 'NomorError'
    ERROR_MESSAGE() AS PesanError;      -- Mengambil teks pesan deskripsi error dan menamainya 'PesanError'
END CATCH;                              -- Mengakhiri blok penanganan error CATCH


-- Praktikum 10 - THROW
DECLARE                                 -- Memulai deklarasi variabel
@Harga DECIMAL(18,2);                   -- Mendeklarasikan variabel '@Harga' dengan tipe data decimal (18,2)
SET @Harga=-100;                        -- Mengisi variabel '@Harga' dengan nilai negatif (-100)
IF @Harga<0                             -- Percabangan IF: memeriksa apakah nilai '@Harga' bernilai kurang dari 0
THROW 50001,                            -- Memunculkan error kustom dengan nomor error 50001 (harus antara 50000 dan 2147483647)
'Harga tidak boleh negatif.',           -- Pesan teks deskripsi error yang akan ditampilkan
1;                                      -- Menentukan tingkat keparahan error (state), biasanya bernilai 1


-- Praktikum 11 - Stored Procedure Tambah Produk
CREATE OR ALTER PROCEDURE dbo.usp_TambahProduk  -- Membuat atau memperbarui stored procedure 'usp_TambahProduk'
    @KodeProduk CHAR(6),                        -- Parameter input untuk kode produk
    @NamaProduk VARCHAR(100),                   -- Parameter input untuk nama produk
    @KodeKategori CHAR(6),                      -- Parameter input untuk kode kategori produk
    @Harga DECIMAL(18,2),                       -- Parameter input untuk harga produk
    @Stok INT                                   -- Parameter input untuk jumlah stok produk
AS                                              -- Batas awal definisi stored procedure
BEGIN                                        
    INSERT INTO dbo.Produk                      -- Perintah untuk menambahkan data baru ke dalam tabel 'Produk'
    (                                           -- Menentukan kolom-kolom yang akan diisi datanya
        KodeProduk,
        NamaProduk,
        KodeKategori,
        Harga,
        Stok
    )
    VALUES                                     -- Menentukan nilai yang akan dimasukkan
    (                                          -- Mengisi kolom sesuai dengan nilai dari parameter input
        @KodeProduk,
        @NamaProduk,
        @KodeKategori,
        @Harga,
        @Stok
    );
END;                                          
GO                          


-- Menjalankan
EXEC dbo.usp_TambahProduk                -- Menjalankan stored procedure 'usp_TambahProduk'
    'PRD999',                            -- Mengirim nilai 'PRD999' ke parameter @KodeProduk
    'Snack Kucing',                      -- Mengirim nilai 'Snack Kucing' ke parameter @NamaProduk
    'KTG001',                            -- Mengirim nilai 'KTG001' ke parameter @KodeKategori
    25000,                               -- Mengirim nilai 25000 ke parameter @Harga
    30;                                  -- Mengirim nilai 30 ke parameter @Stok


-- Praktikum 12 - Stored Procedure Update Produk
CREATE OR ALTER PROCEDURE dbo.usp_UpdateProduk  -- Membuat atau memperbarui stored procedure 'usp_UpdateProduk'
    @KodeProduk CHAR(6),                        -- Parameter input untuk menentukan produk yang akan di-update berdasarkan kodenya
    @Harga DECIMAL(18,2),                       -- Parameter input untuk nilai pembaruan pada kolom harga
    @Stok INT                                   -- Parameter input untuk nilai pembaruan pada kolom stok
AS                                              -- Batas awal definisi stored procedure
BEGIN                                      
    UPDATE dbo.Produk                           -- Perintah untuk memperbarui (update) data di dalam tabel 'Produk'
    SET                                         -- Menentukan kolom mana saja yang nilainya akan diubah
        Harga = @Harga,                         -- Mengubah kolom 'Harga' dengan nilai dari parameter @Harga
        Stok = @Stok                            -- Mengubah kolom 'Stok' dengan nilai dari parameter @Stok
    WHERE KodeProduk = @KodeProduk;             -- Batasan (filter) agar pembaruan hanya berlaku pada baris dengan 'KodeProduk' yang sesuai
END;                                         
GO                                             


-- Praktikum 13 - Stored Procedure Tambah Penjualan
CREATE OR ALTER PROCEDURE dbo.usp_TambahPenjualan  -- Membuat atau memperbarui stored procedure 'usp_TambahPenjualan'
    @KodePenjualan CHAR(6),                        -- Parameter input untuk kode penjualan
    @Tanggal DATE,                                 -- Parameter input untuk tanggal transaksi penjualan
    @KodePelanggan CHAR(6),                        -- Parameter input untuk kode pelanggan yang melakukan pembelian
    @KodePegawai CHAR(6),                          -- Parameter input untuk kode pegawai yang melayani transaksi
    @MetodeBayar VARCHAR(30)                       -- Parameter input untuk metode pembayaran yang digunakan
AS                                                 -- Batas awal definisi stored procedure
BEGIN                                       
    INSERT INTO dbo.Penjualan                      -- Perintah untuk menambahkan data baru ke dalam tabel 'Penjualan'
    (                                              -- Menentukan kolom-kolom tabel yang akan diisi
        KodePenjualan,
        TanggalPenjualan,
        KodePelanggan,
        KodePegawai,
        MetodeBayar
    )
    VALUES                                         -- Menentukan nilai yang akan dimasukkan ke dalam kolom-kolom di atas
    (                                              -- Mengisi kolom sesuai dengan urutan parameter input yang diterima
        @KodePenjualan,
        @Tanggal,
        @KodePelanggan,
        @KodePegawai,
        @MetodeBayar
    );
END;                                             
GO                                               


-- Praktikum 14 - Stored Procedure dengan TRY...CATCH
CREATE OR ALTER PROCEDURE dbo.usp_TambahKategori  -- Membuat atau memperbarui stored procedure 'usp_TambahKategori'
    @KodeKategori CHAR(6),                        -- Parameter input untuk kode kategori produk
    @NamaKategori VARCHAR(100),                   -- Parameter input untuk nama kategori produk
    @Keterangan VARCHAR(200)                      -- Parameter input untuk catatan atau keterangan kategori
AS                                                -- Batas awal definisi stored procedure
BEGIN                                        
    BEGIN TRY                                     -- Memulai blok pemantauan error (mencoba menjalankan perintah di dalamnya)
        INSERT INTO dbo.KategoriProduk            -- Perintah untuk menyisipkan data baru ke tabel 'KategoriProduk'
        VALUES                                    -- Menentukan nilai yang akan dimasukkan ke tabel
        (
            @KodeKategori,
            @NamaKategori,
            @Keterangan
        );
        PRINT 'Data berhasil disimpan';          -- Mencetak pesan sukses jika proses insert tidak mengalami kendala
    END TRY                                      -- Mengakhiri blok pemantauan TRY
    BEGIN CATCH                                  -- Memulai blok penanganan error jika perintah di dalam TRY gagal
        SELECT
        ERROR_NUMBER() AS ErrorNumber,          -- Menampilkan nomor kode error yang terjadi
        ERROR_MESSAGE() AS Pesan;               -- Menampilkan teks pesan deskripsi error
    END CATCH                                   
END;                                          
GO                                            




/*
1. Menggunakan parameter input
Fungsi: Supaya stored procedure bisa menerima data dari luar (dikirim user saat EXEC), bukan data yang di-hardcode. 
        Ini yang bikin procedure-nya fleksibel dan bisa dipakai berulang kali untuk produk yang berbeda-beda.

2. Menggunakan DECLARE
Fungsi: Bikin variabel lokal di dalam procedure untuk menampung nilai sementara — di sini dipakai buat nyimpen hasil
        pengecekan jumlah kategori sebelum dipakai di kondisi IF.

3. Menggunakan IF...ELSE
Fungsi: Struktur percabangan yang jadi kerangka utama validasi berlapis — tiap kondisi yang gagal langsung berhenti
        (lewat THROW), dan hanya kalau semua kondisi lolos baru sampai ke proses INSERT.

4. Memeriksa apakah KodeKategori tersedia

Fungsi: Mencegah data produk masuk dengan kategori yang gak valid/gak ada di tabel referensi (KategoriProduk) — 
        ini bentuk validasi referential integrity secara manual di level procedure.

5. Memastikan harga lebih besar dari 0
Fungsi: Validasi bisnis — harga produk gak masuk akal kalau nol atau negatif, jadi dicegah dari sisi database sebelum data tersimpan.

6. Memastikan Stok tidak negatif
Fungsi: Validasi bisnis juga — stok barang gak mungkin bernilai minus, jadi dicegah supaya data tetap konsisten dan masuk akal secara logika inventori.

7. Menggunakan TRY...CATCH
Fungsi: Membungkus seluruh proses (validasi + insert) supaya kalau ada error apapun (baik dari THROW manual maupun error 
        sistem SQL Server), eksekusi gak berhenti paksa/crash, tapi ditangkap rapi dan ditampilkan informasinya.

8. Menggunakan THROW jika validasi gagal
Fungsi: Cara memunculkan error kustom secara manual dengan kode dan pesan yang kita tentukan sendiri, biar pesan errornya
        jelas dan spesifik (bukan pesan error default SQL Server yang teknis).

9. Tambahkan data ke tabel Produk jika seluruh validasi telah berhasil
Fungsi: Ini "hasil akhir" dari seluruh proses validasi — INSERT cuma dieksekusi kalau kode berhasil melewati ELSE paling dalam, 
        artinya ketiga validasi (kategori, harga, stok) semuanya lolos.
*/

-- =========================================================
-- Exercise - Stored Procedure Tambah Produk dengan Validasi
-- =========================================================

CREATE OR ALTER PROCEDURE dbo.usp_TambahProdukValidasi  -- Membuat atau memperbarui stored procedure 'usp_TambahProdukValidasi' di dalam skema 'dbo'
    @KodeProduk CHAR(6),                                -- Parameter input untuk kode produk
    @NamaProduk VARCHAR(100),                           -- Parameter input untuk nama produk
    @KodeKategori CHAR(6),                              -- Parameter input untuk kode kategori produk
    @Harga DECIMAL(18,2),                               -- Parameter input untuk harga produk
    @Stok INT                                           -- Parameter input untuk jumlah stok produk
AS                                                      -- Batas awal definisi stored procedure
BEGIN
    BEGIN TRY                                           -- Memulai blok kode yang dipantau untuk mendeteksi adanya error

        DECLARE                                         -- Memulai deklarasi variabel lokal
        @CekKategori INT;                               -- Variabel bertipe integer untuk menampung jumlah KodeKategori yang cocok

        SELECT                                          -- Memulai perintah pengambilan data
        @CekKategori=COUNT(*)                           -- Menghitung jumlah baris yang sesuai dan menyimpannya ke variabel '@CekKategori'
        FROM dbo.KategoriProduk                         -- Mengambil data dari tabel 'KategoriProduk'
        WHERE KodeKategori=@KodeKategori;               -- Menyaring data berdasarkan kode kategori yang dikirim lewat parameter

        IF @CekKategori=0                               -- Percabangan IF: memeriksa apakah kode kategori tidak ditemukan (jumlahnya nol)
        BEGIN
            THROW 50001,                                -- Memunculkan error kustom dengan nomor 50001 
            'KodeKategori tidak tersedia.',             -- Pesan teks deskripsi error yang ditampilkan
            1;                                          -- Tingkat keparahan error (state), umumnya bernilai 1
        END
        ELSE                                            -- Jika kode kategori ditemukan (validasi 1 lolos), lanjut ke pengecekan berikutnya
        BEGIN
            IF @Harga<=0                                -- Percabangan IF: memeriksa apakah harga kurang dari atau sama dengan 0
            BEGIN
                THROW 50002,                            -- Memunculkan error kustom dengan nomor 50002
                'Harga harus lebih besar dari 0.',      -- Pesan teks deskripsi error yang ditampilkan
                1;                                      -- Tingkat keparahan error (state)
            END
            ELSE                                        -- Jika harga valid (validasi 2 lolos), lanjut ke pengecekan berikutnya
            BEGIN
                IF @Stok<0                              -- Percabangan IF: memeriksa apakah stok bernilai negatif
                BEGIN
                    THROW 50003,                        -- Memunculkan error kustom dengan nomor 50003
                    'Stok tidak boleh negatif.',        -- Pesan teks deskripsi error yang ditampilkan
                    1;                                  -- Tingkat keparahan error (state)
                END
                ELSE                                    -- Jika stok valid (validasi 3 lolos), lanjut ke proses penyimpanan data
                BEGIN
                    INSERT INTO dbo.Produk              -- Perintah untuk menambahkan data baru ke dalam tabel 'Produk'
                    (                                   -- Menentukan kolom-kolom yang akan diisi datanya
                        KodeProduk,
                        NamaProduk,
                        KodeKategori,
                        Harga,
                        Stok
                    )
                    VALUES                               -- Menentukan nilai yang akan dimasukkan
                    (                                    -- Mengisi kolom sesuai dengan nilai dari parameter input
                        @KodeProduk,
                        @NamaProduk,
                        @KodeKategori,
                        @Harga,
                        @Stok
                    );

                    PRINT 'Data produk berhasil disimpan'; -- Mencetak pesan sukses jika proses insert tidak mengalami kendala
                END
            END
        END

    END TRY                                             -- Mengakhiri blok pemantauan TRY
    BEGIN CATCH                                         -- Memulai blok kode yang dijalankan jika terjadi error (baik dari THROW maupun error sistem) di blok TRY
        SELECT                                          -- Memulai perintah untuk mengambil informasi detail error
        ERROR_NUMBER() AS ErrorNumber,                  -- Mengambil kode nomor identifikasi error dan menamainya 'ErrorNumber'
        ERROR_MESSAGE() AS Pesan;                       -- Mengambil teks pesan deskripsi error dan menamainya 'Pesan'
    END CATCH                                           -- Mengakhiri blok penanganan error CATCH
END;                                                     
GO                                                       



-- Menjalankan: berhasil, semua validasi lolos
EXEC dbo.usp_TambahProdukValidasi                       -- Menjalankan stored procedure 'usp_TambahProdukValidasi'
    'PRD100',                                           -- Mengirim nilai 'PRD100' ke parameter @KodeProduk
    'Pasir Kucing 5kg',                                 -- Mengirim nilai 'Pasir Kucing 5kg' ke parameter @NamaProduk
    'KTG001',                                           -- Mengirim nilai 'KTG001' ke parameter @KodeKategori (harus sudah ada di tabel KategoriProduk)
    45000,                                              -- Mengirim nilai 45000 ke parameter @Harga
    20;                                                 -- Mengirim nilai 20 ke parameter @Stok


-- Menampilkan data berhasil di input
SELECT * FROM dbo.Produk WHERE KodeProduk='PRD100';


-- Menjalankan: gagal, KodeKategori tidak ditemukan
EXEC dbo.usp_TambahProdukValidasi
    'PRD101',
    'Tes Barang',
    'ZZZ999',                                            -- Kode kategori diisi nilai yang tidak ada di tabel KategoriProduk
    10000,
    5;


-- Menjalankan: gagal, harga tidak valid
EXEC dbo.usp_TambahProdukValidasi
    'PRD102',
    'Tes Barang',
    'KTG001',
    0,                                                   -- Harga diisi 0 untuk memicu error validasi harga
    5;


-- Menjalankan: gagal, stok bernilai negatif
EXEC dbo.usp_TambahProdukValidasi
    'PRD103',
    'Tes Barang',
    'KTG001',
    10000,
    -3;                                                  -- Stok diisi negatif untuk memicu error validasi stok
