/* CREATE */

/* Insert new patient */
INSERT INTO PATIENTS (first_name, last_name, birthdate, email, phone, primary_doctor, primary_location) VALUES (?,?,?,?,?,?,?)

/* Insert new doctor */
INSERT INTO DOCTORS (title, first_name, last_name, degree) VALUES (?,?,?,?)

/* Insert new location */
INSERT INTO LOCATIONS (label, street1, street2, city, state, zip, phone) VALUES (?,?,?,?,?,?,?);

/* Insert new appointment */
INSERT INTO APPOINTMENTS (doctor_id, location_id, time, year, month, day, day_of_week) VALUES (?,?,?,?,?,?,?);





/* READ */

/* Get open appointment slots on a particular date */
SELECT appointment_id AS id, time FROM APPOINTMENTS WHERE patient_id IS NULL AND doctor_id = ? AND location_id = ? AND year = ? AND month = ? AND day = ?;

/* Get dates where there are open appointment slots */
SELECT DOCTORS.doctor_id AS did, DOCTORS.title AS dtitle, DOCTORS.first_name AS dfname, DOCTORS.last_name AS dlname, LOCATIONS.location_id AS lid, LOCATIONS.label AS location FROM PATIENTS
JOIN DOCTORS ON PATIENTS.primary_doctor = DOCTORS.doctor_id AND PATIENTS.patient_id = ?
JOIN LOCATIONS ON PATIENTS.primary_location = LOCATIONS.location_id AND PATIENTS.patient_id = ?;
SELECT year, month, day FROM APPOINTMENTS WHERE patient_id IS NULL AND doctor_id = ? AND location_id = ? GROUP BY month, day;

/* Get patients who have a primary doctor and location assigned */
SELECT patient_id, first_name, last_name FROM PATIENTS WHERE primary_doctor IS NOT NULL AND primary_location IS NOT NULL;

/* Get details of a particular scheduled appointment */
SELECT PATIENTS.patient_id AS pid, PATIENTS.first_name AS pfname, PATIENTS.last_name AS plname, year, month, day, time, day_of_week,
title AS dtitle, DOCTORS.first_name AS dfname, DOCTORS.last_name AS dlname, label AS location FROM APPOINTMENTS
JOIN PATIENTS ON APPOINTMENTS.patient_id = PATIENTS.patient_id
JOIN DOCTORS ON APPOINTMENTS.doctor_id = DOCTORS.doctor_id
JOIN LOCATIONS ON APPOINTMENTS.location_id = LOCATIONS.location_id
WHERE appointment_id = ?;

/* Get list of patients */
SELECT patient_id AS id, CONCAT(first_name, " ", last_name) AS name FROM PATIENTS;

/* Get list of doctors */
SELECT doctor_id, CONCAT(title, " ", first_name, " ", last_name) AS name FROM DOCTORS;

/* Get list of locations */
SELECT location_id, label FROM LOCATIONS;

/* Get list of appointments */
SELECT appointment_id AS id, day_of_week, month, CONCAT(" ", day, ", ", year) AS header, time, APPOINTMENTS.patient_id AS booked,
APPOINTMENTS.doctor_id AS doc, CONCAT(title, " ", first_name, " ", last_name) AS doctor_name, APPOINTMENTS.location_id AS loc, label FROM APPOINTMENTS
JOIN DOCTORS ON APPOINTMENTS.doctor_id = DOCTORS.doctor_id AND APPOINTMENTS.doctor_id = ?
JOIN LOCATIONS ON APPOINTMENTS.location_id = LOCATIONS.location_id AND APPOINTMENTS.location_id = ?
ORDER BY loc, doc, id ASC;

/* Get details of a particular patient */
SELECT patient_id, first_name, last_name, birthdate, email, phone FROM PATIENTS WHERE patient_id = ?;

/* Get details of a particular doctor */
SELECT doctor_id, title, first_name, last_name, degree FROM DOCTORS WHERE doctor_id = ?;

/* Get details of a particular location */
SELECT location_id, label, street1, street2, city, state, zip, phone FROM LOCATIONS WHERE location_id = ?;

/* Get details of a particular appointment */
SELECT appointment_id, time, year, month, day FROM APPOINTMENTS WHERE appointment_id = ?;

/* Get list of appointments scheduled by a particular patient */
SELECT PATIENTS.patient_id AS pid, CONCAT(PATIENTS.first_name, " ", PATIENTS.last_name) AS name, birthdate, email, PATIENTS.phone AS phone,
CONCAT(title, " ", DOCTORS.first_name, " ", DOCTORS.last_name) AS doc, label AS loc,
appointment_id AS aid, day_of_week, month, CONCAT(" ", day, ", ", year) AS header, time, chief_complaint AS reason FROM PATIENTS
JOIN DOCTORS ON PATIENTS.primary_doctor = DOCTORS.doctor_id
JOIN LOCATIONS ON PATIENTS.primary_location = LOCATIONS.location_id
LEFT JOIN APPOINTMENTS ON PATIENTS.patient_id = APPOINTMENTS.patient_id
WHERE PATIENTS.patient_id = ?;

/* Get list of doctors who work at each location */
SELECT DOCTORS.doctor_id AS id, title, first_name, last_name, degree, label FROM DOCTORS
JOIN DOCTORS_LOCATIONS ON DOCTORS.doctor_id = DOCTORS_LOCATIONS.doctor_id
JOIN LOCATIONS ON DOCTORS_LOCATIONS.location_id = LOCATIONS.location_id ORDER BY id ASC;

/* Get list of locations who have each doctor on-site */
SELECT LOCATIONS.location_id AS id, label, street1, street2, city, state, zip, phone, title, first_name, last_name FROM LOCATIONS
JOIN DOCTORS_LOCATIONS ON LOCATIONS.location_id = DOCTORS_LOCATIONS.location_id
JOIN DOCTORS ON DOCTORS_LOCATIONS.doctor_id = DOCTORS.doctor_id ORDER BY id ASC;

/* Get list of locations who have a particular doctor on-site */
SELECT LOCATIONS.location_id AS id, label FROM LOCATIONS
JOIN DOCTORS_LOCATIONS ON LOCATIONS.location_id = DOCTORS_LOCATIONS.location_id
JOIN DOCTORS ON DOCTORS_LOCATIONS.doctor_id = DOCTORS.doctor_id AND DOCTORS.doctor_id = ?
ORDER BY id ASC;

/* Get list of doctors who work at a particular location */
SELECT DOCTORS.doctor_id AS id, CONCAT(title, " ", first_name, " ", last_name) AS name FROM DOCTORS
JOIN DOCTORS_LOCATIONS ON DOCTORS.doctor_id = DOCTORS_LOCATIONS.doctor_id
JOIN LOCATIONS ON DOCTORS_LOCATIONS.location_id = LOCATIONS.location_id AND LOCATIONS.location_id = ?
ORDER BY id ASC;





/* UPDATE */

/* Schedule appointment */
UPDATE APPOINTMENTS SET patient_id = ?, chief_complaint = ? WHERE appointment_id = ?;

/* Cancel ("un-schedule") appointment */
UPDATE APPOINTMENTS SET patient_id = NULL, chief_complaint = NULL WHERE appointment_id = ?;





/* DELETE */

/* Delete patient */
DELETE FROM PATIENTS WHERE patient_id = ?;

/* Delete doctor */
DELETE FROM DOCTORS WHERE doctor_id = ?;
DELETE FROM DOCTORS_LOCATIONS WHERE doctor_id = ?;

/* Delete location */
DELETE FROM LOCATIONS WHERE location_id = ?;
DELETE FROM DOCTORS_LOCATIONS WHERE location_id = ?;

/* Delete appointment */
DELETE FROM APPOINTMENTS WHERE appointment_id = ?;