/* Copy data from 'customers`table into 'persons'*/ 

INSERT INTO persons (id, person_name, birth_date, phone)
SELECT 
id,
first_name,
NULL,
'Unknow'
FROM customers

SELECT *
FROM persons 