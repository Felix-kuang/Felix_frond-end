CREATE TABLE IF NOT EXISTS kategori (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS barang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_barang VARCHAR(100) NOT NULL,
    kategori_id INT,
    stok INT DEFAULT 0,
    kelompok_barang ENUM('A','B','C') DEFAULT 'A',
    harga BIGINT DEFAULT 0,

    FOREIGN KEY (kategori_id) REFERENCES kategori(id)
);

ALTER TABLE barang ADD COLUMN imageUrl TEXT;