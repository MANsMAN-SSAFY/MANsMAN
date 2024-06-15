-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 3.38.101.110    Database: test
-- ------------------------------------------------------
-- Server version	8.3.0

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
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `acne` int NOT NULL,
  `age` int NOT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `skin_type` enum('OILY','DRY','NORMAL') DEFAULT NULL,
  `sleep` double DEFAULT NULL,
  `water` double DEFAULT NULL,
  `wrinkle` int NOT NULL,
  `code` int DEFAULT NULL,
  `member_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3dbcs8bny0og4qycy265tndfn` (`code`),
  KEY `FKel7y5wyx42a6njav1dbe2torl` (`member_id`),
  CONSTRAINT `FK3dbcs8bny0og4qycy265tndfn` FOREIGN KEY (`code`) REFERENCES `common_code` (`code`),
  CONSTRAINT `FKel7y5wyx42a6njav1dbe2torl` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report`
--

LOCK TABLES `report` WRITE;
/*!40000 ALTER TABLE `report` DISABLE KEYS */;
INSERT INTO `report` VALUES (32,'2024-03-29 05:16:32.675783','2024-03-29 05:16:32.675783',38,23,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/f5f18597-1fd9-440a-bdb0-6c7b50a36221-scaled_250px-240301_Cha_Eun-woo.jpg','메모를 작성해주세요','NORMAL',6,1200,8,40003,30),(33,'2024-03-30 05:18:15.814219','2024-03-30 05:18:15.814219',13,20,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/d96f4e1f-2fca-47bb-836f-930ac51d8171-scaled_202306211104055510_1.jpg','메모를 작성해주세요','NORMAL',8,1200,3,40003,30),(34,'2024-03-31 05:20:40.181139','2024-03-31 05:20:40.181139',30,20,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/63857be9-0832-4f73-adcf-f96ce3614ef2-scaled_mb_1682303925565083.jpg','메모를 작성해주세요','NORMAL',7,1800,7,40003,30),(35,'2024-04-01 05:24:03.419372','2024-04-01 05:24:03.419372',19,20,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/8e163aca-b2e9-49f6-a450-a510c9d0fda9-scaled_2022033002001805200348151.jpg','메모를 작성해주세요','NORMAL',6,1600,3,40003,30),(36,'2024-04-02 05:25:23.894520','2024-04-02 05:25:23.894520',22,18,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/1b9e18a2-00f8-497c-a476-fe0f5c054750-scaled_KakaoTalk_20200807_164932040_01.jpg','메모를 작성해주세요','NORMAL',7,1200,3,40003,30),(39,'2024-04-03 05:31:24.669511','2024-04-04 10:38:08.196626',17,19,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/0124af8b-dbd5-4a96-a02a-f88afcb5ecfe-scaled_202208161740776246_62fb5a1f76eba.jpg','메모를 작성해주세요','NORMAL',7,1000,4,40003,30),(44,'2024-04-04 06:31:15.345960','2024-04-04 10:18:06.861932',13,23,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/aed713e9-edeb-4b51-ba08-e67dd1f3110b-scaled_tumblr_o9qk9aU81d1uvwvl5o1_1280.png','좋ㅇ기','NORMAL',6,1800,4,40002,6),(45,'2024-04-04 06:31:15.345960','2024-04-04 06:31:15.345960',15,22,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/aed713e9-edeb-4b51-ba08-e67dd1f3110b-scaled_tumblr_o9qk9aU81d1uvwvl5o1_1280.png','메모를 작성해주세요','OILY',0,0,3,40004,1),(46,'2024-04-04 06:31:15.345960','2024-04-04 06:31:15.345960',23,26,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/aed713e9-edeb-4b51-ba08-e67dd1f3110b-scaled_tumblr_o9qk9aU81d1uvwvl5o1_1280.png','메모를 작성해주세요','DRY',0,0,1,40003,17),(47,'2024-04-04 06:31:15.345960','2024-04-04 06:31:15.345960',14,29,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/aed713e9-edeb-4b51-ba08-e67dd1f3110b-scaled_tumblr_o9qk9aU81d1uvwvl5o1_1280.png','메모를 작성해주세요','DRY',0,0,16,40004,31),(48,'2024-04-04 06:31:15.345960','2024-04-04 06:31:15.345960',9,21,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/aed713e9-edeb-4b51-ba08-e67dd1f3110b-scaled_tumblr_o9qk9aU81d1uvwvl5o1_1280.png','메모를 작성해주세요','OILY',0,0,23,40001,32),(49,'2024-04-04 06:31:15.345960','2024-04-04 06:31:15.345960',22,18,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/aed713e9-edeb-4b51-ba08-e67dd1f3110b-scaled_tumblr_o9qk9aU81d1uvwvl5o1_1280.png','메모를 작성해주세요','OILY',0,0,9,40002,33),(51,'2024-04-04 07:27:28.224017','2024-04-04 07:27:28.224017',12,27,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/baa5d12d-8427-4a7f-96f8-c8cd7d641520-scaled_c06b5fe6-370b-43ed-acbe-19c5eaeb223a5736775068369265733.jpg','메모를 작성해주세요','NORMAL',0,0,8,40001,29),(52,'2024-04-04 09:11:45.774898','2024-04-04 09:25:16.279774',12,16,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/a79e36a7-80f3-4bb7-a947-c20dbf4aa24e-scaled_94e2ceda-9440-49ea-89fc-397975fdfaa84246159108301192544.jpg','ㅁㄴㅇㅎㅁㄴㅇㅁㄴㅇ','NORMAL',3,1400,4,40001,35),(55,'2024-04-04 09:55:17.113954','2024-04-04 10:10:25.880664',12,26,'https://s3.ap-northeast-2.amazonaws.com/msm.bucket/36c9fa33-7176-4d8c-9124-7ab3f907501a-scaled_480efa60-15e4-4991-820f-8902623558ad6472736586943795418.jpg','메모를 작성해주세요','NORMAL',10.5,400,10,40001,11);
/*!40000 ALTER TABLE `report` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-04 11:25:20
