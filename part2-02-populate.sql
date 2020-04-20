--populate caers_event table
INSERT INTO caers_event(report_id, created_date, event_date, patient_age, age_unit, sex) 
(select distinct report_id, created_date, event_date, patient_age, age_unit, sex from staging_caers_event);

--populate symptom table
INSERT INTO symptom(symptom_name)
(select distinct upper(trim(unnest(string_to_array(symptom, ',')))) from staging_caers_event);

--populate report_symptom table
-- this query first creates a tmp table which comes from unnest the symptom column in staging table, then select symptom_id and report_id from the inner join of the tmp table and symptom table 
INSERT INTO report_symptom(
report_id, symptom_id)
(select report_id, symptom_id from (select caers_event_id, report_id, trim(upper(unnest(string_to_array(symptom, ',')))) as ss
from staging_caers_event) as tmp, symptom s where tmp.ss = s.symptom_name);

--populate product table
INSERT INTO product (product_code, product_name, description) 
(select distinct product_code, upper(trim(product)), description from staging_caers_event)

--populate report_product table
--first inner join product and staging_caers_event table, then retrieve required columns and insert
-- into report_product table
INSERT INTO report_product (report_id, product_id, product_type) 
(select report_id, product_id, s.product_type from staging_caers_event s inner join product p on s.product_code = p.product_code
and upper(trim(s.product)) = p.product_name)