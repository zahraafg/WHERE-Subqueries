CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- WHERE Subquery + (JOIN, Aggregation, NON+Correlated, NOT+EXISTS, CASE)


/* 📌 TASK — IT_CompanyDB üzrə kompleks sorğu

Elə departmentləri gətir ki:

həmin departmentdə çalışan işçilərin orta maaşı bütün şirkət üzrə 

orta maaşdan böyük olsun (non-correlated subquery)

departmentdə ən azı 1 işçi olsun (aggregation + having)

o departmentdə ən azı 1 nəfər aktiv projectdə işləyir (EXISTS)

o departmentdə heç bir işçi HR departamentində olmasın (NOT EXISTS + correlated)

nəticədə CASE ilə maaş səviyyəsi etiketi də göstər

Çıxışda göstər: department_name, employee_count, avg_salary, salary_level (CASE ilə) */

select 
    d.department_name,
    COUNT(distinct e.id) as emp_count,
    AVG(e.salary) as avg_salary,
    case 
        when AVG(e.salary) > 2000 then 'HIGH'
        else 'NORMAL'
    end as salary_level
from Employees e
join Departments d
on d.id = e.department_id
where e.department_id in (
    select department_id
	from Employees
	group by department_id
	having AVG(salary) > (select AVG(salary) from Employees)
	)
and exists (
   select 1
   from Assignments a
   join Projects p 
   on p.id = a.project_id
   where a.employee_id = e.id
   and p.end_date is null
    )
and not exists (
   select 1
   from Employees e2
   join Departments d2 
   on d2.id = e2.department_id
   where d2.department_name = 'HR'
   and e2.department_id = e.department_id
   )
group by d.department_name
having COUNT(distinct e.id) >= 1;


/* 📌 TASK 2 — Advanced Company Analytics

Elə customer-ləri gətir ki:

1️. O customer-in ümumi order məbləği (SUM total_amount)
bütün customer-lərin orta order məbləğindən böyük olsun
👉 (non-correlated subquery)

2️. O customer-in ən azı 1 orderi tam ödənilib
(yəni Payments cədvəlində order total_amount-a bərabər payment var)
👉 EXISTS (correlated)

3️. O customer-in heç bir gecikmiş layihəsi olmasın
(yəni Projects cədvəlində end_date < GETDATE() olan projecti olmasın)
👉 NOT EXISTS (correlated)

4️. Customer-in ən azı 2 sifarişi olsun
👉 GROUP BY + HAVING */

select c.company_name
from Customers c
join Orders o
on o.customer_id = c.id
where c.id = (
	select o2.customer_id
	from Orders o2
	group by o2.customer_id
	having SUM(o2.total_amount)  > (select SUM(total_amount) from orders )
	)
 and exists (
   select 1
   from Payments p
   where p.order_id = o.id
   and p.amount = o.total_amount
   )
and not exists (
   select 1
   from Projects pr
   where pr.customer_id = c.id
   and pr.end_date < GETDATE()
   )
group by c.company_name
having COUNT(o.id) >= 2;


/* 📌 REAL TASK 3 — HR & Performance Analizi

Şirkət HR şöbəsi belə bir analiz istəyir:

Elə departmentləri tapın ki:

Departmentdə çalışan işçilərin orta maaşı şirkət üzrə orta maaşdan yüksək olsun

Departmentdə ən çoxu 2 işçi olsun

Həmin departmentdə ən azı 1 nəfər aktiv projectdə işləsin (Projects.end_date IS NULL)

Həmin departmentdə heç bir işçi 1000-dən az maaş almasın

Nəticədə aşağıdakı məlumatlar göstərilsin: department_name, employee_count, avg_salary, salary_status

salary_status:

AVG(salary) > 2000 → 'STRONG'

əks halda → 'NORMAL' */

select 
	d.department_name,
	COUNT(distinct e.id) as emp_count,
	AVG(salary) as avg_salary,

	case
		when AVG(salary) > 2000 then 'STRONG'
		else 'NORMAL'
	end as salary_status

from Employees e
join Departments d
on d.id = e.department_id
where d.id in (
	select e.department_id
	from Employees e
	group by e.department_id
	having AVG(salary) > (select AVG(salary) from Employees)
	)
and exists (
	select 1
	from Assignments a
	join Projects p
	on a.project_id = p.id
	where a.employee_id = e.id
	and p.end_date is null
	)
and not exists (
	select 1
	from Employees  e2
	where e2.department_id = d.id
	and salary <= 1000
	)
group by d.department_name
having COUNT(distinct e.id) <= 2;


/* 📌 REAL TASK 4 — Sales Performance Analizi

Şirkət maliyyə şöbəsi belə bir analiz istəyir:

Elə customer-ləri tapın ki:

1️. Customer-in ümumi sifariş məbləği (SUM total_amount)
şirkət üzrə bütün sifarişlərin orta məbləğindən böyük olsun

2️. Customer-in ən azı 1 sifarişi tam ödənilib
(Payments.amount = Orders.total_amount)

3️. Customer-in heç bir natamam ödənişi olmasın
(yəni Orders var amma həmin order üçün uyğun payment yoxdur)

4️. Customer-in ən azı 2 sifarişi olsun

Nəticədə göstər: company_name, total_orders, total_revenue, payment_status

CASE şərti:

SUM(total_amount) > 25000 → 'PREMIUM'

əks halda → 'STANDARD' */

select 
	c.company_name,
	COUNT(o.id) as total_orders,
	SUM(o.total_amount) as total_revenue,
	case
	when SUM(total_amount) > 25000 then 'PREMIUM'
	else 'STANDARD'
	end as payment_status
from Customers c
join Orders o
on c.id = o.customer_id
where c.id in (
	select o2.customer_id
	from Orders o2
	group by o2.customer_id
	having SUM(o2.total_amount) > (select AVG(total_amount) from orders)
	)
and exists (
	select 1
	from Orders o3
	join Payments p
	on p.order_id = o3.id
	where o3.customer_id = c.id
	and p.amount = o3.total_amount
	)
and not exists (
	select 1
	from orders o4
	left join Payments p2
	on p2.order_id = o4.id
	where o4.customer_id = c.id
	and (p2.amount is null or p2.amount <> o4.total_amount)
	)
group by c.company_name
having COUNT(o.id) >= 2;


/* 📌 REAL TASK 5 — Employee Performance & Project Analysis

Şirkət rəhbərliyi belə bir analiz istəyir:

Elə departmentləri və işçiləri tapın ki:

1️. Departmentin orta maaşı şirkət üzrə orta maaşdan yüksək olsun
2️. Hər işçi ən azı 1 aktiv layihədə çalışsın (Projects.end_date IS NULL)
3️. Həmin işçinin maaşı department-in ortalama maaşının 50%-dən az olmasın
4️. Departmentdə ən azı 2 işçi olsun

Nəticədə göstər: department_name, employee_name, salary, avg_department_salary, project_count, salary_status

CASE şərti:

salary > 2 * avg_department_salary → 'TOP'

salary > avg_department_salary → 'ABOVE_AVG'

salary ≤ avg_department_salary → 'NORMAL' */

select 
	d.department_name, 
	e.full_name, 
	e.salary,
	COUNT(e.id) as emp_count,
	AVG(e.salary) as avg_salary,
	case 
		when  salary > 2 * AVG(e.salary) then 'TOP'
		when salary > AVG(e.salary) then 'ABOVE_AVG'
		else 'NORMAL'
	end as salary_status
from Employees e
join Departments d
on d.id = e.department_id
where d.id in (
	select e2.department_id
	from Employees e2
	group by e2.department_id
	having AVG(e2.salary) > (select AVG(salary) from Employees)
	)
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
