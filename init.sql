-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: balco
-- ------------------------------------------------------
-- Server version	8.0.30

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
CREATE Database balco;
use balco;
--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `appointment_id` int NOT NULL AUTO_INCREMENT,
  `d_id` int NOT NULL,
  `p_id` int NOT NULL,
  `charge` varchar(5) NOT NULL,
  `hour` int NOT NULL,
  `month` int NOT NULL,
  `day` int NOT NULL,
  `year` int NOT NULL,
  PRIMARY KEY (`appointment_id`),
  KEY `d_id` (`d_id`),
  KEY `p_id` (`p_id`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`d_id`) REFERENCES `doctors` (`doctor_id`),
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`p_id`) REFERENCES `patients` (`patient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1019 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,3,2,'1200',8,8,28,2022),(2,5,5,'800',9,8,15,2022),(3,1,4,'1400',10,9,29,2022),(4,2,2,'700',11,7,28,2022),(5,4,1,'600',12,10,16,2022),(6,5,11,'1600',15,1,20,2022),(7,6,10,'600',16,6,26,2022),(8,6,7,'600',8,9,21,2022),(9,10,8,'900',9,11,14,2022),(10,11,9,'1500',10,11,25,2022),(1014,1,1003,'1400',8,9,16,2022),(1015,7,1003,'1800',8,9,24,2022),(1016,1,1003,'1400',8,9,30,2022),(1017,1,1003,'1400',11,9,13,2022),(1018,10,1003,'900',8,9,16,2022);
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctors` (
  `doctor_id` int NOT NULL AUTO_INCREMENT,
  `doctor_ssn` varchar(15) NOT NULL,
  `charge` varchar(5) NOT NULL,
  PRIMARY KEY (`doctor_id`),
  KEY `doctor_ssn` (`doctor_ssn`),
  CONSTRAINT `doctors_ibfk_1` FOREIGN KEY (`doctor_ssn`) REFERENCES `persons` (`ssn`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

LOCK TABLES `doctors` WRITE;
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
INSERT INTO `doctors` VALUES (1,'142-66-2792','1400'),(2,'143-05-3565','700'),(3,'145-20-1506','1200'),(4,'145-30-3889','600'),(5,'856-66-4937','800'),(6,'639-82-6590','600'),(7,'642-72-6312','1800'),(8,'206-80-4630','2000'),(9,'811-64-1286','900'),(10,'146-70-9732','900'),(11,'526-97-4652','1500'),(12,'103-19-4824','1300');
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `holiday_dates`
--

DROP TABLE IF EXISTS `holiday_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `holiday_dates` (
  `holiday_id` int NOT NULL AUTO_INCREMENT,
  `resting_id` int NOT NULL,
  `reason` varchar(25) DEFAULT NULL,
  `rest_date` date NOT NULL,
  PRIMARY KEY (`holiday_id`),
  KEY `resting_id` (`resting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `holiday_dates`
--

LOCK TABLES `holiday_dates` WRITE;
/*!40000 ALTER TABLE `holiday_dates` DISABLE KEYS */;
INSERT INTO `holiday_dates` VALUES (1,6,'Other','2020-07-03'),(2,22,'Other','2020-05-31'),(3,14,'Other','2021-01-15'),(4,17,NULL,'2020-07-31'),(5,14,NULL,'2021-06-19'),(6,18,'Annual Holiday','2021-06-07'),(9,23,'Annual Holiday','2021-05-18'),(10,2,'Other','2021-04-04'),(12,23,'Other','2021-03-06'),(13,3,'Annual Holiday','2020-05-05'),(14,8,NULL,'2020-09-17');
/*!40000 ALTER TABLE `holiday_dates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `patient_id` int NOT NULL AUTO_INCREMENT,
  `patient_ssn` varchar(15) NOT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `patient_ssn` (`patient_ssn`),
  CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`patient_ssn`) REFERENCES `persons` (`ssn`)
) ENGINE=InnoDB AUTO_INCREMENT=1004 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'100-45-1173'),(2,'100-50-1722'),(3,'103-99-6905'),(4,'104-46-9870'),(5,'105-63-8664'),(6,'105-66-6671'),(7,'106-09-0996'),(8,'106-13-2714'),(9,'141-68-0561'),(10,'141-76-8604'),(11,'142-36-1160'),(1003,'4445784534');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person_contact_numbers`
--

DROP TABLE IF EXISTS `person_contact_numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_contact_numbers` (
  `contact_number` varchar(15) NOT NULL,
  `contact_ssn` varchar(15) NOT NULL,
  PRIMARY KEY (`contact_number`,`contact_ssn`),
  KEY `contact_ssn` (`contact_ssn`),
  CONSTRAINT `person_contact_numbers_ibfk_1` FOREIGN KEY (`contact_ssn`) REFERENCES `persons` (`ssn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person_contact_numbers`
--

LOCK TABLES `person_contact_numbers` WRITE;
/*!40000 ALTER TABLE `person_contact_numbers` DISABLE KEYS */;
INSERT INTO `person_contact_numbers` VALUES ('1036109649','100-45-1173'),('1039399236','100-50-1722'),('1085916278','103-99-6905'),('1088193530','104-46-9870'),('1089596166','105-63-8664'),('1094596462','105-66-6671'),('1099501626','106-09-0996'),('1135610837','106-13-2714'),('1143364573','141-68-0561'),('1177136996','141-76-8604'),('1179544952','142-36-1160'),('3424567658','4445784534');
/*!40000 ALTER TABLE `person_contact_numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persons`
--

DROP TABLE IF EXISTS `persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persons` (
  `ssn` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `birth_date` date DEFAULT NULL,
  PRIMARY KEY (`ssn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persons`
--

LOCK TABLES `persons` WRITE;
/*!40000 ALTER TABLE `persons` DISABLE KEYS */;
INSERT INTO `persons` VALUES ('100-45-1173','kdonovino7@gmail','0f6706ec51ee721badbf23c8434a9e613cc9b468ba30dac282da8c18ebf24207','Karan','Dubey','male','1962-11-06'),('100-50-1722','sujeetkumar@gmail.com','7ddd1b95a9fdfcf30b4bcd2a9e303381d1ab035640ec08d1b7be64d82d603c02','John','Fernandes','male','1974-09-08'),('103-19-4824','gvinickfi@gmail.com','ad0710e166217409204829602d6e9569a7da405da061c09360e3b893eb4f2556','Dr.George','Vinick','male','1951-02-22'),('103-99-6905','gthunner@yahoo.com','4859cfae25bfb9d40f31ed899f07aa4667f7c7be52af0864052b926293527400','Golu','Sharma','male','1989-04-27'),('104-46-9870','dgaizem1@cornell.edu','4230cac06320830ae6b57aac540202c5d9c701b73d6e2fe10c14284f610c43bf','Diwakar','Kumar','male','1982-12-03'),('105-63-8664','lioze@gmail.com','6a81db8e05ae7936f8c54cfb34c935b97930bdfc4887ffad3163810b80a83e49','Lizy','Phillip','female','1979-06-03'),('105-66-6671','ibrosnanb0@gmail.com','2d42c52555c8057cef5f1e79ba70ba1e4312196361375382ae894a83d5b932c1','Anuj','Bakshi','male','1990-08-21'),('106-09-0996','fdufaire7n@gmail.com','8232c5ff7aa64f5ccad4111704a20b079b31bd9a149985bbcedb2e9e246cc626','Rani','Kumari','female','1977-05-23'),('106-13-2714','sfooterms@gmail.com','800c651364069d8f6bba8d01f5664b95bbec1eee4f57c6bf1dad6c5480761e02','Sonu','Kumarr','male','2000-02-27'),('141-68-0561','dbetterisse7@gmail.com','a4de3c921065fe620e1c1304ae8afb09ed4305b90b7531a8e1de0d8c1207cbef','David','John','male','1953-11-23'),('141-76-8604','jjeffels2t@wisc.edu','598b02296608e9fa488fbd4643807248bf80a162496fc6a3932e24e208f2338d','Jay','Singh','male','1984-07-04'),('142-36-1160','ccolborn38@gmail.com','c9bcd8f5c93c7b5430db8f332dd78a131f7528f994653f2d5d7a49338edc8f8f','Vinay','Chaudhary','male','1962-06-29'),('142-66-2792','rmosbye9@gmail.com','73d2b95b6b29ff625faaa2f4273e9115ee73cfb7b68b2af4ea119087ea6d2c1a','Dr.Ashish','Mazumdar','male','2000-02-05'),('143-05-3565','xyewmanfv@gmail.com','0851e092eaee9d9e16c8aedc853dcd5d84611695e82dbf3a31528b7058d0adeb','Dr.Harsha','KN','male','1951-07-15'),('145-20-1506','jslight1z@gmail.com','d31e578fa48dd306a1d7157ecf0322410cb65e1d4db0cad2aba9d1c1e3de5ec4','Dr.Jay','Kumar Rai','male','1969-05-15'),('145-30-3889','ckybirdj9@gmail.com','c3cb5fdee2dc23ea92733da3118ec3364114025f0d308bc5805a985b1aa36790','Dr.Manisha','Sahu','female','1962-07-01'),('146-70-9732','cjuza6m@gmail.com','988d8f9d9448e8ae8cef7aaaa086ad86167c68aa44dcc2b68c0c43dc1c07d6f6','Dr.Sweta','Soni','female','2001-03-28'),('206-80-4630','tbenoeyc7@gmail.com','19d87ac32a6d505d9e6344bf91fae798fb5b9c719bac35d1cc43ccb26c36c3c5','Dr.Nilesh','Jain','male','1964-07-06'),('4445784525','ajay@gmail.com','$5$rounds=535000$K9S99ivmpawsBGVw$QTx87jd.wmKHsazjW5XqZoMQW/evYO.9/df4BpF7Ld1','Ajay','Vijay','male','2014-06-09'),('4445784534','shivam.kumar@gmail.com','$5$rounds=535000$x9K2boV7UtvdXSmo$5J/KZ44Ssj3ztdiO6mTOrjUXWvnqM6Us6cB8vPtR.w8','Shivam','Kumar','male','2010-02-08'),('4445784576','rudra@gmail.com','$5$rounds=535000$.XEJXV8BXJjC6jGa$Wqpy7gqXI6/ArAVYubblOWDvRVwW9sHcrEsaqcjcoB4','Rudra','Gupta','male','2022-09-15'),('526-97-4652','afortindr@gmail.com','08c465d7ea30e1c9a03d58f42b5f69a4ab3739c544340bba42552e5ef120b821','Dr.Apurva','Sharma','female','1990-07-24'),('639-82-6590','cskatcher43@gmail.com','b3180eee6f37568f4bc4bcae8afb7e6f9602485146fffd5872c86eec5c07aa65','Dr.Santosh','Tharwani','male','1969-05-12'),('642-72-6312','gjovasevicil@gmail.com','84658bdd48c432b265dedfb30120d9447c1975069fb92dec67af81cc38ad21bd','Dr.Poulami','Choudhary','female','1956-10-30'),('811-64-1286','ysetche3@gmail.com','e28968364ad5e4f6baafbefed11fa31891b14351bbeca84c55df5f2cb81dcabc','Dr.Rashmi','Rai','female','2000-06-22'),('856-66-4937','lmenlownv@gmail.com','ce94a89054f56fc86db45d745eea1af6cfa2bbca91e0ac1918400b47e66cf618','Dr.Shrestha','Tiwari','female','2003-08-17');
/*!40000 ALTER TABLE `persons` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-09-20  9:40:28
