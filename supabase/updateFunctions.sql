-- Script para actualizar funciones de registro
-- Ejecutar en Supabase SQL Editor

-- 1. Primero, agregar columna pais a Perfil_estudiante si no existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='perfil_estudiante' AND column_name='pais') THEN
        ALTER TABLE Perfil_estudiante ADD COLUMN pais VARCHAR(20);
    END IF;
END $$;

-- 2. Actualizar función de registro de estudiante
-- (Copiar y pegar el contenido de registrarEstudiante.sql)

-- 3. Crear función de registro de empresa  
-- (Copiar y pegar el contenido de registrarEmpresa.sql)