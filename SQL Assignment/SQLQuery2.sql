/**• Views 
• CTE 
• Programming 
• Ranking (01-12-2025)**/

------------EMPLOYEES----------------------------------------

CREATE TABLE Employees 
( 
    EmpId INT PRIMARY KEY, 
    EmpName VARCHAR(100), 
    DeptId INT, 
    ManagerId INT NULL, 
    JoinDate DATE, 
    Salary DECIMAL(10,2) 
); 
 
INSERT INTO Employees VALUES 
(1, 'Amit', 10, NULL, '2020-01-10', 65000), 
(2, 'Neha', 10, 1,    '2022-02-15', 50000), 
(3, 'Ravi', 20, 1,    '2023-03-12', 45000), 
(4, 'Sana', 20, 3,    '2024-01-20', 42000), 
(5, 'Karan', 30, 1,   '2021-07-18', 55000);

select * from Employees

--------------------------DEPARTMENTS------------------------------------
CREATE TABLE Departments 
( 
    DeptId INT PRIMARY KEY, 
    DeptName VARCHAR(100) 
); 
 
INSERT INTO Departments VALUES 
(10, 'IT'), 
(20, 'HR'), 
(30, 'Finance');

select * from Departments

-----------------------------------SALES---------------------------------------
CREATE TABLE Sales 
( 
    SaleId INT PRIMARY KEY, 
    EmpId INT, 
    Region VARCHAR(50), 
    SaleAmount DECIMAL(10,2), 
    SaleDate DATE 
); 
 
INSERT INTO Sales VALUES 
(1, 1, 'North', 100000, '2024-01-01'), 
(2, 2, 'North',  90000, '2024-01-10'), 
(3, 3, 'South', 120000, '2024-02-05'), 
(4, 4, 'South', 120000, '2024-02-20'), 
(5, 5, 'North', 110000, '2024-03-15');

select * from Sales

---------------------------TRANSACTIONS----------------------------------------------

CREATE TABLE Transactions 
( 
    TransId INT PRIMARY KEY, 
    AccountId INT, 
    Amount DECIMAL(10,2), 
    TransDate DATE 
); 
 
INSERT INTO Transactions VALUES 
(1, 101, 1000, '2024-01-01'), 
(2, 101, 2000, '2024-02-01'), 
(3, 101, -500, '2024-03-01'), 
(4, 102, 1500, '2024-01-15'), 
(5, 102, -200, '2024-03-10');

select * from Transactions

----------------------------------------------------------------------
select * from Employees
select * from Departments
select * from Sales
select * from Transactions


/**
Task-1 
Write a query using CASE to categorize salary levels on Employees table: 
• <20000 ? Low 
• 20000–50000 ? Medium 
• 50000 ? High 
**/

select 
EmpId,
EmpName,
Salary,
case 
when salary<2000 then 'Low'
when salary between 20000 and 50000 then 'Medium'
else 'High'
end as Salarylvl
from Employees

/**
Task -2 
 
Declare a variable @Age. 
Write logic using IF / ELSE: 
• If Age < 18 ? print “Minor” 
• Else If Age between 18–60 ? “Adult” 
**/


declare @age int
set @age=(18)
if(@age<18)
print'Minor'
else if(@age between 18 and 60)
print'Adult'
else 
print'Senior'

/**
Task-3 Encrypted & Schema-Bound View 
Create an encrypted and schemabound view that: 
• Joins Employees, Departments, and Salaries tables 
• Returns only employees who joined in the last 3 years 
• Includes computed column: AnnualSalary = Salary * 12 
• Prevents updates to base tables that break schema binding 
Tasks 
1. Create the view with WITH SCHEMABINDING, ENCRYPTION. 
2. Try altering an underlying table column ? observe the error.
**/

select * from Employees
select * from Departments
select * from Sales
select * from Transactions

create view  dbo.RecentEmployees
with schemabinding, Encryption as
select e.EmpId,e.Empname,e.DeptId,e.ManagerId,e.JoinDate,e.Salary, AnnualSalary = e.Salary * 12
from dbo.Employees as e
join dbo.Departments as d on e.DeptId = d.DeptId
where e.JoinDate >= Dateadd(Year, -3, Getdate())
with check option

alter table dbo.Employees alter column EmpName
Nvarchar(200)

/**
Task-4— Complex Multi-Table View 
Create a view that: 
• Joins Employees + Sales 
• Shows total sales per employee 
• Shows rank based on total sales across company 
**/

select * from Employees
select * from Departments
select * from Sales
select * from Transactions

select sum (s.SaleAmount) as totalsales,e.EmpName, 
rank() over (partition by e.EmpName order by sum(s.SaleAmount)desc) as rankbytotalsales  
from  Employees as e
join Sales as s
on
e.EmpId=s.empid
group by e.EmpName

/**
Task-5— Simulate Error Capture 
Write a block that: 
• Attempts dividing by zero 
• Catches the error 
• Prints error details
**/

begin try
declare @a int 
set @a = 10
print @a/0
end try
begin catch 
print' you cannot divide by 0'
print'Error_message'
end catch

/**
Task-6— Nested TRY…CATCH With Custom Error 
Validate salary: 
• If salary < 1000, throw custom error using THROW. 
• Declare variable  to simulate salary
**/

select * from Employees

begin try 
declare @salary int 
set @salary=1800
print @salary/0
end try 
begin catch 
if(@salary<1000)
throw 50001,'NOT VALID',1
print 'salary not valid'
end catch

/**
Task-7— Rank Employees by Region Sales 
Task 
• Compare Rank / Dense_Rank / Row_Number 
• Identify top 2 per region
**/

select * from Employees 
select * from Sales
select * from Departments
select * from Transactions


Select Region, EmpName, SaleAmount,
       RANK() Over (Partition By Region Order By SaleAmount Desc) as RankValue,
       DENSE_RANK() Over (Partition By Region Order By SaleAmount Desc) as DenseRankValue,
       ROW_NUMBER() Over (Partition By Region Order By SaleAmount Desc) as nRowNumValue
From Sales s
Join Employees e on s.EmpId = e.EmpId;
Select *
From (
    Select Region, EmpName, SaleAmount,
           RANK() Over (Partition By Region Order By SaleAmount Desc) AS RankValue
    From Sales s
    Join Employees e on s.EmpId = e.EmpId
) ranked
Where RankValue <= 2;

/**
Task-8 -Using Sales table: 
• First CTE: Filter only last 1 year sales 
• Second CTE: Compute total sales per region 
• Third CTE: Rank regions based on total sales 
• Output top 3 regions 
 
Task-8 Find Employees With Duplicate SalesAmount in Any Department
**/

select * from Sales

WITH LastYearSales AS (
    SELECT *
    FROM Sales
    WHERE SaleDate >= DATEADD(YEAR, -1, GETDATE())  -- last 1 year
),
RegionSales AS (
    SELECT Region, SUM(SaleAmount) AS TotalSales
    FROM LastYearSales
    GROUP BY Region
),
RankedRegions AS (
    SELECT Region, TotalSales,
           RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
    FROM RegionSales
)
SELECT Region, TotalSales
FROM RankedRegions
WHERE SalesRank <= 3;


SELECT e.DeptId, s.SaleAmount, COUNT(*) AS DuplicateCount
FROM Employees e
JOIN Sales s ON e.EmpId = s.EmpId
GROUP BY e.DeptId, s.SaleAmount
HAVING COUNT(*) > 1;
 
 /**
 Task – 9 
Perform Pagination and list all details from employees who’s page between 6 and 10
**/


With OrderedEmployees as (
    Select ROW_NUMBER() Over (Order By EmpId) as RowNum, *
    From Employees
)
Select *
From OrderedEmployees
Where RowNum BETWEEN 51 AND 100;  



















 


