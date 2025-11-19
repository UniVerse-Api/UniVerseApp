-- Function para registrar una empresa completa
CREATE OR REPLACE FUNCTION registrar_empresa(
    p_id_usuario UUID,
    p_nombre_completo VARCHAR(80),
    p_foto_perfil VARCHAR(255) DEFAULT NULL,
    p_biografia TEXT,
    p_ubicacion TEXT,
    p_telefono VARCHAR(30),
    p_sitio_web VARCHAR(500) DEFAULT NULL,
    p_pais VARCHAR(20),
    p_nombre_comercial VARCHAR(20),
    p_anio_fundacion INTEGER,
    p_total_empleados INTEGER,
    p_doc_verificacion VARCHAR(255),
    p_foto_portada VARCHAR(255) DEFAULT NULL
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
    VALUES (p_id_usuario, 'empresa', 'pendiente');
    
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
    
    -- Insertar en Perfil_empresa
    INSERT INTO Perfil_empresa (
        id_perfil,
        nombre_comercial,
        anio_fundacion,
        total_empleados,
        pais,
        doc_verificacion,
        foto_portada
    )
    VALUES (
        v_id_perfil,
        p_nombre_comercial,
        p_anio_fundacion,
        p_total_empleados,
        p_pais,
        p_doc_verificacion,
        p_foto_portada
    );
    
    -- Preparar respuesta
    v_result := json_build_object(
        'success', true,
        'id_perfil', v_id_perfil,
        'message', 'Empresa registrada exitosamente. Pendiente de verificación.'
    );
    
    RETURN v_result;
    
EXCEPTION
    WHEN OTHERS THEN
        -- En caso de error, devolver respuesta de error
        v_result := json_build_object(
            'success', false,
            'error', SQLERRM,
            'message', 'Error al registrar empresa'
        );
        RETURN v_result;
END;
$$;