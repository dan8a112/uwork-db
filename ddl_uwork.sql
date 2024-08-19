-- MySQL Script generated by MySQL Workbench
-- Wed Aug 14 23:33:59 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb1` DEFAULT CHARACTER SET utf8 ;
USE `mydb1` ;

-- -----------------------------------------------------
-- Table `mydb1`.`generos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`generos` (
  `ID_GENERO` INT NOT NULL AUTO_INCREMENT,
  `GENERO` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_GENERO`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`personas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`personas` (
  `ID_PERSONA` INT NOT NULL AUTO_INCREMENT,
  `PRIMER_NOMBRE` VARCHAR(45) NULL,
  `SEGUNDO_NOMBRE` VARCHAR(45) NULL,
  `PRIMER_APELLIDO` VARCHAR(45) NULL,
  `SEGUNDO_APELLIDO` VARCHAR(45) NULL,
  `TELEFONO` INT NULL,
  `IDENTIFICACION` VARCHAR(45) NULL,
  `GENERO_ID_GENERO` INT NOT NULL,
  PRIMARY KEY (`ID_PERSONA`),
  INDEX `fk_PERSONA_GENERO_idx` (`GENERO_ID_GENERO` ASC) ,
  CONSTRAINT `fk_PERSONA_GENERO`
    FOREIGN KEY (`GENERO_ID_GENERO`)
    REFERENCES `mydb1`.`generos` (`ID_GENERO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`parentescos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`parentescos` (
  `ID_PARENTESCOS` INT NOT NULL AUTO_INCREMENT,
  `PARENTESCO` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_PARENTESCOS`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`estado_civil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`estado_civil` (
  `ID_ESTADO_CIVIL` INT NOT NULL AUTO_INCREMENT,
  `ESTADO_CIVIL` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_ESTADO_CIVIL`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`tipo_lugar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`tipo_lugar` (
  `ID_TIPO_LUGAR` INT NOT NULL AUTO_INCREMENT,
  `TIPO_LUGAR` VARCHAR(100) NULL,
  PRIMARY KEY (`ID_TIPO_LUGAR`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`lugares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`lugares` (
  `ID_LUGAR` INT NOT NULL AUTO_INCREMENT,
  `NOMBRE_LUGAR` VARCHAR(45) NULL,
  `ID_TIPO_LUGAR` INT NOT NULL,
  `ID_LUGAR_PADRE` INT NOT NULL,
  PRIMARY KEY (`ID_LUGAR`),
  INDEX `fk_LUGARES_TIPO_LUGAR1_idx` (`ID_TIPO_LUGAR` ASC) ,
  INDEX `fk_LUGARES_LUGARES1_idx` (`ID_LUGAR_PADRE` ASC) ,
  CONSTRAINT `fk_LUGARES_TIPO_LUGAR1`
    FOREIGN KEY (`ID_TIPO_LUGAR`)
    REFERENCES `mydb1`.`tipo_lugar` (`ID_TIPO_LUGAR`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LUGARES_LUGARES1`
    FOREIGN KEY (`ID_LUGAR_PADRE`)
    REFERENCES `mydb1`.`lugares` (`ID_LUGAR`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`solicitantes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`solicitantes` (
  `ID_PERSONA` INT NOT NULL,
  `CORREO` VARCHAR(45) NULL,
  `CONTRASENA` VARCHAR(45) NULL,
  `FECHA_NACIMIENTO` DATE NULL,
  `TITULAR` VARCHAR(100) NULL,
  `DESCRIPCION` VARCHAR(800) NULL,
  `ID_ESTADO_CIVIL` INT NOT NULL,
  `ID_LUGAR_NACIMIENTO` INT NOT NULL,
  `ID_LUGAR_RESIDENCIA` INT NOT NULL,
  `URL_FOTO_PERFIL` VARCHAR(100) NULL,
  PRIMARY KEY (`ID_PERSONA`),
  INDEX `fk_SOLICITANTE_PERSONAS1_idx` (`ID_PERSONA` ASC) ,
  INDEX `fk_SOLICITANTES_ESTADO_CIVIL1_idx` (`ID_ESTADO_CIVIL` ASC) ,
  INDEX `fk_SOLICITANTES_LUGARES1_idx` (`ID_LUGAR_NACIMIENTO` ASC) ,
  INDEX `fk_SOLICITANTES_LUGARES2_idx` (`ID_LUGAR_RESIDENCIA` ASC) ,
  CONSTRAINT `fk_SOLICITANTE_PERSONAS1`
    FOREIGN KEY (`ID_PERSONA`)
    REFERENCES `mydb1`.`personas` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICITANTES_ESTADO_CIVIL1`
    FOREIGN KEY (`ID_ESTADO_CIVIL`)
    REFERENCES `mydb1`.`estado_civil` (`ID_ESTADO_CIVIL`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICITANTES_LUGARES1`
    FOREIGN KEY (`ID_LUGAR_NACIMIENTO`)
    REFERENCES `mydb1`.`lugares` (`ID_LUGAR`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICITANTES_LUGARES2`
    FOREIGN KEY (`ID_LUGAR_RESIDENCIA`)
    REFERENCES `mydb1`.`lugares` (`ID_LUGAR`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`familiares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`familiares` (
  `ID_FAMILIAR` INT NOT NULL,
  `ID_PARENTESCOS` INT NOT NULL,
  `ID_SOLICITANTE` INT NOT NULL,
  INDEX `fk_FAMILIAR_PERSONA1_idx` (`ID_FAMILIAR` ASC),
  INDEX `fk_FAMILIARES_PARENTESCOS1_idx` (`ID_PARENTESCOS` ASC),
  INDEX `fk_FAMILIARES_SOLICITANTE1_idx` (`ID_SOLICITANTE` ASC),
  UNIQUE INDEX `UNIQUE_FAMILIAR_SOLICITANTE` (`ID_FAMILIAR`, `ID_SOLICITANTE`),
  CONSTRAINT `fk_FAMILIAR_PERSONA1`
    FOREIGN KEY (`ID_FAMILIAR`)
    REFERENCES `mydb1`.`personas` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FAMILIARES_PARENTESCOS1`
    FOREIGN KEY (`ID_PARENTESCOS`)
    REFERENCES `mydb1`.`parentescos` (`ID_PARENTESCOS`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FAMILIARES_SOLICITANTE1`
    FOREIGN KEY (`ID_SOLICITANTE`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb1`.`condiciones_medicas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`condiciones_medicas` (
  `ID_CONDICIONE_MEDICA` INT NOT NULL AUTO_INCREMENT,
  `CONDICION_MEDICAS` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_CONDICIONE_MEDICA`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`historial_medico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`historial_medico` (
  `DESCRIPCION` VARCHAR(300) NULL,
  `ID_CONDICION_MEDICA` INT NOT NULL,
  `ID_PERSONA` INT NOT NULL,
  INDEX `fk_HISTORIAL_MEDICO_CONDICIONES_MEDICAS1_idx` (`ID_CONDICION_MEDICA` ASC),
  INDEX `fk_HISTORIAL_MEDICO_SOLICITANTES1_idx` (`ID_PERSONA` ASC),
  CONSTRAINT `fk_HISTORIAL_MEDICO_CONDICIONES_MEDICAS1`
    FOREIGN KEY (`ID_CONDICION_MEDICA`)
    REFERENCES `mydb1`.`condiciones_medicas` (`ID_CONDICIONE_MEDICA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISTORIAL_MEDICO_SOLICITANTES1`
    FOREIGN KEY (`ID_PERSONA`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  UNIQUE INDEX `UNIQUE_CONDICION_PERSONA` (`ID_CONDICION_MEDICA`, `ID_PERSONA`)
)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb1`.`tipo_seguros`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`tipo_seguros` (
  `ID_TIPO_SEGURO` INT NOT NULL AUTO_INCREMENT,
  `TIPO_SEGURO` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_TIPO_SEGURO`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`seguros_solicitantes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`seguros_solicitantes` (
  `ID_PERSONA` INT NOT NULL,
  `ID_TIPO_SEGURO` INT NOT NULL,
  `FECHA_AFILIACION` DATE NULL,
  `FECHA_EXPIRACION` DATE NULL,
  `NUMERO_AFILIACION` VARCHAR(30) NULL,
  INDEX `fk_SEGUROS_SOLICITANTES_SOLICITANTES1_idx` (`ID_PERSONA` ASC) ,
  INDEX `fk_SEGUROS_SOLICITANTES_TIPO_SEGUROS1_idx` (`ID_TIPO_SEGURO` ASC) ,
  CONSTRAINT `fk_SEGUROS_SOLICITANTES_SOLICITANTES1`
    FOREIGN KEY (`ID_PERSONA`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SEGUROS_SOLICITANTES_TIPO_SEGUROS1`
    FOREIGN KEY (`ID_TIPO_SEGURO`)
    REFERENCES `mydb1`.`tipo_seguros` (`ID_TIPO_SEGURO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`nivel_academico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`nivel_academico` (
  `ID_NIVEL_ACADEMICO` INT NOT NULL AUTO_INCREMENT,
  `NIVEL_ACADEMICO` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_NIVEL_ACADEMICO`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`formacion_profesional`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`formacion_profesional` (
  `ID_FORMACION_PROFESIONAL` INT NOT NULL AUTO_INCREMENT,
  `FORMACION_PROFESIONAL` VARCHAR(100) NULL,
  PRIMARY KEY (`ID_FORMACION_PROFESIONAL`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`historial_academico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`historial_academico` (
  `ID_PERSONA` INT NOT NULL,
  `ID_NIVEL_ACADEMICO` INT NOT NULL,
  `ID_FORMACION_PROFESIONAL` INT NULL,
  `TITULO` VARCHAR(100) NULL,
  `FECHA_EGRESO` DATE NULL,
  `INSTITUCION` VARCHAR(100) NULL,
  INDEX `fk_HISTORIAL_ACADEMICO_NIVEL_ACADEMICO1_idx` (`ID_NIVEL_ACADEMICO` ASC) ,
  INDEX `fk_HISTORIAL_ACADEMICO_FORMACION_PROFESIONAL1_idx` (`ID_FORMACION_PROFESIONAL` ASC) ,
  INDEX `fk_HISTORIAL_ACADEMICO_SOLICITANTES1_idx` (`ID_PERSONA` ASC) ,
  CONSTRAINT `fk_HISTORIAL_ACADEMICO_NIVEL_ACADEMICO1`
    FOREIGN KEY (`ID_NIVEL_ACADEMICO`)
    REFERENCES `mydb1`.`nivel_academico` (`ID_NIVEL_ACADEMICO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISTORIAL_ACADEMICO_FORMACION_PROFESIONAL1`
    FOREIGN KEY (`ID_FORMACION_PROFESIONAL`)
    REFERENCES `mydb1`.`formacion_profesional` (`ID_FORMACION_PROFESIONAL`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISTORIAL_ACADEMICO_SOLICITANTES1`
    FOREIGN KEY (`ID_PERSONA`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`puestos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`puestos` (
  `ID_PUESTO` INT NOT NULL AUTO_INCREMENT,
  `PUESTO` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_PUESTO`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`experienCIA_LABORAL`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`experiencia_laboral` (
  `idEXPERIENCIA_LABORAL` INT NOT NULL AUTO_INCREMENT,
  `ID_PERSONA` INT NOT NULL,
  `ID_PUESTO` INT NOT NULL,
  `EMPRESA` VARCHAR(45) NULL,
  `FECHA_INICIO` DATE NULL,
  `FECHA_FIN` DATE NULL,
  `DESCRIPCION` VARCHAR(300) NULL,
  PRIMARY KEY (`idEXPERIENCIA_LABORAL`),
  INDEX `fk_EXPERIENCIA_LABORAL_SOLICITANTES1_idx` (`ID_PERSONA` ASC) ,
  INDEX `fk_EXPERIENCIA_LABORAL_PUESTOS1_idx` (`ID_PUESTO` ASC) ,
  CONSTRAINT `fk_EXPERIENCIA_LABORAL_SOLICITANTES1`
    FOREIGN KEY (`ID_PERSONA`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EXPERIENCIA_LABORAL_PUESTOS1`
    FOREIGN KEY (`ID_PUESTO`)
    REFERENCES `mydb1`.`puestos` (`ID_PUESTO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`modalidad`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`modalidad` (
  `ID_MODALIDAD` INT NOT NULL AUTO_INCREMENT,
  `MODALIDAD` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_MODALIDAD`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`preferencias_puestos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`preferencias_puestos` (
  `ID_PUESTO` INT NOT NULL,
  `ID_PERSONA` INT NOT NULL,
  INDEX `fk_PREFERENCIAS_PUESTOS_PUESTOS1_idx` (`ID_PUESTO` ASC),
  INDEX `fk_PREFERENCIAS_PUESTOS_SOLICITANTES1_idx` (`ID_PERSONA` ASC),
  UNIQUE INDEX `UNIQUE_PUESTO_PERSONA` (`ID_PUESTO`, `ID_PERSONA`),
  CONSTRAINT `fk_PREFERENCIAS_PUESTOS_PUESTOS1`
    FOREIGN KEY (`ID_PUESTO`)
    REFERENCES `mydb1`.`puestos` (`ID_PUESTO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PREFERENCIAS_PUESTOS_SOLICITANTES1`
    FOREIGN KEY (`ID_PERSONA`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb1`.`preferencias_modalidades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`preferencias_modalidades` (
  `ID_MODALIDAD` INT NOT NULL,
  `ID_PERSONA` INT NOT NULL,
  INDEX `fk_PREFERENCIAS_MODALIDADES_MODALIDAD1_idx` (`ID_MODALIDAD` ASC),
  INDEX `fk_PREFERENCIAS_MODALIDADES_SOLICITANTES1_idx` (`ID_PERSONA` ASC),
  UNIQUE INDEX `UNIQUE_MODALIDAD_PERSONA` (`ID_MODALIDAD`, `ID_PERSONA`),
  CONSTRAINT `fk_PREFERENCIAS_MODALIDADES_MODALIDAD1`
    FOREIGN KEY (`ID_MODALIDAD`)
    REFERENCES `mydb1`.`modalidad` (`ID_MODALIDAD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PREFERENCIAS_MODALIDADES_SOLICITANTES1`
    FOREIGN KEY (`ID_PERSONA`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`contratos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`contratos` (
  `ID_CONTRATO` INT NOT NULL AUTO_INCREMENT,
  `CONTRATO` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_CONTRATO`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`preferencias_contratos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`preferencias_contratos` (
  `ID_PERSONA` INT NOT NULL,
  `ID_CONTRATO` INT NOT NULL,
  INDEX `fk_PREFERENCIAS_CONTRATOS_SOLICITANTES1_idx` (`ID_PERSONA` ASC),
  INDEX `fk_PREFERENCIAS_CONTRATOS_CONTRATOS1_idx` (`ID_CONTRATO` ASC),
  UNIQUE INDEX `UNIQUE_PERSONA_CONTRATO` (`ID_PERSONA`, `ID_CONTRATO`),
  CONSTRAINT `fk_PREFERENCIAS_CONTRATOS_SOLICITANTES1`
    FOREIGN KEY (`ID_PERSONA`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PREFERENCIAS_CONTRATOS_CONTRATOS1`
    FOREIGN KEY (`ID_CONTRATO`)
    REFERENCES `mydb1`.`contratos` (`ID_CONTRATO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb1`.`industrias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`industrias` (
  `ID_INDUSTRIA` INT NOT NULL AUTO_INCREMENT,
  `INDUSTRIA` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_INDUSTRIA`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`empresa` (
  `ID_EMPRESA` INT NOT NULL AUTO_INCREMENT,
  `NOMBRE_EMPRESA` VARCHAR(100) NULL,
  `CORREO` VARCHAR(45) NULL,
  `CONTRASENA` VARCHAR(45) NULL,
  `TELEFONO` VARCHAR(20) NULL,
  `SITIO_WEB` VARCHAR(100) NULL,
  `DESCRIPCION` VARCHAR(800) NULL,
  `ID_DIRECTOR` INT NOT NULL,
  `ID_INDUSTRIA` INT NOT NULL,
  `ID_DIRECCION` INT NOT NULL,
  `URL_LOGO` VARCHAR(100) NULL,
  PRIMARY KEY (`ID_EMPRESA`),
  INDEX `fk_AGENCIA_PERSONAS1_idx` (`ID_DIRECTOR` ASC) ,
  INDEX `fk_AGENCIA_INDUSTRIAS1_idx` (`ID_INDUSTRIA` ASC) ,
  INDEX `fk_AGENCIA_LUGARES1_idx` (`ID_DIRECCION` ASC) ,
  CONSTRAINT `fk_AGENCIA_PERSONAS1`
    FOREIGN KEY (`ID_DIRECTOR`)
    REFERENCES `mydb1`.`personas` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AGENCIA_INDUSTRIAS1`
    FOREIGN KEY (`ID_INDUSTRIA`)
    REFERENCES `mydb1`.`industrias` (`ID_INDUSTRIA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AGENCIA_LUGARES1`
    FOREIGN KEY (`ID_DIRECCION`)
    REFERENCES `mydb1`.`lugares` (`ID_LUGAR`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`tipo_empleo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`tipo_empleo` (
  `ID_TIPO_EMPLEO` INT NOT NULL AUTO_INCREMENT,
  `TIPO_EMPLEO` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_TIPO_EMPLEO`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`ofertas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`ofertas` (
  `ID_OFERTA` INT NOT NULL AUTO_INCREMENT,
  `ID_EMPRESA` INT NOT NULL,
  `ID_TIPO_EMPLEO` INT NOT NULL,
  `ID_NIVEL_ACADEMICO` INT NOT NULL,
  `ID_LUGAR` INT NOT NULL,
  `ID_MODALIDAD` INT NOT NULL,
  `ID_CONTRATO` INT NOT NULL,
  `TITULO` VARCHAR(100) NULL,
  `DESCRIPCION` TEXT(5000) NULL,
  `FECHA_PUBLICACION` DATE NULL,
  `PLAZAS_DISPONIBLES` INT NULL,
  `ESTADO_OFERTA` TINYINT NULL,
  `FECHA_EXPIRACION` DATE NULL,
  PRIMARY KEY (`ID_OFERTA`),
  INDEX `fk_OFERTAS_EMPRESA1_idx` (`ID_EMPRESA` ASC) ,
  INDEX `fk_OFERTAS_TIPO_EMPLEO1_idx` (`ID_TIPO_EMPLEO` ASC) ,
  INDEX `fk_OFERTAS_NIVEL_ACADEMICO1_idx` (`ID_NIVEL_ACADEMICO` ASC) ,
  INDEX `fk_OFERTAS_LUGARES1_idx` (`ID_LUGAR` ASC) ,
  INDEX `fk_OFERTAS_MODALIDAD1_idx` (`ID_MODALIDAD` ASC) ,
  INDEX `fk_OFERTAS_CONTRATOS1_idx` (`ID_CONTRATO` ASC) ,
  CONSTRAINT `fk_OFERTAS_EMPRESA1`
    FOREIGN KEY (`ID_EMPRESA`)
    REFERENCES `mydb1`.`empresa` (`ID_EMPRESA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OFERTAS_TIPO_EMPLEO1`
    FOREIGN KEY (`ID_TIPO_EMPLEO`)
    REFERENCES `mydb1`.`tipo_empleo` (`ID_TIPO_EMPLEO`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OFERTAS_NIVEL_ACADEMICO1`
    FOREIGN KEY (`ID_NIVEL_ACADEMICO`)
    REFERENCES `mydb1`.`nivel_academico` (`ID_NIVEL_ACADEMICO`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OFERTAS_LUGARES1`
    FOREIGN KEY (`ID_LUGAR`)
    REFERENCES `mydb1`.`lugares` (`ID_LUGAR`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OFERTAS_MODALIDAD1`
    FOREIGN KEY (`ID_MODALIDAD`)
    REFERENCES `mydb1`.`modalidad` (`ID_MODALIDAD`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OFERTAS_CONTRATOS1`
    FOREIGN KEY (`ID_CONTRATO`)
    REFERENCES `mydb1`.`contratos` (`ID_CONTRATO`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`ofertas_puestos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`ofertas_puestos` (
  `idOFERTAS_PUESTOS` INT NOT NULL AUTO_INCREMENT,
  `DESCRIPCION_PUESTO` VARCHAR(300) NULL,
  `ID_PUESTO` INT NOT NULL,
  `ID_OFERTA` INT NOT NULL,
  PRIMARY KEY (`idOFERTAS_PUESTOS`),
  INDEX `fk_OFERTAS_PUESTOS_PUESTOS1_idx` (`ID_PUESTO` ASC) ,
  INDEX `fk_OFERTAS_PUESTOS_OFERTAS1_idx` (`ID_OFERTA` ASC) ,
  CONSTRAINT `fk_OFERTAS_PUESTOS_PUESTOS1`
    FOREIGN KEY (`ID_PUESTO`)
    REFERENCES `mydb1`.`puestos` (`ID_PUESTO`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OFERTAS_PUESTOS_OFERTAS1`
    FOREIGN KEY (`ID_OFERTA`)
    REFERENCES `mydb1`.`ofertas` (`ID_OFERTA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`requisitos_academicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`requisitos_academicos` (
  `ID_OFERTA` INT NOT NULL,
  `ID_FORMACION_PROFESIONAL` INT NOT NULL,
  INDEX `fk_REQUISITOS_ACADEMICOS_OFERTAS1_idx` (`ID_OFERTA` ASC) ,
  INDEX `fk_REQUISITOS_ACADEMICOS_FORMACION_PROFESIONAL1_idx` (`ID_FORMACION_PROFESIONAL` ASC) ,
  CONSTRAINT `fk_REQUISITOS_ACADEMICOS_OFERTAS1`
    FOREIGN KEY (`ID_OFERTA`)
    REFERENCES `mydb1`.`ofertas` (`ID_OFERTA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REQUISITOS_ACADEMICOS_FORMACION_PROFESIONAL1`
    FOREIGN KEY (`ID_FORMACION_PROFESIONAL`)
    REFERENCES `mydb1`.`formacion_profesional` (`ID_FORMACION_PROFESIONAL`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`requisitos_laborales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`requisitos_laborales` (
  `ID_REQUISITOS_LABORALES` INT NOT NULL AUTO_INCREMENT,
  `ID_PUESTO` INT NOT NULL,
  `ID_OFERTA` INT NOT NULL,
  PRIMARY KEY (`ID_REQUISITOS_LABORALES`),
  INDEX `fk_REQUISITOS_LABORALES_PUESTOS1_idx` (`ID_PUESTO` ASC),
  INDEX `fk_REQUISITOS_LABORALES_OFERTAS1_idx` (`ID_OFERTA` ASC),
  UNIQUE INDEX `UNIQUE_PUESTO_OFERTA` (`ID_PUESTO`, `ID_OFERTA`),
  CONSTRAINT `fk_REQUISITOS_LABORALES_PUESTOS1`
    FOREIGN KEY (`ID_PUESTO`)
    REFERENCES `mydb1`.`puestos` (`ID_PUESTO`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REQUISITOS_LABORALES_OFERTAS1`
    FOREIGN KEY (`ID_OFERTA`)
    REFERENCES `mydb1`.`ofertas` (`ID_OFERTA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`estado_solicitud`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`estado_solicitud` (
  `ID_ESTADO_SOLICITUD` INT NOT NULL,
  `ESTADO_SOLICITUD` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_ESTADO_SOLICITUD`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`solicitudes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`solicitudes` (
  `ID_SOLICITUD` INT NOT NULL AUTO_INCREMENT,
  `ID_OFERTA` INT NOT NULL,
  `ID_SOLICITANTE` INT NOT NULL,
  `ID_ESTADO_SOLICITUD` INT NOT NULL,
  `EMISOR_SOLICITUD` TINYINT NOT NULL,
  `DESCRIPCION` VARCHAR(300) NULL,
  `FECHA_SOLICITUD` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_SOLICITUD`),
  INDEX `fk_SOLICITUDES_OFERTAS1_idx` (`ID_OFERTA` ASC) ,
  INDEX `fk_SOLICITUDES_ESTADO_SOLICITUD1_idx` (`ID_ESTADO_SOLICITUD` ASC) ,
  INDEX `fk_SOLICITUDES_SOLICITANTES1_idx` (`ID_SOLICITANTE` ASC) ,
  CONSTRAINT `fk_SOLICITUDES_OFERTAS1`
    FOREIGN KEY (`ID_OFERTA`)
    REFERENCES `mydb1`.`ofertas` (`ID_OFERTA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICITUDES_ESTADO_SOLICITUD1`
    FOREIGN KEY (`ID_ESTADO_SOLICITUD`)
    REFERENCES `mydb1`.`estado_solicitud` (`ID_ESTADO_SOLICITUD`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICITUDES_SOLICITANTES1`
    FOREIGN KEY (`ID_SOLICITANTE`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`idiomas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`idiomas` (
  `ID_IDIOMA` INT NOT NULL AUTO_INCREMENT,
  `IDIOMA` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_IDIOMA`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`nivel_idioma`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`nivel_idioma` (
  `ID_NIVEL_IDIOMA` INT NOT NULL,
  `NIVEL_IDIOMA` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_NIVEL_IDIOMA`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`solicitantes_idiomas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`solicitantes_idiomas` (
  `ID_SOLICITANTE` INT NOT NULL,
  `ID_IDIOMA` INT NOT NULL,
  `ID_NIVEL_IDIOMA` INT NOT NULL,
  INDEX `fk_SOLICITANTES_IDIOMAS_SOLICITANTES1_idx` (`ID_SOLICITANTE` ASC),
  INDEX `fk_SOLICITANTES_IDIOMAS_IDIOMAS1_idx` (`ID_IDIOMA` ASC),
  INDEX `fk_SOLICITANTES_IDIOMAS_NIVEL_IDIOMA1_idx` (`ID_NIVEL_IDIOMA` ASC),
  UNIQUE INDEX `UNIQUE_SOLICITANTE_IDIOMA_NIVEL` (`ID_SOLICITANTE`, `ID_IDIOMA`, `ID_NIVEL_IDIOMA`),
  CONSTRAINT `fk_SOLICITANTES_IDIOMAS_SOLICITANTES1`
    FOREIGN KEY (`ID_SOLICITANTE`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICITANTES_IDIOMAS_IDIOMAS1`
    FOREIGN KEY (`ID_IDIOMA`)
    REFERENCES `mydb1`.`idiomas` (`ID_IDIOMA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICITANTES_IDIOMAS_NIVEL_IDIOMA1`
    FOREIGN KEY (`ID_NIVEL_IDIOMA`)
    REFERENCES `mydb1`.`nivel_idioma` (`ID_NIVEL_IDIOMA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb1`.`ofertas_idiomas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`ofertas_idiomas` (
  `ID_NIVEL_IDIOMA` INT NOT NULL,
  `ID_OFERTA` INT NOT NULL,
  `ID_IDIOMA` INT NOT NULL,
  INDEX `fk_OFERTAS_IDIOMAS_NIVEL_IDIOMA1_idx` (`ID_NIVEL_IDIOMA` ASC) ,
  INDEX `fk_OFERTAS_IDIOMAS_OFERTAS1_idx` (`ID_OFERTA` ASC) ,
  INDEX `fk_OFERTAS_IDIOMAS_IDIOMAS1_idx` (`ID_IDIOMA` ASC) ,
  UNIQUE INDEX `unique_nivel_oferta_idioma` (`ID_NIVEL_IDIOMA`, `ID_OFERTA`, `ID_IDIOMA`),
  CONSTRAINT `fk_OFERTAS_IDIOMAS_NIVEL_IDIOMA1`
    FOREIGN KEY (`ID_NIVEL_IDIOMA`)
    REFERENCES `mydb1`.`nivel_idioma` (`ID_NIVEL_IDIOMA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OFERTAS_IDIOMAS_OFERTAS1`
    FOREIGN KEY (`ID_OFERTA`)
    REFERENCES `mydb1`.`ofertas` (`ID_OFERTA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OFERTAS_IDIOMAS_IDIOMAS1`
    FOREIGN KEY (`ID_IDIOMA`)
    REFERENCES `mydb1`.`idiomas` (`ID_IDIOMA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb1`.`notificaciones_solicitantes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`notificaciones_solicitantes` (
  `ID_NOTIFICACION_SOL` INT NOT NULL AUTO_INCREMENT,
  `TITULO` VARCHAR(45) NULL,
  `DESCRIPCION` VARCHAR(200) NULL,
  `FECHA` DATE NULL,
  `ID_SOLICITANTE` INT NOT NULL,
  `ESTADO_VISUALIZACION` TINYINT NULL,
  `ID_SOLICITUD` INT NOT NULL,
  PRIMARY KEY (`ID_NOTIFICACION_SOL`),
  INDEX `fk_NOTIFICACIONES_SOLICITANTES_SOLICITANTES1_idx` (`ID_SOLICITANTE` ASC) ,
  INDEX `fk_NOTIFICACIONES_SOLICITANTES_SOLICITUDES1_idx` (`ID_SOLICITUD` ASC) ,
  CONSTRAINT `fk_NOTIFICACIONES_SOLICITANTES_SOLICITANTES1`
    FOREIGN KEY (`ID_SOLICITANTE`)
    REFERENCES `mydb1`.`solicitantes` (`ID_PERSONA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_NOTIFICACIONES_SOLICITANTES_SOLICITUDES1`
    FOREIGN KEY (`ID_SOLICITUD`)
    REFERENCES `mydb1`.`solicitudes` (`ID_SOLICITUD`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`notificaciones_empresas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`notificaciones_empresas` (
  `ID_NOTIFICACION_EMP` INT NOT NULL AUTO_INCREMENT,
  `TITULO` VARCHAR(45) NULL,
  `DESCRIPCION` VARCHAR(200) NULL,
  `FECHA` DATE NULL,
  `ESTADO_VISUALIZACION` TINYINT NULL,
  `ID_EMPRESA` INT NOT NULL,
  `ID_SOLICITUD` INT NOT NULL,
  PRIMARY KEY (`ID_NOTIFICACION_EMP`),
  INDEX `fk_NOTIFICACIONES_SOLICITANTES_copy1_EMPRESA1_idx` (`ID_EMPRESA` ASC) ,
  INDEX `fk_NOTIFICACIONES_EMPRESAS_SOLICITUDES1_idx` (`ID_SOLICITUD` ASC) ,
  CONSTRAINT `fk_NOTIFICACIONES_SOLICITANTES_copy1_EMPRESA1`
    FOREIGN KEY (`ID_EMPRESA`)
    REFERENCES `mydb1`.`empresa` (`ID_EMPRESA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_NOTIFICACIONES_EMPRESAS_SOLICITUDES1`
    FOREIGN KEY (`ID_SOLICITUD`)
    REFERENCES `mydb1`.`solicitudes` (`ID_SOLICITUD`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb1`.`administradores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`administradores` (
  `ID_PERSONA` INT NOT NULL AUTO_INCREMENT,
  `CORREO` VARCHAR(45) NULL,
  `CONTRASENA` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_PERSONA`),
  CONSTRAINT `fk_ADMINISTRADORES_PERSONAS1`
    FOREIGN KEY (`ID_PERSONA`)
    REFERENCES `mydb1`.`personas` (`ID_PERSONA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
