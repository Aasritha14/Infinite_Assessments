/**1. 
Create a procedure which accepts input parameter and inserts the 
data in the customer table.
**/
 create table customer
 (
 custid int identity(1,1),
 custname varchar(20),
 custage int,
 address varchar(20)
 )

create procedure valueinsert(@cname varchar(20), @cage int, @address varchar(20)) 
as
insert into customer values(@cname, @cage,@address)
return scope_identity()

declare @res int 
exec @res = valueinsert 'Aasritha',21, 'Bangalore'
print @res

select * from customer

/**
2.  Create a procedure for orders table , which displays all the purchase 
made between  1-12-2005  and 2-12-2007 
(Accept date as parameter_)**/



create procedure orderstable(@start date, @end date)
as
select * from Orders where orderdate between @start and @end

exec orderstable '2005-12-1', '2007-12-2'

select * from Orders



/**
3. create a procedure which reads custid as parameter  
and return qty and produtid as output parameter
**/
 
alter procedure GetOrderQtyAndProduct
(@ccustid int,
@cqty int output,
@cproductid int output)
as select 
@cqty = o.qty,
@cproductid = p.productid
from  Orders as o
inner join Products as p
on o.custid = p.custid
where o.custid = @ccustid;

declare @qty int
declare @pid int
exec GetOrderQtyAndProduct @ccustid=101,@cqty=@qty output,@cproductid=@pid output

print @qty
print @pid



 /**
 4. Write a batch that will check for the existence of the productname 
“books” if it exists, display the total stock of the book else print  
“productname books not found”.
**/

declare @Productname varchar(50) = 'book'
if exists (
select * from Product1 where pname = @Productname
)
select sum(totalstock) as Totalstock
from Product1
where pname = @Productname
else
print concat('productname', @Productname, 'not found')

/**
5.insert  data to customer table via return value of sp_getdata() 
procedure
**/

select * into newtable1 from customer
delete  from newtable1
select * from newtable1
select * from customer

alter procedure sp_getdata
as
select * from customer 

insert into newtable1 exec sp_getdata

/**
6. Create a procedure to display all customer details where rownumber 
between 2 to 5 (accept row number as a parameter)
**/

create procedure sp_getcustomers_by_rownum
@start int,
@end int 
as with CTE2 as (
select *,ROW_NUMBER()over(order by custage desc) as RN from customer
)
select RN from CTE2
where RN between @start and @end

exec sp_getcustomers_by_rownum 2,5;

select * from customer

/**
7.Create a stored procedure to insert a new employee 
Create a table Employees and write a stored procedure: 
• Procedure name: spAddEmployee 
• Inputs: Name, Department, Salary 
• Insert the record into Employees table. 
• Return newly generated CustomerID using SCOPE_IDENTITY().
**/

create table Employees 
(
EmployeeID int identity(1,1) primary key ,
Name varchar(50), 
Department varchar(50), 
Salary decimal(10,2)
)
create procedure spAddEmployee
@Name varchar(50),
@Department varchar(50),
@Salary decimal(10,2)
as
insert into Employees(Name, Department, Salary)
values (@Name, @Department, @Salary);

return Scope_Identity


declare @EmpID int;
exec @EmpID = spAddEmployee 'John', 'IT', 55000;
print 'New Employee ID: ' + cast(@EmpID AS VARCHAR);

/**9. Stored procedure using TRY…CATCH 
Create spSafeOrderInsert 
• Insert a new order 
• If any error occurs, insert error details into an ErrorLog table**/

create table ErrorLog (
    LogID int identity(1,1),
    ErrorMessage nvarchar(4000),
    OccurredAt datetime default getdate()
);

create procedure sp_OrderInsert
    @custID int,
    @productID int,
    @qty int
as
begin try
        insert into Orders (custid, product, qty)
        values (@custid, @productID,@qty)
end try
begin catch
        insert into ErrorLog(ErrorMessage)
        values (ERROR_MESSAGE());
end catch

/**
10.Stored procedure with multiple operations 
Create spUpdateSalary 
• Inputs: EmpID, Percentage 
• Increase employee salary by given percentage 
• Return updated salary
**/

select * from Employees;
 
CREATE PROCEDURE spUpdateSalary
    @EmpID INT,
    @Percentage DECIMAL(5,2),
    @UpdatedSalary DECIMAL(10,2) OUTPUT
AS
BEGIN
    -- Increase salary by given percentage
    UPDATE Employees
    SET Salary = Salary + (Salary * @Percentage / 100)
    WHERE EmpId = @EmpID;
 
 
    -- Return updated salary
       SELECT @UpdatedSalary = Salary FROM Employees WHERE EmpId = @EmpID;
END;
 
 
DECLARE @NewSalary DECIMAL(10,2);
 
EXEC spUpdateSalary 
    @EmpID =  4,
       @Percentage = 10, 
    @UpdatedSalary = @NewSalary OUTPUT;











 
 



