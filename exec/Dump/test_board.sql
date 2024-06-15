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
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `comment_cnt` bigint NOT NULL,
  `content` text NOT NULL,
  `like_cnt` bigint NOT NULL,
  `title` varchar(30) NOT NULL,
  `view_cnt` bigint NOT NULL,
  `member_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKsds8ox89wwf6aihinar49rmfy` (`member_id`),
  CONSTRAINT `FKsds8ox89wwf6aihinar49rmfy` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board`
--

LOCK TABLES `board` WRITE;
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
INSERT INTO `board` VALUES (72,'2024-03-28 01:08:18.383784','2024-04-04 10:31:38.599695',26,'요즘 잠을 너무 못자서 피부가 너무 안좋아진거 같습니다. 건조하고 얼굴에 트러블도 너무 많이나는데 어떻게 해야할까요?',19,'남자 피부관리 방법??',37,6),(73,'2024-03-30 02:10:31.445601','2024-04-04 10:24:24.149257',14,'민감 지성 피부인데 요즘 피부 고민이 많네요..어떤 음식이 피부에 좋을까요 ㅠㅠ',5,'여드름 고민',28,1),(74,'2024-04-01 03:08:18.383784','2024-04-04 10:57:59.723711',7,'피부에 가장 좋은 음식은 물입니다! 수분을 항상 유지하세요!',4,'꿀팁!',16,30),(75,'2024-04-02 03:48:18.383784','2024-04-04 10:17:12.693298',34,'과일, 채소가 좋다는데 구체적으로 어떤 음식이 좋을까요?',15,'음식 추천 해주세요~~',36,30),(76,'2024-04-04 04:28:18.383784','2024-04-04 10:06:17.227171',25,'선크림이 피부에 영향이 꽤 있다고 들었는데 다들 얼마나 자주 얼마나 많이 바르시나요???',16,'선크림 효과',24,30),(77,'2024-04-04 05:08:18.383784','2024-04-04 10:16:45.465742',9,'얼굴에 최대한 자극이 안가게 하는게 피부 관리의 비결입니다! 혹시나 자신도 모르게 손을 대지 않는지 주의하세요!!',23,'자극을 피하라~!',50,33);
/*!40000 ALTER TABLE `board` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-04 11:25:14
