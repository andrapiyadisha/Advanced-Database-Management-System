--Part – A
--1. Write a function to print "hello world".
Create OR Alter function fn_Halloworld()
Returns varchar(20)
As
Begin
	Return 'Hello World'
End

--2. Write a function which returns addition of two numbers.
Create OR Alter function fn_Sum(@N1 int, @N2 int)
Returns int
As
Begin
	Declare @sum int
	set @sum = @N1 + @N2
	Return @sum
End

--3. Write a function to check whether the given number is ODD or EVEN.
Create OR Alter function fn_Sum(@N1 int)
Returns varchar(Max)
As
Begin
	Declare @MSG varchar(Max)
	if @N1 % 2 = 0
		Set @MSG = 'Even'
	else
		Set @MSG = 'Odd'
	Return @MSG
End

--4. Write a function which returns a table with details of a person whose first name starts with B.
Create or alter function  fn_Person()
Returns Table
As
return(Select *from Person where FirstName like 'B%') 
 
--5. Write a function which returns a table with unique first names from the person table.
Create or alter function  fn_FirstName()
Returns Table
As
return(Select Distinct FirstName from Person) 

--6. Write a function to print number from 1 to N. (Using while loop)
Create OR Alter function fn_PrintNum(@N1 int)
Returns varchar(Max)
As
Begin
	Declare @MSG varchar(max), @Count int
	Set @MSG = ''
	Set @Count = 1
	While @Count <= @N1
		Begin 
			Set @MSG = @MSG + ''+CAST(@Count AS VArchar)
			Set @Count = @Count + 1
		End
Return @MSG
End
--7. Write a function to find the factorial of a given integer.
Create OR alter Function fn_Fact(@N int)
Returns int
As
Begin
	Declare @num int
	Set @num = 1
	While @N > 1
		Begin
			Set @num = @num * @N;
			Set @N = @N - 1;
		End
Return @num
End
SELECT dbo.fn_Fact(5) AS Factorial;

--Part – B
--8. Write a function to compare two integers and return the comparison result. (Using Case statement)
Create OR Alter function fn_Compare(@N1 int,@N2 int)
Returns varchar(Max)
As
Begin
	Declare @MSG varchar(Max)
	if @N1 > @N2
		Set @MSG = 'Number a is greter than b'
	else
		Set @MSG = 'Number b is Greater than a'
	Return @MSG
End
--9. Write a function to print the sum of even numbers between 1 to 20.
Create OR Alter function fn_1TO20()
Returns int
As
Begin
	Declare @sum int, @Count int
	Set @sum = 0
	Set @Count = 2
	While @Count <= 20
		Begin 
			Set @sum = @sum + @count
			Set @Count = @Count + 2
		End
Return @sum
End
SELECT dbo.fn_1TO20() AS SumOfEvenNumbers;

--10. Write a function that checks if a given string is a palindrome
Create OR Alter function fn_Palindron(@S1 varchar(max))
Returns varchar(Max)
As
Begin
	Declare @rev varchar(max)
	Set @rev = reverse(@S1)
	If @S1 = @rev
		Return 'Palindron'
	Else 
		Return 'Not Palindron'
	Return 'Invalid Input'
End
Select dbo.fn_Palindron('12321')
--Part – C
--11. Write a function to check whether a given number is prime or not.
CREATE OR ALTER FUNCTION FN_PRIME(@N INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @NUM INT;
	SET @NUM = 2;
	WHILE @NUM * @NUM <= @N
	BEGIN
		IF @N % @NUM = 0
			RETURN 'NOT PRIME'
		SET @NUM = @NUM + 1;
	END
	RETURN 'PEIME'
END
SELECT dbo.FN_PRIME(2) AS Result;
	
--12. Write a function which accepts two parameters start date & end date, and returns a difference in days.
CREATE OR ALTER FUNCTION FN_RETURNDAYS(@SDATE DATE)
RETURNS INT
AS
BEGIN
	RETURN DATEDIFF(DAY, @SDATE, GETDATE());
END
SELECT dbo.FN_RETURNDAYS('2024-01-10') AS DaysDifference

--13. Write a function which accepts two parameters year & month in integer and returns total days each year.
CREATE OR ALTER FUNCTION fn_TotalDaysInMonth(@Year INT, @Month INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalDays INT;

    SET @TotalDays = DAY(EOMONTH(DATEFROMPARTS(@Year, @Month, 1)));

    RETURN @TotalDays;
END;
SELECT dbo.fn_TotalDaysInMonth(2024, 2) AS TotalDays;
--14. Write a function which accepts departmentID as a parameter & returns a detail of the persons.
CREATE OR ALTER FUNCTION fn_GetEmployeesByDepartment(@DepartmentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.FirstName,
        p.LastName,
        d.DepartmentID,
        d.DepartmentName,
        p.Salary
    FROM Person p join Departments d 
	on p.DepartmentID = d.DepartmentID
    WHERE p.DepartmentID = @DepartmentID
);
SELECT * FROM dbo.fn_GetEmployeesByDepartment(2);

--15. Write a function that returns a table with details of all persons who joined after 1-1-1991.
CREATE FUNCTION GetPersonsJoinedAfter1991()
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Person
    WHERE JoiningDate > '1991-01-01'
);

select *from Person
select *from Departments