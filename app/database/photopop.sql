-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: INSTAFOTO
-- ------------------------------------------------------
-- Server version	8.0.35-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ANOM`
--

DROP TABLE IF EXISTS `ANOM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ANOM` (
  `userID` varchar(200) DEFAULT NULL,
  `hash` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ANOM`
--

LOCK TABLES `ANOM` WRITE;
/*!40000 ALTER TABLE `ANOM` DISABLE KEYS */;
INSERT INTO `ANOM` VALUES ('pZ1dNxpMYxn2YGxAxawJ4E8AwXHmHmaWOqWHqrg/yPI=','89656DA067199EE3C67EB15ADB33A1B3EFAA95F395DEB49BCD64FEC63DEF84EA8351A3A45231BA01461DEC9B07EFDD7F16983C5B1E1EA5F1E17FA47F5BD2B1C58087D749A49E7B9B2A17FC17808B0C238AD74C334DBD4C7001273F2F7BBC5E6FAD1DA2B89E7BB8A4E7D7CF4406709F19A62D9AB55FC9166B435F209B8C595CA340B88FCFF715FC5555FDF1A0D4ADCA9FCFD13D2A61E34758ABE1185DECAC2C93B1FD7DC62D64D256B0CBDCA2ACC8F92ADEC1290B4AC833BED8B3CCFB7AB4BC1B'),('Dqt0phIecdw+UyDwQ8+Nwz3MsQkdVsouW8erS3ShiUo=','89656DA067199EE3C67EB15ADB33A1B3EFAA95F395DEB49BCD64FEC63DEF84EA313242AD92F82E367E8102F1CF81C536A4C5DCB38A85FE3ECFA0250DDC8646BB184ADA0D703931C467D6200B31F0CE128C6FC018A7A801B2A377DA9F039E8E952B4982C3C02CED7D245532AF277B45DC5F86C66FD91A6EE4E24EC2E43B5CDF9065F3BE8898FFEA30E9D99A204C4DC5227EE0ABAB8ECCF6D6734B8844B15568C8DE20F9128BC38ECF8F41CE19F978D02290DED41E70B38638FE22B9ADD5B99A88'),('JlfMnuQhg63tjDTbmng65m1bssCedZk1lt+knRrFjTI=','89656DA067199EE3C67EB15ADB33A1B3EFAA95F395DEB49BCD64FEC63DEF84EA9C033AB89A6ECC199189CA23A213C0F3959B2956BFB033273D7985776647672F170A54EA0378A1AA50F678938AC9B79850F5E3A00C6C2820992021B5551E28DF8E842CAD04992F433F414701755034B454064D03A0246A2D4C78E84FFD8302521D2D1B80A38A34D7FDE89E3D85673079BCEB13466859E2349E6EC383803AEBAB0B98A5ACB7344A43A8949C46366CD98DB88FE97E85A4A8EA92CE1299DDD48359'),('U767ILoeUWcH6sXqSAVZLoa6364LPgnGOf2sK8Go60g=','BFB66353643EAF1CF32ABD3283FC44C7C9FEFDADC69113B252BC83F42C764C51DA89CFFDB1606E6A0B4374762E0CD4321BF6B2BD204DF8375C0D9386D0E87A0B440443E84C3EBBAF901EBAFC747A48AB35BEBB45A5A73526733FC3F48A5E336701094EC2F591241D8A7F167B1DB159174ED4BA1CFBB9DF80DB4B011BB109922BEFC568EDF04C70A5D68DF32C5BC98A3B0DB22B35E19D1B89EEFFF94FDC728AF6FBAF1F19F7B509C624AFBBB2BD6F33784F7A775B45DBDDA0A06F78E6CF3B604B'),('polY2ZUPz3vHPoTC4Es6vobMK7NW0TA2hfNiFTdFDQw=','89656DA067199EE3C67EB15ADB33A1B3EFAA95F395DEB49BCD64FEC63DEF84EA74BBF04A3EC0AD9A7BA1584D66EAF8E3F78FC87EF42E3F22E3B3FDC86F3335ECF2326DFC71707482FF32DF6C73BD7F3126276336223BB60F88711E4E02F14EAFC99A9043D58BCA8274BB069C05B4A868733CB484D0F0362D8F279AC25234A8B0D911278D7074DEFD63C812D833468C81F0E4941BD3A1F603FBE215F68C374EC86AFAB28587963A1B7085EADD1F8AEB23AC26FF41A598F0A32E3AD97AC407F39E'),('DlDXtJqiKRiHsw6mPCcIGSD5js/OI/CzKfLhwu33pds=','89656DA067199EE3C67EB15ADB33A1B3EFAA95F395DEB49BCD64FEC63DEF84EA6C4E1E50110078A94010ED015413F379A47C5A68E4EFD4750485FE3271C1165B9FA93ACA2A37626567BBF8150F55E216525440A3DB9BF57A34DA223FDFD384DC91DF770CB7104E2B04205F1F3062B958B0B7BC5719512E9D2BBD094F9F94C74C9E2C625B52692EB9C50EFC7CBB626B706DB2D126DD7611AB88EBAB9870124C163B1A9C41833E3754458910E5CF974660907CB42048394D5B367B99816FDA49A9'),('fRBClJ+Wh6jvBZL0OLsXc+2QuTGo/2xDEhKUcAtM9KQ=','89656DA067199EE3C67EB15ADB33A1B3EFAA95F395DEB49BCD64FEC63DEF84EA8D5942BE08E77D65EDCA2F09E29284AD9711EC99168A13998251B52D9DE4CFC3430249849C66EAD01EFFAF956BFC55E873E571AD969CCDE2F79378AF11A3FCEF8A1A76ABA42644770EFB47190B47A2A7A8E6451743247C29AA75F3F96F805630953A0268DE2F35818F0237628265496644A343729FAD1B9C5E744DEA2062649AD807C0CE84CED0B8F34873F9A3F88002F1FADF68894DFCB2F0DA777BF0199998'),('TmSCYIhiQwbsfBzUmKq9fElftc8Mu0wiVJgj2zi2zvc=','CE2A1D44DCFE1E31698C665C3461F350498C76B93E37CAD999DB9DCB4BA28AC2841D7F827D4731EBA5F07110CCBCA3052631737CD3D965589E10904F0E579762A076D375624D4644CEAAE6E42B4730A6CBAEC4CAE8D52A234810CE735E9A1B82358AE18B5FF486BDEF9B37031617A43E6706E6D16BA13031BAD62DD8193DF03996579FC0209A33DC9BD94DF14F6F0228F5EF1B152B5068CC6557CF96A0EBC5786F49F04D4A01C0A2E87195C8CBE6CD6EDB0A4A712463FD91A412EFC5188CF36A');
/*!40000 ALTER TABLE `ANOM` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AUTH`
--

DROP TABLE IF EXISTS `AUTH`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AUTH` (
  `correo` varchar(100) DEFAULT NULL,
  `token` varchar(500) DEFAULT NULL,
  `loc` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTH`
--

LOCK TABLES `AUTH` WRITE;
/*!40000 ALTER TABLE `AUTH` DISABLE KEYS */;
INSERT INTO `AUTH` VALUES ('admin@mail.com','mHsGI+3BdMLhqX2xVMI4diGfM1SmS0DMSQWJbDz+dpQ=','7V2mGJNxGBB80T+z64NUELAeK69OWJYpbw1IxdEzxNs='),('josel@mail.com','cuPhiChJSz2+2OFUCASPX/6+Bni5KrORnPoPq/v/+t8=','ia4YP+lAqUs+R6tr6K7MzeBMl0DgsMe2znGlwkQwx8o='),('marta@mail.com','HdYNyRcZrf0OyeeOGWLq/hB4xZxSvf1EqtHYjWytEd0=','O0QzMXB1Q2pLpsLZmX+F04WNjQS2MN2Wwe1X0ZsU8eQ='),('alex@mail.com','8qSxQpakpdX3jyNM5uVN9sW4zuRzb41vjFeOUd+mAh0=','EZ3gLIRGsCtr47u5G1InH+9CLzHJy5ylrnkOL4an/M4='),('pepe@mail.com','HgjBY7BTpGi61NnrvyPn2NIPJGOa4jfsuSMs1uS6qyM=','rBSZ1D0+ubFB8B0+PSHFKxh9mTEUaxCuH5xFn+j8Dug=');
/*!40000 ALTER TABLE `AUTH` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CARTERA`
--

DROP TABLE IF EXISTS `CARTERA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CARTERA` (
  `correo` varchar(200) DEFAULT NULL,
  `saldo` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CARTERA`
--

LOCK TABLES `CARTERA` WRITE;
/*!40000 ALTER TABLE `CARTERA` DISABLE KEYS */;
INSERT INTO `CARTERA` VALUES ('marta',79),('Alejandro',21),('Jose Luis',0),('admin',0),('Pepe',0);
/*!40000 ALTER TABLE `CARTERA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CATEGORIAS`
--

DROP TABLE IF EXISTS `CATEGORIAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CATEGORIAS` (
  `nombre` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CATEGORIAS`
--

LOCK TABLES `CATEGORIAS` WRITE;
/*!40000 ALTER TABLE `CATEGORIAS` DISABLE KEYS */;
INSERT INTO `CATEGORIAS` VALUES ('Informática'),('Herramientas'),('Ropa'),('Accesorios'),('Deporte'),('Muebles'),('Electrodomésticos'),('Vehículos'),('Coches'),('Motos'),('Otros'),('Decoración');
/*!40000 ALTER TABLE `CATEGORIAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CHAT`
--

DROP TABLE IF EXISTS `CHAT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CHAT` (
  `idChat` bigint NOT NULL AUTO_INCREMENT,
  `usuario1` varchar(100) DEFAULT NULL,
  `usuario2` varchar(100) DEFAULT NULL,
  `ultimoMensaje` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`idChat`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CHAT`
--

LOCK TABLES `CHAT` WRITE;
/*!40000 ALTER TABLE `CHAT` DISABLE KEYS */;
INSERT INTO `CHAT` VALUES (33,'alex','bea','eyy'),(34,'alex','tablet','ee'),(35,'bea','tablet','ee'),(36,'a','bea','eyy'),(37,'Alejandro','marta','Alejandro#30'),(38,'Jose Luis','marta','muy bien'),(60,'Alejandro','admin','eoo'),(83,'Alejandro','Jose Luis','hola');
/*!40000 ALTER TABLE `CHAT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CODIGOSMONETARIOS`
--

DROP TABLE IF EXISTS `CODIGOSMONETARIOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CODIGOSMONETARIOS` (
  `codigo` varchar(30) NOT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `cantidad` float DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CODIGOSMONETARIOS`
--

LOCK TABLES `CODIGOSMONETARIOS` WRITE;
/*!40000 ALTER TABLE `CODIGOSMONETARIOS` DISABLE KEYS */;
INSERT INTO `CODIGOSMONETARIOS` VALUES ('0E380D615DD1DB9F','Alejandro',100),('4278B454B38467FD',NULL,100),('63B8CF448A3AAC70',NULL,100),('65DBEDD9BA9362DD',NULL,100),('86DD43C1FA11C137',NULL,100),('927DFC66B8DAEB22',NULL,100),('9E09189851565AFD',NULL,100),('DB932B3D9CF9C38D',NULL,100),('E72FC5A1D068B85D',NULL,100),('FCB6288143F4F1F0',NULL,100);
/*!40000 ALTER TABLE `CODIGOSMONETARIOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COMENTARIOS`
--

DROP TABLE IF EXISTS `COMENTARIOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COMENTARIOS` (
  `idComentario` bigint NOT NULL AUTO_INCREMENT,
  `contenido` varchar(1000) DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `tiempo` bigint DEFAULT NULL,
  `idPublicacion` bigint DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idComentario`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMENTARIOS`
--

LOCK TABLES `COMENTARIOS` WRITE;
/*!40000 ALTER TABLE `COMENTARIOS` DISABLE KEYS */;
INSERT INTO `COMENTARIOS` VALUES (42,'bonitos','texto',1688419511734,58,'Alejandro'),(43,'bonita flor','texto',1688501749679,57,'admin'),(44,'muy bonito!!','texto',1688503190745,57,'Alejandro'),(45,'gracias!','texto',1688503218267,57,'marta');
/*!40000 ALTER TABLE `COMENTARIOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GUSTA`
--

DROP TABLE IF EXISTS `GUSTA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GUSTA` (
  `usuario` varchar(500) DEFAULT NULL,
  `idPublicacion` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GUSTA`
--

LOCK TABLES `GUSTA` WRITE;
/*!40000 ALTER TABLE `GUSTA` DISABLE KEYS */;
INSERT INTO `GUSTA` VALUES ('Alejandro',58),('Alejandro',57),('admin',57),('Alejandro',60);
/*!40000 ALTER TABLE `GUSTA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MENSAJES`
--

DROP TABLE IF EXISTS `MENSAJES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MENSAJES` (
  `idChat` bigint DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `contenido` varchar(10000) DEFAULT NULL,
  `emisor` varchar(100) DEFAULT NULL,
  `receptor` varchar(100) DEFAULT NULL,
  `tiempo` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MENSAJES`
--

LOCK TABLES `MENSAJES` WRITE;
/*!40000 ALTER TABLE `MENSAJES` DISABLE KEYS */;
INSERT INTO `MENSAJES` VALUES (33,'texto','hola','alex','bea',1683664094226),(33,'operacion','alex#10','alex','bea',1683664100070),(33,'texto','MUCHAS GRACIAS!','bea','alex',1683664114452),(33,'operacion','bea#10','bea','alex',1683664137626),(33,'operacion','bea#50','bea','alex',1683664151168),(34,'texto','hola amigo','alex','tablet',1683708946937),(34,'texto','holita','tablet','alex',1683708959665),(34,'operacion','alex#60','alex','tablet',1683708971742),(34,'operacion','tablet#30','tablet','alex',1683708978624),(35,'texto','ee','bea','tablet',1683709830975),(33,'texto','ey','bea','alex',1683709908662),(33,'operacion','bea#50','bea','alex',1683715043581),(33,'operacion','bea#50','bea','alex',1683715061322),(33,'texto','DISESELO','bea','alex',1684081526941),(33,'texto','MAMAHUEVO','bea','alex',1684081537851),(33,'texto','QUE ERES UN MAMAHUEVO','bea','alex',1684081546813),(33,'operacion','bea#20','bea','alex',1684150795702),(33,'texto','ey','bea','alex',1684191402013),(33,'texto','ey','bea','alex',1684191638875),(33,'texto','holaaaaa','bea','alex',1684191643262),(33,'texto','y','bea','alex',1684191676576),(33,'texto','eee','alex','bea',1684191904193),(33,'texto','que dices pichita','alex','bea',1684191919433),(33,'texto','naa','bea','alex',1684191925802),(33,'texto','gt','bea','alex',1684191933763),(33,'texto','yy','bea','alex',1684191935567),(33,'texto','kj','bea','alex',1684191937001),(33,'texto','vjj','bea','alex',1684191948267),(33,'texto','jjt','bea','alex',1684191951493),(33,'texto','sfasdfa','alex','bea',1684191957355),(33,'texto','eee','alex','bea',1684192319801),(34,'texto','amiguin','alex','tablet',1684192342084),(34,'operacion','alex#34','alex','tablet',1684192346846),(34,'texto','ee','alex','tablet',1684192367305),(33,'texto','qq','alex','bea',1684192370044),(33,'operacion','alex#24','alex','bea',1684192389544),(33,'operacion','bea#10','bea','alex',1684192415360),(33,'texto','ey','alex','bea',1684192557194),(33,'operacion','alex#45','alex','bea',1684192562442),(33,'texto','que dices locon?','bea','alex',1684192633884),(33,'operacion','bea#23','bea','alex',1684192642275),(33,'operacion','alex#23','alex','bea',1684192658402),(33,'texto','hola','bea','alex',1684359239256),(33,'texto','que te cuentas coleguÍN','bea','alex',1684359248816),(33,'texto','naa','bea','alex',1684437792486),(33,'texto','hola amigo me gusta tu obra','bea','alex',1684446715577),(33,'texto','ey','bea','alex',1684957238363),(33,'texto','oyeee','alex','bea',1684957443290),(33,'texto','que dices','alex','bea',1684957447158),(33,'texto','ton','alex','bea',1684957452171),(33,'texto','hhj','alex','bea',1684957455244),(33,'texto','huhoj','bea','alex',1684957461866),(36,'texto','hola','a','bea',1684964696338),(36,'texto','es increible como va esto','bea','a',1684964710951),(36,'texto','eyy','bea','a',1684964754004),(33,'texto','ee','bea','alex',1684964960437),(33,'texto','dsa','bea','alex',1684964966221),(33,'texto','eyy','bea','alex',1684968082846),(37,'texto','hola','Alejandro','marta',1686054241219),(37,'texto','me gusta ese traje que vendes','Alejandro','marta',1686054250780),(38,'texto','Eyyy','Jose Luis','marta',1686054842910),(38,'texto','que tal?','Jose Luis','marta',1686054849506),(38,'texto','como t va?','Jose Luis','marta',1686054864816),(38,'texto','muy bien','marta','Jose Luis',1686054900461),(37,'texto','cuesta 100€','marta','Alejandro',1686056586166),(37,'texto','es buen precio, te lo compro','Alejandro','marta',1686056614504),(37,'operacion','Alejandro#100','Alejandro','marta',1686083968319),(37,'texto','Muchas gracias','marta','marta',1686083979457),(37,'texto','ey','Alejandro','marta',1688756521464),(39,'texto','hola','Alejandro','Jose Luis',1688757055023),(39,'texto','je','Alejandro','Jose Luis',1688757114816),(37,'operacion','marta#50','marta','Alejandro',1688860665120),(37,'operacion','marta#1','marta','Alejandro',1688860687463),(51,'texto','ee','marta','admin',1688860870334),(55,'texto','eee','Alejandro','admin',1688861617005),(56,'texto','que dices','marta','admin',1688861710895),(57,'texto','hola','Alejandro','admin',1688862232232),(58,'texto','ee','Alejandro','admin',1688862447272),(NULL,'texto','oleee','Alejandro','admin',1688862679934),(59,'texto','err','Alejandro','admin',1688863130158),(60,'texto','eoo','Alejandro','admin',1688863277791),(61,'texto','hola','Alejandro','Jose Luis',1688863351945),(61,'texto','eyy','Jose Luis','Alejandro',1688863369202),(61,'texto','que','Jose Luis','Alejandro',1688863376431),(61,'texto','buenas','Alejandro','Jose Luis',1688863385026),(61,'texto','eee','Alejandro','Jose Luis',1688863402905),(61,'texto','eee','Alejandro','Jose Luis',1688863404017),(61,'texto','hola','Jose Luis','Alejandro',1688863409506),(37,'operacion','Alejandro#30','Alejandro','marta',1689447720448),(83,'texto','que dices','Alejandro','Jose Luis',1689447912965),(83,'texto','que','Alejandro','Jose Luis',1689447921915),(83,'texto','hola','Alejandro','Jose Luis',1689447925476);
/*!40000 ALTER TABLE `MENSAJES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PREFERENCIAS`
--

DROP TABLE IF EXISTS `PREFERENCIAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PREFERENCIAS` (
  `relacion` varchar(50) DEFAULT NULL,
  `interes` varchar(50) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `edadMinima` int DEFAULT NULL,
  `edadMaxima` int DEFAULT NULL,
  `distancia` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PREFERENCIAS`
--

LOCK TABLES `PREFERENCIAS` WRITE;
/*!40000 ALTER TABLE `PREFERENCIAS` DISABLE KEYS */;
INSERT INTO `PREFERENCIAS` VALUES ('Cita','Ambos','Alejandro',18,46,200),('Cita','Hombres','marta',18,39,200);
/*!40000 ALTER TABLE `PREFERENCIAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PRESENTACION`
--

DROP TABLE IF EXISTS `PRESENTACION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRESENTACION` (
  `usuario` varchar(100) DEFAULT NULL,
  `descripcion` varchar(1000) DEFAULT NULL,
  `sexo` varchar(50) DEFAULT NULL,
  `edad` int DEFAULT NULL,
  `longitud` float DEFAULT NULL,
  `latitud` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRESENTACION`
--

LOCK TABLES `PRESENTACION` WRITE;
/*!40000 ALTER TABLE `PRESENTACION` DISABLE KEYS */;
INSERT INTO `PRESENTACION` VALUES ('Alejandro','hola muy buenas','Hombre',19,0,0),('marta','Quiero conocer a alguien divertido','Mujer',30,0,0);
/*!40000 ALTER TABLE `PRESENTACION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PRODUCTO`
--

DROP TABLE IF EXISTS `PRODUCTO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUCTO` (
  `idPublicacion` bigint DEFAULT NULL,
  `categoria` varchar(500) DEFAULT NULL,
  `descripcion` varchar(1000) DEFAULT NULL,
  `precio` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUCTO`
--

LOCK TABLES `PRODUCTO` WRITE;
/*!40000 ALTER TABLE `PRODUCTO` DISABLE KEYS */;
INSERT INTO `PRODUCTO` VALUES (50,'Ropa','en perfecto estado, sin estrenar',200),(51,'Ropa','en perfecto estado',100),(52,'Ropa','de segunda mano. está en buenas condiciones',120),(62,'Informática','un ratón de cable muy bueno',5),(175,'Otros','nuevo producto',1000);
/*!40000 ALTER TABLE `PRODUCTO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PUBLICACIONES`
--

DROP TABLE IF EXISTS `PUBLICACIONES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PUBLICACIONES` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `path` varchar(1000) DEFAULT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `descripcion` varchar(5000) DEFAULT NULL,
  `denuncias` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PUBLICACIONES`
--

LOCK TABLES `PUBLICACIONES` WRITE;
/*!40000 ALTER TABLE `PUBLICACIONES` DISABLE KEYS */;
INSERT INTO `PUBLICACIONES` VALUES (50,'marta-1686052658437.jpg','users/marta/galeria/marta-1686052658437.jpg','producto','Vestido floral',0),(51,'marta-1686052698638.jpg','users/marta/galeria/marta-1686052698638.jpg','producto','Traje ejecutivo',0),(52,'marta-1686052745629.jpg','users/marta/galeria/marta-1686052745629.jpg','producto','vestido primera comunión ',0),(53,'marta-1686053993370.jpg','users/marta/galeria/marta-1686053993370.jpg','imagen','casa bonita',0),(55,'marta-1686054019851.jpg','users/marta/galeria/marta-1686054019851.jpg','imagen','frase',0),(56,'marta-1686054078978.jpg','users/marta/galeria/marta-1686054078978.jpg','imagen','playa',0),(57,'marta-1686054086656.jpg','users/marta/galeria/marta-1686054086656.jpg','imagen','nenufar',3),(58,'Alejandro-1686055873381.jpg','users/Alejandro/galeria/Alejandro-1686055873381.jpg','imagen','hidroaviones',0),(59,'Alejandro-1686055935224.jpg','users/Alejandro/galeria/Alejandro-1686055935224.jpg','imagen','cañon real',0),(60,'Alejandro-1686056081454.jpg','users/Alejandro/galeria/Alejandro-1686056081454.jpg','imagen','aquí entrenando',1),(61,'Alejandro-1686056146653.mp4','users/Alejandro/galeria/Alejandro-1686056146653.mp4','video','entrenamiento ',0),(62,'Alejandro-1688505217162.jpg','users/Alejandro/galeria/Alejandro-1688505217162.jpg','producto','ratón ',NULL),(172,'Pepe-1698949513367.jpg','users/Pepe/galeria/Pepe-1698949513367.jpg','imagen','fotodeprueba',NULL),(175,'Pepe-1698949753662.jpg','users/Pepe/galeria/Pepe-1698949753662.jpg','producto','productop',NULL);
/*!40000 ALTER TABLE `PUBLICACIONES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SIGUE`
--

DROP TABLE IF EXISTS `SIGUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SIGUE` (
  `usuario1` varchar(500) DEFAULT NULL,
  `usuario2` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SIGUE`
--

LOCK TABLES `SIGUE` WRITE;
/*!40000 ALTER TABLE `SIGUE` DISABLE KEYS */;
INSERT INTO `SIGUE` VALUES ('Alejandro','marta'),('marta','Alejandro');
/*!40000 ALTER TABLE `SIGUE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USUARIOPUBLICACION`
--

DROP TABLE IF EXISTS `USUARIOPUBLICACION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USUARIOPUBLICACION` (
  `usuario` varchar(500) DEFAULT NULL,
  `id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USUARIOPUBLICACION`
--

LOCK TABLES `USUARIOPUBLICACION` WRITE;
/*!40000 ALTER TABLE `USUARIOPUBLICACION` DISABLE KEYS */;
INSERT INTO `USUARIOPUBLICACION` VALUES ('marta',50),('marta',51),('marta',52),('marta',53),('marta',55),('marta',56),('marta',57),('Alejandro',58),('Alejandro',59),('Alejandro',60),('Alejandro',61),('Alejandro',62),('Pepe',172),('Pepe',175);
/*!40000 ALTER TABLE `USUARIOPUBLICACION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USUARIOS`
--

DROP TABLE IF EXISTS `USUARIOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USUARIOS` (
  `nombre` varchar(100) DEFAULT NULL,
  `correo` varchar(200) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `foto` varchar(500) DEFAULT NULL,
  `permisos` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USUARIOS`
--

LOCK TABLES `USUARIOS` WRITE;
/*!40000 ALTER TABLE `USUARIOS` DISABLE KEYS */;
INSERT INTO `USUARIOS` VALUES ('marta','marta@mail.com','12345678','users/marta/perfil.jpg',0),('Alejandro','alex@mail.com','987654321','users/Alejandro/perfil.jpg',0),('Jose Luis','josel@mail.com','543210987','users/Jose Luis/perfil.jpg',0),('admin','admin@mail.com','12308342',NULL,1),('Pepe','pepe@mail.com','882134812',NULL,0);
/*!40000 ALTER TABLE `USUARIOS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-03 18:34:40
