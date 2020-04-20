DROP TABLE IF EXISTS caers_event;

CREATE TABLE caers_event (
    report_id text primary key,
    created_date date,
    event_date date,
    patient_age int,
    age_unit text,
    sex text
);

DROP TABLE IF EXISTS symptom;

CREATE TABLE symptom (
    symptom_id serial primary key,
    symptom_name text not null
);

DROP TABLE IF EXISTS report_symptom;

CREATE TABLE report_symptom (
    report_id text references caers_event (report_id),
    symptom_id int references symptom (symptom_id)
);


DROP TABLE IF EXISTS product;

CREATE TABLE product (
    product_id serial primary key,
    product_code text, 
    product_name text,
    description text,
    UNIQUE(product_code, product_name)
);

DROP TABLE IF EXISTS report_product;

CREATE TABLE report_product (
    report_id text references caers_event (report_id),
    product_id int references product (product_id),
    product_type text
);


-- DROP TABLE IF EXISTS outcome;

-- CREATE TABLE outcome (
--     outcome_id serial primary key,
--     outcome_name text
-- );

-- DROP TABLE IF EXISTS report_outcome;

-- CREATE TABLE report_outcome (
--     report_id text references caers_event (report_id),
--     outcome_id int references outcome (outcome_id),
-- );