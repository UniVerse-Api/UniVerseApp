-- Function para registrar un estudiante completo
CREATE OR REPLACE FUNCTION registrar_estudiante(
    p_id_usuario UUID,
    p_nombre_completo VARCHAR(80),
    p_biografia TEXT,
    p_ubicacion TEXT,
    p_telefono VARCHAR(30),
    p_nombre_comercial VARCHAR(20),
    p_carrera VARCHAR(25),
    p_universidad_actual VARCHAR(30) DEFAULT NULL,
    p_foto_perfil VARCHAR(255) DEFAULT NULL,
    p_sitio_web VARCHAR(500) DEFAULT NULL,
    p_pais VARCHAR(20) DEFAULT NULL
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_id_perfil INTEGER;
    v_result json;
BEGIN
    -- Insertar en Usuario
    INSERT INTO Usuario (id_usuario, rol, estado)
    VALUES (p_id_usuario, 'estudiante', 'activo');
    
    -- Insertar en Perfil
    INSERT INTO Perfil (
        id_usuario, 
        nombre_completo, 
        foto_perfil, 
        biografia, 
        ubicacion, 
        telefono, 
        sitio_web
    )
    VALUES (
        p_id_usuario,
        p_nombre_completo,
        p_foto_perfil,
        p_biografia,
        p_ubicacion,
        p_telefono,
        p_sitio_web
    )
    RETURNING id_perfil INTO v_id_perfil;
    
    -- Insertar en Perfil_estudiante
    INSERT INTO Perfil_estudiante (
        id_perfil,
        nombre_comercial,
        carrera,
        universidad_actual,
        pais
    )
    VALUES (
        v_id_perfil,
        p_nombre_comercial,
        p_carrera,
        p_universidad_actual,
        p_pais
    );
    
    -- Retornar resultado
    SELECT json_build_object(
        'success', true,
        'id_perfil', v_id_perfil,
        'message', 'Estudiante registrado exitosamente'
    ) INTO v_result;
    
    RETURN v_result;
    
EXCEPTION WHEN OTHERS THEN
    -- Manejo de errores
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM
    );
END;
$$;