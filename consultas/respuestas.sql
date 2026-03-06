----------------------------------------------------------------------------------------------------------
-- 1. Se identificaron todos los reportes de incidentes registrados en SQL City el 15 de enero de 2018.

-- Conclusión: Se encontraron dos testigos del asesinato.

-- Captura: paso1_reporte.png

SELECT * FROM crime_scene_report 
WHERE date = 20180115 AND LOWER(city) = "sql city";
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- SELECT * FROM person WHERE address_street_name = "Northwestern Dr";
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 2. Se identificó el primer testigo ordenando las direcciones de la calle Northwestern Dr
-- de mayor a menor y se seleccionó únicamente el primer resultado.

-- Conclusión: Se descubrió que el sospechoso era un hombre que llevaba una bolsa del 
-- gimnasio Get Fit Now Gym, tenía un número de membresía que comenzaba con "48Z" y se subió 
-- a un auto que contenía la secuencia "H42W".

-- Captura: paso2_testigo_Northwestern_Dr.png

SELECT id, name, transcript, address_number FROM person 
JOIN interview 
ON person.id = interview.person_id
WHERE address_street_name = "Northwestern Dr" 
ORDER BY address_number DESC LIMIT 1;
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 3. Se identificó el segundo testigo del crimen: una persona llamada Annabel que vivía en Franklin Ave.

-- Conclusión: Mediante la declaración de Annabel, se confirmó que el sospechoso
-- tenía un vínculo con el gimnasio Get Fit Now Gym

-- Captura: paso3_testigo_Annabel_Franklin_Ave.png

SELECT id, name, address_street_name, transcript FROM person 
JOIN interview 
ON person.id = interview.person_id
WHERE name LIKE "%Annabel%" AND address_street_name = "Franklin Ave";
----------------------------------------------------------------------------------------------------------