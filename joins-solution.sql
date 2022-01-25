-- 1. Get all customers and their addresses.

SELECT 
  concat ( customers.first_name, ' ', customers.last_name ) AS name,
  concat ( addresses.street, ' ', addresses.city, ', ', addresses.state) AS address
FROM customers
JOIN addresses ON customers.id = addresses.customer_id;

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT
  orders.id AS order_id,
  products.description AS product_name,
  line_items.quantity
FROM orders
JOIN line_items ON line_items.order_id = orders.id
JOIN products ON products.id = line_items.product_id;

-- 3. Which warehouses have cheetos?
SELECT 
  warehouse.warehouse,
  products.description
FROM "warehouse"
JOIN "warehouse_product" ON warehouse_product.warehouse_id = warehouse.id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'cheetos';

-- 4. Which warehouses have diet pepsi?
SELECT 
  warehouse.warehouse,
  products.description
FROM "warehouse"
JOIN "warehouse_product" ON warehouse_product.warehouse_id = warehouse.id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi';

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT 
  count(orders.id) AS order_count,
  CONCAT ( customers.first_name, ' ', customers.last_name ) AS name
FROM customers
JOIN addresses ON customers.id = addresses.customer_id
JOIN orders ON orders.address_id = addresses.id
GROUP BY name;

-- 6. How many customers do we have?
SELECT
  count(customers.id)
FROM customers;

-- 7. How many products do we carry?
SELECT
  count(products.id)
FROM products;

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT
  sum(warehouse_product.on_hand),
  products.description
FROM warehouse_product
JOIN products ON products.id = warehouse_product.product_id
WHERE products.description = 'diet pepsi'
GROUP BY products.description;


-- 9. How much was the total cost for each order?
SELECT 
  concat ( customers.first_name, ' ', customers.last_name ) AS name,
  coalesce(sum(products.unit_price*line_items.quantity), 0)
FROM customers
JOIN addresses ON customers.id = addresses.customer_id
JOIN orders ON orders.address_id = addresses.id
JOIN line_items ON line_items.order_id = orders.id
JOIN products ON products.id = line_items.product_id
GROUP BY name;

-- 10. How much has each customer spent in total?

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT 
  concat ( customers.first_name, ' ', customers.last_name ) AS name,
  coalesce(sum(products.unit_price*line_items.quantity), 0)
FROM customers
FULL JOIN addresses ON customers.id = addresses.customer_id
FULL JOIN orders ON orders.address_id = addresses.id
FULL JOIN line_items ON line_items.order_id = orders.id
FULL JOIN products ON products.id = line_items.product_id
GROUP BY name;
-- FULL JOIN makes it grab all the data...period