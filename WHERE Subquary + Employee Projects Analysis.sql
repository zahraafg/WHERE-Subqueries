USE IT_CompanyDB;

-- =========================================
-- Tapşırıq: Aktiv layihələrdə iştirak edən və 
-- maaşı department ortalamasından yüksək işçiləri seç.
-- Şərtlər:
-- 1) Ən azı 2 aktiv layihə (end_date IS NULL)
-- 2) Maaş > department ortalaması
-- 3) Department-də minimum 2 işçi
-- Nəticə: department_name, full_name, salary, avg_department_salary, project_count, salary_status
-- Status: TOP (>2x avg), ABOVE_AVG (>avg), NORMAL
-- =========================================

select 
	d.department_name, 
	e.full_name, 
	e.salary,
	AVG(salary) as avg_salary,
	COUNT(e.id) as emp_count,
	case
		when salary > 2 * AVG(salary) then 'TOP'
		when salary > AVG(salary) then 'ABOVE_AVG'
		else 'NORMAL'
	end as salary_status
from Employees e
join Departments d
on d.id = e.department_id
where exists (
	select 1
	from Assignments a
	join Projects p
	on p.id = a.project_id
	where a.employee_id = e.id
	and p.end_date is null
	)
and d.id in (
	select e2.department_id
	from Employees e2
	group by e2.department_id
	having AVG(salary) > (select AVG(salary) from Employees)
)
group by d.department_name, e.full_name, e.salary
having COUNT(e.id) >= 2;

--OR

select 
	d.department_name, 
	e.full_name, 
	e.salary,
	AVG(salary) as avg_salary,
	COUNT(e.id) as emp_count,
	case
		when salary > 2 * AVG(salary) then 'TOP'
		when salary > AVG(salary) then 'ABOVE_AVG'
		else 'NORMAL'
	end as salary_status
from Employees e
join Departments d
on d.id = e.department_id
join (
	select e2.department_id
	from Employees e2
	group by e2.department_id
	having AVG(salary) > (select AVG(salary) from Employees)
) sub
on e.department_id = sub.department_id
and exists (
	select 1
	from Assignments a
	join Projects p
	on p.id = a.project_id
	where a.employee_id = e.id
	and p.end_date is null
	)
group by d.department_name, e.full_name, e.salary
having COUNT(e.id) >= 2;