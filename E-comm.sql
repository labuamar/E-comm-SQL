-- For a general overview, I do some data exploration.
-- Viewing number of purchases, average rating, and average number of purchases and cost by gender:

SELECT ecom_ship."Gender",
COUNT(ecom_ship."Gender") AS "Purchases",
AVG("Customer_rating") AS "Avg Rating",
AVG("Prior_purchases") AS "Avg past purchases",
AVG("Cost_of_the_Product") AS "Avg Cost"
FROM public.ecom_ship 
GROUP BY ecom_ship."Gender";

-- Percentage of late deliveries by warehouse block:

SELECT "Warehouse_block" AS "Warehouse Block",
COUNT("Arrived_late") AS "Total Deliveries",
COUNT(1) FILTER (WHERE "Arrived_late" = True) AS "Arrived Late",
COUNT(1) FILTER (WHERE "Arrived_late" = True)::NUMERIC / COUNT("Arrived_late") *100 AS "Percentage Late"
FROM public.ecom_ship
GROUP BY "Warehouse_block";

-- No significant difference in delivery determined in different warehouse blocks.
-- Percentage late by product importance:

SELECT "Product_importance" AS "Product Importance",
COUNT(1) FILTER (WHERE "Arrived_late" = True)::NUMERIC / COUNT("Arrived_late") *100 AS "Percentage Late"
FROM public.ecom_ship
GROUP BY "Product_importance";

-- Percentage late by mode of shipment:

SELECT "Mode_of_Shipment" AS "Shipment Mode",
COUNT(1) FILTER (WHERE "Arrived_late" = True)::NUMERIC / COUNT("Arrived_late") *100 AS "Percentage Late"
FROM public.ecom_ship
GROUP BY "Mode_of_Shipment";

-- Percentage late for different ratings:

SELECT "Customer_rating" AS "Rating",
COUNT(1) FILTER (WHERE "Arrived_late" = True)::NUMERIC / COUNT("Arrived_late") *100 AS "Percentage Late"
FROM public.ecom_ship
GROUP BY "Customer_rating";

-- No significant difference.
-- Average rating for late and on-time deliveries:

SELECT "Arrived_late" AS "Arrived Late",
AVG("Customer_rating") AS "Avg Rating"
FROM public.ecom_ship
GROUP BY "Arrived_late";

-- No significant difference.
-- Late vs on-time delivery counts:

SELECT "Arrived_late" AS "Arrived Late",
COUNT("Arrived_late")
FROM public.ecom_ship
GROUP BY "Arrived_late";

-- More often than not, deliveries are late.
-- Let's look at if there are different ratings based off of the source warehouse block:

SELECT "Warehouse_block" AS "Warehouse Block",
AVG("Customer_rating") AS "Avg Rating"
FROM public.ecom_ship
GROUP BY "Warehouse_block";

-- No significant insights were made from previous queries. Checking continues variables by first binning.
-- Trying to bin into 3 and 5 categories. determining minimum and maximum values for the 'Weight in grams' variable:

SELECT MIN("Weight_in_gms"), MAX("Weight_in_gms")
FROM public.ecom_ship;

-- Min turned out to be 1001 and max 7846.
-- 3 bins will be: 1000-3282, 3283-5564, 5565-7846.
-- 5 bins will be: 1000-2369, 2370-3739, 3740-5108, 5109-6477, 6478-7846.

SELECT "Arrived_late", 
COUNT(CASE WHEN "Weight_in_gms">= 1000 AND "Weight_in_gms" <3282 THEN 1 END) AS "1000-3282",
COUNT(CASE WHEN "Weight_in_gms">= 3283 AND "Weight_in_gms" <5564 THEN 1 END) AS "3283-5564",
COUNT(CASE WHEN "Weight_in_gms">= 5565 AND "Weight_in_gms" <7846 THEN 1 END) AS "5565-7846"
FROM public.ecom_ship
GROUP BY "Arrived_late";

-- Items that weight 1000-3282 grams are arriving late at a higher rate than heavier items. 76% of lighter items are arriving late.
-- Checking this finding in more detail with more bins:

SELECT "Arrived_late", 
COUNT(CASE WHEN "Weight_in_gms">= 1000 AND "Weight_in_gms" <2369 THEN 1 END) AS "1000-2369",
COUNT(CASE WHEN "Weight_in_gms">= 2370 AND "Weight_in_gms" <3739 THEN 1 END) AS "2370-3739",
COUNT(CASE WHEN "Weight_in_gms">= 3740 AND "Weight_in_gms" <5108 THEN 1 END) AS "3740-5108",
COUNT(CASE WHEN "Weight_in_gms">= 5109 AND "Weight_in_gms" <6477 THEN 1 END) AS "5109-6477",
COUNT(CASE WHEN "Weight_in_gms">= 6478 AND "Weight_in_gms" <7846 THEN 1 END) AS "6478-7846"
FROM public.ecom_ship
GROUP BY "Arrived_late";

-- Again, the lightest items (under ~4000 grams) seem to have the most issues with delivery time.
-- Let's see how this effects customer ratings:

SELECT "Customer_rating", 
COUNT(CASE WHEN "Weight_in_gms">= 1000 AND "Weight_in_gms" <3282 THEN 1 END) AS "1000-3282",
COUNT(CASE WHEN "Weight_in_gms">= 3283 AND "Weight_in_gms" <5564 THEN 1 END) AS "3283-5564",
COUNT(CASE WHEN "Weight_in_gms">= 5565 AND "Weight_in_gms" <7846 THEN 1 END) AS "5565-7846"
FROM public.ecom_ship
GROUP BY "Customer_rating";

-- Just by quickly eyeballing the ratings and bar chart graphing, the distribution is similar across all ratings.

-- Summary: There exists a link between product weight and whether a delivery is made late or on-time.
-- This leads to many questions that can not be answered using this dataset:

-- Is there an internal processing issue with smaller items causing delays (smaller items falling off conveyer belt? Requiring frequent human intervention?)
-- Are smaller and larger items delivered using different services or carriers?

-- These questions are worth investigating.