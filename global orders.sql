use gbonlineorders;
show tables;
desc orders;
desc ordersdetails;
desc customers;
desc employees;
desc shippers;
desc categories;
desc products;
desc suppliers;

select * from orders;
select * from ordersdetails;
select * from customers;
select * from employees;
select * from shippers;
select * from categories;
select * from suppliers;
select * from products;

#--------------------------joins-------------------------------------------------------------------------------------------
#--------------show customers name, shipper name and orderid using joins
select orders.orderid, customers.customername, shippers.shippername, customers.customerid from
((orders inner join customers on orders.customerid = customers.customerid)
inner join shippers on orders.shipperid = shippers.shipperid) order by customers.customerid;

#---------------show customer who ordered maximum quantity 
SELECT 
    o.orderid, c.customerid, c.customername, od.quantity
FROM
    ((orders o
    INNER JOIN customers c ON o.customerid = c.customerid)
    INNER JOIN ordersdetails od ON o.orderid = od.orderid)
WHERE
    od.quantity = (SELECT 
            MAX(quantity)
        FROM
            ordersdetails);
            
#---------------------Find each employee's name and the total number of orders they processed.
select concat(e.firstname," ",e.lastname) as FullName, count(o.orderid) as Total_orders
from employees e left join orders o on e.EmployeeID = o.EmployeeID
group by e.firstname, e.LastName
order by total_orders;

#---------------------List each shipper's name and the total number of orders shipped by them
select s.shippername, count(o.orderid) as Total_orders
from shippers s left join orders o on s.shipperid= o.shipperid
group by s.shippername
order by total_orders;

#---------------------Retrieve each product's name, its category, and the total quantity sold.
SELECT 
    c.CategoryName AS Category, 
    p.ProductName AS ProductName, 
    SUM(o.Quantity) AS Total_Quantity
FROM 
    categories c
INNER JOIN 
    products p 
ON 
    c.CategoryID = p.CategoryID
INNER JOIN 
    ordersdetails o 
ON 
    p.ProductID = o.ProductID
GROUP BY 
    c.CategoryName, p.ProductName
ORDER BY 
    Total_Quantity DESC;
    
#---------------Find all products supplied by suppliers who provide more than 10 products.
select * from products;
select * from suppliers;

SELECT p.ProductName, s.SuppliersName, o.Quantity 
FROM products p
INNER JOIN suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN ordersdetails o ON p.ProductID = o.ProductID
WHERE o.Quantity >= 10;

#--------------------------List all orders along with their shipping company names by joining orders and shippers.
SELECT 
    o.OrderID, 
    o.OrderDate, 
    s.ShipperName
FROM 
    orders o
INNER JOIN 
    shippers s ON o.ShipperID = s.ShipperID;
    
#-----------------------------Retrieve a summary of orders, showing customer name, product name, quantity, and order date.
SELECT 
    c.CustomerName, 
    p.ProductName, 
    od.Quantity, 
    o.OrderDate
FROM 
    orders o
INNER JOIN 
    customers c ON o.CustomerID = c.CustomerID
INNER JOIN 
    ordersdetails od ON o.OrderID = od.OrderID
INNER JOIN 
    products p ON od.ProductID = p.ProductID
ORDER BY
    o.OrderDate DESC;
#--------------------------------Find all customers who have ordered products from a specific category (e.g., "Electronics").
SELECT DISTINCT 
    c.CustomerName
FROM 
    customers c
INNER JOIN 
    orders o ON c.CustomerID = o.CustomerID
INNER JOIN 
    ordersdetails od ON o.OrderID = od.OrderID
INNER JOIN 
    products p ON od.ProductID = p.ProductID
INNER JOIN 
    categories cat ON p.CategoryID = cat.CategoryID
WHERE 
    cat.CategoryName = 'Electronics';

############################## Subqueries  ##########################################################
#----------Find Products That Belong to the Category With the Highest Number of Products
SELECT p.ProductName, c.CategoryName
FROM products p
INNER JOIN categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryID = (
    SELECT CategoryID 
    FROM products 
    GROUP BY CategoryID 
    ORDER BY COUNT(ProductID) DESC 
    LIMIT 1
);

#---------------------List Details of Orders Placed by Customers Located in Countries With the Highest Number of Orders
SELECT o.OrderID, c.CustomerName, c.Country, o.OrderDate
FROM orders o
INNER JOIN customers c ON o.CustomerID = c.CustomerID
WHERE c.Country = (
    SELECT Country 
    FROM customers 
    INNER JOIN orders ON customers.CustomerID = orders.CustomerID 
    GROUP BY Country 
    ORDER BY COUNT(OrderID) DESC 
    LIMIT 1
);

#------------------- Find All Products Supplied by Suppliers Who Provide More Than 10 Products 
SELECT e.EmployeeID, e.FirstName, e.LastName, COUNT(o.OrderID) AS TotalOrders
FROM employees e
INNER JOIN orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalOrders DESC
LIMIT 1;

#---------------------List Orders Shipped by the Shipper With the Maximum Orders Handled
SELECT o.OrderID, s.ShipperName
FROM orders o
INNER JOIN shippers s ON o.ShipperID = s.ShipperID
WHERE s.ShipperID = (
    SELECT ShipperID
    FROM orders 
    GROUP BY ShipperID 
    ORDER BY COUNT(OrderID) DESC 
    LIMIT 1
);

#------------------Find Customers Who Have Placed Orders for Products Supplied by a Specific Supplier
SELECT DISTINCT c.CustomerName
FROM customers c
INNER JOIN orders o ON c.CustomerID = o.CustomerID
INNER JOIN ordersdetails od ON o.OrderID = od.OrderID
INNER JOIN products p ON od.ProductID = p.ProductID
WHERE p.SupplierID = 1;

#------------Retrieve Categories Where the Total Quantity Ordered Exceeds a Certain Threshold
SELECT c.CategoryName, SUM(od.Quantity) AS TotalQuantity
FROM categories c
INNER JOIN products p ON c.CategoryID = p.CategoryID
INNER JOIN ordersdetails od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
HAVING TotalQuantity > 100;

################################ basic Questions ##########################################
#--------Count the total number of orders in the dataset.
select count(orderid) from orders;

#--------Retrieve all distinct ship countries in the suppliers table.
select distinct country from suppliers;

#--------Find the earliest and latest order dates.
select min(orderdate) from orders;

#---------Count the total number of customers in the customers table.
select count(customername) from customers;

#---------Find the customer with the most orders.
SELECT c.CustomerName, COUNT(o.OrderID) AS OrderCount
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY OrderCount DESC
LIMIT 1;

#---------Retrieve the details of all orders shipped by a specific shipper
select o.orderid, o.customerid, o.employeeid, o.orderdate, o.shipperid, s.shippername 
from orders o inner join shippers s on o.shipperid = s.shipperid where shippername = "speedy express";

#---------List all products and their categories.
select p.productname, c.categoryname from products p inner join categories c on p.CategoryID = c.CategoryID;

#----------Find the average quantity ordered for each product.
SELECT p.ProductName, AVG(od.Quantity) AS AverageQuantity
FROM products p
JOIN ordersdetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName;

#-----------Count the total number of employees in the employees table.
SELECT COUNT(*) AS TotalEmployees
FROM employees;

#----------List the names of all employees who processed orders.
SELECT DISTINCT e.FirstName, e.LastName
FROM employees e
JOIN orders o ON e.EmployeeID = o.EmployeeID;

#----------List all shippers and the number of orders handled by each.
SELECT s.ShipperName, COUNT(o.OrderID) AS NumberOfOrders
FROM shippers s
JOIN orders o ON s.ShipperID = o.ShipperID
GROUP BY s.ShipperName;

#----------Retrieve the most frequently ordered product.
SELECT p.ProductName, COUNT(od.ProductID) AS OrderCount
FROM products p
JOIN ordersdetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY OrderCount DESC
LIMIT 1;

#----------Identify the top 5 customers based on total quantity ordered.
SELECT c.CustomerName, SUM(od.Quantity) AS TotalQuantityOrdered
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN ordersdetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerName
ORDER BY TotalQuantityOrdered DESC
LIMIT 5;

#----------List all categories and the number of products in each.
SELECT cat.CategoryName, COUNT(p.ProductID) AS NumberOfProducts
FROM categories cat
JOIN products p ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName;

#----------Retrieve orders where the shipper is not assigned (ShipperID is NULL).
SELECT o.OrderID, o.CustomerID, o.OrderDate
FROM orders o
WHERE o.ShipperID IS NULL;

#----------Find products that have never been ordered.
SELECT p.ProductName
FROM products p
LEFT JOIN ordersdetails od ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;
