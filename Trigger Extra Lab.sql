--AFTER Trigger
CREATE TABLE EMPLOYEEDETAILS
(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
)

CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
	EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
)

--1)Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to display the message "Employee record inserted", "Employee record updated", "Employee record deleted"
CREATE TRIGGER TR_INSERT_EXT
ON EMPLOYEEDETAILS
AFTER INSERT
AS
BEGIN
	PRINT 'Employee record inserted'
END

CREATE TRIGGER TR_UPDATE_EXT
ON EMPLOYEEDETAILS
AFTER UPDATE
AS
BEGIN
	PRINT 'Employee record updated'
END

CREATE TRIGGER TR_DELETE_EXT
ON EMPLOYEEDETAILS
AFTER DELETE
AS
BEGIN
	PRINT 'Employee record deleted'
END

--2)Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to log all operations into the EmployeeLog table.
CREATE TRIGGER tr_EmployeeDetails_after_Insert
ON EMPLOYEEDETAILS
AFTER INSERT
AS
BEGIN
	Declare @EmpID int;
	Declare @EmpName varchar(100);

	select @EmpID = EmployeeID from inserted
	Select @EmpName = EmployeeName from inserted

	Insert into EmployeeLogs
	values(@EmpID, @EmpName, 'Insert', getdate())

END;

CREATE TRIGGER tr_EmployeeDetails_after_Update
ON EMPLOYEEDETAILS
AFTER Update
AS
BEGIN
	Declare @EmpID int;
	Declare @EmpName varchar(100);

	select @EmpID = EmployeeID from inserted
	Select @EmpName = EmployeeName from inserted

	Insert into EmployeeLogs
	values(@EmpID, @EmpName, 'Update', getdate())

END;

CREATE TRIGGER tr_EmployeeDetails_after_Delete
ON EMPLOYEEDETAILS
AFTER Delete
AS
BEGIN
	Declare @EmpID int;
	Declare @EmpName varchar(100);

	select @EmpID = EmployeeID from inserted
	Select @EmpName = EmployeeName from inserted

	Insert into EmployeeLogs
	values(@EmpID, @EmpName, 'Delete', getdate())

END;

--3)Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary) for new employees and update a bonus column in the EmployeeDetails table.
	CREATE TRIGGER TR_BONUS
	ON EMPLOYEEDETAILS
	AFTER INSERT
	AS
	BEGIN
		declare @empId int;
		select @empId= EmployeeID from inserted
	
		Update EmployeeDetails
		set Salary = Salary + Salary*0.1
		where EmployeeID = @empId

	END

--4)Create a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.
	CREATE TRIGGER TR_DATE
	ON EMPLOYEEDETAILS
	AFTER INSERT
	AS
	BEGIN
		declare @empId int;
		declare @JoiningDate datetime;
		select @empId= EmployeeID from inserted;
		select @JoiningDate = JoiningDate from inserted

		if @JoiningDate IS Null
			BEGIN
				Update EMPLOYEEDETAILS
				set JoiningDate = getdate()
				where EmployeeID = @empId 
			END

	END

--5)Create a trigger that ensure that ContactNo is valid during insert and update (Like ContactNo length is 10)
	CREATE TRIGGER TR_VALIDCONTACT
	ON EMPLOYEEDETAILS
	AFTER INSERT,UPDATE
	AS
	BEGIN
		declare @empId int;
		declare @Contact datetime;
		select @empId= EmployeeID from inserted;
		select @Contact = ContactNo from inserted

		if Len(@Contact)=10
		BEGIN
			print'VALID';
		END
		ELSE
		BEGIN
			PRINT 'NOTE VALID'
		END
	END

--Instead of Trigger

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(255) NOT NULL,
    ReleaseYear INT NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Rating DECIMAL(3, 1) NOT NULL,
    Duration INT NOT NULL
);

CREATE TABLE MoviesLog
(
	LogID INT PRIMARY KEY IDENTITY(1,1),
	MovieID INT NOT NULL,
	MovieTitle VARCHAR(255) NOT NULL,
	ActionPerformed VARCHAR(100) NOT NULL,
	ActionDate	DATETIME  NOT NULL
);
SELECT *FROM Movies

--1.Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the Movies table. For that, log all operations performed on the Movies table into MoviesLog.
	CREATE or alter TRIGGER tr_Movie_insted_Insert
	ON Movies
	Instead of INSERT
	AS
	BEGIN
		Declare @movieId int;
		Declare @title varchar(100);

		select @movieId = movieId from inserted
		Select @title = movietitle from inserted

		Insert into MoviesLog
		values(@movieId, @title, 'Insert', getdate())

	END;

	CREATE TRIGGER tr_Movie_instead_update
	ON Movies
	Instead of update
	AS
	BEGIN
		Declare @movieId int;
		Declare @title varchar(100);

		select @movieId = movieId from inserted
		Select @title = movietitle from inserted

		Insert into MoviesLog
		values(@movieId, @title, 'Update', getdate())

	END;

	CREATE TRIGGER tr_Movie_instead_Delete
	ON Movies
	Instead of Delete
	AS
	BEGIN
		Declare @movieId int;
		Declare @title varchar(100);

		select @movieId = movieId from inserted
		Select @title = movietitle from inserted

		Insert into MoviesLog
		values(@movieId, @title, 'Delete', getdate())

	END;
--2.Create a trigger that only allows to insert movies for which Rating is greater than 5.5 .
	CREATE or alter TRIGGER tr_Movie_instead_Insert_Rating
	ON Movies
	Instead of INSERT
	AS
	BEGIN

		INSERT INTO MoviesLog (MovieID, MovieTitle,  ReleaseYear,Genre, Rating,duration)
        SELECT MovieID, MovieTitle, ReleaseYear,Genre, Rating,duration
        FROM inserted
		where Rating>5.5;
		
	END;
--3.Create trigger that prevent duplicate 'MovieTitle' of Movies table and log details of it in MoviesLog table.
Create or alter trigger tr_Insteadof_insert_Movie_duplicate
on Movies
instead of Insert
as
begin
	INSERT INTO Movies (MovieID, MovieTitle,  ReleaseYear,Genre, Rating,duration)
        SELECT MovieID, MovieTitle, ReleaseYear,Genre, Rating,duration
        FROM inserted
		where MovieTitle Not In (Select MovieTitle from inserted);

end


--4.Create trigger that prevents to insert pre-release movies.
Create or alter trigger tr_Insteadof_insert_Movie_PreRelease
on Movies
instead of Insert
as
begin
	INSERT INTO Movies (MovieID, MovieTitle,  ReleaseYear,Genre, Rating,duration)
        SELECT MovieID, MovieTitle, ReleaseYear,Genre, Rating,duration
        FROM inserted
		where Year(ReleaseYear)>Year(GetDate());

end


--5.Develop a trigger to ensure that the Duration of a movie cannot be updated to a value greater than 120 minutes (2 hours) to prevent unrealistic entries.
Create or alter trigger tr_Insteadof_insert_Movie_Duration
on Movies
instead of Insert
as
begin
	INSERT INTO Movies (MovieID, MovieTitle,  ReleaseYear,Genre, Rating,duration)
        SELECT MovieID, MovieTitle, ReleaseYear,Genre, Rating,duration
        FROM inserted
		where Duration>120;

end