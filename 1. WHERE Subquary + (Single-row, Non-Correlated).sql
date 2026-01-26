CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- WHERE Subquary + (Single-row, Non-Correlated)


/* Sual 1:

Ən yüksək maaş alan işçinin adını. */

select full_name
from Employees e
where salary = (
	select MAX(salary)
	from Employees e
	);


/* Sual 2: 

Ən tez işə qəbul olunan (ilk hire_date olan) işçinin adını. */

select full_name, hire_date
from Employees e
where hire_date = (
	select MIN(hire_date)
	from Employees e
	);


/* Sual 3: 

ən yüksək maaşı olan əməkdaşın adını seç. */

select full_name
from Employees e
where salary = (
	select MAX(salary)
	from Employees e
	);


/* Sual 4: 

Maaşı 2000-dən yüksək olan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary > (
	select MIN(salary)
	from Employees e
	where salary > 2000
	);

--OR
select full_name
from Employees e
where salary > 2000;


/* Sual 5: 

Maaşı 1500-dən aşağı olan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary < (
	select MIN(salary)
	from Employees e
	where salary > 1500
	);

--OR

select full_name
from Employees e
where salary < 1500;


/* Sual 6: 

ən yüksək büdcəyə malik layihənin adını seç. */

select p.project_name
from Projects p
where budget = (
	select MAX(budget)
	from Projects p
	);


/* Sual 7: 

20000-dən böyük olan sifarişlərin ümumi məbləğini seç. */

select total_amount
from Orders o
where total_amount = (
	select MIN(total_amount)
	from Orders o
	where total_amount > 20000
	);

--OR
select total_amount
from Orders o
where o.total_amount > 20000;


/* Sual 8: 

15000-dən az olan ödənişlərin miqdarını seç. */

select total_amount
from Orders o
where total_amount = (
	select MIN(total_amount)
	from Orders o
	where total_amount < 15000
	);

--OR
select total_amount
from Orders o
where o.total_amount < 15000;


/* Sual 9: 

Ən yüksək maaşa malik əməkdaşın adını seç. */

select full_name
from Employees e
where salary = (
	select MAX(salary)
	from Employees e
	);


/* Sual 10: 

Maaşı şirkət üzrə orta maaşdan yüksək olan əməkdaşların adını seç. */

select full_name
from Employees e
where salary > (
	select AVG(salary)
	from Employees e
	);


/* Sual 11: 

Maaşı şirkət üzrə orta maaşdan aşağı olan əməkdaşların adını seç. */

select full_name
from Employees e
where salary < (
	select AVG(salary)
	from Employees e
	);


