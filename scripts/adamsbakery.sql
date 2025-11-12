-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.4.3 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for adamsbakery
CREATE DATABASE IF NOT EXISTS `adamsbakery`
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE `adamsbakery`;
-- Dumping structure for table adamsbakery.admin_users
CREATE TABLE IF NOT EXISTS `admin_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.admin_users: ~1 rows (approximately)
INSERT INTO `admin_users` (`id`, `username`, `password`, `created_at`) VALUES
	(1, 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '2025-09-17 16:22:57');

-- Dumping structure for table adamsbakery.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama` (`nama`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.categories: ~4 rows (approximately)
INSERT INTO `categories` (`id`, `nama`, `created_at`) VALUES
	(1, 'Roti Manis', '2025-09-17 16:22:57'),
	(2, 'Roti Gurih', '2025-09-17 16:22:57'),
	(3, 'Kue Kering', '2025-09-17 16:22:57'),
	(4, 'Kue Ulang Tahun', '2025-09-17 16:22:57');

-- Dumping structure for table adamsbakery.customer_users
CREATE TABLE IF NOT EXISTS `customer_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nama_lengkap` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `alamat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_verified` tinyint(1) DEFAULT '0' COMMENT 'Status verifikasi (0=belum, 1=sudah)',
  `otp_code` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Kode OTP 6 digit',
  `otp_expires_at` datetime DEFAULT NULL COMMENT 'Waktu kedaluwarsa OTP',
  `otp_attempts` int unsigned DEFAULT '0' COMMENT 'Jumlah percobaan OTP',
  `reset_token` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Token unik untuk reset password',
  `reset_expires` datetime DEFAULT NULL COMMENT 'Waktu kadaluarsa token reset',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_customer_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.customer_users: ~7 rows (approximately)
INSERT INTO `customer_users` (`id`, `nama_lengkap`, `email`, `password`, `phone`, `alamat`, `created_at`, `updated_at`, `is_verified`, `otp_code`, `otp_expires_at`, `otp_attempts`, `reset_token`, `reset_expires`) VALUES
	(2, 'Adam F', 'yanto@gmail.com', '$2y$10$o.m9k2sNGxJBAmXMfvVhPeLoR2jan6tIpaIa/i3CCZ3nwJfels6hW', '12345', 'pacul', '2025-09-23 06:53:03', '2025-09-23 06:53:03', 0, NULL, NULL, 0, NULL, NULL),
	(11, 'adam', 'nurcahyaputraa@gmail.com', '$2y$10$T9Y90/LsSPRiASvMeCrRzupFSPyoJzCeICGRC.8hVqAOnxk2cIxpm', NULL, NULL, '2025-11-02 00:33:06', '2025-11-02 00:34:08', 1, NULL, NULL, 0, NULL, NULL),
	(12, 'dimdim', 'juomino@gmail.com', '$2y$10$padnGQJ195JADtuleEwZbuC2HTpsF9xd80jUenOHZoGdAM9Id4v3y', NULL, NULL, '2025-11-02 02:17:09', '2025-11-02 02:17:09', 0, '422778', '2025-11-02 02:22:09', 0, NULL, NULL),
	(13, 'dimdim', 'ambatukam@gmail.com', '$2y$10$xS3xR4YeVNeYacX.66L00uhghHJdmmFC.a/mIb/h57O8fnHFA0iQu', NULL, NULL, '2025-11-02 02:19:16', '2025-11-02 02:19:16', 0, '102904', '2025-11-02 02:24:16', 0, NULL, NULL),
	(14, 'dimdim', 'ambatukamm@gmail.com', '$2y$10$Aw6jWrtx7zoSwREvhQ5iqOLEknpgi4hLekKVbCRwavyTuqS8iJr8W', NULL, NULL, '2025-11-02 02:22:58', '2025-11-02 02:22:58', 0, '524984', '2025-11-02 02:27:58', 0, NULL, NULL),
	(15, 'Adam Faizal', 'adamfaizal1313@gmail.com', '$2y$10$DlxG3L70qDcmRPCGt.SyD.eNK62tPbtbJ6jg7txepkd441gALpe4G', '085225779194', 'jalan kekasih', '2025-11-02 04:15:02', '2025-11-02 04:15:02', 0, NULL, NULL, 0, NULL, NULL),
	(16, 'gusti', 'gusticaesar17@gmail.com', '$2y$10$vlQTtZhuOnGhMXPzxJ5Wcu9QwAAMe0bxcAqrrhjfilXhMAkJqDicO', NULL, NULL, '2025-11-02 09:13:03', '2025-11-02 09:13:37', 1, NULL, NULL, 0, NULL, NULL);

-- Dumping structure for table adamsbakery.custom_order_quotes
CREATE TABLE IF NOT EXISTS `custom_order_quotes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kontak_id` int NOT NULL,
  `quoted_price` decimal(10,2) NOT NULL,
  `quote_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `valid_until` date DEFAULT NULL,
  `status` enum('pending','accepted','rejected','expired') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `kontak_id` (`kontak_id`),
  CONSTRAINT `custom_order_quotes_ibfk_1` FOREIGN KEY (`kontak_id`) REFERENCES `kontak` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.custom_order_quotes: ~0 rows (approximately)

-- Dumping structure for table adamsbakery.kontak
CREATE TABLE IF NOT EXISTS `kontak` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pesan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `jenis_kontak` enum('ulasan','custom_order','pertanyaan') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ulasan',
  `custom_order_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `budget_range` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `event_date` date DEFAULT NULL,
  `jumlah_porsi` int DEFAULT NULL,
  `status` enum('pending','reviewed','quoted','confirmed','completed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `admin_reply` text COLLATE utf8mb4_general_ci COMMENT 'Jawaban admin',
  PRIMARY KEY (`id`),
  KEY `idx_kontak_jenis` (`jenis_kontak`),
  KEY `idx_kontak_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.kontak: ~3 rows (approximately)
INSERT INTO `kontak` (`id`, `nama`, `email`, `pesan`, `jenis_kontak`, `custom_order_details`, `budget_range`, `event_date`, `jumlah_porsi`, `status`, `created_at`, `admin_reply`) VALUES
	(1, 'Adam', 'yanto@gmail.com', 'G wuenak', 'ulasan', NULL, NULL, NULL, NULL, 'pending', '2025-09-18 11:26:56', NULL),
	(14, 'adam', 'nurcahyaputraa@gmail.com', 'harus jozjiz', 'custom_order', 'yg penting hepi', '> 5jt', '2025-11-07', 70, 'confirmed', '2025-11-02 00:39:15', NULL),
	(15, 'Gusti', 'gusticaesar17@gmail.com', 'snack macam', 'custom_order', 'pakai lilin 5', '> 5jt', '2025-11-07', 100, 'confirmed', '2025-11-02 09:21:25', NULL);

-- Dumping structure for table adamsbakery.packages
CREATE TABLE IF NOT EXISTS `packages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `deskripsi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `harga` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'placeholder.jpg',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.packages: ~7 rows (approximately)
INSERT INTO `packages` (`id`, `nama`, `deskripsi`, `harga`, `created_at`, `image`) VALUES
	(1, 'Paket Pagi Sehat', 'Roti tawar gandum + croissant + susu segar untuk memulai hari', 35000.00, '2025-09-17 16:22:57', '1760953842_paket super besar.jpg'),
	(2, 'Paket Ulang Tahun Kecil', 'Kue tart vanilla + 6 donat mix + lilin ulang tahun', 200000.00, '2025-09-17 16:22:57', '1760953897_paket super besar.jpg'),
	(3, 'Paket Ulang Tahun Besar', 'Kue tart coklat + 12 donat mix + black forest mini + dekorasi', 350000.00, '2025-09-17 16:22:57', '1760953880_roti coklat X keju.jpg'),
	(4, 'Paket Kue Kering Lebaran', 'Nastar + kastengel + putri salju dalam kemasan cantik', 120000.00, '2025-09-17 16:22:57', '1760953833_paket roti cokelat X keju.jpg'),
	(5, 'Paket Sarapan Keluarga', '2 roti tawar + 4 croissant + selai strawberry', 65000.00, '2025-09-17 16:22:57', '1760953854_paket xtra big.jpg'),
	(6, 'Paket Kecil', 'Paket Roti Unyil dengan 4 varian rasa yang bisa dipilih sesuai keinginan! ', 10000.00, '2025-09-22 06:41:24', '1760953822_paket nastar.jpg'),
	(7, 'Paket Sedang', 'Paket Sedang dengan 4 varian rasa sesuai keinginanmu!', 15000.00, '2025-09-22 06:44:01', '1760953866_pket roti besar.jpg');

-- Dumping structure for table adamsbakery.pertanyaan_umum
CREATE TABLE IF NOT EXISTS `pertanyaan_umum` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `pertanyaan` text NOT NULL,
  `admin_reply` text COMMENT 'Jawaban admin',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Dumping data for table adamsbakery.pertanyaan_umum: ~3 rows (approximately)
INSERT INTO `pertanyaan_umum` (`id`, `nama`, `email`, `pertanyaan`, `admin_reply`, `created_at`) VALUES
	(4, 'adam', 'nurcahyaputraa@gmail.com', 'kenapa harus jozjiz', 'karena kita pemuda jozjiz', '2025-11-02 07:40:44'),
	(5, 'adam faizal', 'adamfaizal1313@gmail.com', 'arti dari algoritma pemrograman apa ya min?', 'nyocot sih', '2025-11-02 11:25:31'),
	(6, 'Rusdi', 'gusticaesar17@gmail.com', 'udah ngokang belum', 'udah', '2025-11-02 16:22:33');

-- Dumping structure for table adamsbakery.products
CREATE TABLE IF NOT EXISTS `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `harga` decimal(10,2) NOT NULL,
  `kategori` enum('Roti Manis','Roti Gurih','Kue Kering','Kue Ulang Tahun') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `deskripsi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'placeholder.jpg',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.products: ~10 rows (approximately)
INSERT INTO `products` (`id`, `category_id`, `nama`, `harga`, `kategori`, `deskripsi`, `image`, `created_at`, `updated_at`) VALUES
	(3, 1, 'Croissant Butter', 18000.00, 'Roti Manis', 'Croissant berlapis dengan butter premium, renyah di luar lembut di dalam', '1760953688_pukis coklat dalam.jpg', '2025-09-17 16:22:57', '2025-10-20 09:48:08'),
	(4, 1, 'Donat Coklat', 12000.00, 'Roti Manis', 'Donat lembut dengan glazur coklat manis yang menggoda', '1760953702_roti gula.jpg', '2025-09-17 16:22:57', '2025-10-20 09:48:22'),
	(5, 1, 'Donat Strawberry', 12000.00, 'Roti Manis', 'Donat dengan topping strawberry segar dan manis', '1760953714_roti coklat unik.jpg', '2025-09-17 16:22:57', '2025-10-20 09:48:34'),
	(6, 3, 'Kue Nastar', 45000.00, 'Kue Kering', 'Kue kering tradisional dengan isian nanas manis (per toples)', '1760953641_hot dawg.jpg', '2025-09-17 16:22:57', '2025-10-20 09:47:21'),
	(7, 2, 'Kastengel', 50000.00, 'Kue Kering', 'Kue kering keju yang gurih dan renyah (per toples)', '1760953605_donat coklat.jpg', '2025-09-17 16:22:57', '2025-11-01 03:26:25'),
	(8, 4, 'Kue Tart Coklat', 150000.00, 'Kue Ulang Tahun', 'Kue tart coklat dengan dekorasi cantik untuk ulang tahun', '1760953664_donat coklat.jpg', '2025-09-17 16:22:57', '2025-10-20 09:47:44'),
	(9, 4, 'Kue Tart Vanilla', 140000.00, 'Kue Ulang Tahun', 'Kue tart vanilla dengan cream lembut dan dekorasi elegan', '1760953676_pizza unik.jpg', '2025-09-17 16:22:57', '2025-10-20 09:47:56'),
	(15, 2, 'pizza', 8000.00, 'Roti Gurih', 'jafjk', '1762059208_pizza unik.jpg', '2025-11-02 04:53:28', '2025-11-02 04:53:28'),
	(16, 1, 'roti pukis', 50000.00, 'Roti Manis', 'joz', '1762059366_pukis coklat keju.jpg', '2025-11-02 04:56:06', '2025-11-02 04:56:06'),
	(17, 2, 'roti abon', 11111.00, 'Roti Gurih', 'dg', '1762059712_roti abon.jpg', '2025-11-02 05:01:52', '2025-11-02 05:01:52');

-- Dumping structure for table adamsbakery.promos
CREATE TABLE IF NOT EXISTS `promos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.promos: ~1 rows (approximately)
INSERT INTO `promos` (`id`, `title`, `description`, `created_at`) VALUES
	(1, 'Gratis Ongkir', 'Gratis coii', '2025-09-23 16:24:29');

-- Dumping structure for table adamsbakery.reviews
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transaction_id` int NOT NULL,
  `product_id` int DEFAULT NULL COMMENT 'ID produk jika review untuk produk',
  `package_id` int DEFAULT NULL COMMENT 'ID paket jika review untuk paket',
  `item_type` enum('product','package') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'product' COMMENT 'Tipe item: product atau package',
  `nama_reviewer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rating` int NOT NULL,
  `review_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_review_transaction` (`transaction_id`),
  KEY `idx_review_product` (`product_id`),
  KEY `idx_review_package` (`package_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.reviews: ~6 rows (approximately)
INSERT INTO `reviews` (`id`, `transaction_id`, `product_id`, `package_id`, `item_type`, `nama_reviewer`, `rating`, `review_text`, `created_at`) VALUES
	(10, 36, NULL, NULL, 'product', 'adam', 3, 'regegas', '2025-11-02 03:22:55'),
	(11, 37, 5, NULL, 'product', 'Adam Faizal', 5, 'enak loh ya', '2025-11-02 04:24:10'),
	(12, 37, NULL, NULL, 'product', 'Adam Faizal', 3, 'ah enakan holland', '2025-11-02 04:24:24'),
	(13, 37, 9, NULL, 'product', 'Adam Faizal', 1, 'kok ada rambut yang buat ya di roti saya?', '2025-11-02 04:24:40'),
	(14, 38, 17, NULL, 'product', 'gusti', 5, 'ytta', '2025-11-02 09:17:45'),
	(15, 38, NULL, 4, 'package', 'gusti', 2, 'anjayy', '2025-11-02 09:18:10');

-- Dumping structure for table adamsbakery.transactions
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nama_pembeli` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `alamat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_method` enum('transfer_bank') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'transfer_bank',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `account_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `transfer_amount` decimal(10,2) DEFAULT NULL,
  `transfer_proof` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('pending','confirmed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` int DEFAULT NULL,
  `bukti_pembayaran` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'bukti pembayaran',
  PRIMARY KEY (`id`),
  KEY `idx_transaction_customer` (`customer_id`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer_users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.transactions: ~3 rows (approximately)
INSERT INTO `transactions` (`id`, `nama_pembeli`, `email`, `phone`, `alamat`, `total_amount`, `payment_method`, `bank_name`, `account_name`, `account_number`, `transfer_amount`, `transfer_proof`, `status`, `created_at`, `updated_at`, `customer_id`, `bukti_pembayaran`) VALUES
	(36, 'adam', 'nurcahyaputraa@gmail.com', '082225348452', 'eF', 56000.00, 'transfer_bank', 'Mandiri', 'SDF', 'sdg', 56000.00, NULL, 'confirmed', '2025-11-02 03:22:15', '2025-11-02 03:22:25', 11, 'bukti_1762053735.jpg'),
	(37, 'Adam Faizal', 'adamfaizal1313@gmail.com', '085225779194', 'jalan kekasih', 682000.00, 'transfer_bank', 'Lainnya', 'adam', '-', 682000.00, NULL, 'confirmed', '2025-11-02 04:20:11', '2025-11-02 04:22:33', 15, 'bukti_1762057211.jpg'),
	(38, 'gusti', 'gusticaesar17@gmail.com', '0895606495209', 'jalan pwt', 131111.00, 'transfer_bank', 'Mandiri', 'Adam Bakery', '1234567890', 131111.00, NULL, 'confirmed', '2025-11-02 09:15:28', '2025-11-02 09:16:07', 16, 'bukti_1762074928.png');

-- Dumping structure for table adamsbakery.transaction_items
CREATE TABLE IF NOT EXISTS `transaction_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transaction_id` int NOT NULL,
  `product_id` int DEFAULT NULL,
  `package_id` int DEFAULT NULL,
  `item_type` enum('product','package') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_transaction_id` (`transaction_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_package_id` (`package_id`),
  CONSTRAINT `transaction_items_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transaction_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  CONSTRAINT `transaction_items_ibfk_3` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table adamsbakery.transaction_items: ~6 rows (approximately)
INSERT INTO `transaction_items` (`id`, `transaction_id`, `product_id`, `package_id`, `item_type`, `quantity`, `price`) VALUES
	(37, 36, NULL, NULL, 'product', 1, 56000.00),
	(38, 37, 5, NULL, 'product', 1, 12000.00),
	(39, 37, NULL, NULL, 'product', 10, 25000.00),
	(40, 37, 9, NULL, 'product', 3, 140000.00),
	(41, 38, 17, NULL, 'product', 1, 11111.00),
	(42, 38, NULL, 4, 'package', 1, 120000.00);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
