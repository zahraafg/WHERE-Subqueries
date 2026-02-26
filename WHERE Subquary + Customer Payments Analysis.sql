USE IT_CompanyDB;

-- =========================================
-- Tapşırıq: Müştəri ödənişlərini analiz et
-- Şərtlər:
--   1) Ümumi sifariş məbləği şirkət ortalamasından yüksək olan müştərilər
--   2) Ən azı 2 sifariş etmiş müştərilər
--   3) Bütün sifarişləri tam ödənilmiş müştərilər
-- Nəticə: company_name, total_orders, total_revenue, payment_status
-- Ödəniş statusu: PREMIUM >2000, MEDIUM >1000, STANDARD əks halda
-- =========================================

select 
	c.company_name, 
	COUNT(o.id) as total_orders,
	SUM(o.total_amount) as total_revenue,
	case
		when SUM(o.total_amount) > 2000 then 'PREMIUM'
		when SUM(o.total_amount) > 1000 then 'MEDIUM'
		else 'STANDARD'
	end as payment_status
from Customers c
join Orders o
on c.id = o.customer_id
where c.id in (
	select o2.customer_id
	from Orders o2
	group by o2.customer_id
	having SUM(o2.total_amount) > (select AVG(total_amount) from Orders)
	)
and exists (
	select 1
	from Payments p
	join Orders o3
	on p.order_id = o3.id
	where o3.customer_id = c.id
	and p.amount = o3.total_amount
	)
group by c.company_name
having COUNT(o.id) >= 2;

-- OR

select 
	c.company_name, 
	COUNT(o.id) as total_orders,
	SUM(o.total_amount) as total_revenue,
	case
		when SUM(o.total_amount) > 2000 then 'PREMIUM'
		when SUM(o.total_amount) > 1000 then 'MEDIUM'
		else 'STANDARD'
	end as payment_status
from Customers c
join Orders o
on c.id = o.customer_id
join Payments p
on p.order_id = o.id
and p.amount = o.total_amount
join (
select 
	o2.customer_id, 
	COUNT(o2.id) as total_orders,
	SUM(o2.total_amount) as total_revenue
from Orders o2
group by o2.customer_id
having COUNT(o2.id) >= 2 
and SUM(o2.total_amount) > (select AVG(total_amount) from Orders)
) cust_stats
on o.customer_id = cust_stats.customer_id
where exists (
    select 1
    from Payments p
    where p.order_id = o.id
    and p.amount = o.total_amount
)
group by c.company_name
having COUNT(o.id) >= 2;



