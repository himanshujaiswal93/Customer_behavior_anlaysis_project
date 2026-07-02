select * from customer limit 20

-- what is the total revenuve genrated by male vs female customers?
select gender , SUM(purchase_amount) as revenuve
from customer
group by gender

-- q2 which customer ussed a discount but still spent more than the average purchase amount 
select customer_id , purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount >= (select AVG(purchase_amount) from customer)

--q3 which are the top 5 products with the higesht average review rating /
select item_purchased , ROUND(AVG(review_rating::numeric),2) as " Average Product Rating "
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- q4 compare the average purchase amount between standard and experess shiping
select shipping_type, 
ROUND(AVG(purchase_amount),2)
from customer 
where shipping_type in ('Standard','Express')
group by shipping_type

-- q5 do subscribed sutmoer more / compare average spend and total revneue between subscriber and non subscribes
select subscription_status,
COUNT(customer_id) as total_customer,
ROUND(AVG(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;

--q6  which 5 proudct have the highest percentage of purchase  with discount applied
select item_purchased ,
ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;
select item_purchased ,
ROUND(100.0 * SUM(CASE WHEN discount_applied = 'yes' THEN 1 ELSE 0 END)/COUNT(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

-- q7 segment custmoer into new returning and loyal based thier total number of previous purchase and show the count of each segment 
with customer_type as (
select customer_id, previous_purchases,
CASE
WHEN previous_purchases = 1 THEN 'New'
WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
ELSE 'Loyal'
END AS customer_segment
from customer
)

select customer_segment, count(*) as "number of customer"
from customer_type
group by customer_segment

--q8 what are the top3 most purchased product within each category?
with item_counts as(
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id)desc) as item_rank
from customer
group by category, item_purchased
)

select item_rank,category,item_purchased,total_orders
from item_counts
where item_rank <= 3;

-- q9 are the customer who are reporrt buyers (more then 5 previoues purchases )also likley to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status

--q10 what is thge revenue contribution or each age group
select age_group,
SUM(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;
