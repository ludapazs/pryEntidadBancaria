
CREATE TABLE TIPO_CLIENTE (
    id                      SERIAL              PRIMARY KEY,
    descripcion             VARCHAR(50)         NOT NULL
);

CREATE TABLE TIPO_MONEDA (
    id                      SERIAL              PRIMARY KEY, 
    codigo                  CHAR(3)             NOT NULL, 
    descripcion             VARCHAR(50)         NOT NULL
);

CREATE TABLE TIPO_TARJETA (
    id                      SERIAL              PRIMARY KEY, 
    descripcion             VARCHAR(50)         NOT NULL
);

CREATE TABLE TIPO_MOVIMIENTO (
    id                      SERIAL              PRIMARY KEY, 
    descripcion             VARCHAR(50)         NOT NULL
);

CREATE TABLE CANAL (
    id                      SERIAL              PRIMARY KEY, 
    descripcion             VARCHAR(50)         NOT NULL
);

CREATE TABLE TIPO_PRESTAMO (
    id                      SERIAL              PRIMARY KEY, 
    descripcion             VARCHAR(50)         NOT NULL
);

CREATE TABLE DEPARTAMENTO (
    id                      SERIAL              PRIMARY KEY, 
    descripcion             VARCHAR(60)         NOT NULL
);

CREATE TABLE PROVINCIA (
    id                      SERIAL              PRIMARY KEY,
    descripcion             VARCHAR(60)         NOT NULL
);

CREATE TABLE MARCA (
    id                      SERIAL              PRIMARY KEY,
    descripcion             VARCHAR(30)         NOT NULL
);

CREATE TABLE USUARIO (
    id                      SERIAL              PRIMARY KEY,
    codigo_usuario          VARCHAR(40)         NOT NULL
);

CREATE TABLE UBIGEO (
    id                      CHAR(6)             PRIMARY KEY,
    departamento_id         INT                 NOT NULL REFERENCES DEPARTAMENTO,
    provincia_id            INT                 NOT NULL REFERENCES PROVINCIA,
    distrito                VARCHAR(60)         NOT NULL
);

CREATE TABLE SUCURSAL (
    id                      SERIAL              PRIMARY KEY,
    ubigeo_id               CHAR(6)             NOT NULL REFERENCES UBIGEO,
    descripcion             VARCHAR(100)        NOT NULL,
    direccion               VARCHAR(200)        NOT NULL,
    telefono                VARCHAR(14)         NOT NULL
);

CREATE TABLE EMPLEADO (
    id                      SERIAL              PRIMARY KEY,
    numero_documento        CHAR(8)             NOT NULL,
    nombres                 VARCHAR(100)        NOT NULL,
    apellido_paterno        VARCHAR(100)        NOT NULL,
    apellido_materno        VARCHAR(100)        NOT NULL,
    fecha_nacimiento        DATE                NOT NULL CHECK (AGE(fecha_nacimiento) >= '20 years'),
    direccion               VARCHAR(200)        NOT NULL,
    correo                  VARCHAR(50)         NOT NULL,
    telefono                VARCHAR(20)         NOT NULL,
    estado                  BOOLEAN             NOT NULL
);

CREATE TABLE CLIENTE (
    id                      SERIAL              PRIMARY KEY,
    tipo_cliente_id         INT                 NOT NULL REFERENCES TIPO_CLIENTE,
    numero_documento        VARCHAR(11)         NOT NULL,
    nombres                 VARCHAR(100)        NOT NULL,
    apellido_paterno        VARCHAR(100)        NULL,
    apellido_materno        VARCHAR(100)        NULL,
    fecha_nacimiento        DATE                NOT NULL,
    direccion               VARCHAR(200)        NOT NULL,
    correo                  VARCHAR(50)         NOT NULL,
    telefono                VARCHAR(20)         NULL,
    estado                  BOOLEAN             NOT NULL,

    CONSTRAINT chk_fecha_nacimiento_cliente
        CHECK (
            (LENGTH(numero_documento) = 8 AND AGE(fecha_nacimiento) >= '18 years') OR
            (LENGTH(numero_documento) = 11 AND AGE(fecha_nacimiento) >= '0 days')
        )
);

CREATE TABLE SERVICIO (
    id                      SERIAL              PRIMARY KEY,
    cliente_id              INT                 NOT NULL REFERENCES CLIENTE,
    descripcion             VARCHAR(40)         NOT NULL
);

CREATE TABLE SERVICIO_BRINDADO (
    id                      SERIAL              PRIMARY KEY,
    servicio_id             INT                 NOT NULL REFERENCES SERVICIO,
    usuario_id              INT                 NOT NULL REFERENCES USUARIO,
    costo                   MONEY               NOT NULL,
    fecha_facturacion       DATE                NOT NULL,
    fecha_pago              DATE                NULL CHECK (fecha_pago >= fecha_facturacion)
);

CREATE TABLE CUENTA (
    id                      SERIAL              PRIMARY KEY,
    cliente_id              INT                 NOT NULL REFERENCES CLIENTE,
    tipo_moneda_id          INT                 NOT NULL REFERENCES TIPO_MONEDA,
    sucursal_id             INT                 NOT NULL REFERENCES SUCURSAL,
    numero                  VARCHAR(20)         NOT NULL,
    estado                  BOOLEAN             NOT NULL,
    fecha_creacion          DATE                NOT NULL CHECK (fecha_creacion <= CURRENT_DATE) DEFAULT CURRENT_DATE,
    fecha_anulacion         DATE                NULL CHECK (AGE(fecha_anulacion, fecha_creacion) > '3 mons'),
    cci                     VARCHAR(30)         NOT NULL,
    saldo                   MONEY               NOT NULL CHECK (saldo >= MONEY '0'),
    saldo_usado             MONEY               NULL CHECK (saldo_usado < saldo_total),
    saldo_total             MONEY               NULL CHECK (saldo_total = saldo + saldo_usado)
);

CREATE TABLE TARJETA (
    id                      SERIAL              PRIMARY KEY,
    tipo_tarjeta_id         INT                 NOT NULL REFERENCES TIPO_TARJETA,
    marca_id                INT                 NOT NULL REFERENCES MARCA,
    numero                  VARCHAR(20)         NOT NULL,
    mes_expiracion          INT                 NOT NULL CHECK (mes_expiracion BETWEEN 1 and 12),
    año_expiracion          INT                 NOT NULL CHECK (LENGTH(año_expiracion :: VARCHAR) = 4),
    cvv                     CHAR(3)             NOT NULL,
    estado                  BOOLEAN             NOT NULL,
    fecha_adquisicion       DATE                NOT NULL CHECK (fecha_adquisicion <= CURRENT_DATE) DEFAULT CURRENT_DATE,
    fecha_anulacion         DATE                NULL CHECK (AGE(fecha_anulacion, fecha_adquisicion) > '3 mons')
);

CREATE TABLE CUENTA_TARJETA (
    cuenta_id               INT                 NOT NULL REFERENCES CUENTA,
    tarjeta_id              INT                 NOT NULL REFERENCES TARJETA,
  
    CONSTRAINT pk_cuenta_tarjeta
        PRIMARY KEY (cuenta_id, tarjeta_id)
);

CREATE TABLE PRESTAMO (
    id                      SERIAL              PRIMARY KEY,
    empleado_id             INT                 NOT NULL REFERENCES EMPLEADO,
    tipo_prestamo_id        INT                 NOT NULL REFERENCES TIPO_PRESTAMO,
    cliente_id              INT                 NOT NULL REFERENCES CLIENTE,
    fecha_solicitud         DATE                NOT NULL CHECK (fecha_solicitud <= CURRENT_DATE),
    fecha_aprobacion        DATE                NULL CHECK (fecha_aprobacion >= fecha_solicitud),
    monto_total             MONEY               NOT NULL,
    tasa_mensual            FLOAT               NOT NULL,
    numero_cuotas           INT                 NOT NULL CHECK (numero_cuotas >= 1),
    estado                  CHAR(1)             NOT NULL
);

CREATE TABLE CUOTA (
    id                      SERIAL              PRIMARY KEY,
    prestamo_id             INT                 NOT NULL REFERENCES PRESTAMO,
    numero_cuota            INT                 NOT NULL,
    monto                   MONEY               NOT NULL,
    monto_mora              MONEY               NOT NULL,
    fecha_vencimiento       DATE                NOT NULL,
    fecha_pago              DATE                NULL CHECK (fecha_pago > fecha_vencimiento - 7),
    monto_pago              MONEY               NULL CHECK (monto_pago = monto + monto_mora)
);

CREATE TABLE MOVIMIENTO (
    id                      SERIAL              PRIMARY KEY,
    movimiento_asociado_id  INT                 NULL REFERENCES MOVIMIENTO,
    canal_id                INT                 NOT NULL REFERENCES CANAL,
    tipo_movimiento_id      INT                 NOT NULL REFERENCES TIPO_MOVIMIENTO,
    cuenta_id               INT                 NULL REFERENCES CUENTA,
    cuenta_destino_id       INT                 NULL REFERENCES CUENTA,
    cuota_id                INT                 NULL REFERENCES CUOTA,
    empleado_id             INT                 NULL REFERENCES EMPLEADO,
    servicio_brindado_id    INT                 NULL REFERENCES SERVICIO_BRINDADO,
    monto                   MONEY               NOT NULL,
    fecha                   DATE                NOT NULL CHECK (fecha <= CURRENT_DATE),
    cci                     VARCHAR(30)         NULL
);

CREATE TABLE MOVIMIENTO_FRECUENTE (
    id                      SERIAL              PRIMARY KEY,
    cliente_id              INT                 NOT NULL REFERENCES CLIENTE,
    tipo_movimiento_id      INT                 NOT NULL REFERENCES TIPO_MOVIMIENTO,
    cuenta_id               INT                 NOT NULL REFERENCES CUENTA,
    cuenta_destino_id       INT                 NULL REFERENCES CUENTA,
    cuota_id                INT                 NULL REFERENCES CUOTA,
    servicio_brindado_id    INT                 NULL REFERENCES SERVICIO_BRINDADO
);

alter table movimiento_frecuente ADD monto money null; 