/*
Questions available at http://sqlzoo.net/wiki/AdventureWorks
*/


-- #1
/*
Show the first name and the email address of customer with CompanyName 'Bike World'
*/
SELECT FirstName, EmailAddress
FROM Customer
WHERE CompanyName = 'Bike World';

Result:
FirstName	EmailAddress
Kerim	kerim0@adventure-works.com

-- #2
/*
Show the CompanyName for all customers with an address in City 'Dallas'.
*/
SELECT CompanyName
FROM Customer
JOIN CustomerAddress
ON Customer.CustomerID = CustomerAddress.CustomerID
JOIN Address
ON CustomerAddress.AddressID = Address.AddressID
WHERE Address.City = 'Dallas';

Result:
CompanyName
Town Industries
Elite Bikes
Elite Bikes
Third Bike Store
Unsurpassed Bikes
Rental Bikes

-- #3
/*
How many items with ListPrice more than $1000 have been sold?
*/
SELECT COUNT(*) AS Solditem
FROM SalesOrderDetail
JOIN Product
ON SalesOrderDetail.ProductID = Product.ProductID
WHERE Product.ListPrice > 1000;

Result:
Solditem
131

-- #4
/*
Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight.
*/
SELECT Customer.CompanyName
FROM SalesOrderHeader
JOIN Customer
ON SalesOrderHeader.CustomerID = Customer.CustomerID
WHERE SubTotal + TaxAmt + Freight > 100000;

Result:
CompanyName
Action Bicycle Specialists
Metropolitan Bicycle Supply

-- #5
/*
Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'
*/
SELECT SUM(SalesOrderDetail.OrderQty) As SumRacingSocks
FROM SalesOrderDetail
JOIN Product
ON SalesOrderDetail.ProductID = Product.ProductID
JOIN SalesOrderHeader
ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
JOIN Customer
ON SalesOrderHeader.CustomerID = Customer.CustomerID
WHERE Product.Name = 'Racing Socks, L'
AND Customer.CompanyName = 'Riding Cycles';

Result:
SumRacingSocks
3

-- #6
/*
A "Single Item Order" is a customer order where only one item is ordered. Show the SalesOrderID and the UnitPrice for every Single Item Order.
*/
SELECT SalesOrderID, UnitPrice
FROM SalesOrderDetail
WHERE OrderQty = 1;

Result:
SalesOrderID	UnitPrice
71774	356.9
71774	356.9
71776	63.9
71780	323.99
71780	149.87
Results truncated. Only the first 5 rows have been shown.

-- #7
/*
Where did the racing socks go? List the product name and the CompanyName for all Customers who ordered ProductModel 'Racing Socks'.
*/
SELECT Product.name, Customer.CompanyName
FROM ProductModel
JOIN Product
ON ProductModel.ProductModelID = Product.ProductModelID
JOIN SalesOrderDetail
ON SalesOrderDetail.ProductID = Product.ProductID
JOIN SalesOrderHeader
ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
JOIN Customer
ON SalesOrderHeader.CustomerID = Customer.CustomerID
WHERE ProductModel.Name = 'Racing Socks';

Result:
name	CompanyName
Racing Socks, M	Thrifty Parts and Sales
Racing Socks, M	Sports Products Store
Racing Socks, M	The Bicycle Accessories Company
Racing Socks, M	Remarkable Bike Store
Racing Socks, L	Eastside Department Store
Racing Socks, L	Riding Cycles
Racing Socks, L	Sports Products Store
Racing Socks, L	Essential Bike Works
Racing Socks, L	The Bicycle Accessories Company
Racing Socks, L	Remarkable Bike Store

-- #8
/*
Show the product description for culture 'fr' for product with ProductID 736.
*/
SELECT ProductDescription.Description
FROM ProductDescription
JOIN ProductModelProductDescription
ON ProductDescription.ProductDescriptionID = ProductModelProductDescription.ProductDescriptionID
JOIN ProductModel
ON ProductModelProductDescription.ProductModelID = ProductModel.ProductModelID
JOIN Product
ON ProductModel.ProductModelID = Product.ProductModelID
WHERE ProductModelProductDescription.culture = 'fr'
AND Product.ProductID = '736';

Result:
Description
Le cadre LL en aluminium offre une conduite confortable, une excellente absorption des bosses pour un très bon rapport qualité-prix.

-- #9
/*
Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest. For each order show the CompanyName and the SubTotal and the total weight of the order.
*/
SELECT Customer.CompanyName, SalesOrderHeader.SubTotal, SUM(SalesOrderDetail.OrderQty * Product.weight) as SumWeight
FROM Product
JOIN SalesOrderDetail
ON Product.ProductID = SalesOrderDetail.ProductID
JOIN SalesOrderHeader
ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesorderID
JOIN Customer
ON SalesOrderHeader.CustomerID = Customer.CustomerID
GROUP BY SalesOrderHeader.SalesOrderID, SalesOrderHeader.SubTotal, Customer.CompanyName
ORDER BY SalesOrderHeader.SubTotal DESC;

Result:
CompanyName	SubTotal	SumWeight
Action Bicycle Specialists	108561.83	1133911.56
Metropolitan Bicycle Supply	98278.69	679588.02
Bulk Discount Store	88812.86	34813.05
Eastside Department Store	83858.43	565638.72
Riding Cycles	78029.69	504095.33

Only the first 5 rows have been shown.

-- #10
/*
How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?
*/
SELECT SUM(SalesOrderDetail.OrderQty) as SoldQty
FROM ProductCategory
JOIN Product
ON ProductCategory.ProductCategoryID = Product.ProductCategoryID
JOIN SalesOrderDetail
ON Product.ProductID = SalesOrderDetail.ProductID
JOIN SalesOrderHeader
ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesorderID
JOIN Address
ON SalesOrderHeader.ShipToAddressID = Address.AddressID
WHERE Address.City = 'London'
AND ProductCategory.Name = 'Cranksets';

Result:
SoldQty
9

