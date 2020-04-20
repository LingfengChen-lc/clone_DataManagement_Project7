DROP TABLE IF EXISTS staging_caers_event;

CREATE TABLE staging_caers_event (
    caers_event_id serial primary key,
    report_id text,
    created_date date,
    event_date date,
    product_type text,
    product text,
    product_code text,
    description text,
    patient_age smallint,
    age_unit text,
    sex text,
    symptom text,
    outcome text
);
