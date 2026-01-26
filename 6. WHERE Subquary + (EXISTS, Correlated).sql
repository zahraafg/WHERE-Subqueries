CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- WHERE Subquary + (EXISTS, Correlated)


/* 1. EXISTS – Correlated

Ən azı bir əməkdaşı olan şöbələrin adlarını seç. */

select department_name
from Departments d
where exists (
	select 1 
	from Employees e
	where e.department_id = d.id
	);


/* 2. NOT EXISTS – Correlated

Heç bir əməkdaşı olmayan şöbələrin adlarını seç. */

select department_name
from Departments d
where not exists (
	select 1
	from Employees e
	where e.department_id = d.id
	);


/* 3. EXISTS – Correlated (JOIN əvəzi tip)

Ən azı bir əməkdaşı layihəyə təyin olunmuş layihələrin adlarını seç. */

select project_name
from Projects p
where exists (
	select 1
	from Assignments a
	join Employees e
	on e.id = a.employee_id
	where p.id = a.project_id
	);


/* 4. NOT EXISTS – Correlated 

Heç bir layihədə iştirak etməyən əməkdaşların adlarını seç. */

select full_name
from Employees e
where not exists(
	select 1
	from Assignments a
	where e.id = a.employee_id
	);


/* 5. EXISTS Correlated

Hər bir şöbə üçün ən azı bir əməkdaşı olan şöbələrin adlarını seç. */

select department_name
from Departments d
where exists (
	select 1
	from Employees e
	where d.id = e.department_id
	);


/* 6. NOT EXISTS Correlated

Hər bir layihə üçün heç bir əməkdaşı olmayan layihələrin adlarını seç. */

select project_name
from Projects p
where not exists (
	select 1
	from Assignments a
	where p.id = a.project_id
	);


/* 7. EXISTS Correlated + Şərt

Hər bir müştəri üçün ən azı bir sifariş vermiş müştərinin adını seç. */

select company_name
from Customers c
where exists (
	select 1
	from Orders o
	where o.customer_id = c.id
	);


/* 8. NOT EXISTS Correlated + Şərt

Hər bir müştəri üçün heç bir sifariş verməmiş müştərinin adını seç. */

select company_name
from Customers c
where not exists (
	select 1
	from Orders o
	where o.customer_id = c.id
	);