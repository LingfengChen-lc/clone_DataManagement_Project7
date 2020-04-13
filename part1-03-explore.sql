--1. this query shows if the report_id, created_date, product_type, or product have null values
select count(*) from staging_caers_event where created_date is not null and report_id is not null 
and product is not null and product_type is not null;


--2. this query determines the relationship between the patient_age column and age_unit column
select patient_age, age_unit from staging_caers_event where age_unit is null and patient_age is not null;


--3. this query determines if the composite report_id, created_date and product uniquely determine each row
select report_id, created_date, product, count(*) as cout from staging_caers_event group by report_id, created_date, product 
having count(*) > 1 order by report_id limit 5;


--4. this query check rows with report_id equal 173066 which shows in the previous query's result contains multiple duplicate value 
select product_code, product, description from staging_caers_event where report_id = '173066';

--5. these two queries first look into groups based on report_id, then select the rows with duplicate report_id
select report_id, count(*) from staging_caers_event group by report_id limit 5;
select * from staging_caers_event where report_id = '2018-CFS-006260';