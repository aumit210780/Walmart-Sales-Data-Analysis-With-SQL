# Create Database 
create database if not exists walmart;
use walmart;

# Create the table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

select * from sales;

## Feature Engineering ##
# Time of the day

select time,
       (CASE
        when `time` between '00:00:00' and '12:00:00' then 'Morning'
        when `time` between '12:01:00' and '16:00:00' then 'Afternoon'
        else 'Evening'
        END
        )as time_of_date
	from sales;
        
alter table sales add column time_of_the_day varchar(20);
update sales
set time_of_the_day = (
        CASE
        when `time` between '00:00:00' and '12:00:00' then 'Morning'
        when `time` between '12:01:00' and '16:00:00' then 'Afternoon'
        else 'Evening'
        END

);

# Day Name

select
 date, dayname(date) as day_name
from
 sales;
 
 
alter table sales add column day_name varchar(10);
update sales
set day_name = dayname(date);

ALTER TABLE sales
DROP COLUMN day_name_1;

# Month Name
select
 date, monthname(date)
from
 sales;

ALTER TABLE sales
DROP COLUMN month_name_1;

ALTER TABLE sales
DROP COLUMN month_name_2;
ALTER TABLE sales
DROP COLUMN month_name_3;
ALTER TABLE sales
DROP COLUMN month_name;
alter table sales add column month_name varchar(10);
update sales
set month_name = monthname(date);

## Exploratory Data Analysis ##
# How many unique cities does the data have
select count(distinct city)
from sales;

select distinct city
from sales;

# In which city is each branch

select distinct(city), branch
from sales;

# How many unique product lines does the data have?
select distinct(product_line)
from sales;

select count(distinct product_line)
from sales;

# what is the most common payment method?
select payment, count(payment) as cnt
from sales
group by payment
order by cnt desc;

# what is the most selling product line
select product_line, count(product_line) as cnt
from sales
group by product_line
order by cnt desc;

# What is the total revenue by month?
select month_name, sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

# What month had the largest cogs?
select month_name, sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

# What product line had the largest revenue?
select product_line, sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

# What is the city with the largest revenue
select branch, city, sum(total) as total_revenue
from sales
group by city, branch
order by total_revenue desc;

# What product line had the largest VAT?
select product_line,
avg(tax_pct) as avg_vat
from sales
group by product_line
order by avg_vat desc;

# Which branch sold more products than average product sold?
select branch, sum(quantity) as qty
from sales
group by branch
having qty > (select avg(quantity) from sales);

# What is the most common product line by gender?
select product_line, gender, count(gender) as cnt
from sales
group by product_line, gender
order by cnt desc;

# What is the average rating of each product line?
select product_line, round(avg(rating), 2) as avg_rating
from sales
group by product_line
order by avg_rating desc;


# Number of Sales made in each time of the day per weekday
select time_of_the_day,
count(*) as total_sales
from sales
group by time_of_the_day
order by total_sales desc;

select time_of_the_day,
count(*) as total_sales
from sales
where day_name = 'Monday'
group by time_of_the_day
order by total_sales desc;


# Which of the customer types brings the most revenue?
select 
customer_type,
sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

# Which city has the largest tax percent/VAT (Value Added Tax)?
select city, avg(tax_pct) as VAT
from sales
group by city
order by VAT desc;

# Which customer type pays the most in VAT?
select customer_type, avg(tax_pct) as VAT
from sales
group by customer_type
order by VAT desc;

# How many unique customer types does the data have?
select
distinct customer_type
from sales;

# How many unique payment methods does the data have?
select
distinct payment
from sales;

# Which customer types buys the most?
select customer_type,
count(*) as cstmr_cnt
from
sales
group by customer_type
order by cstmr_cnt desc;

# What is the gender of most of the customer?
select gender,
count(*) as gender_cnt
from
sales
group by gender
order by gender_cnt desc;

# What is the gender distribution per branch?

select gender,
count(*) as gender_cnt
from
sales
where branch = 'A'
group by gender
order by gender_cnt desc;


select gender,
branch,
count(*) as gender_cnt
from
sales
group by gender, branch
order by gender_cnt desc;

# Which time of the day the customer do customers give most ratings?
select time_of_the_day, avg(rating) as avg_rating
from sales
group by time_of_the_day
order by avg_rating desc;

# Which time of the day the customer do customers give most ratings per branch?
select time_of_the_day, branch, avg(rating) as avg_rating
from sales
group by time_of_the_day, branch
order by avg_rating desc;

# Which day of the week has the best average ratings?
SELECT 
    day_name, AVG(rating) AS avg_rating
FROM
    sales
GROUP BY day_name
ORDER BY avg_rating desc;

# Which day of the week has the best average ratings per branch?
SELECT 
    day_name, branch, AVG(rating) AS avg_rating
FROM
    sales
GROUP BY day_name, branch
ORDER BY avg_rating desc;

SELECT 
    day_name, AVG(rating) AS avg_rating
FROM
    sales
where branch = "A"
GROUP BY day_name
ORDER BY avg_rating desc;









