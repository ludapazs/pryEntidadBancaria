
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

--consultar prestamos por cliente
create or replace function fn_consultar_prestamos_por_cliente(dni varchar) 
returns table( des varchar, f_solicitud date, f_aprobacion date, monto money, tasa float, cuotas int, est char ) as
$$
Declare
	id int = (select c.id from cliente c where c.numero_documento=dni);
Begin
	return query
	select tp.descripcion, p.fecha_solicitud, p.fecha_aprobacion, p.monto_total,  p.tasa_mensual, p.numero_cuotas, p.estado
	from prestamo p 
	inner join tipo_prestamo tp on p.tipo_prestamo_id=tp.id 
	where p.cliente_id=id;
end;
$$ language 'plpgsql'

--consultar movimientos por canal
create or replace function fn_consultar_movimientos_por_canal ( ident int ) 
returns table ( descrip varchar, numero varchar, monto money, fecha date ) as 
$$
Declare
Begin
	return query
	select tp.descripcion, c.numero, m.monto, m.fecha from movimiento m 
	inner join tipo_movimiento tp on m.tipo_movimiento_id=tp.id
	inner join cuenta c on m.cuenta_id=c.id
	where m.canal_id=ident;
end;
$$ language 'plpgsql'

--consultar cuenta por sucursal
create or replace function fn_consultar_cuenta_por_sucursal( cod int ) 
returns table ( nombre text, numero varchar, descrip_tm varchar, descrip_sucursal varchar, descrip_dpto varchar, descrip_prov varchar ) 
as
$$
Declare	
Begin
	return query
	select c.nombres ||' '||c.apellido_paterno||' '||c.apellido_materno as nombre, ct.numero, tm.descripcion, s.descripcion,
	dpto.descripcion , p.descripcion
	from cuenta ct
	inner join cliente c on ct.cliente_id=c.id
	inner join tipo_moneda tm on ct.tipo_moneda_id=tm.id
	inner join sucursal s on ct.sucursal_id=s.id
	inner join ubigeo u on s.ubigeo_id=u.id
	inner join departamento dpto on u.departamento_id=dpto.id
	inner join provincia p on u.provincia_id=p.id
	where s.id=cod;
	
end;
$$ language 'plpgsql'

--consultar cuenta por moneda
create or replace function fn_consultar_cuenta_por_moneda_cliente( cod varchar, dni varchar ) 
returns table ( nom text, numero_cuenta varchar, descrip varchar ) as
$$
Declare
	
Begin
	return query
	select c.nombres ||' '||c.apellido_paterno||' '||c.apellido_materno as nombre, ct.numero, tm.descripcion from cuenta ct
	inner join cliente c on ct.cliente_id=c.id
	inner join tipo_moneda tm on ct.tipo_moneda_id=tm.id
	where tm.codigo=cod and c.numero_documento=dni;
	
end;
$$ language 'plpgsql'

--consultar movimientos frecuentes
create or replace function fn_consultar_movimientos_frecuentes( dni varchar ) 
returns table (nom text, ) as
$$
Declare
	id int = (select id from cliente where numero_documento=dni);
Begin
	return query
	select c.nombres ||' '||c.apellido_paterno||' '||c.apellido_materno as nombre, cnt.numero from movimiento_frecuente mf
	inner join cliente c on mf.cliente_id=c.id
	inner join tipo_movimiento tm on mf.tipo_movimiento_id=tm.id
	inner join cuenta cnt on mf.cuenta_id=cnt.id
	where c.id=id;
	
end;
$$ language 'plpgsql'

--conocer mes 
Create or replace function fn_nombre_mes(mes_num int) returns character varying as
$$
Declare
nom_mes character varying;
Begin
	case mes_num
		when 1 then nom_mes='Enero';
		when 2 then nom_mes='Febrero';
		when 3 then nom_mes='Marzo';
		when 4 then nom_mes='Abril';
		when 5 then nom_mes='Mayo';
		when 6 then nom_mes='Junio';
		when 7 then nom_mes='Julio';
		when 8 then nom_mes='Agosto';
		when 9 then nom_mes='Setiembre';
		when 10 then nom_mes='Octubre';
		when 11 then nom_mes='Noviembre';
		when 12 then nom_mes='Diciembre';
		else nom_mes='Numero inválido';
	end case;
	return nom_mes;
end;
$$ language 'plpgsql';

--consultar tarjeta por tipo y por marca juntos
create or replace function fn_consultar_cuenta_por_moneda_cliente( cod int, marca_nombre varchar ) 
returns table ( numero varchar, mes_exp varchar , año_exp int, cvv char(3), estado boolean, f_adqui date ) as
$$
Declare
	id_marca int = (select id from marca where descripcion=marca_nombre);
Begin
	return query
	select t.numero, (select fn_nombre_mes(t.mes_expiracion)) as mes_venc , t.año_expiracion, t.cvv, t.estado, t.fecha_adquisicion from tarjeta t 
	inner join tipo_tarjeta tt on t.tipo_tarjeta_id=tt.id
	inner join marca m on t.marca_id=m.id
	where m.id=id_marca and tt.id=cod;
	
end;
$$ language 'plpgsql'

--consultar movimiento por tipo, por canal
create or replace function fn_consultar_movimientos_por_canal_tipo_movimiento ( tipo int, canal int ) 
returns table ( numero_cuenta varchar, monto money, fecha date ) as 
$$
Declare
Begin
	return query
	select c.numero, m.monto, m.fecha from movimiento m
	inner join tipo_movimiento tp on m.tipo_movimiento_id=tp.id
	inner join cuenta c on m.cuenta_id=c.id
	inner join canal cn on m.canal_id=cn.id
	where m.canal_id=canal and tp.id=tipo;
end;
$$ language 'plpgsql'

--insertando en tabla canal
insert into canal (descripcion) values ('Agente');
insert into canal (descripcion) values ('Banca Móvil');
insert into canal (descripcion) values ('Banca por internet');
insert into canal (descripcion) values ('Cajeros automáticos');
insert into canal (descripcion) values ('Agencias');

--insert en la tabla tipo cliente
select * from tipo_cliente;

insert into tipo_cliente (descripcion) values ('Persona natural');
insert into tipo_cliente (descripcion) values ('Persona jurídica');

--insert dentro de tipo_moneda
select * from tipo_moneda;

insert into tipo_moneda (codigo,descripcion) values ('SOL','Sol'),
						    ('EUR','Euro'),
						    ('USD','Dólar'),
						    ('JPY','Yen'),
						    ('MXN','Peso Mexicano'),
						    ('ARS','Peso Argentino'),
						    ('GBP','Libra Esterlina'),
						    ('BRL','Real Brasileño'),
					       	    ('VES','Bolívar');

--insert en la tabla tipo tarjeta
select * from tipo_tarjeta
insert into tipo_tarjeta (descripcion) values ('Débito');
insert into tipo_tarjeta (descripcion) values ('Crédito');
