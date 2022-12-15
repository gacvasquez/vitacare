/*
UNIVERSIDAD DOMINICANA O&M


Gabriel Antonio Carrasco Vásquez
21-MIIT-1-010

Administración de Base de Datos

Sección 0541

*/



USE [master];
GO 
IF DB_ID('vitacare') IS NOT NULL
BEGIN
	ALTER DATABASE vitacare SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE vitacare SET ONLINE;
	DROP DATABASE  vitacare;
END
GO

CREATE DATABASE vitacare;
GO

use vitacare

CREATE TABLE aseguradoras (aseguradoraId INT NOT NULL  PRIMARY KEY IDENTITY, nombre NVARCHAR(50) NOT NULL,
telefono NVARCHAR(15) NOT NULL, correo NVARCHAR(75) NOT NULL);
GO

CREATE TABLE clientes (clienteId INT NOT NULL  PRIMARY KEY IDENTITY,  nombre NVARCHAR(50) NOT NULL,
telefono NVARCHAR(15) NOT NULL, cedula NVARCHAR(15) NOT NULL, aseguradoraId INT NOT NULL FOREIGN KEY
REFERENCES aseguradoras(aseguradoraId));
GO

CREATE TABLE productos (productoId INT NOT NULL  PRIMARY KEY IDENTITY, codigo NVARCHAR(10) NOT NULL,
nombre NVARCHAR(50) NOT NULL, precio DECIMAL(8,2) NOT NULL, stock INT NOT NULL)
GO

CREATE TABLE ventas (ventaId INT NOT NULL  PRIMARY KEY IDENTITY, cant INT NOT NULL, total INT, 
clienteId INT NOT NULL FOREIGN KEY REFERENCES clientes(clienteId), productoId INT NOT NULL FOREIGN KEY
REFERENCES productos(productoId), 
);
 GO

CREATE TABLE cotizaciones (cotizacionId INT NOT NULL  PRIMARY KEY IDENTITY, cobertura DECIMAL(8,2), clienteId INT NOT NULL FOREIGN KEY
REFERENCES clientes(clienteId));
GO


INSERT INTO aseguradoras VALUES
('ARS Primera', '829-476-3535', 'contacto@humano.com.do'),
('Mapfre Salud ARS', '809-381-5000', 'servicios@mapfresaludars.com.do'),
('ARS Universal', '809-544-7111', 'clientes@universal.com.do'),
('ARS Sigma', '809-685-7940', 'info@arssimag.com.do'),
('ARS Yunen', '809-540-0901', 'info@arsyunen.com'),
('ARS Monumental', '809-683-0433', 'info@arsmonumental.com.do'),
('ARS Meta Salud', '809-688-2020', 'servicios@arsmetasalud.com'),
('ARS SENASA', '809-333-3821', 'info@arssenasa.gob.do'),
('Medicard', '809-948-4449', 'info@medicard.com'),
('ARS Reservas', '809-334-5505 ', 'ars@reservas.com'),
('ARS Futuro', '809-686-1218', 'info@arsfuturo.com');

INSERT INTO clientes VALUES
('Miguel Hernández','809-370-4822','402-2241256-9',3),
('Laura Cuevas','829-447-1082','001-0734589-2',8),
('Alondra Payano','829-784-1548','402-0058796-1',8),
('Jason Galvez','809-785-4773','402-4305879-6',2),
('Victoria Castillo','849-987-2555','101-0081329-2',4),
('Cristian Durán','849-788-0715','024-0002585-3',1),
('Nicolás Castro','829-080-4322','402-1012558-3',2),
('Vielka Ramírez','849-980-0414','001-1442585-4',5),
('Camilo Castillo','809-450-4565','101-0253369-7',3),
('Masiel Valdez','829-855-2554','402-0122588-5',7),
('Carlos Pérez','809-580-4380','402-0990587-2',9),
('Víctor Santana','849-880-2366','001-2257896-0',11),
('Estebanía Lucas','809-980-6698','402-0225686-3',1);

INSERT INTO productos VALUES
('ACE500','Acetaminofén 50mg',35,420),
('ACF03','Ácido FOlínico 3mg',120,200),
('ABZ20','Albendazol 20mg',320,75),
('AMP500','Ampicilina 500mg',25,220),
('CTP25','Captopril 25mg',35,180),
('DFC75','Diclofenac 75mg',20,175),
('FTN050','Fentanilo 0.05mg',125,200),
('LTD100','Loratadina 100mg',220,80),
('MCZ2','Miconazol 2g',175,60),
('PCM100','Paracetamol Oral 100mg', 90,220),
('QFD100','Quinfamida 100ml', 250,180);


DECLARE @i AS INT=0;


WHILE @i<10
BEGIN
SET @i= @i+1;
INSERT INTO ventas VALUES
(@i*3, (SELECT TOP 1 precio*(@i*3) FROM productos WHERE productoId=@i), 11-@i, @i);
UPDATE productos SET stock=stock-(@i*3) WHERE productoId=@i;
INSERT INTO cotizaciones VALUES ((SELECT TOP 1 precio*(@i*3)/3 FROM productos WHERE productoId=@i), 11-@i);
END

SELECT * FROM aseguradoras;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;
SELECT * FROM cotizaciones;




SELECT c.nombre AS Cliente, p.nombre AS Product, v.cant AS Cant, v.total AS Total, a.nombre AS Aseguradora, 
ct.cobertura AS Cobertura, v.total-ct.cobertura AS Saldo FROM ventas v LEFT JOIN clientes c on v.clienteId=c.clienteId 
LEFT JOIN productos p on v.productoId=p.productoId LEFT JOIN cotizaciones ct on c.clienteId=ct.clienteId LEFT JOIN
aseguradoras a on c.aseguradoraId=a.aseguradoraId;


