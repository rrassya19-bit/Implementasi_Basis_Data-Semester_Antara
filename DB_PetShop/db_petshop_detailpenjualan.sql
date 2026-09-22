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
-- Table structure for table `detailpenjualan`
--

DROP TABLE IF EXISTS `detailpenjualan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detailpenjualan` (
  `KodePenjualan` char(6) NOT NULL,
  `KodeProduk` char(6) NOT NULL,
  `Jumlah` int NOT NULL,
  `HargaJual` decimal(18,2) NOT NULL,
  `Diskon` decimal(18,2) DEFAULT '0.00',
  PRIMARY KEY (`KodePenjualan`,`KodeProduk`),
  KEY `FK_DetailPenjualan_Produk` (`KodeProduk`),
  CONSTRAINT `FK_DetailPenjualan_Penjualan` FOREIGN KEY (`KodePenjualan`) REFERENCES `penjualan` (`KodePenjualan`),
  CONSTRAINT `FK_DetailPenjualan_Produk` FOREIGN KEY (`KodeProduk`) REFERENCES `produk` (`KodeProduk`),
  CONSTRAINT `CK_DetailPenjualan_Diskon` CHECK ((`Diskon` >= 0)),
  CONSTRAINT `CK_DetailPenjualan_HargaJual` CHECK ((`HargaJual` >= 0)),
  CONSTRAINT `CK_DetailPenjualan_Jumlah` CHECK ((`Jumlah` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detailpenjualan`
--

LOCK TABLES `detailpenjualan` WRITE;
/*!40000 ALTER TABLE `detailpenjualan` DISABLE KEYS */;
INSERT INTO `detailpenjualan` VALUES ('PJL001','PRD001',2,75000.00,0.00),('PJL001','PRD003',1,25000.00,0.00),('PJL002','PRD002',1,120000.00,10000.00),('PJL003','PRD004',2,45000.00,0.00),('PJL003','PRD005',1,30000.00,0.00);
/*!40000 ALTER TABLE `detailpenjualan` ENABLE KEYS */;
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
