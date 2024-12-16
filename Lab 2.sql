-- Create Department Table
CREATE TABLE Department (
 DepartmentID INT PRIMARY KEY,
 DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Designation Table
CREATE TABLE Designation (
 DesignationID INT PRIMARY KEY,
 DesignationName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Person Table
CREATE TABLE Person (
 PersonID INT PRIMARY KEY IDENTITY(101,1),
 FirstName VARCHAR(100) NOT NULL,
 LastName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8, 2) NOT NULL,
 JoiningDate DATETIME NOT NULL,
 DepartmentID INT NULL,
 DesignationID INT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
 FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID)
);

--Part – A
--1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures.

CREATE PROCEDURE PR_DEPARTMENT_INSERT
	@DEPTID INT,
	@DEPTNAME VARCHAR(100)
AS 
BEGIN
	INSERT INTO DEPARTMENT
	(DEPARTMENTID,DEPARTMENTNAME)
	VALUES
	(@DEPTID,@DEPTNAME)
END

EXEC PR_DEPARTMENT_INSERT 1,'ADMIN'
EXEC PR_DEPARTMENT_INSERT 2,'IT'
EXEC PR_DEPARTMENT_INSERT 3,'HR'
EXEC PR_DEPARTMENT_INSERT 4,'ACCOUNT'

CREATE PROCEDURE PR_DESIGNATION_INSERT
	@DEGID INT,
	@DEGNAME VARCHAR(100)
AS 
BEGIN
	INSERT INTO DESIGNATION
	(DESIGNATIONID,DESIGNATIONNAME)
	VALUES
	(@DEGID,@DEGNAME)
END

EXEC PR_DESIGNATION_INSERT 11,'JOBBER'
EXEC PR_DESIGNATION_INSERT 12,'WELDER'
EXEC PR_DESIGNATION_INSERT 13,'CLERK'
EXEC PR_DESIGNATION_INSERT 14,'MANAGER'
EXEC PR_DESIGNATION_INSERT 15,'CEO'

CREATE PROCEDURE PR_PERSON_INSERT
	@PFIRSTNAME VARCHAR(100),
	@PLASTNAME VARCHAR(100),
	@PSALARY DECIMAL(8,2),
	@PJOININGDT DATETIME,
	@PDEPTID INT,
	@PDEGID INT
AS 
BEGIN
	INSERT INTO PERSON
	(FIRSTNAME,LASTNAME,SALARY,JOININGDATE,DEPARTMENTID,DESIGNATIONID)
	VALUES
	(@PFIRSTNAME,@PLASTNAME,@PSALARY,@PJOININGDT,@PDEPTID,@PDEGID)
END

EXEC PR_PERSON_INSERT 'RAHUL','ANSHU',56000,'01-01-1990',1,12
EXEC PR_PERSON_INSERT 'HARDIK','HINSHU',18000,'1990-09-25',2,11
EXEC PR_PERSON_INSERT 'BHAVIN','KAMANI',25000,'1991-05-14',NULL,11
EXEC PR_PERSON_INSERT 'BHOOMI','PATEL',39000,'2014-02-20',1,13
EXEC PR_PERSON_INSERT 'ROHIT','RAJGOR',17000,'1990-07-23',2,15
EXEC PR_PERSON_INSERT 'PRIYA','MEHTA',25000,'1990-10-18',2,NULL
EXEC PR_PERSON_INSERT 'NEHA','TRIVEDI',18000,'2014-02-20',3,15

CREATE PROCEDURE PR_DEPARTMENT_DELETE
	@DEPTID INT
AS
BEGIN
	DELETE FROM DEPARTMENT
	WHERE DEPARTMENTID=@DEPTID
END

CREATE PROCEDURE PR_DESIGNATION_DELETE
	@DEGID INT
AS
BEGIN
	DELETE FROM DESIGNATION
	WHERE DESIGNATIONID=@DEGID
END

CREATE PROCEDURE PR_PERSON_DELETE
	@PID INT
AS
BEGIN
	DELETE FROM PERSON
	WHERE PERSONID=@PID
END

CREATE PROCEDURE PR_DEPARTMENT_UPDATE
	@DEPTID INT,
	@DEPTNAME VARCHAR(100)
AS 
BEGIN
	UPDATE DEPARTMENT
	SET 
	DEPARTMENTNAME=@DEPTNAME
	WHERE 
	DEPARTMENTID = @DEPTID
END

CREATE PROCEDURE PR_DESIGNATION_UPDATE
	@DEGID INT,
	@DEGNAME VARCHAR(100)
AS 
BEGIN
	UPDATE DESIGNATION
	SET 
	DESIGNATIONNAME=@DEGNAME
	WHERE 
	DESIGNATIONID = @DEGID
END

CREATE OR ALTER PROCEDURE PR_PERSON_UPDATE
	@PID INT,
	@PFIRSTNAME VARCHAR(100),
	@PLASTNAME VARCHAR(100),
	@PSALARY DECIMAL(8,2),
	@PJOININGDT DATETIME,
	@PDEPTID INT,
	@PDEGID INT
AS 
BEGIN
	UPDATE PERSON
	SET 
	FIRSTNAME=@PFIRSTNAME ,
	LASTNAME=@PLASTNAME ,
	SALARY=@PSALARY ,
	JOININGDATE=@PJOININGDT,
	DEPARTMENTID=@PDEPTID ,
	DESIGNATIONID=@PDEGID 
	WHERE 
	PERSONID = @PID
END

EXEC PR_PERSON_UPDATE 102,'DISHA','ANDRAPIYA',85000,'2005-08-23',2,15
SELECT * FROM PERSON

	
--2. Department, Designation & Person Table’s SELECTBYPRIMARYKEY
CREATE OR ALTER PROCEDURE PR_PERSON_SELECTBYPRIMARYKEY
	@PID INT
AS
BEGIN
	SELECT *FROM Person 
	WHERE PERSONID = @PID
END
EXEC PR_PERSON_SELECTBYPRIMARYKEY 102
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_SELECTBYPRIMARYKEY
	@DEPTID INT
AS
BEGIN
	SELECT *FROM Department 
	WHERE DepartmentID = @DEPTID
END
EXEC PR_DEPARTMENT_SELECTBYPRIMARYKEY 2
CREATE OR ALTER PROCEDURE PR_DESIGNATION_SELECTBYPRIMARYKEY
	@DID INT
AS
BEGIN
	SELECT *FROM Designation 
	WHERE DesignationID = @DID
END
EXEC PR_DESIGNATION_SELECTBYPRIMARYKEY 13

--3. Department, Designation & Person Table’s (If foreign key is available then do write join and take columns on select list)
CREATE OR ALTER PROCEDURE PR_ALLTABLEJOIN
AS
BEGIN
	SELECT *FROM Person JOIN Department ON PERSON.PersonID = Department.DepartmentID
	JOIN Designation ON Department.DepartmentID = Designation.DesignationID
END
EXEC PR_ALLTABLEJOIN

--4. Create a Procedure that shows details of the first 3 persons.
CREATE OR ALTER PROCEDURE PR_FIRST_3_PERSON
AS
BEGIN
	SELECT TOP 3 Person.PersonID,Person.FirstName, Person.LastName, Person.Salary, person.JoiningDate, Department.DepartmentName, Designation.DesignationName FROM Person JOIN Department ON PERSON.PersonID = Department.DepartmentID
	JOIN Designation ON Department.DepartmentID = Designation.DesignationID
END
EXEC PR_FIRST_3_PERSON

--Part – B
--5. Create a Procedure that takes the department name as input and returns a table with all workers
--working in that department.
	CREATE OR ALTER PROCEDURE PR_DEPARTMENT_EMPLIST
	@DEPTNAME VARCHAR(20)
	AS 
	BEGIN
		SELECT P.FirstName, P.LastName, D.DepartmentName 
		FROM Person P JOIN Department D
		ON P.DepartmentID = D.DepartmentID
		WHERE D.DepartmentName = @DEPTNAME
	END

	EXEC PR_DEPARTMENT_EMPLIST 'IT'

--6. Create Procedure that takes department name & designation name as input and returns a table with
--worker’s first name, salary, joining date & department name.
	CREATE OR ALTER PROCEDURE PR_DEP_DESI_EMPLIST
	@DEPTNAME VARCHAR(20),
	@DESINAME VARCHAR(20)
	AS 
	BEGIN
		SELECT P.FirstName, P.LastName, P.Salary, P.JoiningDate ,D.DepartmentName
		FROM Person P JOIN Department D
		ON P.DepartmentID = D.DepartmentID
		JOIN Designation B
		ON P.DesignationID = B.DesignationID
		WHERE D.DepartmentName = @DEPTNAME AND B.DesignationName = @DESINAME
	END

	EXEC PR_DEP_DESI_EMPLIST 'IT','Jobber'


--7. Create a Procedure that takes the first name as an input parameter and display all the details of the
--worker with their department & designation name.

	CREATE OR ALTER PROCEDURE PR_EMPLIST
	@NAME VARCHAR(20)
	AS 
	BEGIN
		SELECT P.FirstName, P.LastName, P.Salary, P.JoiningDate ,D.DepartmentName, B.DesignationName
		FROM Person P JOIN Department D
		ON P.DepartmentID = D.DepartmentID
		JOIN Designation B
		ON P.DesignationID = B.DesignationID
		WHERE P.FirstName = @NAME
	END

	EXEC PR_EMPLIST 'Disha'

--8. Create Procedure which displays department wise maximum, minimum & total salaries.
	CREATE OR ALTER PROCEDURE PR_EMPLIST
	AS 
	BEGIN
		SELECT D.DepartmentName, MAX(P.Salary) AS MAXSALARY,MIN(P.Salary) AS MINSALARY,SUM(P.Salary) AS TOTALSALARY
		FROM Person P JOIN Department D
		ON P.DepartmentID = D.DepartmentID
		GROUP BY D.DepartmentName
	END

	EXEC PR_EMPLIST
	
--9. Create Procedure which displays designation wise average & total salaries.

	CREATE OR ALTER PROCEDURE PR_DESIGNATION_WISE_SALARY
	AS
	BEGIN
		SELECT  AVG(P.SALARY) AS AVG_SALARY, SUM(P.SALARY) AS TOTAL_SALARY, D.DesignationName
		FROM PERSON P
		JOIN Designation D ON P.DepartmentID=D.DesignationID
		GROUP BY D.DesignationName
	END

--Part – C
--10. Create Procedure that Accepts Department Name and Returns Person Count.

	CREATE OR ALTER PROCEDURE PR_PERSON_COUNT
	@DEPTNAME VARCHAR(100)
	AS
	BEGIN
		SELECT D.DepartmentName, COUNT(P.PersonID) FROM PERSON P
		JOIN Department D ON P.DepartmentID=D.DepartmentID
		GROUP BY D.DepartmentName
	END
	
--11. Create a procedure that takes a salary value as input and returns all workers with a salary greater than
--input salary value along with their department and designation details.
	CREATE OR ALTER PROCEDURE PR_PERSON_BY_SALARY
	@SALARY DECIMAL(8,2)
	AS
	BEGIN
		SELECT P.FirstName,P.LastName,P.Salary,P.JoiningDate,D.DepartmentName,DS.DesignationName FROM PERSON P
		JOIN Department D ON P.DepartmentID=D.DepartmentID
		JOIN Designation DS ON P.DesignationID=DS.DesignationID
		WHERE P.SALARY>@SALARY
	END
--12. Create a procedure to find the department(s) with the highest total salary among all departments.
	CREATE OR ALTER PROCEDURE PR_DEPARTMENT_WITH_HIGHEST_SAL
	AS
	BEGIN
		 SELECT d.DepartmentName FROM Department d
        WHERE d.DepartmentID = (
        SELECT TOP 1 p.DepartmentID
        FROM Person p
        WHERE p.Salary = (SELECT MAX(Salary) FROM Person)
    );
	END
--13. Create a procedure that takes a designation name as input and returns a list of all workers under that
--designation who joined within the last 10 years, along with their department.

CREATE OR ALTER PROCEDURE PR_PERSON_BY_DESIGNATION
@DNAME VARCHAR(100)
AS
BEGIN
	SELECT P.FirstName,P.LastName,P.Salary,P.JoiningDate,D.DepartmentName,DS.DesignationName FROM PERSON P 
	JOIN DESIGNATION DS ON P.DesignationID=DS.DesignationID
	JOIN DEPARTMENT D ON P.DepartmentID=D.DepartmentID
	WHERE DS.DesignationName=@DNAME AND P.JoiningDate>= DATEADD(YEAR, -10, GETDATE())
END

--14. Create a procedure to list the number of workers in each department who do not have a designation
--assigned.
	CREATE PROCEDURE PR_PERSON_WITHOUT_DESIGNATION
	AS
	BEGIN
		SELECT D.DepartmentName,COUNT(*) FROM Person P
		JOIN Department D ON P.DepartmentID = D.DepartmentID
		WHERE P.DesignationID IS NULL
		GROUP BY D.DepartmentName
	END
--15. Create a procedure to retrieve the details of workers in departments where the average salary is above
--12000.CREATE PROCEDURE PR_PERSON_AVGSAL_MORE_THAN_12000
AS
BEGIN
    SELECT 
        P.FirstName,
        P.LastName,
        P.Salary,
        P.JoiningDate,
        D.DepartmentName
    FROM 
        Person P
    JOIN 
        Department D ON P.DepartmentID = D.DepartmentID
    WHERE 
        P.DepartmentID IN (
            SELECT P1.DepartmentID
            FROM Person P1
            GROUP BY P1.DepartmentID
            HAVING AVG(P1.Salary) > 12000
        );
END;