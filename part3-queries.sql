-- 1. This query returns the report id and product named 'FISH OIL' with 'suspect' product type 
select c.report_id, p.product_name from caers_event c, report_product r, product p 
where c.report_id = r.report_id and r.product_id = p.product_id and p.product_name = 'FISH OIL' and r.product_type = 'SUSPECT';

EXPLAIN select c.report_id, p.product_name from caers_event c, report_product r, product p 
where c.report_id = r.report_id and r.product_id = p.product_id and p.product_name = 'FISH OIL' and r.product_type = 'SUSPECT';

EXPLAIN ANALYZE select c.report_id, p.product_name from caers_event c, report_product r, product p 
where c.report_id = r.report_id and r.product_id = p.product_id and p.product_name = 'FISH OIL' and r.product_type = 'SUSPECT';

CREATE INDEX product_index on report_product(product_id);

-- 2. this query creates a view combine caers_event, product, and symptom entities
create or replace view caers_event_view as
select c.report_id, c.created_date, c.event_date, c.patient_age, c.age_unit, 
p.product_name, p.product_code, p.description, rp.product_type, s.symptom_name 
from caers_event c, product p, report_product rp, symptom s, report_symptom rs 
where c.report_id = rp.report_id and rp.product_id = p.product_id and c.report_id = rs.report_id 
and rs.symptom_id = s.symptom_id;

-- 3. General query
-- 3.1 
select product_name, patient_age, age_unit from caers_event_view where product_name ilike '%yogurt%' and age_unit ilike 'year(s)'
order by patient_age desc limit 5;

-- 3.2
select distinct product_name, product_code from caers_event_view where symptom_name ilike '%nightmare%' limit 5;

--3.3
select report_id, string_agg(symptom_name, ', ') from report_symptom rs inner join symptom s on rs.symptom_id = s.symptom_id group by report_id limit 5;

-- 3.4
select distinct event_date, report_id, product_name from caers_event_view where date_part('year', event_date) = 2013 and
date_part('month', event_date) = 9 order by report_id limit 5;

--3.5
select created_date from caers_event order by created_date desc limit 1;

select c.report_id, p.product_name, c.created_date from caers_event c, product p, report_product rp where c.report_id = rp.report_id and rp.product_id = p.product_id and c.created_date = '2019-03-30';
