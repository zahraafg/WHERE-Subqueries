CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- WHERE Subquary + (Single-row, Correlated)


/* Sual 1:

Hər departament üzrə ən yüksək maaş alan işçinin adını. */

select full_name
from Employees e
where salary = (
	select MAX(salary)
	from Employees e2
	where e.department_id = e2.department_id
	);


/* Sual 2:

Hər departament üzrə ən tez işə qəbul olunan işçinin adını. */ 

select full_name
from Employees e
where hire_date = (
	select MIN(e2.hire_date)
	from Employees e2
	where e.department_id = e2.department_id
	);


/* Sual 3:

Hər departament üzrə ən yüksək maaş alan işçinin adı və departament adı. */

select e.full_name, d.department_name
from Employees e
join Departments d
on d.id = e.department_id
where salary = (
	select MAX(salary)
	from Employees e2
	where e.department_id = e2.department_id
	);


/* Sual 4:

Hər bir şöbə üçün ən son işə götürülmüş əməkdaşın adını seç. */

select full_name
from Employees e
where hire_date = (
	select MAX(hire_date)
	from Employees e2
	where e.department_id = e2.department_id
	);


/* Sual 5:

Hər bir şöbə üçün həmin şöbədəki orta maaşdan yüksək maaş alan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary > (
	select AVG(salary)
	from Employees e2
	where e.department_id = e2.department_id
	);


/* Sual 6:

Hər bir layihədə iştirak edən əməkdaşlardan həmin layihədəki 

ən aşağı maaşdan az maaş alan əməkdaşların adlarını seç. */

select full_name 
from Employees e
where salary < (
	select MIN(e2.salary)
	from Employees e2
	join Assignments a on e2.id = a.employee_id
	join Projects p on a.project_id = p.id
	where a.project_id in (
		select a2.project_id
		from Assignments a2
		where a2.employee_id = e.id
	)
);


/* Sual 7:

Hər bir müştəri üçün ən son verilən ödənişin miqdarını seç. */

select o.total_amount
from Orders o
where total_amount = (
	select MAX(total_amount)
	from Orders o2
	where o.customer_id = o2.customer_id
	);


/* Sual 8:

Hər bir müştəri üçün həmin müştərinin bütün sifarişlərinin 

ortalama məbləğindən böyük sifarişlərin ümumi məbləğini seç. */

select total_amount
from Orders o
where total_amount > (
	select AVG(total_amount)
	from Orders o2
	where o.customer_id = o2.customer_id
	);


/* Sual 9:

Hər bir müştəri üçün ən az büdcəyə malik layihənin adını seç. */

select project_name
from Projects P 
where budget < (
	select MIN(budget)
	from Projects p2
	where p.customer_id = p2.customer_id
	);


/* Sual 10:

Hər bir şöbə üçün ən yüksək maaşa malik əməkdaşın adını seç. */

select full_name
from Employees e
where salary = (
	select MAX(salary)
	from Employees e2
	where e.department_id = e2.department_id
	);


/* Sual 11:

Hər bir şöbə üçün həmin şöbənin orta maaşından yüksək maaş alan əməkdaşların adını seç. */

select full_name
from Employees e
where salary > (
	select AVG(salary)
	from Employees e2
	where e.department_id = e2.department_id
	);


/* Sual 12:

Hər bir şöbə üçün həmin şöbənin orta maaşından aşağı maaş alan əməkdaşların adını select et. */

select full_name
from Employees e
where salary < (
	select AVG(salary)
	from Employees e2
	where e.department_id = e2.department_id
	);