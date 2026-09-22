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
-- Table structure for table `auditstok`
--

DROP TABLE IF EXISTS `auditstok`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditstok` (
  `KodeAudit` char(6) NOT NULL,
  `KodeProduk` char(6) NOT NULL,
  `TanggalAudit` datetime NOT NULL,
  `StokSebelum` int NOT NULL,
  `StokSesudah` int NOT NULL,
  `Keterangan` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`KodeAudit`),
  KEY `FK_AuditStok_Produk` (`KodeProduk`),
  CONSTRAINT `FK_AuditStok_Produk` FOREIGN KEY (`KodeProduk`) REFERENCES `produk` (`KodeProduk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditstok`
--

LOCK TABLES `auditstok` WRITE;
/*!40000 ALTER TABLE `auditstok` DISABLE KEYS */;
INSERT INTO `auditstok` VALUES ('AUD001','PRD001','2025-01-05 10:00:00',32,30,'Penjualan produk'),('AUD002','PRD003','2025-01-05 10:05:00',51,50,'Penjualan produk'),('AUD003','PRD002','2025-01-06 11:00:00',21,20,'Penjualan produk');
/*!40000 ALTER TABLE `auditstok` ENABLE KEYS */;
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
