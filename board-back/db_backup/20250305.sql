CREATE DATABASE  IF NOT EXISTS `board_project` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `board_project`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: board_project
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `board_category_tb`
--

DROP TABLE IF EXISTS `board_category_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board_category_tb` (
  `board_category_id` int NOT NULL AUTO_INCREMENT,
  `board_category_name` varchar(255) NOT NULL,
  PRIMARY KEY (`board_category_id`),
  UNIQUE KEY `board_category_name_UNIQUE` (`board_category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_category_tb`
--

LOCK TABLES `board_category_tb` WRITE;
/*!40000 ALTER TABLE `board_category_tb` DISABLE KEYS */;
INSERT INTO `board_category_tb` VALUES (2,'aaaa'),(3,'test'),(7,'데이터베이스'),(5,'리액트'),(4,'자바스크립트'),(6,'테스트');
/*!40000 ALTER TABLE `board_category_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board_like_tb`
--

DROP TABLE IF EXISTS `board_like_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board_like_tb` (
  `board_like_id` int NOT NULL AUTO_INCREMENT,
  `board_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`board_like_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_like_tb`
--

LOCK TABLES `board_like_tb` WRITE;
/*!40000 ALTER TABLE `board_like_tb` DISABLE KEYS */;
INSERT INTO `board_like_tb` VALUES (1,9,6),(2,9,7),(3,9,5),(4,9,4),(5,8,7),(6,8,5),(7,8,3),(8,7,5),(9,7,7),(10,7,8);
/*!40000 ALTER TABLE `board_like_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board_tb`
--

DROP TABLE IF EXISTS `board_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board_tb` (
  `board_id` int NOT NULL AUTO_INCREMENT,
  `board_category_id` int NOT NULL,
  `user_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `view_count` int NOT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL,
  PRIMARY KEY (`board_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_tb`
--

LOCK TABLES `board_tb` WRITE;
/*!40000 ALTER TABLE `board_tb` DISABLE KEYS */;
INSERT INTO `board_tb` VALUES (1,2,6,'테스트','<h1>테스트 내용입니다.</h1>',0,'2025-03-04 07:45:24','2025-03-04 07:45:24'),(2,3,6,'ㄻㄴㅇㄹㄴㅁㅇ','<p>ㄻㄴㅇㄻㄴㅇㄻㄴㅇㄹ</p>',0,'2025-03-04 08:16:38','2025-03-04 08:16:38'),(3,3,6,'ㄻㄴㅇㄹㄴㅁㅇ','<p>ㄻㄴㅇㄻㄴㅇㄻㄴㅇㄹ</p>',0,'2025-03-04 08:16:41','2025-03-04 08:16:41'),(4,3,6,'ㄻㄴㅇㄹㄴㅁㅇㅇㄴㄹㅇㄴㅁㄹ','<p>ㄻㄴㅇㄻㄴㅇㄻㄴㅇㄹ</p>',0,'2025-03-04 08:16:44','2025-03-04 08:16:44'),(5,4,6,'자바스크립트','<p>ㅁㄴㅇㅇㅇㅇㅇ</p>',0,'2025-03-04 08:17:07','2025-03-04 08:17:07'),(6,5,6,'리액트 수업내용','<p>ㅁㄴㅇㅇㅇㅇㅇㅇㄻㄴㅇㄴㄹ</p>',0,'2025-03-04 08:17:24','2025-03-04 08:17:24'),(7,4,7,'자바스크립트 수업','<p>ㅇㄴㄹㄴㅇㅁㄻㄴㅇㄹ</p>',0,'2025-03-04 08:18:10','2025-03-04 08:18:10'),(8,6,7,'테스트 글입니다.','<p>ㅇㄴㄹㄴㅇㅁㄻㄴㅇㄹ</p>',0,'2025-03-04 08:18:26','2025-03-04 08:18:26'),(9,7,7,'데이터베이스 수업','<p>ㅇㄴㄹㄴㅇㅁㄻㄴㅇㄹ</p>',0,'2025-03-04 08:18:41','2025-03-04 08:18:41');
/*!40000 ALTER TABLE `board_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_tb`
--

DROP TABLE IF EXISTS `role_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_tb` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(255) NOT NULL,
  `role_name_kor` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name_UNIQUE` (`role_name`),
  UNIQUE KEY `role_name_kor_UNIQUE` (`role_name_kor`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_tb`
--

LOCK TABLES `role_tb` WRITE;
/*!40000 ALTER TABLE `role_tb` DISABLE KEYS */;
INSERT INTO `role_tb` VALUES (1,'ROLE_USER','일반사용자','2025-02-25 06:24:25'),(2,'ROLE_ADMIN','관리자','2025-02-25 06:24:25');
/*!40000 ALTER TABLE `role_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role_tb`
--

DROP TABLE IF EXISTS `user_role_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role_tb` (
  `user_role_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  `created_at` timestamp NOT NULL,
  PRIMARY KEY (`user_role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role_tb`
--

LOCK TABLES `user_role_tb` WRITE;
/*!40000 ALTER TABLE `user_role_tb` DISABLE KEYS */;
INSERT INTO `user_role_tb` VALUES (1,2,1,'2025-02-27 04:06:19'),(2,3,1,'2025-02-27 07:52:35'),(3,4,1,'2025-02-27 08:41:22'),(4,5,1,'2025-02-28 01:03:16'),(5,6,1,'2025-02-28 06:32:58'),(6,7,1,'2025-02-28 07:35:03');
/*!40000 ALTER TABLE `user_role_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_tb`
--

DROP TABLE IF EXISTS `user_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_tb` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `nickname` varchar(255) NOT NULL,
  `oauth2_name` varchar(255) DEFAULT NULL,
  `oauth2_provider` varchar(255) DEFAULT NULL,
  `profile_img` varchar(255) DEFAULT NULL,
  `account_expired` int NOT NULL,
  `account_locked` int NOT NULL,
  `credentials_expired` int NOT NULL,
  `account_enabled` int NOT NULL,
  `created_at` timestamp NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_tb`
--

LOCK TABLES `user_tb` WRITE;
/*!40000 ALTER TABLE `user_tb` DISABLE KEYS */;
INSERT INTO `user_tb` VALUES (1,'test12345','$2a$10$Uo0B.2xDp3Fv3x4OcwfEge.1gff9203mPsvC2p2a4fxkOZvTpAhfS','test@gmail.com','test1234564344',NULL,NULL,'805f025d13a443029cc9d12e894ef62e_KakaoTalk_20250225_150011161_02.jpg',1,1,1,1,'2025-02-25 03:49:16'),(2,'test123456','$2a$10$6XdAp1whlTtVznR3CR27U.R73orUFP0BQadn9wnpWS1EEli2KRnla','test@gmail.com','test123456',NULL,NULL,NULL,1,1,1,1,'2025-02-27 04:06:19'),(3,'test12','$2a$10$W6QmGPgDU.MERniVV0JHUeLwrdBkECCn5hVQ8Rjroh8sD1jfIALP6','skjil1218@naver.com','test12',NULL,NULL,NULL,1,1,1,0,'2025-02-27 07:52:35'),(4,'test123','$2a$10$o4vdy3Or8I2wMh7pS3W1juEC1TzpK/iaNm8Owrdfw5FvNR.fhIB4G','skjil1218@naver.com','test123',NULL,NULL,NULL,1,1,1,1,'2025-02-27 08:41:22'),(5,'test11','$2a$10$EG.j0t/wmHCuFR1tbKjKqe6coy0UrPAOgjjMGmKWto.Tqtn5r06Tu','skjil1218@naver.com','test11',NULL,NULL,NULL,1,1,1,1,'2025-02-28 01:03:16'),(6,'google_107503745689993553322',NULL,'skjil1218@naver.com','google_107503asdfsdafasdfasdfas','107503745689993553322','google','abf86d0fd7414343aa0aae4fabd8b20c_KakaoTalk_20250225_150011161_02.jpg',1,1,1,1,'2025-02-28 06:32:58'),(7,'naver_M8MMDTsovoWm1J-pj5PEuAfEpH5FsMNwQY0q7Qp-heU',NULL,'skjil1218@gmail.com','김준일','M8MMDTsovoWm1J-pj5PEuAfEpH5FsMNwQY0q7Qp-heU','naver',NULL,1,1,1,1,'2025-02-28 07:35:03');
/*!40000 ALTER TABLE `user_tb` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-05 15:08:28
