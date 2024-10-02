SELECT * FROM sql_practice.credit_card_transcations;

-- types of card type and their count 

select card_type , count( card_type) from sql_practice.credit_card_transcations group by card_type;

-- based on gender the sum of amount

select gender, sum(amount), card_type from sql_practice.credit_card_transcations group by gender, card_type;

-- based on city count

select city , count(city) from sql_practice.credit_card_transcations group by city;

-- based exp_type

select exp_type , count(exp_type) from sql_practice.credit_card_transcations group by exp_type;

-- based on year 

select transaction_date, count(transaction_date) from sql_practice.credit_card_transcations group by transaction_date;

-- 1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 

SELECT * FROM sql_practice.credit_card_transcations;

/*with cte as (select city, sum(amount) as total_spnt FROM sql_practice.credit_card_transcations group by city order by city ),
total_spent as (select sum(amount) as ttl_amt from sql_practice.credit_card_transcations) -- total credit car spends

select cte.*,round(total_spnt/ttl_amt*100,2) as percentage from cte inner join total_spent on 1=1 order by total_spnt desc limit 5 ;*/


with cte as (select city , sum(amount) as ttl_amt FROM sql_practice.credit_card_transcations group by city),
ate as (select sum(amount) as ttl_spd from sql_practice.credit_card_transcations)

select cte.*,round(ttl_amt/ttl_spd*100,2) as percentage from cte inner join ate on 1=1 order by ttl_amt desc limit 5;

-------------------------------------------------------------------------------------------------------------------------------------------

-- 2- write a query to print highest spend month and amount spent in that month for each card type

/*SELECT * FROM sql_practice.credit_card_transcations;

with cte as (select month(transaction_date) as mm ,year(transaction_date) as yy , sum(amount) as ss ,card_type FROM sql_practice.credit_card_transcations group by card_type,mm,yy order by sum(amount) desc),
ate as(select *,row_number() over( partition by card_type order by ss desc) as rn from cte )
select * from ate where rn=1;*/


-------------------------------------------------------------------------------------------------------------------------------------------

-- 3- write a query to print the transaction details(all columns from the table) for each card type when 
-- it reaches a cumulative of  1,000,000 total spends(We should have 4 rows in the o/p one for each card type)


/*SELECT * FROM sql_practice.credit_card_transcations;

with cte as (select *,sum(amount) over(partition by card_type order by transaction_id) as ss from sql_practice.credit_card_transcations),
ase as (select *,row_number() over (partition by card_type order by ss) as rk from cte where ss>=1000000 )

select * from ase where rk=1*/

--------------------------------------------------------------------------------------------------------------------------------------------

-- 4- write a query to find city which had lowest percentage spend for gold card type

SELECT * FROM sql_practice.credit_card_transcations;

with cte as (select city,sum(amount),card_type as ttl_spd  from sql_practice.credit_card_transcations where card_type='Gold' group by city,card_type),
ate as (select sum(amount) as ttl_amt from sql_practice.credit_card_transcations ),
dtt as (select round((c.ttl_spd/a.ttl_amt)*100,2) as perc from ate a , cte c )

select c.city , min(d.perc) from cte c , dtt d group by city ;


---------------------------------------------------------------------------------------------------------------------------------


-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)

SELECT * FROM sql_practice.credit_card_transcations;

with cte as (select city , exp_type , sum(amount), dense_rank() over(partition by city order by sum(amount) desc) as dk 
from sql_practice.credit_card_transcations group by city , exp_type ),
ate as (select city , exp_type , sum(amount), dense_rank() over(partition by city order by sum(amount) asc) as rdk 
 from sql_practice.credit_card_transcations group by city , exp_type )

select c.city , c.exp_type , a.exp_type from cte c inner join ate a on c.city=a.city where dk=1 and rdk=1;

-------------------------------------------------------------------------------------------------------------------------------

--  write a query to find percentage contribution of spends by females for each expense type

SELECT * FROM sql_practice.credit_card_transcations;

with cte as(select sum(amount) as ss , exp_type from sql_practice.credit_card_transcations where gender='F' group by exp_type),
ate as(select sum(amount) as tt from sql_practice.credit_card_transcations)

select round((c.ss/a.tt *100 ),2) as tp , c.exp_type from cte c , ate a;


-----------------------------------------------------------------------------------------------------------------------------

-- 8- during weekends which city has highest total spend to total no of transcations ratio 

SELECT * FROM sql_practice.credit_card_transcations;

select city , sum(amount)*0.1/count(1) as ratio from sql_practice.credit_card_transcations where 
dayname(transaction_date) in ('Saturday','Sunday') group by city order by ratio desc limit 1;

-------------------------------------------------------------------------------------------------------------------------------

-- 10- which city took least number of days to reach its 500th transaction after the first transaction in that city

SELECT * FROM sql_practice.credit_card_transcations;


select city , count(transaction_date) from sql_practice.credit_card_transcations group by city;

with cte as (select city , dense_rank() over(partition by city order by transaction_date) as rk from sql_practice.credit_card_transcations 
),
ate as (select city as hh ,rk  from cte where rk=500 group by city)

select a.hh ,count(c.rk) , row_number() over(order by count(c.rk))  from ate a, cte c where a.hh=c.city and c.rk between 1 and 500 group by a.hh 







