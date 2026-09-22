CREATE DATABASE  IF NOT EXISTS `db_petshop` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_petshop`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: db_petshop
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `penjualan`
--

DROP TABLE IF EXISTS `penjualan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `penjualan` (
  `KodePenjualan` char(6) NOT NULL,
  `TanggalPenjualan` date NOT NULL,
  `KodePelanggan` char(6) NOT NULL,
  `KodePegawai` char(6) NOT NULL,
  `MetodeBayar` varchar(30) NOT NULL,
  PRIMARY KEY (`KodePenjualan`),
  KEY `FK_Penjualan_Pelanggan` (`KodePelanggan`),
  KEY `FK_Penjualan_Pegawai` (`KodePegawai`),
  CONSTRAINT `FK_Penjualan_Pegawai` FOREIGN KEY (`KodePegawai`) REFERENCES `pegawai` (`KodePegawai`),
  CONSTRAINT `FK_Penjualan_Pelanggan` FOREIGN KEY (`KodePelanggan`) REFERENCES `pelanggan` (`KodePelanggan`),
  CONSTRAINT `CK_Penjualan_MetodeBayar` CHECK ((`MetodeBayar` in (_utf8mb4'Cash',_utf8mb4'Transfer',_utf8mb4'QRIS',_utf8mb4'Debit')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `penjualan`
--

LOCK TABLES `penjualan` WRITE;
/*!40000 ALTER TABLE `penjualan` DISABLE KEYS */;
INSERT INTO `penjualan` VALUES ('PJL001','2025-01-05','PLG001','PGW001','Cash'),('PJL002','2025-01-06','PLG002','PGW001','QRIS'),('PJL003','2025-01-07','PLG003','PGW003','Transfer');
/*!40000 ALTER TABLE `penjualan` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-09  9:42:51
