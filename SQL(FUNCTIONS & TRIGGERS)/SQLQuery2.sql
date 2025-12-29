----------------------------------------------------Functions------------------------------------------
/**
1. Create a function to find the greatest of three numbers
**/

Create function fn_findthegreatest
(@j int,@k int,@p int)
returns int
as
begin
declare @max int;
if 
(@j >= @k AND @j >= @p)
set @max = @j;
else if 
(@k >= @j AND @k >= @p)
set @max = @k;
else
set @max = @p;
return @max;
end

select dbo.fn_findthegreatest(10, 25, 7) as GreatestNumber;

/**
2. create a function to calculate to discount of 10% on price on all 
the products 
**/

select * from Orders


Create function dbo.fn_discountprice(@price int)
returns int 
as
begin
declare @discounted int
set @discounted = @price * 0.10 
return @discounted
end

select dbo.fn_discountprice(250) as DiscountedPrice;  

/**
3. create a function to calculate the discount on price as following 
if productname = 'books' then 10% 
if productname = toys then 15% 
else 
no discount
**/

Create function fn_calculateDiscount(@productname varchar(60), @price int)
returns int
as 
begin
declare @discountedprice int
if (@productname ='books')
set @discountedprice = @price * 0.10
else if (@productname ='toys')
set @discountedprice = @price * 0.15
else
set @discountedprice = @price
return @discountedprice
end

select dbo.fn_calculateDiscount('books', 500 )
select dbo.fn_calculateDiscount('toys', 500)

/**
4. create inline function which accepts number and prints last n 
years of orders made from  now. 
(pass n as a parameter)
**/

Create function fn_OrdersLastYear(@n int)
returns table
as 
return
(
select orderid,custid,orderdate,price from Orders 
where orderdate >=dateadd(year, @n, getdate())
)


select * from dbo.fn_OrdersLastYear(2)

--------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------TRIGGERS-----------------------------------------------------

/**
1. Create a trigger for table customer, which does not allow 
the user to delete the record who stays in Bangalore, 
Chennai, delhi
**/

Alter trigger tr_deletecities on customer
for delete 
as 
if exists(
select * from deleted where address in ('Banglore', 'Chennai', 'Delhi'))
begin 
print 'You cannot delete the record'
rollback transaction
end 


delete from customer where address in('Banglore','Chennai','Delhi')

/**
2. Create a triggers for orders which allows the user to insert 
only books, cd, mobile 
**/

Create trigger tr_insertOrders on Orders 
for insert 
as 
begin
if exists (
select * from inserted where product  not  in('books', 'cd', 'mobile'))
print'you cannot insert the values'
rollback transaction
end

insert into Orders (product) values(114,5666, '2005-09-03','cd', 500,4,115,9999,'2008-07-12','books',200,3,116,7777,'2004-05-15','mobile',50000,1)

/**
3. Create a trigger for customer table whenever an item is 
delete from this table. The corresponding item should be 
added in customerhistory table.
**/


Create trigger tr_after_customer_deletehistory
on customers
after delete
as
begin
   
insert into samecustomers(custid, custname, cphone, caddress,)
    select custid, custname, cphone,  caddress, GETDATE()
    from deleted;
end;

/**
4. Create update trigger for stock. Display old values and new 
values
**/


Create trigger tr_stock_update
on Stock
after update
as
begin
select
d.StockID AS OldStockID,
d.Quantity AS OldQuantity,
i.Quantity AS NewQuantity,
d.Price AS OldPrice,
i.Price AS NewPrice
FROM deleted d
JOIN inserted i ON d.StockID = i.StockID;
END;




  






