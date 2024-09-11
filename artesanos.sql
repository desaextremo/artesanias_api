DROP SCHEMA IF EXISTS artesanos;

CREATE SCHEMA IF NOT EXISTS artesanos DEFAULT CHARACTER SET utf8;

DROP USER IF EXISTS 'admin';
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'admin123';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

-- Seleccionar base de datos
USE artesanos;

CREATE TABLE IF NOT EXISTS departamento (
   dept_id VARCHAR(2) PRIMARY KEY COMMENT 'ID único del departamento',
   dept_nombre VARCHAR(50) NOT NULL COMMENT 'Nombre del departamento'
) COMMENT = 'Tabla que almacena información sobre los departamentos de Colombia';

CREATE TABLE IF NOT EXISTS municipio (
   mun_id VARCHAR(5) PRIMARY KEY COMMENT 'ID único del municipio',
   mun_dept_id VARCHAR(2) NOT NULL COMMENT 'ID del departamento asociado al municipio',
   mun_nombre VARCHAR(50) NOT NULL COMMENT 'Nombre del municipio',
   CONSTRAINT fk_municipio_depto FOREIGN KEY (mun_dept_id) REFERENCES departamento (dept_id)
) COMMENT = 'Tabla que almacena información sobre los municipios de Colombia';

CREATE TABLE IF NOT EXISTS artesano (
   art_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del artesano',
   art_mun_id VARCHAR(5) NOT NULL COMMENT 'ID del municipio donde reside el artesano (clave foránea a municipio.mun_id)',
   art_nombres VARCHAR(50) NOT NULL COMMENT 'Nombres del artesano',
   art_apellidos VARCHAR(50) NOT NULL COMMENT 'Apellidos del artesano',
   art_razon_social VARCHAR(150) NOT NULL COMMENT 'Razón social del artesano',
   art_descripccion TEXT COMMENT 'Descripción de las habilidades y productos del artesano',
   art_email VARCHAR(50) NOT NULL COMMENT 'Correo electrónico del artesano',
   art_celular VARCHAR(10) NOT NULL COMMENT 'Número de celular del artesano',
   art_genero CHAR(1) CHECK (art_genero IN ('F', 'M')) COMMENT 'Género del artesano (F: Femenino, M: Masculino)',
   art_fecha_nacimiento DATE DEFAULT NULL COMMENT 'Fecha de nacimiento del artesano',
   art_picture VARCHAR(255) NOT NULL COMMENT 'Ruta de la imagen del artesano',
   CONSTRAINT fk_artesano_municipio FOREIGN KEY (art_mun_id) REFERENCES municipio (mun_id)
) COMMENT = 'Tabla que almacena información sobre los artesanos';

CREATE TABLE categoria_producto (
    cat_prod_id INT PRIMARY KEY COMMENT 'ID único de la categoría de producto',
    cat_prod_nombre VARCHAR(255) NOT NULL COMMENT 'Nombre de la categoría de producto'
) COMMENT = 'Tabla que almacena información sobre las categorías de producto';

CREATE TABLE producto (
    prod_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del producto',
    prod_nombre VARCHAR(255) NOT NULL COMMENT 'Nombre del producto',
    prod_precio DECIMAL(10, 2) NOT NULL COMMENT 'Precio del producto en moneda local',
    prod_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción breve del producto',
    prod_stock INT NOT NULL COMMENT 'Cantidad de unidades disponibles en stock',
    prod_cat_id INT COMMENT 'ID de la categoría a la que pertenece el producto (clave foránea a categoria_producto.cat_prod_id)',
    prod_art_id INT COMMENT 'ID del artesano que fabrica el producto (clave foránea a artesano.art_id)',
    FOREIGN KEY (prod_cat_id) REFERENCES categoria_producto(cat_prod_id),
    FOREIGN KEY (prod_art_id) REFERENCES artesano(art_id)
) COMMENT = 'Tabla que almacena información sobre los productos';

CREATE TABLE IF NOT EXISTS imagen_producto (
   img_prod_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único de la imagen del producto',
   img_prod_prod_id INT NOT NULL COMMENT 'ID del producto al que pertenece esta imagen (clave foránea a producto.prod_id)',
   img_prod_url VARCHAR(255) NOT NULL COMMENT 'URL de la imagen del producto',
   img_prod_descripcion TEXT COMMENT 'Descripción de la imagen del producto',
   CONSTRAINT fk_imagen_producto FOREIGN KEY (img_prod_prod_id) REFERENCES producto (prod_id)
) COMMENT = 'Tabla que almacena información sobre las imágenes de los productos';

CREATE TABLE IF NOT EXISTS imagen_artesano (
   img_art_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único de la imagen del artesano',
   img_art_artesano_id INT NOT NULL COMMENT 'ID del artesano al que pertenece esta imagen (clave foránea a artesano.art_id)',
   img_art_url VARCHAR(255) NOT NULL COMMENT 'URL de la imagen del artesano',
   img_art_descripcion TEXT COMMENT 'Descripción de la imagen del artesano',
   CONSTRAINT fk_imagen_artesano FOREIGN KEY (img_art_artesano_id) REFERENCES artesano (art_id)
) COMMENT = 'Tabla que almacena información sobre las imágenes de los artesanos';

CREATE INDEX idx_producto_artesano ON producto (prod_art_id);
CREATE INDEX idx_producto_categoria ON producto (prod_cat_id);
CREATE INDEX idx_imagen_producto ON imagen_producto (img_prod_prod_id);
CREATE INDEX idx_imagen_artesano ON imagen_artesano (img_art_artesano_id);
