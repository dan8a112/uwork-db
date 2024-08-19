DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarPreferenciaSolicitante`(IN `id_solicitante` INT)
BEGIN 

    DELETE FROM preferencias_puestos
    WHERE ID_PERSONA = id_solicitante;
    
    DELETE FROM preferencias_modalidades
    WHERE ID_PERSONA = id_solicitante;
    
    DELETE FROM preferencias_contratos
    WHERE ID_PERSONA = id_solicitante;
    
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarPreferenciasUser`(IN `id_persona` INT)
BEGIN 

    DELETE FROM preferencias_puestos
    WHERE ID_PERSONA = id_persona;
    
    DELETE FROM preferencias_modalidades
    WHERE ID_PERSONA = id_persona;
    
    DELETE FROM preferencias_contratos
    WHERE ID_PERSONA = id_persona;
    
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ingresarFamiliarSolicitante`(
	in idFamiliarP int,
    in idParentescoP int,
    in idSolicitante int
)
BEGIN
	INSERT INTO `familiares`(`ID_FAMILIAR`, `ID_PARENTESCOS`, `ID_SOLICITANTE`) VALUES (idFamiliarP, idParentescoP, idSolicitante);
    
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ingresarHistorialMedico`(
	in descripcionP varchar(300),
    in idCondicionP int,
    in idPersona int
)
BEGIN
	INSERT INTO `historial_medico`(`DESCRIPCION`, `ID_CONDICION_MEDICA`, `ID_PERSONA`) VALUES (descripcionP, idCondicionP, idPersona);
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ingresarPreferenciaContrato`(IN ID_PERSONA_P INT, IN ID_CONTRATO_P INT)
BEGIN
	INSERT INTO preferencias_contratos(ID_PERSONA,ID_CONTRATO) VALUES (ID_PERSONA_P, ID_CONTRATO_P);
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ingresarPreferenciaModalidad`(IN `ID_MODALIDAD_P` INT, IN `ID_PERSONA_P` INT)
BEGIN
	INSERT INTO preferencias_modalidades(ID_MODALIDAD, ID_PERSONA) VALUES (ID_MODALIDAD_P, ID_PERSONA_P);
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ingresarPreferenciaPuesto`(IN `ID_PUESTO_P` INT, IN `ID_PERSONA_P` INT)
BEGIN
	INSERT INTO preferencias_puestos(ID_PUESTO, ID_PERSONA) VALUES (ID_PUESTO_P, ID_PERSONA_P);
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ingresarSolicitanteIdioma`(
	in idPersonaP int,
    in idIdiomaP int,
    in idNivelP int
)
BEGIN
	INSERT INTO `solicitantes_idiomas`(`ID_SOLICITANTE`, `ID_IDIOMA`, `ID_NIVEL_IDIOMA`) VALUES (idPersonaP, idIdiomaP, idNivelP);
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarHistorialAcademico`(IN idPersonaP int, in idNivelAcademicoP int, 
                                            in idFormacionAcP int, in tituloP varchar(100), in fechaEgresoP date, 
                                            in INSTITUCIONP varchar(100))
BEGIN
	INSERT INTO `historial_academico`(`ID_PERSONA`, `ID_NIVEL_ACADEMICO`,`ID_FORMACION_PROFESIONAL`, `TITULO`, `FECHA_EGRESO`, `INSTITUCION`) 
    VALUES (idPersonaP, idNivelAcademicoP, idFormacionAcP, tituloP, fechaEgresoP, INSTITUCIONP);
    
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarSeguroSolicitante`(
	in idPersonaP int,
    in idTipoSeguroP int,
    in fechaAfiliacionP date,
    in fechaExpiracionP date,
    in numeroAfiliacionP varchar(30)
)
BEGIN
INSERT INTO `seguros_solicitantes`(`ID_PERSONA`, `ID_TIPO_SEGURO`, `FECHA_AFILIACION`, `FECHA_EXPIRACION`, `NUMERO_AFILIACION`) VALUES (idPersonaP, idTipoSeguroP, fechaAfiliacionP, fechaExpiracionP, numeroAfiliacionP);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerAplicacionesSolicitante`(IN `idSolicitanteP` INT)
BEGIN
	SELECT o.id_oferta,
		DATE_FORMAT(o.fecha_publicacion, '%d %b, %Y') as fechaPublicacion,
        o.titulo,
        em.nombre_empresa,
        DATE_FORMAT(s.fecha_solicitud, '%d %b, %Y') as fechaSolicitud,
        es.estado_solicitud,
        em.url_logo
    FROM estado_solicitud es
    INNER JOIN solicitudes s on es.ID_ESTADO_SOLICITUD = s.ID_ESTADO_SOLICITUD
    INNER JOIN ofertas o on s.ID_OFERTA = o.ID_OFERTA -- Corregido: `of` a `o`
    INNER JOIN empresa em on o.ID_EMPRESA = em.ID_EMPRESA
    WHERE s.ID_SOLICITANTE = idSolicitanteP
    ORDER BY s.FECHA_SOLICITUD ASC;
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER TGR_CAMPOS_DEFAULT_OFERTA
BEFORE INSERT ON ofertas
FOR EACH ROW
BEGIN
	IF NEW.FECHA_PUBLICACION IS NULL THEN
    	SET NEW.FECHA_PUBLICACION = CURDATE();
    END IF;
    
    IF NEW.ESTADO_OFERTA IS NULL THEN
    	SET NEW.ESTADO_OFERTA = 1;
    END IF;
    
END $$

DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `enviarNotificacionEmpresa`(
    IN ID_PERSONA_P INT, 
    IN ID_OFERTA_P INT,
    IN ID_ESTADO_SOLICITUD_P INT,
    IN ID_SOLICITUD_P INT
)
BEGIN
    DECLARE oferTitulo VARCHAR(255);
    DECLARE idEmpresa INT;
    DECLARE nombreSolicitante VARCHAR(255);

    -- Obtener el nombre completo del solicitante
    SELECT CONCAT(PRIMER_NOMBRE, ' ', PRIMER_APELLIDO) 
    INTO nombreSolicitante
    FROM personas 
    WHERE ID_PERSONA = ID_PERSONA_P;

    -- Obtener el título de la oferta y el ID de la empresa
    SELECT TITULO, ID_EMPRESA 
    INTO oferTitulo, idEmpresa
    FROM ofertas
    WHERE id_oferta = ID_OFERTA_P;

    -- Insertar notificación si el estado de la solicitud es 3
    IF ID_ESTADO_SOLICITUD_P = 3 THEN 
        INSERT INTO notificaciones_empresas (
            TITULO, 
            DESCRIPCION, 
            FECHA, 
            ESTADO_VISUALIZACION, 
            ID_EMPRESA, 
            ID_SOLICITUD
        ) 
        VALUES (
            'SOLICITUD ACEPTADA',
            CONCAT('Nos complace informarle que ', nombreSolicitante, ' ha aceptado la oferta de empleo ', oferTitulo, ' que usted extendió a través de nuestra plataforma. Agradecemos su confianza en nuestra aplicación para facilitar este proceso.'),
            CURDATE(),
            0,
            idEmpresa,
            ID_SOLICITUD_P
        );
    END IF;
    
    -- Si fue rechazada
	IF ID_ESTADO_SOLICITUD_P = 4 THEN 
        INSERT INTO notificaciones_empresas (
            TITULO, 
            DESCRIPCION, 
            FECHA, 
            ESTADO_VISUALIZACION, 
            ID_EMPRESA, 
            ID_SOLICITUD
        ) 
        VALUES (
            'SOLICITUD RECHAZADA',
            CONCAT('Le informamos que ', nombreSolicitante, ' ha decidido rechazar la oferta de empleo ', oferTitulo, ' que usted extendió a través de nuestra plataforma. Agradecemos su confianza en nuestra aplicación para facilitar el proceso.'),
            CURDATE(),
            0,
            idEmpresa,
            ID_SOLICITUD_P
        );
    END IF;

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vaciarTablasIntermediasOfertas`(IN idOfertaP int)
BEGIN

	DELETE FROM ofertas_puestos WHERE ID_OFERTA = idOfertaP;
    DELETE FROM requisitos_academicos WHERE ID_OFERTA = idOfertaP;
    DELETE FROM requisitos_laborales WHERE ID_OFERTA = idOfertaP;
    DELETE FROM ofertas_idiomas WHERE ID_OFERTA = idOfertaP;

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `APLICAR_OFERTA`(
IN p_idOferta int,
IN p_idSolicitante int,
IN p_idEstadoSolicitud int,
IN p_emisorSolicitud int,
IN p_descripcion varchar(200))
BEGIN
	DECLARE V_ID_EMPRESA INT;
	DECLARE V_ID_SOLICITUD INT;
	DECLARE V_NOMBRE_EMPRESA varchar(45);
	DECLARE V_NOMBRE_SOLICITANTE varchar(45);
	DECLARE V_NOMBRE_OFERTA varchar(45);
	DECLARE V_DESCRIPCION_EMPRESA varchar(200);
	DECLARE V_DESCRIPCION_SOLICITANTE varchar(200);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al aplicar la oferta' AS mensaje;
    END;
	
	START TRANSACTION;
	
	INSERT INTO SOLICITUDES (`ID_OFERTA`, `ID_SOLICITANTE`, `ID_ESTADO_SOLICITUD`, `EMISOR_SOLICITUD`, `DESCRIPCION`, `FECHA_SOLICITUD`) VALUES
	(p_idOferta, p_idSolicitante, p_idEstadoSolicitud, p_emisorSolicitud, p_descripcion, sysdate());
	
	SELECT B.ID_EMPRESA
	INTO V_ID_EMPRESA
	FROM OFERTAS A
	INNER JOIN EMPRESA B
	ON(A.ID_EMPRESA = B.ID_EMPRESA)
	WHERE A.ID_OFERTA=p_idOferta;
	
	select nombre_empresa
	into V_NOMBRE_EMPRESA
	FROM empresa
	where id_empresa = v_id_empresa;
	
	select concat(primer_nombre,' ', primer_apellido)
	into V_NOMBRE_SOLICITANTE
	FROM personas
	WHERE ID_persona = p_idSolicitante;
	
	select titulo
	into V_NOMBRE_OFERTA
	FROM ofertas
	WHERE ID_OFERTA = p_idOferta;
	
	SELECT id_solicitud
	INTO v_id_solicitud
	FROM solicitudes
	WHERE id_solicitante = p_idSolicitante
	AND id_oferta = p_idOferta
	ORDER BY fecha_solicitud DESC
	LIMIT 1;
	
	IF p_emisorSolicitud = 0 THEN
		SET v_DESCRIPCION_EMPRESA = Concat('Hola ', v_nombre_empresa,', el usuario ', V_NOMBRE_SOLICITANTE, ' ha aplicado correctamente a la oferta ', V_NOMBRE_OFERTA, ', mensaje:  ', p_descripcion);
        
		SET V_DESCRIPCION_SOLICITANTE = Concat('Felicidades! ',V_NOMBRE_SOLICITANTE,' has aplicado correctamente a la oferta ',V_NOMBRE_OFERTA,' de la empresa ',v_nombre_empresa, ', mensaje:  ', p_descripcion);
	ELSE
		SET v_DESCRIPCION_EMPRESA = Concat('Hola ', v_nombre_empresa, ', se ha enviado una solicitud de aplicacion de la oferta ', V_NOMBRE_OFERTA, ' al solicitante ', V_NOMBRE_SOLICITANTE, ', mensaje:  ', p_descripcion);
		
		SET V_DESCRIPCION_SOLICITANTE = Concat('Buen dia! ', V_NOMBRE_SOLICITANTE,' Has recibido una solicitud para aplicar a la oferta ',V_NOMBRE_OFERTA,' de la empresa ',v_nombre_empresa, '. Tu eliges si aplicar.', ' mensaje:  ', p_descripcion);
	END IF;
	
	
	INSERT INTO NOTIFICACIONES_EMPRESAS
	(`TITULO`,
	`DESCRIPCION`,
	`FECHA`,
	`ESTADO_VISUALIZACION`,
	`ID_EMPRESA`,
	`ID_SOLICITUD`)
	VALUES
	('Nueva aplicacion a una de tus ofertas',v_descripcion_empresa, sysdate(), 0, v_id_empresa, v_id_solicitud);
	
	INSERT INTO NOTIFICACIONES_SOLICITANTES
	(`TITULO`,
	`DESCRIPCION`,
	`FECHA`,
	`ID_SOLICITANTE`,
	`ESTADO_VISUALIZACION`,
	`ID_SOLICITUD`)
	VALUES
	('Nueva aplicacion a oferta',V_DESCRIPCION_SOLICITANTE, sysdate(),p_idSolicitante, 0, v_id_solicitud);
	
	COMMIT;
	SELECT 'Aplicacion creada correctamente' AS mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `enviarNotificacionSolicitante`(
    IN ID_ESTADO_SOLICITUD_P INT,
    IN ID_SOLICITUD_P INT
)
BEGIN 
	DECLARE oferTitulo VARCHAR(255);
	DECLARE idPersona INT;
    DECLARE nombreEmpresa VARCHAR(255);
    
    SELECT id_solicitante into idPersona 
    FROM solicitudes WHERE id_solicitud = ID_SOLICITUD_P;
    
    SELECT em.NOMBRE_EMPRESA, o.titulo INTO nombreEmpresa, oferTitulo
    FROM empresa em 
    INNER JOIN ofertas o on em.ID_EMPRESA = o.ID_EMPRESA
    INNER JOIN solicitudes s on o.ID_OFERTA = s.ID_OFERTA
    WHERE s.id_solicitud = ID_SOLICITUD_P;
    
    -- Insertar notificación si el estado de la solicitud es 3
    IF ID_ESTADO_SOLICITUD_P = 3 THEN 
        INSERT INTO notificaciones_solicitantes (
            TITULO, 
            DESCRIPCION, 
            FECHA, 
            ID_SOLICITANTE, 
            ESTADO_VISUALIZACION, 
            ID_SOLICITUD
        ) 
        VALUES (
            'SOLICITUD ACEPTADA',
            CONCAT('Nos complace informarle que la empresa ',nombreEmpresa,' ha decidido aceptar su solicitud a la oferta de empleo: ', oferTitulo, '. La empresa ',nombreEmpresa,' se pondra en contacto con usted. Feliz dia'),
            CURDATE(),
            idPersona,
            0,
            ID_SOLICITUD_P
        );
    END IF;
    -- si fue rechazada
	IF ID_ESTADO_SOLICITUD_P = 4 THEN 
        INSERT INTO notificaciones_solicitantes (
            TITULO, 
            DESCRIPCION, 
            FECHA, 
            ID_SOLICITANTE, 
            ESTADO_VISUALIZACION, 
            ID_SOLICITUD
        ) 
        VALUES (
            'SOLICITUD RECHAZADA',
            CONCAT('Le informamos que la empresa ',nombreEmpresa,' ha decidido rechazar su solicitud a la oferta de empleo: ', oferTitulo, ', pero aun puede seguir aplicando a ofertas. No te rindas!'),
            CURDATE(),
            idPersona,
            0,
            ID_SOLICITUD_P
        );
    END IF;

END$$
DELIMITER ;
