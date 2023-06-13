/*
Questions available at http://sqlzoo.net/wiki/AdventureWorks
*/


-- #1
/*
Show the first name and the email address of customer with CompanyName 'Bike World'
*/
Select FirstName, EmailAddress
from Customer
where CompanyName = 'Bike World';

Result:
FirstName	EmailAddress
Kerim	kerim0@adventure-works.com

-- #2
/*
Show the CompanyName for all customers with an address in City 'Dallas'.
*/
Select CompanyName
from Customer
join CustomerAddress
on Customer.CustomerID = CustomerAddress.CustomerID
Join Address
on CustomerAddress.AddressID = Address.AddressID
where Address.City = 'Dallas';

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
Select count(distinct Product.ProductID) as Solditem
from SalesOrderDetail
join Product
on SalesOrderDetail.ProductID = Product.ProductID
where Product.ListPrice > 1000;

Result:
Solditem
41

-- #4
/*
Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight.
*/
Select Customer.CompanyName
from SalesOrderHeader
join Customer
on SalesOrderHeader.CustomerID = Customer.CustomerID
where SubTotal + TaxAmt + Freight > 100000;

Result:
CompanyName
Action Bicycle Specialists
Metropolitan Bicycle Supply

-- #5
/*
Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'
*/
Select SUM(SalesOrderDetail.OrderQty) as SumRacingSocks
from SalesOrderDetail
join Product
on SalesOrderDetail.ProductID = Product.ProductID
join SalesOrderHeader
on SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
join Customer
on SalesOrderHeader.CustomerID = Customer.CustomerID
where Product.Name = 'Racing Socks, L'
and Customer.CompanyName = 'Riding Cycles';

Result:
SumRacingSocks
3

-- #6
/*
A "Single Item Order" is a customer order where only one item is ordered. Show the SalesOrderID and the UnitPrice for every Single Item Order.
*/
Select SalesOrderID, UnitPrice
from SalesOrderDetail
where OrderQty = 1;

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
Select Product.name, Customer.CompanyName
from ProductModel
join Product
on ProductModel.ProductModelID = Product.ProductModelID
join SalesOrderDetail
on SalesOrderDetail.ProductID = Product.ProductID
join SalesOrderHeader
on SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
join Customer
on SalesOrderHeader.CustomerID = Customer.CustomerID
where ProductModel.Name = 'Racing Socks';

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
Select ProductDescription.Description
from ProductDescription
join ProductModelProductDescription
on ProductDescription.ProductDescriptionID = ProductModelProductDescription.ProductDescriptionID
join ProductModel
on ProductModelProductDescription.ProductModelID = ProductModel.ProductModelID
join Product
on ProductModel.ProductModelID = Product.ProductModelID
where ProductModelProductDescription.culture = 'fr'
and Product.ProductID = '736';

Result:
Description
Le cadre LL en aluminium offre une conduite confortable, une excellente absorption des bosses pour un très bon rapport qualité-prix.

-- #9
/*
Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest. For each order show the CompanyName and the SubTotal and the total weight of the order.
*/
Select Customer.CompanyName, SalesOrderHeader.SubTotal, SUM(SalesOrderDetail.OrderQty * Product.weight) as SumWeight
from Product
join SalesOrderDetail
on Product.ProductID = SalesOrderDetail.ProductID
join SalesOrderHeader
on SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesorderID
join Customer
on SalesOrderHeader.CustomerID = Customer.CustomerID
group by SalesOrderHeader.SalesOrderID, SalesOrderHeader.SubTotal, Customer.CompanyName
group by SalesOrderHeader.SubTotal desc;

Result:
CompanyName	SubTotal	SumWeight
Action Bicycle Specialists	108561.83	1133911.56
Metropolitan Bicycle Supply	98278.69	679588.02
Bulk Discount Store	88812.86	34813.05
Eastside Department Store	83858.43	565638.72
Riding Cycles	78029.69	504095.33
...
#Only the first 5 rows have been shown.

-- #10
/*
How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?
*/
Select SUM(SalesOrderDetail.OrderQty) as SoldQty
from ProductCategory
join Product
on ProductCategory.ProductCategoryID = Product.ProductCategoryID
join SalesOrderDetail
on Product.ProductID = SalesOrderDetail.ProductID
join SalesOrderHeader
on SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesorderID
join Address
on SalesOrderHeader.ShipToAddressID = Address.AddressID
where Address.City = 'London'
and ProductCategory.Name = 'Cranksets';

Result:
SoldQty
9

-- #11
/*
For every customer with a 'Main Office' in Dallas show AddressLine1 of the 'Main Office' and AddressLine1 of the 'Shipping' address - if there is no shipping address leave it blank. Use one row per customer.
*/
Select CompanyName,
MAX(case when AddressType = 'Main Office' then AddressLine1 else '' end) as MainOfficeAdress,
MAX(case when AddressType = 'Shipping' then AddressLine1 else '' end) as ShippingAddress
from Address
join CustomerAddress
on Address.AddressID = CustomerAddress.AddressID
join Customer
on CustomerAddress.CustomerID = Customer.CustomerID
where Address.City = 'Dallas'
group by Customer.CompanyName;

Result:
CompanyName	MainOfficeAdr..	ShippingAddre..
Elite Bikes	Po Box 8259024	9178 Jumping St.
Rental Bikes	99828 Routh Street, Suite 825	
Third Bike Store	2500 North Stemmons Freeway	
Town Industries	P.O. Box 6256916	
Unsurpassed Bikes	Po Box 8035996

-- #12
/*
For each order show the SalesOrderID and SubTotal calculated three ways:
A) From the SalesOrderHeader
B) Sum of OrderQty*UnitPrice
C) Sum of OrderQty*ListPrice
*/
Select SalesOrderHeader.SalesOrderID, SalesOrderHeader.SubTotal,
sum(OrderQty*UnitPrice) as DealTotal, sum(OrderQty * ListPrice) as ListTotal
from SalesOrderDetail 
join SalesOrderHeader
on SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
join Product 
on SalesOrderDetail.ProductID = Product.ProductID
group by SalesOrderHeader.SalesOrderID, SalesOrderHeader.SubTotal;

Result:
SalesOrderID	SubTotal	DealTotal	ListTotal
71774	880.35	713.8	1189.66
71776	78.81	63.9	106.5
71780	38418.69	30600.81	56651.56
71782	39785.33	33319.68	55533.31
71783	83858.43	68141.99	121625.43
...
#Only the first 5 rows have been shown.

-- #13
/*
Show the best selling item by value.
*/
Select top 1 Product.Name,
sum(SalesOrderDetail.OrderQTY * SalesOrderDetail.UnitPrice) as TotalValue
from Product
join SalesOrderDetail
on Product.ProductID = SalesOrderDetail.ProductID
group by Product.Name
Order by TotalValue desc;

Result:
Name	TotalValue
Touring-1000 Blue, 60	37191.44

-- #14
/*
Show how many orders are in the following ranges (in $):

    RANGE      Num Orders      Total Value
    0-  99
  100- 999
 1000-9999
10000-
*/
Select a.range as RANGE, count(a.Total) as 'Num orders', sum(a.Total) as 'Total Value'
from (select
      case 
      when SalesOrderDetail.UnitPrice * SalesOrderDetail.OrderQty between 0 and 99
      then '0 - 99'
      when SalesOrderDetail.UnitPrice * SalesOrderDetail.OrderQty between 100 and 999
      then '100-999'
      when SalesOrderDetail.UnitPrice * SalesOrderDetail.OrderQty between 1000 and 9999
      then '1000-9999'
      when SalesOrderDetail.UnitPrice * SalesOrderDetail.OrderQty > 10000
      then '10000-'
      else ''
      end as range,
      SalesOrderDetail.UnitPrice * SalesOrderDetail.OrderQty AS Total
      from SalesOrderDetail)a
group by a.range;

Result:
RANGE	Num orders	Total Value
0 - 99	129	6576.02
100-999	225	90859.33
1000-9999	138	433813.21
10000-	8	113661.13

-- #15
/*
Identify the three most important cities. Show the break down of top level product category against city.
*/
Select * from
(select ee.City, dd.ProductCateName, sum(Tot) as total, rank() over (Partition by ee.City order by sum(Tot) desc) as ranknum
from

(select SalesOrderID, cc.Name ProductCateName, sum(OrderQty*UnitPrice) Tot
from SalesOrderDetail aa
join Product bb
on aa.ProductID = bb.ProductID
join ProductCategory cc
on bb.ProductCategoryID = cc.ProductCategoryID
group by SalesOrderID, cc.Name) dd

join

(select bb.City, SalesOrderID, Subtotal
from SalesOrderHeader aa
join Address bb
on aa.ShipToAddressID = bb.AddressID
join
(select top 3 City
from SalesOrderHeader aa
join Address bb
on aa.ShipToAddressID = bb.AddressID
group by City
order by sum(SubTotal) desc) cc
on bb.City = cc.City) ee

on dd.SalesOrderID = ee.SalesOrderID
group by ee.City, dd.ProductCateName) ddd
where ranknum = 1;

Result:
City	ProductCateNa..	total	ranknum
London	Mountain Bikes	50881.99	1
Union City	Road Bikes	53478.76	1
Woolston	Touring Bikes	77040.15	1

/*
Resit Questions
*/

-- #1
/*
List the SalesOrderNumber for the customer 'Good Toys' 'Bike World'
*/
Select SalesOrderHeader.SalesOrderID, Customer.CompanyName
from Customer
left join SalesOrderHeader 
on Customer.CustomerID = SalesOrderHeader.CustomerID
where CompanyName like '%Good Toys%'
   or CompanyName like '%Bike World%';
  
Result:
SalesOrderID	CompanyName
Bike World
71774	Good Toys

-- #2
/*
List the ProductName and the quantity of what was ordered by 'Futuristic Bikes'
*/
Select Product.Name, SalesOrderDetail.OrderQty
from Customer
join SalesOrderHeader
on Customer.CustomerID = SalesOrderHeader.CustomerID
join SalesOrderDetail
on SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
join Product
on SalesOrderDetail.ProductID = Product.ProductID
where Customer.CompanyName = 'Futuristic Bikes';

Result:
Name	OrderQty
ML Mountain Seat/Saddle	2
Long-Sleeve Logo Jersey, L	2
Classic Vest, S	3

-- #3
/*
List the name and addresses of companies containing the word 'Bike' (upper or lower case) and companies containing 'cycle' (upper or lower case). Ensure that the 'bike's are listed before the 'cycles's.
*/
 
