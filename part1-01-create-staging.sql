DROP TABLE IF EXISTS staging_caers_event;

CREATE TABLE staging_caers_event (
    caers_event_id serial primary key,
    report_id int,
    created_date date,
    event_date date,
    product_type text,
    product text,
    product_code smallint,
    description text,
    patient_age smallint,
    age_unit text,
    sex varchar(1),
    symptom text,
    outcome text
);
