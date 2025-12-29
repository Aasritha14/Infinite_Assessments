create table student
(
student int, 
studentname varchar(20),
age int,
class int
)
insert into Student values
(101, 'Ram',32,4),
(102,'Madhavi',31,1),
(103,'Ashu',24,4),
(104,'Varun',25,6),
(105,'Eswar',36,9)

select * from student

create view studentv1 as
select student, studentname , age , class from student

select * from studentv1

--Alter command----
alter view studentv1 as select student, studentname, age , class from student
where age=23

select * from studentv1
select * from student

insert into studentv1(student,studentname) values
(106,'Raj')

select * from studentv1
select * from student

------------UPDATE in view----------------

update student set age = 23
where student=101

select * from studentv1
select * from student

-------------INSERT values in table----------------------
insert into student values 
(107,'Kim',30,7)

select * from student

create view studentv2 as select * from student
where studentname like '%(_)%'

select * from studentv2


-------now create which can hide the definition---------------
create view studentv3 with encryption 
schemabinding as select student, studentname, age from dbo.studentv1
where age=23
 with check option 

select max(totalage) as manage from(select max(age) as totalage from student 
group by studentname) as t

select * from student 

------------USING SUBQUERIES-----------------------------
select max(totalage) as maxage from(select sum(age) as totalge from student
group by studentname

with cte1 as (
select sum(age) as totalage class from student
group by class 
)
select * from cte1

--------------------------SQL ADVANCED---------------------

create table Product1
(
pid int primary key,
pname varchar(20),
price int,
totalstock int
)

insert into Product1 values(10,'books',120,20)
insert into Product1 values(20,'cd',220,60)
insert into Product1 values(30,'pen',50,100)
insert into Product1 values(40,'mouse',1000,45)
insert into Product1 values(50,'keyboard',2200,5)


SELECT 
    pname,
    Price,
    CASE 
        WHEN Price > 500 THEN 'Expensive'
        WHEN Price BETWEEN 200 AND 500 THEN 'Medium'
        ELSE 'Cheap'
    END AS PriceCategory
FROM Product1;

-------------------------------RANK------------------------------------
CREATE TABLE EmployeeSales (
    EmpId INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Department VARCHAR(50),
    SalesAmount INT,
    SalesMonth VARCHAR(20)
);

INSERT INTO EmployeeSales VALUES
(1, 'Amit',   'IT',        50000, 'January'),
(2, 'Neha',   'IT',        75000, 'January'),
(3, 'Rohit',  'IT',        75000, 'January'), 
(4, 'Kiran',  'IT',        30000, 'January'),
(5, 'Pooja',  'HR',        40000, 'January'),
(6, 'Sanjay', 'HR',        40000, 'January'),
(7, 'Meera',  'HR',        60000, 'January'),
(8, 'Vinay',  'Sales',     90000, 'January'),
(9, 'Simran', 'Sales',     85000, 'January'),
(10,'John',   'Sales',     85000, 'January');

select * from EmployeeSales

-----------------------ROLLUP----------------------------
select Department ,sum(salesamount) as totalsales
from EmployeeSales
Group by rollup(Department)

----------------------------CUBE--------------------------------
select Department ,sum(salesamount) as totalsales
from EmployeeSales
Group by cube(Department)


---------using ranking rank(),denserank(),rownumber()------------------------
select * ,rank() over (order by salesamount desc) as rankindepartment from EmployeeSales
select *,dense_rank() over(order by salesamount desc) as rankindepartment from EmployeeSales
select *,ROW_NUMBER() over(order by salesamount desc) as rankindepartment from EmployeeSales

-------------------PARTITION BY-------------------------------
select *, rank() over(partition by department order by salesamount desc) as deptrank from EmployeeSales
select *, DENSE_RANK() over(partition by department order by salesamount desc) as deptrank from EmployeeSales
select *,ROW_NUMBER() over(partition by department order by salesamount desc) as rankindepartment from EmployeeSales



----------------------PROGRAMMING--------------------------------
declare @a int ,@b int
set @a=5
set @b=5
print @a+@b

-- greatest of two number
declare @m int ,@n int
set @m=500
set @n=50
if(@m > @n)
begin
--print 'the greatest  is ' + cast(@m as varchar)
print concat('the greatest  is ',@m)
print 'hello world'
end
else
print @n


---------------------TYPECASTING--------------------------

declare @m int ,@n int
set @m=500
set @n=50
if(@m > @n)
begin
print 'the greatest  is ' + cast(@m as varchar)
print concat('the greatest  is ',@m)
print 'hello world'
end
else
print @n

------------------WHILE LOOP--------------------------------


declare @x int 
set @x=0;
while(@x<=10)
begin
if(@x=5)
break
set @x = @x +1 
print @x
end

-----------------------------------------------ERROR HANDLING----------------------------------------------
declare @c int 
set @c = 10
print @c /0
print @@error

declare @c int 
set @c = 10
print @c/0
if (@@error=8134)
print'you are trying to divide 0.....pls check again'

begin try 
declare @c int 
set @c = 10
print @c/0
end try 
begin catch 
print'you are trying to divide 0.....pls check again'
print '@@error_message()'
print '@@error_line()'
print '@@error_severity()'
print '@@error_number()'
print '@@error_procedure()'
end catch

