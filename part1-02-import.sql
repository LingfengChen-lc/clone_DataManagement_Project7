copy staging_caers_event (
    report_id, created_date, event_date,
    product_type, product, product_code, description,
    patient_age, age_unit,
    sex, symptom, outcome)
    from 'path/to/CAERSASCII 2014-20190331.csv'
    (format csv, header, encoding 'LATIN1');