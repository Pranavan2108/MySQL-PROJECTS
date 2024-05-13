create database swiggy;
use swiggy;

# 1) How many restaurants have a rating greater than 4.5
select count(distinct restaurant_name) as restaurant_count
from swiggy
where rating > 4.5;

# 2) Which is the top 1 city with the highest number of restaurants.
select city , count(distinct restaurant_name) as restaurant_count 
from swiggy
group by city
order by restaurant_count desc
limit 1;

# 3) How many restaurants have 'pizza' word in their name
select restaurant_name , count(*) over() as cnt from (
select distinct restaurant_name from swiggy) as x where restaurant_name like '%pizza%';

# 4) What is the most common cuisine among the restaurants in the dataset
select cuisine , count(cuisine) as cuisine_count  
from swiggy
group by cuisine
order by cuisine_count desc
limit 1;

# 5) What is the average rating of restaurants in each city
select city , round(avg(rating),2) as average_rating
from swiggy
group by city;

# 6) What is the highest price of the item in the 'Recommended' menu category for each restaurant
select distinct restaurant_name , menu_category ,max(price) over(partition by restaurant_name) as highest_price
from swiggy
where menu_category = 'recommended';

# 7) Find the top 5 most expensive restaurants that offer cuisine other than indian cuisine
select distinct restaurant_name , cuisine , cost_per_person 
from swiggy where cuisine not like '%india%'
order by cost_per_person desc
limit 5;

# 8) Find the restaurants that have an average cost which is higher than the total average cost of all restaurants together
select distinct restaurant_name , cost_per_person 
from swiggy where cost_per_person > (select avg(cost_per_person) from swiggy);

# 9) Retrieve the details of restaurants that have same name but located in different cities
select restaurant_name , count(city) as city_count from (
select distinct restaurant_name , city from swiggy ) as x group by restaurant_name having city_count > 1;

# 10) Which restaurant offers the most number of items in the 'Main Course' category
select restaurant_name , menu_category ,count(distinct item) item_count
from swiggy
where menu_category = 'main course'
group by restaurant_name
order by item_count desc
limit 1;

# 11) List the names of restaurants that are 100% vegeterian in the alphabetical order of restaurant name
select restaurant_name , veg_or_nonveg from (
select * , count(*) over(partition by restaurant_name) as cnt from (
select distinct restaurant_name , veg_or_nonveg from swiggy) as x ) as x where cnt < 2;

# 12) Which is the restaurant providing the lowest average price for all items
select restaurant_name , round(avg(price),2) as average_price
from swiggy 
group by restaurant_name
order by average_price asc
limit 1;

# 13) Which top 5 restaurants offers highest number of categories
select restaurant_name , count(distinct menu_category) categories
from swiggy
group by restaurant_name
order by categories desc
limit 5;

# 14) Which restaurant provides the highest percentage of non vegeterian food
with table1 as(
select restaurant_name , count(distinct item) as nv_item_count 
from swiggy where veg_or_nonveg = 'non-veg' group by restaurant_name) ,
table2 as(
select restaurant_name , count(distinct item) as total_item_count
from swiggy where restaurant_name in (select restaurant_name from table1) group by restaurant_name) 
select table1.restaurant_name , round(nv_item_count/total_item_count,2) * 100 as nonveg_percentage 
from table1,table2 where table1.restaurant_name = table2.restaurant_name
order by nonveg_percentage desc 
limit 1;