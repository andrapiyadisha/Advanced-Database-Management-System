-- Create the Products table
CREATE TABLE Products (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);
-- Insert data into the Products table
INSERT INTO Products (Product_id, Product_Name, Price) VALUES
(1, 'Smartphone', 35000),
(2, 'Laptop', 65000),
(3, 'Headphones', 5500),
(4, 'Television', 85000),
(5, 'Gaming Console', 32000);
select *from Products

--From the above given tables perform the following queries:
--Part - A

--1. Create a cursor Product_Cursor to fetch all the rows from a products table.
Declare @id int, @PName varchar(max), @price int
Declare cursor_product CURSOR
for
	select *from Products
Open cursor_product
fetch next from cursor_product
into @id, @PName, @price

while @@FETCH_STATUS = 0
	Begin
		print (cast(@id as varchar)+ @PName +cast(@price as varchar))
		fetch next from cursor_product
		into @id, @PName, @price
	End
Close cursor_product
Deallocate cursor_product

--2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName. (Example: 1_Smartphone)
Declare @id int, @PName varchar(max)
Declare cursor_product_fetch CURSOR
for
	select Product_id, Product_Name from Products
Open cursor_product_fetch
fetch next from cursor_product_fetch
into @id, @PName

while @@FETCH_STATUS = 0
	Begin
		print (cast(@id as varchar)+'_'+ @PName)
		fetch next from cursor_product_fetch
		into @id, @PName
	End
Close cursor_product_fetch
Deallocate cursor_product_fetch

--3. Create a Cursor to Find and Display Products Above Price 30,000.

Declare @PName varchar(max), @price int
Declare cursor_product_price CURSOR
for
	select Product_Name, Price from Products where Price > 30000
Open cursor_product_price
fetch next from cursor_product_price
into @PName, @price

while @@FETCH_STATUS = 0
	Begin
		print(@PName)
		fetch next from cursor_product_price
		into @PName, @price
	End
Close cursor_product_price
Deallocate cursor_product_price
--4. Create a cursor Product_CursorDelete that deletes all the data from the Products table.
Declare @id int, @PName varchar(max), @price int
Declare cursor_product_delete CURSOR
for
	select *from Products
Open cursor_product_delete
fetch next from cursor_product_delete
into @id, @PName, @price

while @@FETCH_STATUS = 0
	Begin
		DELETE FROM Products WHERE Product_id = @id;
		fetch next from cursor_product_delete
		into @id, @PName, @price
	End
Close cursor_product_delete
Deallocate cursor_product_delete

--Part – B
--5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases the price by 10%.
Declare @id int, @PName varchar(max), @price int ,@NPrice int
Declare cursor_productUpdate CURSOR
for
	select *from Products
Open cursor_productUpdate
fetch next from cursor_productUpdate
into @id, @PName, @price

while @@FETCH_STATUS = 0
	Begin
		set @NPrice = @NPrice + 0.1
		print (cast(@id as varchar)+ @PName +cast(@NPrice as varchar))
		fetch next from cursor_productUpdate
		into @id, @PName, @price
	End
Close cursor_productUpdate
Deallocate cursor_productUpdate

--6. Create a Cursor to Rounds the price of each product to the nearest whole number.
Declare @id int, @PName varchar(max), @price int
Declare cursor_product_round CURSOR
for
	select *from Products
Open cursor_product_round
fetch next from cursor_product_round
into @id, @PName, @price

while @@FETCH_STATUS = 0
	Begin
		Update Products
		set @price = ROUND(@price, 0)
		where Product_id = @id
		print (cast(@id as varchar)+ @PName +cast(@price as varchar))
		fetch next from cursor_product_round
		into @id, @PName, @price
	End
Close cursor_product_round
Deallocate cursor_product_round

--Part – C

--7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop”
--(Note: Create NewProducts table first with same fields as Products table)
Declare @id int, @PName varchar(max), @price int
Declare cursor_NewProduct CURSOR
for
	select *from Products where Product_Name = 'Laptop' 
Open cursor_NewProduct
fetch next from cursor_NewProduct
into @id, @PName, @price

while @@FETCH_STATUS = 0
	Begin
		Insert into NewProducts values(@id, @PName, @price)
		fetch next from cursor_NewProduct
		into @id, @PName, @price
	End
Close cursor_NewProduct
Deallocate cursor_NewProduct

CREATE TABLE NewProducts (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);

--8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products
--with a price above 50000 to an archive table, removing them from the original Products table.
create table ArchivedProducts(
 ProductID INT PRIMARY KEY,
 ProductName VARCHAR(MAX),
 Price INT
)

Declare @id int, @PName varchar(max), @price int
Declare cursor_ArchivedProducts CURSOR
for
	select *from Products where Price>50000

Open cursor_ArchivedProducts

fetch next from cursor_ArchivedProducts
into @id, @PName, @price

while @@FETCH_STATUS = 0
	Begin
		Insert into ArchivedProducts values(@id, @PName, @price)
		Delete from Products Where Product_id = @id
		fetch next from cursor_ArchivedProducts
		into @id, @PName, @price
	End
Close cursor_ArchivedProducts
Deallocate cursor_ArchivedProducts
select *from ArchivedProducts
