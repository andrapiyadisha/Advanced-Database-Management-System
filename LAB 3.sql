CREATE TABLE Departments (
 DepartmentID INT PRIMARY KEY,
 DepartmentName VARCHAR(100) NOT NULL UNIQUE,
 ManagerID INT NOT NULL,
 Location VARCHAR(100) NOT NULL
);
SELECT *FROM Departments
CREATE TABLE Employee (
 EmployeeID INT PRIMARY KEY,
 FirstName VARCHAR(100) NOT NULL,
 LastName VARCHAR(100) NOT NULL,
 DoB DATETIME NOT NULL,
 Gender VARCHAR(50) NOT NULL,
 HireDate DATETIME NOT NULL,
 DepartmentID INT NOT NULL,
 Salary DECIMAL(10, 2) NOT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
SELECT *FROM Employee
-- Create Projects Table
CREATE TABLE Projects (
 ProjectID INT PRIMARY KEY,
 ProjectName VARCHAR(100) NOT NULL,
 StartDate DATETIME NOT NULL,
 EndDate DATETIME NOT NULL,
 DepartmentID INT NOT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
SELECT *FROM Projects
INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID, Location)
VALUES
 (1, 'IT', 101, 'New York'),
 (2, 'HR', 102, 'San Francisco'),
 (3, 'Finance', 103, 'Los Angeles'),
 (4, 'Admin', 104, 'Chicago'),
 (5, 'Marketing', 105, 'Miami');
INSERT INTO Employee (EmployeeID, FirstName, LastName, DoB, Gender, HireDate, DepartmentID,Salary)
VALUES
 (101, 'John', 'Doe', '1985-04-12', 'Male', '2010-06-15', 1, 75000.00),
 (102, 'Jane', 'Smith', '1990-08-24', 'Female', '2015-03-10', 2, 60000.00),
 (103, 'Robert', 'Brown', '1982-12-05', 'Male', '2008-09-25', 3, 82000.00),
 (104, 'Emily', 'Davis', '1988-11-11', 'Female', '2012-07-18', 4, 58000.00),
 (105, 'Michael', 'Wilson', '1992-02-02', 'Male', '2018-11-30', 5, 67000.00);
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID)
VALUES
 (201, 'Project Alpha', '2022-01-01', '2022-12-31', 1),
 (202, 'Project Beta', '2023-03-15', '2024-03-14', 2),
 (203, 'Project Gamma', '2021-06-01', '2022-05-31', 3),
 (204, 'Project Delta', '2020-10-10', '2021-10-09', 4),
 (205, 'Project Epsilon', '2024-04-01', '2025-03-31', 5);
--Part – A
--1. Create Stored Procedure for Employee table As User enters either First Name or Last Name and based
--on this you must give EmployeeID, DOB, Gender & Hiredate.
CREATE OR ALTER PROCEDURE PR_EMPLOYEEDETAIL
@FName varchar(20) = null,
@LName varchar(20) = null
AS
BEGIN
	SELECT EmployeeID, DoB, Gender, Hiredate FROM Employee
	WHERE FirstName = @FName OR LastName = @LName
END
EXEC PR_EMPLOYEEDETAIL NULL,'DOE'

--2. Create a Procedure that will accept Department Name and based on that gives employees list who
--belongs to that department. 
CREATE OR ALTER PROCEDURE PR_DEPARTMENTNAME
@DEPARTMENTNAME VARCHAR(20) 
AS
BEGIN
	SELECT Employee.EmployeeID, Employee.FirstName, Employee.LastName, Departments.DepartmentName FROM Employee JOIN Departments 
	ON Employee.DepartmentID = Departments.DepartmentID
	WHERE DepartmentName = @DEPARTMENTNAME
END
EXEC PR_DEPARTMENTNAME	'IT'

--3. Create a Procedure that accepts Project Name & Department Name and based on that you must give
--all the project related details.
CREATE OR ALTER PROCEDURE PR_PROJECTDETAILS
@DEPARTMENTNAME VARCHAR(20), 
@PROJECTNAME VARCHAR(20)
AS
BEGIN
	SELECT Projects.ProjectName, Projects.StartDate, Projects.EndDate, Departments.DepartmentName FROM Projects JOIN Departments 
	ON Departments.DepartmentID = Projects.DepartmentID
	WHERE DepartmentName = @DEPARTMENTNAME and ProjectName = @PROJECTNAME
END
EXEC PR_PROJECTDETAILS 'IT','Project Alpha'

--4. Create a procedure that will accepts any integer and if salary is between provided integer, then those employee list comes in output. 
	 CREATE PROCEDURE PR_GetEmployeesBySalary
     @Salary INT
	AS
	BEGIN
		SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate, Salary
		FROM Employee
		WHERE Salary BETWEEN @Salary AND @Salary + 10000
	END

exec PR_GetEmployeesBySalary 50000
--5. Create a Procedure that will accepts a date and gives all the employees who all are hired on that date. 
CREATE PROCEDURE PR_GetEmployeesByHireDate
    @HireDate DATETIME
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate, Salary
    FROM Employee
    WHERE HireDate = @HireDate
END

exec PR_GetEmployeesByHireDate "2018-11-30"
--Part – B 
--6. Create a Procedure that accepts Gender’s first letter only and based on that employee details will be 
--served.  
CREATE PROCEDURE PR_GetEmployeesByGender
    @Gender CHAR(1)
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate, Salary
    FROM Employee
    WHERE Gender  Like @Gender + '%' 
END

exec PR_GetEmployeesByGender "F"

--7. Create a Procedure that accepts First Name or Department Name as input and based on that employee 
--data will come.  
CREATE PROCEDURE PR_GetEmployeesByFirstNameOrDepartment
    @FirstName VARCHAR(100) = NULL,
    @DepartmentName VARCHAR(100) = NULL
AS
BEGIN
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.DoB, e.Gender, e.HireDate,d.DepartmentID, e.Salary
    FROM Employee e LEFT JOIN Departments d 
	ON e.DepartmentID = d.DepartmentID
    WHERE e.FirstName = @FirstName OR d.DepartmentName = @DepartmentName 
END

exec PR_GetEmployeesByFirstNameOrDepartment "John"

--8. Create a procedure that will accepts location, if user enters a location any characters, then he/she will 
--get all the departments with all data.  
CREATE PROCEDURE PR_GetDepartmentsByLocation
    @Location VARCHAR(100)
AS
BEGIN
    SELECT * FROM Departments
    WHERE Location LIKE '%' + @Location + '%'
END

exec PR_GetDepartmentsByLocation "N"

--Part – C 
--9. Create a procedure that will accepts From Date & To Date and based on that he/she will retrieve Project 
--related data.  
CREATE PROCEDURE PR_GetProjectsByDateRange
    @FromDate DATETIME,
    @ToDate DATETIME
AS
BEGIN
    SELECT 
        ProjectID,
        ProjectName,
        StartDate,
        EndDate,
        DepartmentID
    FROM Projects
    WHERE StartDate >= @FromDate AND EndDate <= @ToDate
END

EXEC PR_GetProjectsByDateRange '2023-01-01', '2024-12-31';

--10. Create a procedure in which user will enter project name & location and based on that you must 
--provide all data with Department Name, Manager Name with Project Name & Starting Ending Dates.
CREATE PROCEDURE PR_GetProjectDetails2
    @ProjectName VARCHAR(100),
    @Location VARCHAR(100)
AS
BEGIN
    SELECT 
        Projects.ProjectID,
        Projects.ProjectName,
        Projects.StartDate,
        Projects.EndDate,
        Departments.DepartmentName,
        Employee.FirstName + ' ' + Employee.LastName AS ManagerName
    FROM Projects
    JOIN Departments ON Projects.DepartmentID = Departments.DepartmentID
    JOIN Employee ON Departments.ManagerID = Employee.EmployeeID
    WHERE Projects.ProjectName = @ProjectName AND Departments.Location = @Location
END

EXEC PR_GetProjectDetails2 'Project Alpha', 'New York';
