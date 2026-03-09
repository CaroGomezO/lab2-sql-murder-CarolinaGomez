----------------------------------------------------------------------------------------------------------
-- 1. Se identificaron los reportes de crímenes registrados en SQL City el 15 de enero de 2018.

-- Conclusión: Se encontró el reporte del asesinato y se identificaron dos testigos que podrían
-- aportar información clave para la investigación.

-- Captura: paso1_reporte.png

SELECT * FROM crime_scene_report 
WHERE date = 20180115 AND LOWER(city) = "sql city";
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- SELECT * FROM person WHERE address_street_name = "Northwestern Dr";
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 2. Se identificó al primer testigo consultando las personas que viven en Northwestern Dr, ordenando
-- las direcciones de mayor a menor y seleccionando la primera casa que aparecía luego del ordenamiento
-- para así encontrar a la persona que vive en la última casa de la calle.

-- Conclusión: El testigo indicó que el sospechoso llevaba una bolsa del gimnasio Get Fit Now Gym, tenía
-- un número de membresía que comenzaba con "48Z" y escapó en un vehículo cuya placa contenía la
-- secuencia "H42W".

-- Captura: paso2_testigo_Northwestern_Dr.png

SELECT id, name, transcript, address_number FROM person 
JOIN interview 
ON person.id = interview.person_id
WHERE address_street_name = "Northwestern Dr" 
ORDER BY address_number DESC LIMIT 1;
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 3. Se identificó el segundo testigo del crimen, una persona llamada Annabel que vive en Franklin Ave.

-- Conclusión: Annabel declaró haber visto al sospechoso en el gimnasio Get Fit Now Gym días antes
-- del asesinato.

-- Captura: paso3_testigo_Annabel_Franklin_Ave.png

SELECT id, name, address_street_name, transcript FROM person 
JOIN interview 
ON person.id = interview.person_id
WHERE name LIKE "%Annabel%" AND address_street_name = "Franklin Ave";
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- SELECT * FROM get_fit_now_member; 
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 4. Se buscaron en los registros del gimnasio los miembros cuya membresía comenzara con "48Z" y
-- cuyo estado fuera "gold", de acuerdo con la descripción dada por el testigo.

-- Conclusión: Se encontraron dos posibles sospechosos que cumplían con las características mencionadas.

-- Captura: paso4_reporte_gimnasio.png

SELECT * FROM get_fit_now_member 
WHERE id LIKE "48Z__" AND LOWER(membership_status) = "gold"; 
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 5. Se revisaron los registros de entrada al gimnasio para determinar qué miembros tienen membresía que
-- comienza con "48Z", tienen estado "gold" y estuvieron presentes en el gimnasio el 9 de enero de 2018, 
-- fecha mencionada por el segundo testigo.

-- Conclusión: Ambos sospechosos, obtenidos en la consulta anterior, estuvieron en el gimnasio ese día,
-- por lo que ninguno pudo ser descartado todavía.

-- Captura: paso5_check_in_gimnasio.png

SELECT membership_id, membership_status, name, check_in_date, check_in_time, check_out_time 
FROM get_fit_now_check_in 
JOIN get_fit_now_member
ON get_fit_now_check_in.membership_id = get_fit_now_member.id
WHERE id LIKE "48Z__" 
AND LOWER(membership_status) = "gold" 
AND check_in_date = 20180109; 
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 6. Se investigaron los registros de licencias de conducir buscando vehículos cuya 
-- placa contuviera la secuencia "H42W" y cuyo propietario fuera un hombre.

-- Conclusión: Se encontraron dos personas. Al cruzar esta información con los registros del gimnasio, 
-- uno de ellos fue descartado y el sospechoso restante fue identificado como Jeremy Bowers.

-- Captura: paso6_reporte_matricula_auto.png

SELECT license_id, plate_number, name, age, height, eye_color, hair_color,
plate_number, car_make, car_model 
FROM drivers_license
JOIN person
ON drivers_license.id = person.license_id
WHERE plate_number LIKE ("%H42W%") AND LOWER(gender) = "male"; 
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- SELECT name FROM get_fit_now_check_in 
-- JOIN get_fit_now_member
-- ON get_fit_now_check_in.membership_id = get_fit_now_member.id
-- WHERE check_in_date = 20180109;
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 7. Se consultaron los registros financieros de Jeremy Bowers con el fin de
-- conocer su situación económica y evaluar si podría existir un posible motivo
-- relacionado con dinero.

-- Conclusión: Se encontró que sus ingresos anuales eran relativamente bajos, lo que podría
-- indicar que, si cometió el crimen, aceptó hacerlo a cambio de dinero.

-- Captura: paso7_registro_financiero_Jeremy_Bowers.png

SELECT id, name, person.ssn, annual_income FROM person 
JOIN income
ON person.ssn = income.ssn
WHERE name = "Jeremy Bowers";
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 8. Se revisó la declaración de Jeremy Bowers para confirmar su participación en el crimen.

-- Conclusión: Jeremy confesó ser el ejecutor del asesinato y declaró haber sido contratado
-- por una mujer con mucho dinero.

-- Captura: paso8_confesion_del_ejecutor.png

SELECT id, name, transcript FROM person 
JOIN interview
ON person.id = interview.person_id
WHERE name = "Jeremy Bowers";
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- SELECT COUNT(id) FROM drivers_license;
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 9. A partir de la descripción dada por Jeremy, se buscó en las licencias de conducir 
-- mujeres con cabello rojo, estatura entre 65 y 67 pulgadas y que condujeran un Tesla Model S.

-- Conclusión: Se encontraron tres posibles candidatas que coincidían con la descripción
-- de la posible mente maestra.

-- Captura: paso9_posibles_sospechosos_intelectuales.png

SELECT drivers_license.id, name, gender, age, height, hair_color, car_make, car_model 
FROM drivers_license 
JOIN person
ON drivers_license.id = person.license_id
WHERE LOWER(gender) = "female" AND LOWER(hair_color) = "red"
AND car_make = "Tesla" AND car_model = "Model S" 
AND height BETWEEN 65 AND 67;
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 10. Considerando que la mente maestra asistió tres veces al SQL Symphony Concert en 
-- diciembre de 2017, se buscaron las persoans que cumplieran con ese patrón de asistencia.

-- Conclusión: Se obtuvo un único resultado: Miranda Priestly, quien además posee altos
-- ingresos, lo que coincide con la descripción dada por Jeremy.

-- Captura: paso10_identificacion_mente_maestra.png

SELECT person_id, name, annual_income, COUNT(*) AS veces_concierto 
FROM facebook_event_checkin JOIN person
ON facebook_event_checkin.person_id = person.id
JOIN income
ON person.ssn = income.ssn
WHERE event_name = "SQL Symphony Concert" 
AND date LIKE "201712%"
GROUP BY person_id, name, annual_income 
HAVING COUNT(*) = 3;
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 11. Confirmación del asesino mediante el sistema de verificación.

-- Conclusión: Se confirmó oficialmente que Jeremy Bowers es el asesino.

-- Captura: paso11_confirmacion_asesino.png

INSERT INTO solution VALUES (1, 'Jeremy Bowers');

SELECT value FROM solution;
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 12. Confirmación de la mente maestra del crimen mediante el sistema de verificación.

-- Conclusión: Se confirmó oficialmente que Miranda Priestly es la autora intelectual del asesinato.

-- Captura: paso12_confirmacion_mente_maestra.png

INSERT INTO solution VALUES (1, 'Miranda Priestly');

SELECT value FROM solution;
----------------------------------------------------------------------------------------------------------