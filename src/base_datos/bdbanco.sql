
CREATE TABLE TIPO_CLIENTE (
  id                      SERIAL                PRIMARY KEY, 
  descripcion             VARCHAR(50)           NOT NULL
);

CREATE TABLE TIPO_MONEDA (
  id                      SERIAL                PRIMARY KEY, 
  codigo                  CHAR(3)               NOT NULL, 
  descripcion             VARCHAR(50)           NOT NULL
);

CREATE TABLE TIPO_TARJETA (
  id                      SERIAL                PRIMARY KEY, 
  descripcion             VARCHAR(50)           NOT NULL
);

CREATE TABLE TIPO_MOVIMIENTO (
  id                      SERIAL                PRIMARY KEY, 
  descripcion             VARCHAR(50)           NOT NULL
);

CREATE TABLE CANAL (
  id                      SERIAL                PRIMARY KEY, 
  descripcion             VARCHAR(50)           NOT NULL
);

CREATE TABLE TIPO_PRESTAMO (
  id                      SERIAL                PRIMARY KEY, 
  descripcion             VARCHAR(50)           NOT NULL
);

CREATE TABLE DEPARTAMENTO (
  id                      SERIAL                PRIMARY KEY, 
  descripcion             VARCHAR(60)           NOT NULL
);

CREATE TABLE PROVINCIA (
  id                      SERIAL                NOT NULL,
  descripcion             VARCHAR(60)           NOT NULL
);

CREATE TABLE MARCA (
  id                      SERIAL                PRIMARY KEY,
  descripcion             VARCHAR(30)           NOT NULL
);

CREATE TABLE SERVICIO (
  id                      SERIAL                PRIMARY KEY,
  cliente_id              INT                   NOT NULL,
  descripcion             VARCHAR(40)           NOT NULL
);

CREATE TABLE USUARIO (
  id                      SERIAL                PRIMARY KEY,
  codigo_usuario          VARCHAR(40)           NOT NULL
);

CREATE TABLE UBIGEO (
  id                      CHAR(6)               PRIMARY KEY,
  departamento_id         INT                   NOT NULL REFERENCES DEPARTAMENTO,
  provincia_id            INT                   NOT NULL REFERENCES PROVINCIA,
  distrito                VARCHAR(60)           NOT NULL
);

CREATE TABLE SUCURSAL (
  id                      SERIAL                PRIMARY KEY,
  ubigeo_id               CHAR(6)               NOT NULL REFERENCES UBIGEO,
  descripcion             VARCHAR(100)          NOT NULL,
  direccion               VARCHAR(200)          NOT NULL,
  telefono                VARCHAR(14)           NOT NULL
);

CREATE TABLE SERVICIO_BRINDADO (
  id                      SERIAL                PRIMARY KEY,
  servicio_id             INT                   NOT NULL REFERENCES SERVICIO,
  usuario_id              INT                   NOT NULL REFERENCES USUARIO,
  costo                   MONEY                 NOT NULL,
  fecha_facturacion       DATE                  NOT NULL,
  fecha_pago              DATE                  NULL
);

CREATE TABLE EMPLEADO (
  id                      SERIAL                PRIMARY KEY,
  numero_documento        CHAR(8)               NOT NULL,
  nombres                 VARCHAR(100)          NOT NULL,
  apellido_paterno        VARCHAR(100)          NOT NULL,
  apellido_materno        VARCHAR(100)          NOT NULL,
  fecha_nacimiento        DATE                  NOT NULL,
  direccion               VARCHAR(200)          NOT NULL,
  correo                  VARCHAR(50)           NOT NULL,
  telefono                VARCHAR(20)           NOT NULL,
  estado                  BOOLEAN               NOT NULL
);

CREATE TABLE CLIENTE (
  id                      SERIAL                PRIMARY KEY,
  tipo_cliente_id         INT                   NOT NULL REFERENCES TIPO_CLIENTE,
  numero_documento        VARCHAR(11)           NOT NULL,
  nombres                 VARCHAR(100)          NOT NULL,
  apellido_paterno        VARCHAR(100)          NULL
  apellido_materno        VARCHAR(100)          NULL,
  fecha_nacimiento        DATE                  NOT NULL,
  direccion               VARCHAR(200)          NOT NULL,
  correo                  VARCHAR(50)           NOT NULL,
  telefono                VARCHAR(20)           NULL,
  estado                  BOOLEAN               NOT NULL
);

CREATE TABLE CUENTA (
  id                      SERIAL                PRIMARY KEY,
  cliente_id              INT                   NOT NULL REFERENCES CLIENTE,
  tipo_moneda_id          INT                   NOT NULL REFERENCES TIPO_MONEDA,
  sucursal_id             INT                   NOT NULL REFERENCES SUCURSAL,
  numero                  VARCHAR(20)           NOT NULL,
  estado                  BOOLEAN               NOT NULL,
  fecha_creacion          DATE                  NOT NULL,
  fecha_anulacion         DATE                  NULL,
  cci                     VARCHAR(30)           NOT NULL,
  saldo                   MONEY                 NOT NULL,
  saldo_usado             INT                   NULL,
  saldo_total             INT                   NULL
);

CREATE TABLE TARJETA (
  id                      SERIAL                PRIMARY KEY,
  tipo_tarjeta_id         INT                   NOT NULL,
  marca_id                INT                   NOT NULL,
  numero                  VARCHAR(20)           NOT NULL,
  mes_expiracion          INT                   NOT NULL,
  año_expiracion          INT                   NOT NULL,
  cvv                     CHAR(3)               NOT NULL,
  estado                  BOOLEAN               NOT NULL,
  fecha_anulacion         DATE                  NULL
);

CREATE TABLE CUENTA_TARJETA (
  cuenta_id               INT                   NOT NULL,
  tarjeta_id              INT                   NOT NULL,
  
  CONSTRAINT pk_cuenta_tarjeta
    PRIMARY KEY (cuenta_id, tarjeta_id)
);

CREATE TABLE PRESTAMO (
  id                      SERIAL                PRIMARY KEY,
  empleado_id             INT                   NOT NULL REFERENCES EMPLEADO,
  tipo_prestamo_id        INT                   NOT NULL REFERENCES TIPO_PRESTAMO,
  cliente_id              INT                   NOT NULL REFERENCES CLIENTE,
  fecha_solicitud         DATE                  NOT NULL,
  fecha_aprobacion        DATE                  NULL,
  monto_total             MONEY                 NOT NULL,
  tasa_mensual            MONEY                 NOT NULL,
  numero_cuotas           INT                   NOT NULL,
  estado                  CHAR(1)               NOT NULL
);

CREATE TABLE CUOTA (
  id                      SERIAL                PRIMARY KEY,
  prestamo_id             INT                   NOT NULL REFERENCES PRESTAMO,
  numero_cuota            INT                   NOT NULL,
  monto                   MONEY                 NOT NULL,
  monto_mora              MONEY                 NOT NULL,
  fecha_vencimiento       DATE                  NOT NULL,
  fecha_pago              DATE                  NULL,
  monto_pago              MONEY                 NULL
);

CREATE TABLE MOVIMIENTO (
  id                      SERIAL                PRIMARY KEY,
  movimiento_asociado_id  INT                   NULL REFERENCES MOVIMIENTO,
  canal_id                INT                   NOT NULL REFERENCES CANAL,
  tipo_movimiento_id      INT                   NOT NULL REFERENCES TIPO_MOVIMIENTO,
  cuenta_id               INT                   NULL REFERENCES CUENTA,
  cuenta_destino_id       INT                   NULL REFERENCES CUENTA,
  cuota_id                INT                   NULL REFERENCES CUOTA,
  empleado_id             INT                   NULL REFERENCES EMPLEADO,
  servicio_brindado_id    INT                   NULL SERVICIO_BRINDADO,
  monto                   MONEY                 NOT NULL,
  fecha                   DATE                  NOT NULL,
  cci                     VARCHAR(30)           NULL
);

CREATE TABLE MOVIMIENTO_FRECUENTE (
  id                      SERIAL                PRIMARY KEY,
  cliente_id              INT                   NOT NULL REFERENCES CLIENTE,
  tipo_movimiento_id      INT                   NOT NULL REFERENCES TIPO_MOVIMIENTO,
  cuenta_id               INT                   NOT NULL REFERENCES CUENTA,
  cuenta_destino_id       INT                   NULL REFERENCES CUENTA,
  cuota_id                INT                   NULL REFERENCES CUOTA,
  servicio_brindado_id    INT                   NULL REFERENCES SERVICIO_BRINDADO
);
