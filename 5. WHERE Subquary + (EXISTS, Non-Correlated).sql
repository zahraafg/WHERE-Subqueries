CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- WHERE Subquary + (EXISTS, Non-Correlated)


/* 1️. EXISTS – Non-correlated

Şirkətdə maaşı 4000-dən yüksək olan ən azı bir əməkdaş varsa, bütün şöbələrin adlarını seç. */

select department_name
from Departments d
where exists (
	select 1
	from Employees e
	where salary > 4000
	);


/* 2️. NOT EXISTS – Non-correlated

Əgər heç bir əməkdaş 1000-dən aşağı maaş almırsa, bütün layihələrin adlarını seç. */

select project_name
from Projects p
where not exists (
	select 1
	from Employees e
    where salary < 1000
	);


/* 3. EXISTS Non-Correlated

Əgər şirkətdə ən azı 1 əməkdaş varsa, bütün şöbələrin adlarını seç. */

select department_name
from Departments d
where exists (
	select 1
	from Employees
	);


/* 4. NOT EXISTS Non-Correlated

Əgər şirkətdə heç bir əməkdaş yoxdursa, bütün layihələrin adlarını seç. */

select project_name
from Projects p
where not exists (
	select 1
	from Employees
	);