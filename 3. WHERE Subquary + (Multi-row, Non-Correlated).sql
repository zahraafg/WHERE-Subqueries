CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- WHERE Subquary + (Multi-row, Non-Correlated)


/* 1️. Multi-row IN

Non-correlated

Maaşı 2000-dən yüksək olan əməkdaşların çalışdığı şöbələrin adlarını seç. */

select department_name
from Departments d
where id in (
	select e.department_id
	from Employees e
	where salary > 2000
	);


/* 2️. Multi-row ANY

Non-correlated

Maaşı ən azı bir DevOps şöbəsində çalışan əməkdaşın maaşından yüksək olan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary > any (
	select e2.salary
	from Employees e2
	where e2.department_id = (
		select d.id
		from Departments d
		where d.department_name = 'DevOps'
		)
	);


/* 3️. Multi-row ALL

Non-correlated

Maaşı QA şöbəsində çalışan bütün əməkdaşların maaşlarından yüksək olan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary > all (
	select salary
	from Employees e2
	join Departments d
	on d.id = e.department_id
	where department_name = 'QA'
	);


/* 4. Multi-row IN

Non-correlated

2000-dən yüksək maaş alan əməkdaşların işlədiyi layihələrin adlarını seç. */

select p.project_name
from Projects p
where id in (
	select a.project_id
	from Assignments a
	join Employees e
	on e.id = a.employee_id
	where salary > 2000
	);


/* 5. Multi-row ANY

Non-correlated

Maaşı ən azı bir Frontend şöbəsində çalışan əməkdaşın maaşından yüksək olan əməkdaşların adını seç. */

select full_name
from Employees e
where salary > any (
	select salary
	from Employees e
	join Departments d
	on d.id = e.department_id
	where d.department_name = 'Frontend'
	);


/* 6. Multi-row ALL

Non-correlated

Maaşı DevOps şöbəsində çalışan bütün əməkdaşların maaşından yüksək olan əməkdaşların adını seç. */

select full_name
from Employees e
where salary > all (
	select salary
	from Employees e
	join Departments d
	on d.id = e.department_id
	where d.department_name = 'DevOps'
	);


/* 7. Multi-row IN

Non-correlated

2024-cü il ərzində işə götürülmüş əməkdaşların çalışdığı layihələrin adlarını seç. */

select project_name
from Projects p
where id in (
	select a.project_id
	from Assignments a
	join Employees e
	on e.id = a.employee_id
	where year(hire_date) = 2024
	);


/* 8. Multi-row ANY

Non-correlated

Maaşı ən azı bir Junior Developer-in maaşından yüksək olan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary > any (
	select salary 
	from Employees e
	join Positions p
	on p.id = e.position_id
	where p.position_name = 'Junior Developer'
	);


/* 9. Multi-row ALL

Non-correlated

Maaşı QA və ya Frontend şöbələrində çalışan bütün əməkdaşların maaşından yüksək olan əməkdaşların adlarını seç. */

select full_name
from Employees e
where salary > all (
	select salary 
	from Employees e
	join Departments d
	on d.id = e.department_id
	where d.department_name in ('QA', 'Frontend')
	);





