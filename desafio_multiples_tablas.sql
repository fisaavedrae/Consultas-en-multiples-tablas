-- Creación de DB
create database desafio3_felipe_saavedra_890;

-- Creación de tablas

create table usuarios
(
	id serial,
	email varchar(30),
	nombre varchar(30),
	apellido varchar(30),
	rol varchar
);

-- select * from usuarios

create table posts
(
	id serial,
	titulo varchar,
	contenido text,
	fecha_creacion timestamp,
	fecha_actualizacion timestamp,
	destacado boolean,
	usuario_id bigint
);
-- select * from posts

create table comentarios
(
	id serial,
	contenido text,
	fecha_creacion timestamp,
	usuario_id bigint,
	post_id bigint
);
-- select * from comentarios


-- Insert de registros

insert into usuarios (email, nombre, apellido, rol) values ('ines@gmail.com','Ines', 'de Suarez', 'usuario');
insert into usuarios (email, nombre, apellido, rol) values ('pedro@gmail.com','Pedro', 'de Valdivia', 'usuario');
insert into usuarios (email, nombre, apellido, rol) values ('jose@gmail.com','Jose Miguel', 'Carrera', 'administrador');
insert into usuarios (email, nombre, apellido, rol) values ('hernando@gmail.com','Hernando', 'de Magallanes', 'usuario');
insert into usuarios (email, nombre, apellido, rol) values ('isabel@gmail.com','Isabel', 'la Catolica', 'usuario');

-- Insert de posts

INSERT INTO posts
(
	titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id
)
VALUES ('Los mejores autos deportivos del 2023', 'Descubre los modelos más emocionantes y potentes que están marcando tendencia este año, desde sus características hasta su desempeño.', '2023-02-15', '2023-03-10', 'true', 3);

INSERT INTO posts
(
	titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id
)
VALUES ('Guía de mantenimiento para tu coche','Consejos útiles y prácticos para mantener tu automóvil en óptimas condiciones, desde cambios de aceite hasta cuidado de neumáticos.','2023-04-10','2023-05-05','false',3);
INSERT INTO posts
(
	titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id
)
VALUES ('Los avances tecnológicos en la industria automotriz','Explora las innovaciones más recientes en la tecnología de los vehículos, desde sistemas de conducción autónoma hasta conectividad.','2023-06-20','2023-07-15','true',4);
INSERT INTO posts
(
	titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id
)
VALUES ('Comparativa de SUVs familiares','Una comparación detallada entre los SUVs más populares del mercado, evaluando espacio, seguridad y comodidad para familias.','2023-09-05','2023-09-30','false',4);
INSERT INTO posts
(
	titulo, contenido, fecha_creacion, fecha_actualizacion, destacado
)
VALUES ('Historia de los muscle cars','Sumérgete en el pasado de estos icónicos vehículos americanos, desde sus inicios hasta su impacto en la cultura automotriz actual.','2023-11-12','2023-12-03','false');	

-- Insert de comentarios

insert into comentarios (contenido, fecha_creacion, usuario_id, post_id)
values ('¡Los deportivos siempre son emocionantes de ver!', '2023-02-18',1,1);
insert into comentarios (contenido, fecha_creacion, usuario_id, post_id)
values ('Me encantaría saber más sobre el rendimiento de esos autos.', '2023-02-20',2,1);	
insert into comentarios (contenido, fecha_creacion, usuario_id, post_id)
values ('¿Alguien ha probado alguno de estos? ¡Cuéntenos su experiencia!', '2023-02-25',3,1);	
insert into comentarios (contenido, fecha_creacion, usuario_id, post_id)
values ('El mantenimiento es clave para alargar la vida útil del coche.', '2023-02-25',1,2)	;
insert into comentarios (contenido, fecha_creacion, usuario_id, post_id)
values ('¿Qué tipo de aceite recomendarían para un motor a gasolina?', '2023-04-20',2,2);	


-- Requerimientos
-- Punto 2
select u.nombre, u.email, po.titulo, po.contenido 
from usuarios u 
join posts po 
on u.id = po.usuario_id

-- Punto 3
select po.id post_id, po.titulo, po.contenido from usuarios u, posts po where u.id = po.usuario_id and u.rol = 'administrador'

-- Punto 4
select u.id usuario_id, u.email, count(po.usuario_id) cantidad_post 
from usuarios u 
left join posts po 
on u.id = po.usuario_id 
group by u.id, u.email
order by u.id

-- Punto 5
select u.email, cant_post from usuarios u,
	(
		select count(usuario_id) cant_post, usuario_id 
		from posts  
		group by usuario_id
	) as CP
where u.id = CP.usuario_id
group by u.email,cp.cant_post
order by cp.cant_post desc limit 1

-- Punto 6
select U.email, PO.titulo, PO.fecha_creacion  from usuarios u, posts PO,
	(
		select max(fecha_creacion) fecha_ultimo_post, usuario_id 
		from posts
		group by usuario_id
	) as FUP
where FUP.usuario_id = u.id
and PO.fecha_creacion = FUP.fecha_ultimo_post
and PO.usuario_id = FUP.usuario_id

-- Punto 7
select PO.titulo, PO.contenido, cant_comentarios from posts PO, 
	(
		select count(post_id) cant_comentarios, post_id from comentarios
		group by post_id
	) as CO
order by cant_comentarios desc limit 1

-- Punto 8
select PO.titulo titulo_post, PO.contenido, CO.contenido comentario, US.email 
from posts PO,comentarios CO, usuarios US
where PO.id = CO.post_id
and  CO.usuario_id = US.id

-- Punto 9
select U.email, CO.contenido ultimo_comentario from comentarios CO, usuarios U ,
	(
		select max(fecha_creacion) fecha_ultimo_comentario, usuario_id 
		from comentarios
		group by usuario_id
	) as FUP
where FUP.usuario_id = CO.usuario_id
and CO.fecha_creacion =  FUP.fecha_ultimo_comentario
and U.id = FUP.usuario_id

-- Punto 10
select u.email from usuarios U,
	(
		select U.id usuario_id, CO.id 
		from usuarios U 
		left join comentarios CO
		on U.id = CO.usuario_id
	) as UC	
where UC.usuario_id = U.id
group by UC.id,  UC.usuario_id, U.email
having count(UC.id) = 0

