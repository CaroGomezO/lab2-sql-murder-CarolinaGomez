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


----------------------------------------------------------------------------------------------------------
-- SELECT * FROM get_fit_now_member; 
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 4. Se buscó en los registros del gimnasio la persona con id de membresía que comenzaba con 48Z 
-- y tenía una membresía gold, de acuerdo a lo dicho por el testigo Morty Schapiro.

-- Conclusión: Se encontraron dos personas que coincidían con dos características dichas 
-- por el testigo Morty Schapiro

-- Captura: paso4_reporte_gimnasio.png

SELECT * FROM get_fit_now_member 
WHERE id LIKE "48Z__" AND LOWER(membership_status) = "gold"; 
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 5. Se buscó en los registros del check in del gimnasio la persona con id de membresía que comenzaba 
-- con 48Z, tenía una membresía gold y estuvo en el gimnasio el día 9 de enero.

-- Conclusión: El resultado arrojó a las mismas dos personas que se encontraron en el paso 4

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
-- 6. Se buscó en las licencias del pueblo una que tuviera la secuencia "H42W" y cuyo 
-- dueño fuera un hombre.

-- Conclusión: El resultado arrojó dos personas, una que no estuvo en el gimnasio el 9 de enero y 
-- la otra se identificó como Jeremy Bowers

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
-- 7. Se buscó en las licencias del pueblo una que tuviera la secuencia "H42W" y cuyo 
-- dueño fuera un hombre.

-- Conclusión: El resultado arrojó dos personas, una que no estuvo en el gimnasio el 9 de enero y 
-- la otra se identificó como Jeremy Bowers

-- Captura: paso7_registro_financiero_Jeremy_Bowers.png

SELECT id, name, person.ssn, annual_income FROM person 
JOIN income
ON person.ssn = income.ssn
WHERE name = "Jeremy Bowers";
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 8. Se buscó el registro de la declaración de Jeremy Bowers para identificar si efectivamente
-- es el responsable del crimen

-- Conclusión: Jeremy Bowers es el ejecutor. Fue contratado por una mujer con mucho dinero.

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
-- 10. Teniendo en cuenta el detalle de que la mente maestra fue tres veces al SQL Symphony Concert, 
-- se procedió a buscar a la persona que cumpliera con esto y al mismo tiempo con las características 
-- físicas descritas por Jeremy

-- Conclusión: Hubo un único resultado que indica que la mente maestra posiblemente es Miranda Priestly

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
-- 11. Confirmación del asesino mediante pistas otorgadas por los testigos

-- Conclusión: Se registró a Jeremy Bowers como el asesino 

-- Captura: paso11_confirmacion_asesino.png

INSERT INTO solution VALUES (1, 'Jeremy Bowers');

SELECT value FROM solution;
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- 11. Confirmación de la mente maestra mediante pistas ortorgadas por el ejecutor Jeremy Bowers

-- Conclusión: Se registró a Miranda Priestly como la mente maestra 

-- Captura: paso12_confirmacion_mente_maestra.png

INSERT INTO solution VALUES (1, 'Miranda Priestly');

SELECT value FROM solution;
----------------------------------------------------------------------------------------------------------