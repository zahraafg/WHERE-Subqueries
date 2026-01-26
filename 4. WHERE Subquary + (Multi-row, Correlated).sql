CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- WHERE Subquary + (Multi-row, Correlated)


/* 1️. Multi-row IN

Correlated

Hər bir şöbə üçün həmin şöbədə çalışan əməkdaşların maaşları arasında 

ən azı birinin maaşı 2500-dən yüksək olan şöbələrin adlarını seç. */

select department_name
from Departments d
where id in (
select e.department_id
	from Employees e
	where d.id = e.department_id
	and e.salary > 2500
	);


/* 2️. Multi-row ANY

Correlated

Hər bir şöbə üçün maaşı həmin şöbədəki ən azı bir əməkdaşın maaşından yüksək olan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary > any (
	select e2.salary
	from Employees e2
    where e.department_id = e2.department_id
	);


/* 3️. Multi-row ALL

Correlated

Hər bir şöbə üçün maaşı həmin şöbədə çalışan bütün əməkdaşların maaşlarından yüksək olan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary > all (
	select salary
	from Employees e2
	join Departments d
	on d.id = e.department_id
	where e.department_id = e2.department_id
	);


/* 4. Multi-row IN

Correlated

Hər bir layihə üçün həmin layihədəki əməkdaşlardan 

ən azı birinin maaşı 2500-dən yüksəkdirsə, həmin layihənin adını seç. */

select p.project_name
from Projects p
where id in (
	select a.project_id
	from Assignments a
	join Employees e
	on e.id = a.employee_id
	where p.id = a.project_id
	and salary > 2500
	);


/* 5. Multi-row ANY

Correlated

Hər bir şöbə üçün maaşı həmin şöbədəki ən azı bir əməkdaşın maaşından yüksək olan əməkdaşların adını seç. */

select full_name
from Employees e
where salary > any (
	select salary
	from Employees e2
	where e.department_id = e2.department_id
	);


/* 6. Multi-row ALL

Correlated

Hər bir şöbə üçün maaşı həmin şöbədəki bütün əməkdaşların maaşından yüksək olan əməkdaşların adını seç. */

select full_name
from Employees e
where salary > all (
	select salary
	from Employees e2
	where e.department_id = e2.department_id
	);


/* 7. Multi-row IN

Correlated

Hər bir layihə üçün həmin layihədəki əməkdaşlardan ən azı birinin maaşı 2000-dən yüksəkdirsə, layihənin adını seç. */

select project_name
from Projects p
where id in (
	select a.project_id
	from Assignments a
	join Employees e
	on e.id = a.employee_id
	where p.id = a.project_id
	and salary > 2000
	);


/* 8. Multi-row ANY

Correlated

Hər bir şöbə üçün maaşı həmin şöbədəki ən azı bir əməkdaşın maaşından yüksək olan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary > any (
	select salary 
	from Employees e2
	where e.department_id = e2.department_id
	);


/* 9. Multi-row ALL

Correlated

Hər bir şöbə üçün maaşı həmin şöbədəki bütün əməkdaşların maaşından yüksək olan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary > all (
	select salary 
	from Employees e2
	where e.department_id = e2.department_id
	);