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
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `authority` enum('ROLE_USER','ROLE_ADMIN') DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `notification_token` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `privacy` bit(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,'2024-03-30 17:15:42.511691','2024-04-04 10:16:39.297044','ROLE_USER','1998-09-14','ssafy1@ssafy.com','https://s3.ap-northeast-2.amazonaws.com/msm.bucket/0595cf03-ab68-4d2c-8a4e-bf49ab5b629a-코난.png','코난','fqyHZ4NTQNm0YpXaSbrEik:APA91bEvaRbA-yiHchtgilgRkm0HNHz98n5ClkS0GWpBsHmU6ZpvboL_dpP0hZS7pj-2qBYLpgSkgtREt9Tj3dzvASn2W98K2dwcS7pPFKJ7FQe0J1EWy7g0nPnY9WXbKP-1PzUKvGh5','$2a$10$cobKFlCr0EX/7ywsTnZLaeaC4lOGvYvK4H.0lbXvcfde5ggDFglge',_binary '\0'),(2,'2024-03-30 18:40:00.660117','2024-04-02 16:15:29.190679','ROLE_USER','1998-09-14','ssafy2@ssafy.com',NULL,'ㅇㅇ','fqyHZ4NTQNm0YpXaSbrEik:APA91bEvaRbA-yiHchtgilgRkm0HNHz98n5ClkS0GWpBsHmU6ZpvboL_dpP0hZS7pj-2qBYLpgSkgtREt9Tj3dzvASn2W98K2dwcS7pPFKJ7FQe0J1EWy7g0nPnY9WXbKP-1PzUKvGh5','$2a$10$4tcH25w78NNOt.7Zk5YYa.QK5HJ1fTxpIIpBV3QsdIHmutPr32zQy',_binary '\0'),(3,'2024-03-31 01:01:50.931514','2024-03-31 23:44:27.074086','ROLE_USER','2024-03-31','duna@gmail.com',NULL,'치치','cjk6sYfAQxGXyAWLKgaBwS:APA91bFg5XXAtYLzO_2T-60zpPMiMqllGe4wqXJKTIqa3fa0EGloUcwa2WqK8-55ihiqKH3bo5-InS5CiVxRcEoKTolCSvqfVgs7xfiNmkfCOerTqf3zaJKVS5u3TZsNVLBcIKh_7Nox','$2a$10$6aFRnZsMXroU0NxZID54sedhB3PHtj.8G0E1dLw.Jq1Y7qfJDsfm.',_binary ''),(4,'2024-04-01 00:41:39.579417','2024-04-02 12:51:25.081405','ROLE_USER','2016-08-01','test123@naver.com',NULL,'jkhj','dw0mWFVqTHCQlgMbzEfMsO:APA91bGC99QMKY-SEDp3_aXr4zkS3pmi5nmfTBzCDq4BOlkNX8sfVy0uiPG2z13Vqw00kmg5wJtnvV6mhLEE0MrZIDOphd5eGU357Pi9fitbOurchU1wETr21mubxukFz1M78S9U1VQ3','$2a$10$mzL9OnIQKj3z82VUAB.CUOTLBMt/sEyswtBatLl7kOnRWlZIoEzZ6',_binary '\0'),(5,'2024-04-01 00:57:24.095884','2024-04-01 00:57:24.210263','ROLE_USER','2024-04-01','chichi@chichi.com',NULL,NULL,'cjk6sYfAQxGXyAWLKgaBwS:APA91bFg5XXAtYLzO_2T-60zpPMiMqllGe4wqXJKTIqa3fa0EGloUcwa2WqK8-55ihiqKH3bo5-InS5CiVxRcEoKTolCSvqfVgs7xfiNmkfCOerTqf3zaJKVS5u3TZsNVLBcIKh_7Nox','$2a$10$EgwSCyaMcXq/bIQ7MkOtGOsOvn8qupzq/tXj3LyP.0SFqjrf7d20.',_binary '\0'),(6,'2024-04-01 01:06:44.567053','2024-04-04 10:08:28.773478','ROLE_USER','2007-04-01','ehddud0534@naver.com',NULL,'영2','fmkRxSUwSaqybQH5g1xaAu:APA91bFK9A2GxPXNoEw0PZ2l2LxxAbQNX8j9U1VikvrDMcS0ilkheOozORoVumLNJxX7DdyGNKnSTPoXo9mzI66eJBG0-uD-z62ySHKqi-_T2NjQuWUv5a9Zma7On6VRJB4RqOHh09ko','$2a$10$hmVla2P3NzZ8UkYA.iQ0Du54EGlwI8jxgwbD.lqEoGvAb9wukIepe',_binary '\0'),(7,'2024-04-01 01:07:04.540562','2024-04-01 01:12:40.168039','ROLE_USER','2024-04-01','duna12@gmail.com',NULL,'dd','cjk6sYfAQxGXyAWLKgaBwS:APA91bFg5XXAtYLzO_2T-60zpPMiMqllGe4wqXJKTIqa3fa0EGloUcwa2WqK8-55ihiqKH3bo5-InS5CiVxRcEoKTolCSvqfVgs7xfiNmkfCOerTqf3zaJKVS5u3TZsNVLBcIKh_7Nox','$2a$10$BkaIpiZfS7VkkYONwl659ucJNgRsqb9Mil0CoueEa14Xo.Gw35A0m',_binary '\0'),(8,'2024-04-01 01:36:12.043017','2024-04-01 01:36:21.141642','ROLE_USER','2024-04-01','ssafy@s.com',NULL,'momo','dLHbfzoOTIGQ8s7KK-H8sh:APA91bFocdg1ALuiO3-fkTOa7r2WDENSMYJSw9qroLiIJRgf-rrvLLt0MuSR0KR4PCrW2cuE5oa8XWSNwWOqqxGxO0UGV5Y3pV5bWlpV3aArV4HtbKHGhUfD04nNoOhb_C9jp3_U2DUm','$2a$10$slqO3T7PUnKSQ9IjVGcHH.Su5etx8/Fs3Wj5Lkwt8aHfwZ3zFCtum',_binary '\0'),(9,'2024-04-01 01:56:29.782288','2024-04-01 01:56:41.045240','ROLE_USER','2013-04-01','wondreaming@naver.copm',NULL,'모모','dLHbfzoOTIGQ8s7KK-H8sh:APA91bFocdg1ALuiO3-fkTOa7r2WDENSMYJSw9qroLiIJRgf-rrvLLt0MuSR0KR4PCrW2cuE5oa8XWSNwWOqqxGxO0UGV5Y3pV5bWlpV3aArV4HtbKHGhUfD04nNoOhb_C9jp3_U2DUm','$2a$10$9kLyW5Ubq0UCsvJX9e77eeg9MwvRv4/.7xdaimKHKLqMoN3NQ82xu',_binary '\0'),(10,'2024-04-01 02:06:56.498755','2024-04-01 05:11:57.729454','ROLE_USER','1998-09-14','ssafy5@ssafy.com','https://s3.ap-northeast-2.amazonaws.com/msm.bucket/0595cf03-ab68-4d2c-8a4e-bf49ab5b629a-코난.png',NULL,'aa','$2a$10$jGC4PFVA2kYECMNxO7eIaOZXUXFcUApfIx.0WK3cJxEimNYGcUlK6',_binary '\0'),(11,'2024-04-01 03:33:54.573951','2024-04-04 00:31:50.524163','ROLE_USER','2024-04-01','wondreaming@naver.com','https://s3.ap-northeast-2.amazonaws.com/msm.bucket/5fa380cd-dc61-4be5-a28b-f88595199a7b-upload','모모','dLHbfzoOTIGQ8s7KK-H8sh:APA91bFocdg1ALuiO3-fkTOa7r2WDENSMYJSw9qroLiIJRgf-rrvLLt0MuSR0KR4PCrW2cuE5oa8XWSNwWOqqxGxO0UGV5Y3pV5bWlpV3aArV4HtbKHGhUfD04nNoOhb_C9jp3_U2DUm','$2a$10$LYMrfShd/.s1mx4ljW68uuaToq.cRfFb8g9rDWJy1WfRRKCwn9MZe',_binary ''),(12,'2024-04-01 06:49:31.203880','2024-04-01 06:49:31.329333','ROLE_USER','1998-09-14','ssafy10@ssafy.com',NULL,NULL,'aa','$2a$10$RNT7vqhV3FxTfYExQuIU7.PNCYzTCPw7TTXhk1C0Nl.l4n5yBtmpK',_binary '\0'),(13,'2024-04-01 15:55:09.113332','2024-04-01 15:55:09.479215','ROLE_USER','1998-09-14','ssafy11@ssafy.com',NULL,NULL,'aa','$2a$10$pmEe/SpikEvVtOSMTjdCO.WL2kjrHRjScywR/clkiXbzhG5n.XBBa',_binary '\0'),(14,'2024-04-01 17:14:01.215862','2024-04-04 04:26:40.982133','ROLE_USER','2024-04-01','hyunmin266@nate.com',NULL,'dd','fIJA1CCuR1yfJKoidsjUIA:APA91bEroV7Z4ajNhFYnA_DKXAGzTaxw2DdZ6sbzsh7PDuJERhlws4eYH7iin-cQ4zecRst37a8Bwum_SYcRo1AlyDKqBq6un0ctHkMEto8rJAa78hj1ufUH-CWJGCTj79NHp2hTdFVB','$2a$10$zzrnDJlzfojC9CjyEr1I.O/UiKImT4SWumdroVfeEswtFXevAzmFC',_binary '\0'),(15,'2024-04-01 17:17:14.535403','2024-04-01 17:17:17.824467','ROLE_USER','2024-04-01','hyunmin2667@gmail.com',NULL,'dddddd','cnwN-mitSSmUTIeBIAIrcj:APA91bEuUft1P6ePuESMKkZC98wtoeT7IcfhTg1G4t-VkOiv9gffQsJCEi9R0Qq4WT7xtNYOvH6_VLdeZG8YsRmPmgemcIz_NnA0t2cv_fpBRv8wWpaCTxscb6NRgdkQml27zGOZritw','$2a$10$f1PPydQRHRd/EazXzqFgi.2QcCh9j/lmICCwcjlMfN9H/4TPR2t/2',_binary '\0'),(16,'2024-04-01 17:21:44.291299','2024-04-01 17:21:49.796858','ROLE_USER','2024-04-01','hyunmin266@nate.comd',NULL,'asdfasdfasdfasdf','cnwN-mitSSmUTIeBIAIrcj:APA91bEuUft1P6ePuESMKkZC98wtoeT7IcfhTg1G4t-VkOiv9gffQsJCEi9R0Qq4WT7xtNYOvH6_VLdeZG8YsRmPmgemcIz_NnA0t2cv_fpBRv8wWpaCTxscb6NRgdkQml27zGOZritw','$2a$10$mPpCZBYWtvbL0P0NEU1jzOHbHmGivSG8sQ/COiu51T26PP7o7d2Ny',_binary '\0'),(17,'2024-04-01 23:10:02.151015','2024-04-04 05:49:47.838563','ROLE_USER','1998-09-14','ssafy1@ssafy.comm','https://s3.ap-northeast-2.amazonaws.com/msm.bucket/30cc96f1-f3d7-4bb6-aeb6-8baa563403af-짱구.png','짱구','aa2','$2a$10$1XNbcUDanccfsNJt29oSSOpU1fPFoeE6KoO3oSKJ5yB7mfgMXX.yW',_binary '\0'),(18,'2024-04-02 12:40:14.786539','2024-04-02 14:52:25.936342','ROLE_USER','1998-04-02','1234@1234.com',NULL,'1234','eDodvbRmRgmGuk6LaMmO1X:APA91bFk9B3LNhkjUDXGT5mfRftxcFJjZO5Db9PWOfLwN8ILjFJfYwLYZwMdbMtpWIuB1FPEJ6hPKld5_2FpS1vhmBoEq214FR_d01ncBYC5v87PO5JbTg5OM1jsqi2NaGDEkVska_sc','$2a$10$OwV/xL7ArQ0oj672e6Hn7Ob.kzsM66PEXMQj6LSuTdQqtduEgaH2G',_binary '\0'),(19,'2024-04-02 20:53:01.803963','2024-04-02 21:46:44.258314','ROLE_USER','2024-04-02','test11@test.com',NULL,'ㅁㅁㅁㅁ','fG8kThedSvKwcWyMaXYhpd:APA91bGuJeXjGDzMk6xrWQjwkoOY7pZy84MiUxSMzA88AjWuvzNhwFZdKzxQUXPVT0dUP-TlP_9fO8V4Yr-MVqdKQrMBnoPeOBol7Z-qXgvI4XA5QKXEWwE2B-AkLa0jOW4tONf7ZVWG','$2a$10$AX1XVgPFtWV91xyjrZKpC.Mq4xAZotX.crprMicZOhHK30wiBqKVm',_binary '\0'),(20,'2024-04-03 10:07:06.542308','2024-04-03 10:07:16.934064','ROLE_USER','2024-04-03','wondreamin@naver.com',NULL,'clcl','dLHbfzoOTIGQ8s7KK-H8sh:APA91bFocdg1ALuiO3-fkTOa7r2WDENSMYJSw9qroLiIJRgf-rrvLLt0MuSR0KR4PCrW2cuE5oa8XWSNwWOqqxGxO0UGV5Y3pV5bWlpV3aArV4HtbKHGhUfD04nNoOhb_C9jp3_U2DUm','$2a$10$vmFYVm52SgadAGUCXqXh9.t3f/Dq3eYomm1dnEU0csr/CT330ddLe',_binary '\0'),(21,'2024-04-03 10:27:31.853198','2024-04-03 10:27:46.083498','ROLE_USER','2024-04-03','wondream@naver.com',NULL,'모모','dLHbfzoOTIGQ8s7KK-H8sh:APA91bFocdg1ALuiO3-fkTOa7r2WDENSMYJSw9qroLiIJRgf-rrvLLt0MuSR0KR4PCrW2cuE5oa8XWSNwWOqqxGxO0UGV5Y3pV5bWlpV3aArV4HtbKHGhUfD04nNoOhb_C9jp3_U2DUm','$2a$10$xI4Pil3NmaNs7nGdbR3Sne/ALjLTrWtDiGlPfajn.EZiMNH6ZAA/y',_binary '\0'),(22,'2024-04-03 14:21:59.183162','2024-04-03 14:22:07.057634','ROLE_USER','1996-04-03','test1234@naver.com',NULL,'테스트계정','dvm6MrEHRsao_KDxcm62xr:APA91bGtKkcncTzkLLyXtk1JEW-bnRP3xUnihmscaRPFXvwPoV6FDIYxPAsc8OMhtpqrQRE7uWa07NV4Ap0EHGbyVzJxkYSEHQk57i3MugYrSuf4fC-Onj0O77YuN_NRuRDIPx9oo1iz','$2a$10$nXepRrt3xVo7CLCj5sVFTOQR5cl76E8kiMezYTP/eiTFlc537L6Ce',_binary '\0'),(23,'2024-04-03 14:38:39.065986','2024-04-03 14:52:36.957177','ROLE_USER','1999-04-03','qwer@naver.com',NULL,'테스트2','fG8kThedSvKwcWyMaXYhpd:APA91bGuJeXjGDzMk6xrWQjwkoOY7pZy84MiUxSMzA88AjWuvzNhwFZdKzxQUXPVT0dUP-TlP_9fO8V4Yr-MVqdKQrMBnoPeOBol7Z-qXgvI4XA5QKXEWwE2B-AkLa0jOW4tONf7ZVWG','$2a$10$umPz.bbpZ6lTPXECAYofo.5znZN3PfaYb1fOqxZ6b4NHjLtjQK4ym',_binary '\0'),(24,'2024-04-03 15:29:48.494561','2024-04-03 15:29:58.828219','ROLE_USER','1988-04-03','a@a.com',NULL,'강컨','crsrmlMUSoKQUDK_1vrhlq:APA91bHMSI9BHmsds2P6yVDEFjH6G1fpWjx_HR1JKPZApjSPM3wPy4xCtFjiJCgPhuV17TFDCXEbnxyTXHe9LkulVUJx7GZKYzxeZGUvCIEbBCQtL-lSv94BAIzsLgjegFG2p6FcF6V4','$2a$10$Yeq0khhGwhzEMvPplaYttuNT3gwstVsRQ9VByjRwy7z4fFl4W76i.',_binary '\0'),(25,'2024-04-03 15:45:29.794377','2024-04-03 15:45:45.299518','ROLE_USER','2024-04-03','won@naver.com',NULL,'치치','dLHbfzoOTIGQ8s7KK-H8sh:APA91bFocdg1ALuiO3-fkTOa7r2WDENSMYJSw9qroLiIJRgf-rrvLLt0MuSR0KR4PCrW2cuE5oa8XWSNwWOqqxGxO0UGV5Y3pV5bWlpV3aArV4HtbKHGhUfD04nNoOhb_C9jp3_U2DUm','$2a$10$RJ1j34WvZEXw.vfUAnMIAegGLz7CjdCzjpliDT.NYbaSAxDytPeAO',_binary '\0'),(26,'2024-04-03 15:56:52.985014','2024-04-03 15:56:57.715308','ROLE_USER','1990-04-03','coach@ssafy.com',NULL,'코치','fpyydFgpQG27jtJSEtqnYf:APA91bHPfGONAZ17HzumkQCgOi9DBGEcbUE1kDSSFu-EoDJen_JcRhFyKupx2LzRlQBD68Kun8Ql4c7mQRuEqSxJrPT7EK4BhCExwtIlbYSIjXZejTh2q1pAjxVgDik55nb5SAx0OTYg','$2a$10$Ud2K23Q8JajQ4adE1uw.2u3huGILvLndApauQVVZ/lllo.4BTYUMu',_binary '\0'),(27,'2024-04-03 17:01:28.984799','2024-04-03 17:01:33.927378','ROLE_USER','2024-04-03','wond@naver.com',NULL,'gg','dLHbfzoOTIGQ8s7KK-H8sh:APA91bFocdg1ALuiO3-fkTOa7r2WDENSMYJSw9qroLiIJRgf-rrvLLt0MuSR0KR4PCrW2cuE5oa8XWSNwWOqqxGxO0UGV5Y3pV5bWlpV3aArV4HtbKHGhUfD04nNoOhb_C9jp3_U2DUm','$2a$10$aN91CR5MYUTWNtBxAnBLcOJG2bF/S1q20nbVZki/FkzhvzQz5x7Aq',_binary '\0'),(28,'2024-04-03 17:28:55.093946','2024-04-03 17:29:06.235296','ROLE_USER','2024-04-03','wonde@naver.com',NULL,'fffggg','dLHbfzoOTIGQ8s7KK-H8sh:APA91bFocdg1ALuiO3-fkTOa7r2WDENSMYJSw9qroLiIJRgf-rrvLLt0MuSR0KR4PCrW2cuE5oa8XWSNwWOqqxGxO0UGV5Y3pV5bWlpV3aArV4HtbKHGhUfD04nNoOhb_C9jp3_U2DUm','$2a$10$pTAkQIAsKo9YRI9UIfXz7uMat7sUC./8exM47AFQqnIZF7KheEIpu',_binary '\0'),(29,'2024-04-04 01:30:54.765968','2024-04-04 07:27:00.775126','ROLE_USER','1991-04-03','wo@naver.com','https://s3.ap-northeast-2.amazonaws.com/msm.bucket/932755e1-bfed-4f52-b29c-c755cb391617-upload','ㅓㅏㅓㅏㅓㅏ','dLHbfzoOTIGQ8s7KK-H8sh:APA91bFocdg1ALuiO3-fkTOa7r2WDENSMYJSw9qroLiIJRgf-rrvLLt0MuSR0KR4PCrW2cuE5oa8XWSNwWOqqxGxO0UGV5Y3pV5bWlpV3aArV4HtbKHGhUfD04nNoOhb_C9jp3_U2DUm','$2a$10$Oad09G5ut.Du8ybi11wZK.b.z9tKNTh6ftLSbKR1lYDRKEN2lUZr6',_binary ''),(30,'2024-02-24 05:05:45.101314','2024-04-04 10:18:47.855594','ROLE_USER','1998-09-14','ssj0187@ssafy.com','https://s3.ap-northeast-2.amazonaws.com/msm.bucket/e26423bd-7725-4d65-af6d-43a8210fdf3f-제육볶음.jpg','주니','fmkRxSUwSaqybQH5g1xaAu:APA91bFK9A2GxPXNoEw0PZ2l2LxxAbQNX8j9U1VikvrDMcS0ilkheOozORoVumLNJxX7DdyGNKnSTPoXo9mzI66eJBG0-uD-z62ySHKqi-_T2NjQuWUv5a9Zma7On6VRJB4RqOHh09ko','$2a$10$fgplNGGk/9NyBYBA025LwucrAm/2kkwlDPSIhyqBBPGtWMKjcbuda',_binary '\0'),(31,'2024-04-04 05:37:07.834259','2024-04-04 05:38:22.858808','ROLE_USER','2016-04-04','ssafy1@ssafy.commm','https://s3.ap-northeast-2.amazonaws.com/msm.bucket/d4bc5610-1b28-4d08-bac4-18b7ae0d9e35-upload','곰보빵','dKStZ3-8S-KH-AqJL21Ddp:APA91bERAJiHf5sFB-HuKF1ahsJQwGgwDMhCRXMFVe9yPFQI8NcgecEVu6rORP2Zs2aTlWRLFkOG2bUHOhKzrOC5hNvV5AklJ4HmUsqERovGPRzWldhqz8tYR79yuY5xv7yrdzCUfDIP','$2a$10$mpI1x6DAS71WajANJ3yx6Onz/fcqDq59iczcUC5tcZR0n0rpaM.yC',_binary '\0'),(32,'2024-04-04 05:39:14.220340','2024-04-04 05:39:49.962275','ROLE_USER','1998-04-04','ssafy1@ssafy.commmm','https://s3.ap-northeast-2.amazonaws.com/msm.bucket/800699df-81c8-4b37-be8f-54999faff4da-upload','독도','dKStZ3-8S-KH-AqJL21Ddp:APA91bERAJiHf5sFB-HuKF1ahsJQwGgwDMhCRXMFVe9yPFQI8NcgecEVu6rORP2Zs2aTlWRLFkOG2bUHOhKzrOC5hNvV5AklJ4HmUsqERovGPRzWldhqz8tYR79yuY5xv7yrdzCUfDIP','$2a$10$grpgGamYpnTmuwK1ibZD8.1OrKJM9zuWI.g4cxopzMRN11hC8GYli',_binary '\0'),(33,'2024-04-04 05:40:11.795535','2024-04-04 05:40:55.798227','ROLE_USER','2012-04-04','ssafy1@ssafy.commmmm','https://s3.ap-northeast-2.amazonaws.com/msm.bucket/83b4d218-029b-406f-b87f-4a2b52a97e18-upload','핫식스','dKStZ3-8S-KH-AqJL21Ddp:APA91bERAJiHf5sFB-HuKF1ahsJQwGgwDMhCRXMFVe9yPFQI8NcgecEVu6rORP2Zs2aTlWRLFkOG2bUHOhKzrOC5hNvV5AklJ4HmUsqERovGPRzWldhqz8tYR79yuY5xv7yrdzCUfDIP','$2a$10$RTiOCZI.z3zS5gG8j0aqdOnAwK1q.xXwsqeGOM9Vtce96mrk3lJeC',_binary '\0'),(34,'2024-04-04 05:53:49.758705','2024-04-04 05:53:55.196717','ROLE_USER','2009-04-03','test12@naver.com',NULL,'test14','fIJA1CCuR1yfJKoidsjUIA:APA91bEroV7Z4ajNhFYnA_DKXAGzTaxw2DdZ6sbzsh7PDuJERhlws4eYH7iin-cQ4zecRst37a8Bwum_SYcRo1AlyDKqBq6un0ctHkMEto8rJAa78hj1ufUH-CWJGCTj79NHp2hTdFVB','$2a$10$ONJu/4WJBiEq.91.MMEqZOpMAIFdrcLZUujex9w8XHv/NDNmxKm8a',_binary '\0'),(35,'2024-04-04 06:00:43.729162','2024-04-04 06:08:28.191767','ROLE_USER','1991-04-04','test123123@naver.com',NULL,'닉네임','fG8kThedSvKwcWyMaXYhpd:APA91bGuJeXjGDzMk6xrWQjwkoOY7pZy84MiUxSMzA88AjWuvzNhwFZdKzxQUXPVT0dUP-TlP_9fO8V4Yr-MVqdKQrMBnoPeOBol7Z-qXgvI4XA5QKXEWwE2B-AkLa0jOW4tONf7ZVWG','$2a$10$q.rQDTtjQR/2jHv7S8Jkk.57sISXng/CsErBkTj3Vr33mCNN65jfW',_binary '\0'),(36,'2024-04-04 09:30:11.292419','2024-04-04 09:30:11.398152','ROLE_USER','2000-01-01','gildong@gmail.com',NULL,NULL,'abc','$2a$10$mAWaChcV.4imEa8hnTH0IO42zAO6a9NEPj/vJf0UfxSwY/WC/UIkm',_binary '\0');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-04 11:25:23
