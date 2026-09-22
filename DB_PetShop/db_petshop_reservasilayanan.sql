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
-- Table structure for table `reservasilayanan`
--

DROP TABLE IF EXISTS `reservasilayanan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservasilayanan` (
  `KodeReservasi` char(6) NOT NULL,
  `TanggalReservasi` date NOT NULL,
  `JamReservasi` time NOT NULL,
  `KodePelanggan` char(6) NOT NULL,
  `KodeHewan` char(6) NOT NULL,
  `KodeLayanan` char(6) NOT NULL,
  `KodePegawai` char(6) NOT NULL,
  `StatusReservasi` varchar(20) NOT NULL,
  PRIMARY KEY (`KodeReservasi`),
  KEY `FK_Reservasi_Pelanggan` (`KodePelanggan`),
  KEY `FK_Reservasi_Hewan` (`KodeHewan`),
  KEY `FK_Reservasi_Layanan` (`KodeLayanan`),
  KEY `FK_Reservasi_Pegawai` (`KodePegawai`),
  CONSTRAINT `FK_Reservasi_Hewan` FOREIGN KEY (`KodeHewan`) REFERENCES `hewan` (`KodeHewan`),
  CONSTRAINT `FK_Reservasi_Layanan` FOREIGN KEY (`KodeLayanan`) REFERENCES `layanan` (`KodeLayanan`),
  CONSTRAINT `FK_Reservasi_Pegawai` FOREIGN KEY (`KodePegawai`) REFERENCES `pegawai` (`KodePegawai`),
  CONSTRAINT `FK_Reservasi_Pelanggan` FOREIGN KEY (`KodePelanggan`) REFERENCES `pelanggan` (`KodePelanggan`),
  CONSTRAINT `CK_Reservasi_Status` CHECK ((`StatusReservasi` in (_utf8mb4'Booking',_utf8mb4'Selesai',_utf8mb4'Batal')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservasilayanan`
--

LOCK TABLES `reservasilayanan` WRITE;
/*!40000 ALTER TABLE `reservasilayanan` DISABLE KEYS */;
INSERT INTO `reservasilayanan` VALUES ('RSV001','2025-01-08','09:00:00','PLG001','HWN001','LYN001','PGW002','Selesai'),('RSV002','2025-01-09','10:30:00','PLG002','HWN002','LYN002','PGW002','Booking'),('RSV003','2025-01-10','13:00:00','PLG003','HWN003','LYN003','PGW002','Selesai');
/*!40000 ALTER TABLE `reservasilayanan` ENABLE KEYS */;
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
