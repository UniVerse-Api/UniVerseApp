
-- Tabla Usuario
CREATE TABLE Usuario (
    id_usuario SERIAL PRIMARY KEY,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('admin', 'empresa', 'universidad', 'docente', 'estudiante')),
    email VARCHAR(30) NOT NULL UNIQUE,
    password VARCHAR(700) NOT NULL,
    estado enum ('activo', 'inactivo', 'suspendido', 'Pendiente') NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabla Perfil
CREATE TABLE Perfil (
    id_perfil SERIAL PRIMARY KEY,
    id_usuario INTEGER REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    nombre_completo VARCHAR(80) NOT NULL,
    foto_perfil VARCHAR(255),
    biografia TEXT NOT NULL,
    ubicacion TEXT NOT NULL,
    telefono VARCHAR(30) NOT NULL
);

-- Tabla Experiencia
CREATE TABLE Experiencia (
    id_experiencia SERIAL PRIMARY KEY,
    id_perfil INTEGER NOT NULL REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    empresa VARCHAR(255) NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('pasantia', 'tiempo_completo', 'medio_tiempo', 'voluntariado')),
    puesto TEXT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    descripcion TEXT,
    ubicacion TEXT
);

-- Tabla Formacion
CREATE TABLE Formacion (
    id_formacion SERIAL PRIMARY KEY,
    id_perfil INTEGER NOT NULL REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    institucion VARCHAR(255) NOT NULL,
    campo_estudio VARCHAR(255) NOT NULL,
    grado VARCHAR(255) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

-- Tabla Investigacion
CREATE TABLE Investigacion (
    id_investigacion SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    titulo TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    rol VARCHAR(60),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    fecha_publicacion DATE NOT NULL,
    ubicacion TEXT
);

-- Tabla Certificacion
CREATE TABLE Certificacion (
    id_certificacion SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    titulo TEXT NOT NULL,
    imagen TEXT NOT NULL,
    institucion TEXT NOT NULL,
    fecha_obtencion DATE NOT NULL
);

-- Tabla Habilidad
CREATE TABLE Habilidad (
    id_habilidad SERIAL PRIMARY KEY,
    id_perfil INTEGER NOT NULL REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    nombre TEXT NOT NULL
);

-- Tabla Idioma
CREATE TABLE Idioma (
    id_idioma SERIAL PRIMARY KEY,
    id_perfil INTEGER NOT NULL REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    nombre VARCHAR(50) NOT NULL,
    nivel VARCHAR(20) NOT NULL CHECK (nivel IN ('basico', 'intermedio', 'avanzado'))
);

-- Tabla CV_archivo
CREATE TABLE CV_archivo (
    id_cv SERIAL PRIMARY KEY,
    id_perfil INTEGER REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    nombre VARCHAR(30) NOT NULL,
    url_cv VARCHAR(255) NOT NULL,
    fecha_subida DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Tabla Suscripcion_plan
CREATE TABLE Suscripcion_plan (
    id_suscripcion_plan SERIAL PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL,
    precio_mensual DECIMAL(6,2) NOT NULL,
    max_pub_dia INTEGER NOT NULL,
    max_caracteres_pub INTEGER NOT NULL,
    prioridad_busqueda VARCHAR(10) CHECK (prioridad_busqueda IN ('alto', 'medio', 'bajo')),
    agregar_ads BOOLEAN NOT NULL,
    max_cv_subida INTEGER NOT NULL,
    max_ofertas_trabajo INTEGER NOT NULL,
    mostrar_anuncios BOOLEAN NOT NULL
);

-- Tabla Suscripciones
CREATE TABLE Suscripciones (
    id_suscripcion SERIAL PRIMARY KEY,
    id_perfil INTEGER REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    id_suscripcion_plan INTEGER REFERENCES Suscripcion_plan(id_suscripcion_plan) ON DELETE SET NULL,
    estatus VARCHAR(20) NOT NULL CHECK (estatus IN ('activo', 'cancelada', 'expirada', 'prueba')),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    proximo_fecha_pago DATE NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabla Pago
CREATE TABLE Pago (
    id_pago SERIAL PRIMARY KEY,
    id_suscripcion INTEGER REFERENCES Suscripciones(id_suscripcion) ON DELETE CASCADE,
    subtotal DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(20) NOT NULL CHECK (metodo_pago IN ('credito', 'debito', 'paypal')),
    fecha_pago DATE NOT NULL
);

-- Tabla Publicacion
CREATE TABLE Publicacion (
    id_publicacion SERIAL PRIMARY KEY,
    id_perfil INTEGER NOT NULL REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    likes_contador INTEGER NOT NULL DEFAULT 0,
    coments_contador INTEGER NOT NULL DEFAULT 0,
    fecha_publicacion DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Tabla Comentario
CREATE TABLE Comentario (
    id_comentario SERIAL PRIMARY KEY,
    id_publicacion INTEGER NOT NULL REFERENCES Publicacion(id_publicacion) ON DELETE CASCADE,
    id_perfil_autor INTEGER NOT NULL REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    contenido TEXT NOT NULL
);

-- Tabla Publicacion_like
CREATE TABLE Publicacion_like (
    id_publicacion_like SERIAL PRIMARY KEY,
    id_publicacion INTEGER REFERENCES Publicacion(id_publicacion) ON DELETE CASCADE,
    id_perfil INTEGER REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_publicacion, id_perfil)
);

-- Tabla Favorito
CREATE TABLE Favorito (
    id_favorito SERIAL PRIMARY KEY,
    id_publicacion INTEGER REFERENCES Publicacion(id_publicacion) ON DELETE CASCADE,
    id_perfil INTEGER REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_publicacion, id_perfil)
);

-- Tabla Recurso_publicacion
CREATE TABLE Recurso_publicacion (
    id_recurso SERIAL PRIMARY KEY,
    id_publicacion INTEGER NOT NULL REFERENCES Publicacion(id_publicacion) ON DELETE CASCADE,
    url_recurso VARCHAR(600) NOT NULL
);

-- Tabla Seguidor (relación muchos a muchos)
CREATE TABLE Seguidor (
    id_seguidor INTEGER REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    id_seguido INTEGER REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    PRIMARY KEY (id_seguidor, id_seguido),
    CHECK (id_seguidor != id_seguido)
);

-- Tabla Oferta
CREATE TABLE Oferta (
    id_oferta SERIAL PRIMARY KEY,
    id_perfil INTEGER NOT NULL REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    titulo VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL,
    salario_rango VARCHAR(60) NOT NULL,
    tipo_oferta VARCHAR(20) NOT NULL CHECK (tipo_oferta IN ('tiempo_completo', 'medio_tiempo', 'pasantia')),
    es_activa BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_publicacion DATE NOT NULL DEFAULT CURRENT_DATE,
    ubicacion VARCHAR(255) NOT NULL,
    fecha_limite DATE
);

-- Tabla Aplicacion
CREATE TABLE Aplicacion (
    id_aplicacion SERIAL PRIMARY KEY,
    id_oferta INTEGER NOT NULL REFERENCES Oferta(id_oferta) ON DELETE CASCADE,
    id_perfil INTEGER NOT NULL REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pendiente', 'revisado', 'rechazado', 'aceptado')),
    recomendacion_premium BOOLEAN NOT NULL DEFAULT FALSE,
    carta_presentacion TEXT,
    email_contacto VARCHAR(100),
    telefono VARCHAR(30),
    disponibilidad ENUM('inmediata', '1_semana', '2_semanas', '1_mes', 'otro'),
    fecha_aplicacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Requisito_oferta (
    id_requisito SERIAL PRIMARY KEY,
    id_oferta INTEGER NOT NULL REFERENCES Oferta(id_oferta) ON DELETE CASCADE,
    nombre_requisito TEXT NOT NULL
);

CREATE TABLE Beneficio (
    id_beneficio SERIAL PRIMARY KEY,
    id_oferta INTEGER NOT NULL REFERENCES Oferta(id_oferta) ON DELETE CASCADE,
    nombre_beneficio TEXT NOT NULL
);

-- Tabla Perfil_Favorito
CREATE TABLE Perfil_Favorito (
    id_perfil_empresa INTEGER REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    id_perfil_estudiante INTEGER REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    nota VARCHAR(100),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_perfil_empresa, id_perfil_estudiante)
);

-- Tabla Destacado
CREATE TABLE Destacado (
    id_destacado SERIAL PRIMARY KEY,
    id_universidad INTEGER REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    id_estudiante INTEGER REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    comentario TEXT
);

-- Tabla Anuncio
CREATE TABLE Anuncio (
    id_anuncio SERIAL PRIMARY KEY,
    id_empresa INTEGER NOT NULL REFERENCES Perfil(id_perfil) ON DELETE CASCADE,
    titulo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    vista_contador INTEGER NOT NULL DEFAULT 0,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

-- Tabla Recurso_anuncio
CREATE TABLE Recurso_anuncio (
    id_recurso SERIAL PRIMARY KEY,
    id_anuncio INTEGER REFERENCES Anuncio(id_anuncio) ON DELETE CASCADE,
    url_recurso VARCHAR(500) NOT NULL
);

-- Índices para mejorar el rendimiento
CREATE INDEX idx_perfil_usuario ON Perfil(id_usuario);
CREATE INDEX idx_experiencia_perfil ON Experiencia(id_perfil);
CREATE INDEX idx_formacion_perfil ON Formacion(id_perfil);
CREATE INDEX idx_publicacion_perfil ON Publicacion(id_perfil);
CREATE INDEX idx_comentario_publicacion ON Comentario(id_publicacion);
CREATE INDEX idx_oferta_perfil ON Oferta(id_perfil);
CREATE INDEX idx_aplicacion_oferta ON Aplicacion(id_oferta);
CREATE INDEX idx_aplicacion_perfil ON Aplicacion(id_perfil);