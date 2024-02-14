select * from fact_events;

START TRANSACTION; -- Start a transaction /

-- Your update statement
UPDATE fact_events
SET `quantity_sold(after_promo)` = `quantity_sold(after_promo)` * 2 -- Dividing by 2 to revert back to original values
WHERE promo_type = "BOGOF";
commit;


select promo_type ,sum(`quantity_sold(after_promo)`) ,sum(`quantity_sold(before_promo)`)
 from fact_events
 group by  promo_type;

select promo_type ,sum(Revenue_ADP),sum(Revenue_BDP),
sum(IR),sum(ISU) ,sum(`quantity_sold(after_promo)`)
from fact_events
group by promo_type
order by Sum(IR);

SELECT product_code, product_name       /*1.List of products which has a base price >+500 and promotype as bogof */
FROM dim_products                         /*Which helps to identify the high value product that are heavily discounted*/
WHERE product_code IN (
    SELECT product_code
    FROM fact_events
    WHERE base_price >= 500 AND promo_type = 'BOGOF'
);


select city , count(store_id) as" Number_of_stores"   /*2. display a total number of stores in each city in desc order*/
from dim_stores
group by city
order by number_of_stores desc ;


select  dc.campaign_name,                /*3.Returns a revenue before and after promotion in the field of campaign name*/
    SUM(fe.Revenue_BDP)/1000000 AS Revenue_BDP_Million,
    SUM(fe.Revenue_ADP)/1000000 AS Revenue_ADP_million
FROM 
    dim_campaigns dc
JOIN 
    fact_events fe ON dc.campaign_id = fe.campaign_id
GROUP BY 
    dc.campaign_name;
    
    
SELECT dc.category,                /*4.Returns a revenue before and after promotion in the field of campaign name*/
    SUM(fe.IR)/1000000 AS Incremental_Revenue,
    RANK()OVER (ORDER BY sum(fe.IR) DESC)as ranks
FROM 
    dim_products dc
JOIN 
    fact_events fe ON dc.product_code = fe.product_code
    where fe.campaign_id ="CAMP_DIW_01"
GROUP BY 
    dc.category;
    

SELECT 
    dc.product_name,dc.category,                /*5.Returns a revenue before and after promotion in the field of campaign name*/
    SUM(fe.IR)/1000000 AS Incremental_Revenues
FROM 
    dim_products dc
JOIN 
    fact_events fe ON fe.product_code = dc.product_code
GROUP BY 
    dc.product_code;
    

select promo_type ,sum(Revenue_ADP),sum(Revenue_BDP), /*dISPLAY THE promo_type ALONG WITH REVENUE, UNITS SOLD*/
sum(IR),sum(ISU) ,sum(`quantity_sold(after_promo)`)
from fact_events
group by promo_type
order by Sum(IR);

select promo_type,sum(IR)as IR,sum(ISU)as ISu,sum(Revenue_BDP)as Revenue_BDP,
sum(Revenue_ADP)as Revenue_ADP,sum(`quantity_sold(before_promo)`)as units_soldBDP,sum(`quantity_sold(after_promo)`)AS units_soldADP
from fact_events
group by promo_type
ORDER BY Revenue_ADP  DESC;
