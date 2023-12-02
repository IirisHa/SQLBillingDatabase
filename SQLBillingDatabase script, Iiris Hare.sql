-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ER-kaavio_Laskutus
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `ER-kaavio_Laskutus` ;

-- -----------------------------------------------------
-- Schema ER-kaavio_Laskutus
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ER-kaavio_Laskutus` DEFAULT CHARACTER SET utf8 ;
USE `ER-kaavio_Laskutus` ;

-- -----------------------------------------------------
-- Table `ER-kaavio_Laskutus`.`posti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ER-kaavio_Laskutus`.`posti` ;

CREATE TABLE IF NOT EXISTS `ER-kaavio_Laskutus`.`posti` (
  `postinro` CHAR(5) NOT NULL,
  `postitoimipaikka` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`postinro`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ER-kaavio_Laskutus`.`asiakas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ER-kaavio_Laskutus`.`asiakas` ;

CREATE TABLE IF NOT EXISTS `ER-kaavio_Laskutus`.`asiakas` (
  `asiakasid` INT NOT NULL AUTO_INCREMENT,
  `enimi` VARCHAR(45) NOT NULL,
  `snimi` VARCHAR(45) NOT NULL,
  `osoite` VARCHAR(45) NOT NULL,
  `postinro` CHAR(5) NOT NULL,
  PRIMARY KEY (`asiakasid`),
  INDEX `fk_asiakas_posti1_idx` (`postinro` ASC),
  CONSTRAINT `fk_asiakas_posti1`
    FOREIGN KEY (`postinro`)
    REFERENCES `ER-kaavio_Laskutus`.`posti` (`postinro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ER-kaavio_Laskutus`.`laskuttaja`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ER-kaavio_Laskutus`.`laskuttaja` ;

CREATE TABLE IF NOT EXISTS `ER-kaavio_Laskutus`.`laskuttaja` (
  `laskuttajaid` INT NOT NULL AUTO_INCREMENT,
  `enimi` VARCHAR(45) NOT NULL,
  `snimi` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`laskuttajaid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ER-kaavio_Laskutus`.`maksutapa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ER-kaavio_Laskutus`.`maksutapa` ;

CREATE TABLE IF NOT EXISTS `ER-kaavio_Laskutus`.`maksutapa` (
  `maksutapaid` INT NOT NULL AUTO_INCREMENT,
  `maksutapa` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`maksutapaid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ER-kaavio_Laskutus`.`tuote`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ER-kaavio_Laskutus`.`tuote` ;

CREATE TABLE IF NOT EXISTS `ER-kaavio_Laskutus`.`tuote` (
  `tuoteid` INT NOT NULL AUTO_INCREMENT,
  `tuotenimi` VARCHAR(45) NOT NULL,
  `hinta(€)` DOUBLE NOT NULL,
  PRIMARY KEY (`tuoteid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ER-kaavio_Laskutus`.`laskun_tila`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ER-kaavio_Laskutus`.`laskun_tila` ;

CREATE TABLE IF NOT EXISTS `ER-kaavio_Laskutus`.`laskun_tila` (
  `laskuntilaid` INT NOT NULL,
  `laskuntila` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`laskuntilaid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ER-kaavio_Laskutus`.`laskun_tiedot`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ER-kaavio_Laskutus`.`laskun_tiedot` ;

CREATE TABLE IF NOT EXISTS `ER-kaavio_Laskutus`.`laskun_tiedot` (
  `laskuid` INT NOT NULL AUTO_INCREMENT,
  `viitenumero` VARCHAR(45) NOT NULL,
  `lahetyspvm` DATE NOT NULL,
  `erapaiva` DATE NOT NULL,
  `laskuttajaid` INT NOT NULL,
  `asiakasid` INT NOT NULL,
  `maksutapaid` INT NOT NULL,
  `laskuntilaid` INT NOT NULL,
  PRIMARY KEY (`laskuid`, `laskuttajaid`, `asiakasid`, `maksutapaid`, `laskuntilaid`),
  INDEX `fk_laskun_tiedot_laskuttaja1_idx` (`laskuttajaid` ASC),
  INDEX `fk_laskun_tiedot_asiakas1_idx` (`asiakasid` ASC),
  INDEX `fk_laskun_tiedot_maksutapa1_idx` (`maksutapaid` ASC),
  INDEX `fk_laskun_tiedot_laskun_tila1_idx` (`laskuntilaid` ASC),
  CONSTRAINT `fk_laskun_tiedot_laskuttaja1`
    FOREIGN KEY (`laskuttajaid`)
    REFERENCES `ER-kaavio_Laskutus`.`laskuttaja` (`laskuttajaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_laskun_tiedot_asiakas1`
    FOREIGN KEY (`asiakasid`)
    REFERENCES `ER-kaavio_Laskutus`.`asiakas` (`asiakasid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_laskun_tiedot_maksutapa1`
    FOREIGN KEY (`maksutapaid`)
    REFERENCES `ER-kaavio_Laskutus`.`maksutapa` (`maksutapaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_laskun_tiedot_laskun_tila1`
    FOREIGN KEY (`laskuntilaid`)
    REFERENCES `ER-kaavio_Laskutus`.`laskun_tila` (`laskuntilaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ER-kaavio_Laskutus`.`tuoteyhteys`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ER-kaavio_Laskutus`.`tuoteyhteys` ;

CREATE TABLE IF NOT EXISTS `ER-kaavio_Laskutus`.`tuoteyhteys` (
  `laskuid` INT NOT NULL,
  `tuoteid` INT NOT NULL,
  PRIMARY KEY (`laskuid`, `tuoteid`),
  INDEX `fk_laskun_tiedot_has_tuote_tuote1_idx` (`tuoteid` ASC),
  INDEX `fk_laskun_tiedot_has_tuote_laskun_tiedot1_idx` (`laskuid` ASC),
  CONSTRAINT `fk_laskun_tiedot_has_tuote_laskun_tiedot1`
    FOREIGN KEY (`laskuid`)
    REFERENCES `ER-kaavio_Laskutus`.`laskun_tiedot` (`laskuid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_laskun_tiedot_has_tuote_tuote1`
    FOREIGN KEY (`tuoteid`)
    REFERENCES `ER-kaavio_Laskutus`.`tuote` (`tuoteid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `ER-kaavio_Laskutus`.`posti`
-- -----------------------------------------------------
START TRANSACTION;
USE `ER-kaavio_Laskutus`;
INSERT INTO `ER-kaavio_Laskutus`.`posti` (`postinro`, `postitoimipaikka`) VALUES ('79700', 'Heinävesi');
INSERT INTO `ER-kaavio_Laskutus`.`posti` (`postinro`, `postitoimipaikka`) VALUES ('70100', 'Kuopio');
INSERT INTO `ER-kaavio_Laskutus`.`posti` (`postinro`, `postitoimipaikka`) VALUES ('80130', 'Joensuu');
INSERT INTO `ER-kaavio_Laskutus`.`posti` (`postinro`, `postitoimipaikka`) VALUES ('55700', 'Imatra');
INSERT INTO `ER-kaavio_Laskutus`.`posti` (`postinro`, `postitoimipaikka`) VALUES ('20210', 'Turku');
INSERT INTO `ER-kaavio_Laskutus`.`posti` (`postinro`, `postitoimipaikka`) VALUES ('39501', 'Ikaalinen');
INSERT INTO `ER-kaavio_Laskutus`.`posti` (`postinro`, `postitoimipaikka`) VALUES ('73301', 'Nilsiä');
INSERT INTO `ER-kaavio_Laskutus`.`posti` (`postinro`, `postitoimipaikka`) VALUES ('71201', 'Tuusniemi');
INSERT INTO `ER-kaavio_Laskutus`.`posti` (`postinro`, `postitoimipaikka`) VALUES ('73500', 'Juankoski');
INSERT INTO `ER-kaavio_Laskutus`.`posti` (`postinro`, `postitoimipaikka`) VALUES ('73600', 'Kaavi');

COMMIT;


-- -----------------------------------------------------
-- Data for table `ER-kaavio_Laskutus`.`asiakas`
-- -----------------------------------------------------
START TRANSACTION;
USE `ER-kaavio_Laskutus`;
INSERT INTO `ER-kaavio_Laskutus`.`asiakas` (`asiakasid`, `enimi`, `snimi`, `osoite`, `postinro`) VALUES (1, 'Marleena', 'Leppänen', 'Puistotie 3', '70100');
INSERT INTO `ER-kaavio_Laskutus`.`asiakas` (`asiakasid`, `enimi`, `snimi`, `osoite`, `postinro`) VALUES (2, 'Jouni', 'Salo', 'Koivistokuja', '73600');
INSERT INTO `ER-kaavio_Laskutus`.`asiakas` (`asiakasid`, `enimi`, `snimi`, `osoite`, `postinro`) VALUES (3, 'Hannele', 'Huovikka', 'Torikatu', '71201');

COMMIT;


-- -----------------------------------------------------
-- Data for table `ER-kaavio_Laskutus`.`laskuttaja`
-- -----------------------------------------------------
START TRANSACTION;
USE `ER-kaavio_Laskutus`;
INSERT INTO `ER-kaavio_Laskutus`.`laskuttaja` (`laskuttajaid`, `enimi`, `snimi`) VALUES (1, 'Iiris', 'Hare');
INSERT INTO `ER-kaavio_Laskutus`.`laskuttaja` (`laskuttajaid`, `enimi`, `snimi`) VALUES (2, 'Finlay', 'Hare');
INSERT INTO `ER-kaavio_Laskutus`.`laskuttaja` (`laskuttajaid`, `enimi`, `snimi`) VALUES (3, 'Tmi', 'Musiikkia maaseudulla');

COMMIT;


-- -----------------------------------------------------
-- Data for table `ER-kaavio_Laskutus`.`maksutapa`
-- -----------------------------------------------------
START TRANSACTION;
USE `ER-kaavio_Laskutus`;
INSERT INTO `ER-kaavio_Laskutus`.`maksutapa` (`maksutapaid`, `maksutapa`) VALUES (1, 'lasku');
INSERT INTO `ER-kaavio_Laskutus`.`maksutapa` (`maksutapaid`, `maksutapa`) VALUES (2, 'korttimaksu');
INSERT INTO `ER-kaavio_Laskutus`.`maksutapa` (`maksutapaid`, `maksutapa`) VALUES (3, 'käteinen');

COMMIT;


-- -----------------------------------------------------
-- Data for table `ER-kaavio_Laskutus`.`tuote`
-- -----------------------------------------------------
START TRANSACTION;
USE `ER-kaavio_Laskutus`;
INSERT INTO `ER-kaavio_Laskutus`.`tuote` (`tuoteid`, `tuotenimi`, `hinta(€)`) VALUES (1, 'pianotunti 30min', 30);
INSERT INTO `ER-kaavio_Laskutus`.`tuote` (`tuoteid`, `tuotenimi`, `hinta(€)`) VALUES (2, 'pianotunti 45min', 45);
INSERT INTO `ER-kaavio_Laskutus`.`tuote` (`tuoteid`, `tuotenimi`, `hinta(€)`) VALUES (3, 'pianotunti 60min', 60);
INSERT INTO `ER-kaavio_Laskutus`.`tuote` (`tuoteid`, `tuotenimi`, `hinta(€)`) VALUES (4, 'sellotunti 30min', 30);
INSERT INTO `ER-kaavio_Laskutus`.`tuote` (`tuoteid`, `tuotenimi`, `hinta(€)`) VALUES (5, 'sellotunti 45min', 45);
INSERT INTO `ER-kaavio_Laskutus`.`tuote` (`tuoteid`, `tuotenimi`, `hinta(€)`) VALUES (6, 'sellotunti 60min', 60);
INSERT INTO `ER-kaavio_Laskutus`.`tuote` (`tuoteid`, `tuotenimi`, `hinta(€)`) VALUES (7, 'esiintyminen', 600);

COMMIT;


-- -----------------------------------------------------
-- Data for table `ER-kaavio_Laskutus`.`laskun_tila`
-- -----------------------------------------------------
START TRANSACTION;
USE `ER-kaavio_Laskutus`;
INSERT INTO `ER-kaavio_Laskutus`.`laskun_tila` (`laskuntilaid`, `laskuntila`) VALUES (1, 'auki');
INSERT INTO `ER-kaavio_Laskutus`.`laskun_tila` (`laskuntilaid`, `laskuntila`) VALUES (2, 'maksettu');
INSERT INTO `ER-kaavio_Laskutus`.`laskun_tila` (`laskuntilaid`, `laskuntila`) VALUES (3, 'erääntynyt');

COMMIT;


-- -----------------------------------------------------
-- Data for table `ER-kaavio_Laskutus`.`laskun_tiedot`
-- -----------------------------------------------------
START TRANSACTION;
USE `ER-kaavio_Laskutus`;
INSERT INTO `ER-kaavio_Laskutus`.`laskun_tiedot` (`laskuid`, `viitenumero`, `lahetyspvm`, `erapaiva`, `laskuttajaid`, `asiakasid`, `maksutapaid`, `laskuntilaid`) VALUES (1, '70100', '2023-01-01', '2023-01-15', 1, 2, 1, 1);
INSERT INTO `ER-kaavio_Laskutus`.`laskun_tiedot` (`laskuid`, `viitenumero`, `lahetyspvm`, `erapaiva`, `laskuttajaid`, `asiakasid`, `maksutapaid`, `laskuntilaid`) VALUES (2, '73600', '2023-01-02', '2023-01-16', 1, 3, 3, 2);
INSERT INTO `ER-kaavio_Laskutus`.`laskun_tiedot` (`laskuid`, `viitenumero`, `lahetyspvm`, `erapaiva`, `laskuttajaid`, `asiakasid`, `maksutapaid`, `laskuntilaid`) VALUES (3, '71201', '2023-02-17', '2023-03-01', 2, 1, 2, 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `ER-kaavio_Laskutus`.`tuoteyhteys`
-- -----------------------------------------------------
START TRANSACTION;
USE `ER-kaavio_Laskutus`;
INSERT INTO `ER-kaavio_Laskutus`.`tuoteyhteys` (`laskuid`, `tuoteid`) VALUES (1, 3);
INSERT INTO `ER-kaavio_Laskutus`.`tuoteyhteys` (`laskuid`, `tuoteid`) VALUES (2, 2);
INSERT INTO `ER-kaavio_Laskutus`.`tuoteyhteys` (`laskuid`, `tuoteid`) VALUES (3, 1);

COMMIT;

