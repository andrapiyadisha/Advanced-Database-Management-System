-- Creating PersonInfo Table
CREATE TABLE PersonInfo (
 PersonID INT PRIMARY KEY,
 PersonName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8,2) NOT NULL,
 JoiningDate DATETIME NULL,
 City VARCHAR(100) NOT NULL,
 Age INT NULL,
 BirthDate DATETIME NOT NULL
);
-- Creating PersonLog Table
CREATE TABLE PersonLog (
 PLogID INT PRIMARY KEY IDENTITY(1,1),
 PersonID INT NOT NULL,
 PersonName VARCHAR(250) NOT NULL,
 Operation VARCHAR(50) NOT NULL,
 UpdateDate DATETIME NOT NULL,
);

--Part – A

--1. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display
--a message “Record is Affected.”
  --Insert
Create Trigger TR_Insert
on PersonInfo
After Insert,update,Delete
As
Begin 
	print 'Record is Affected'
End;
--2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that,
--log all operations performed on the person table into PersonLog.
CREATE TRIGGER tr_Person_after_Insert
ON PersonInfo
AFTER INSERT
AS
BEGIN
	DECLARE @PersonID int;
	DECLARE @PersonName varchar(max)

	select @PersonID = PersonID from inserted
	select @PersonName = PersonName from inserted

	Insert into PersonLog values (@PersonID, @PersonName, 'INSERT', GETDATE());
END;

CREATE TRIGGER tr_Person_after_Update
ON PersonInfo
AFTER update
AS
BEGIN
	DECLARE @PersonID int;
	DECLARE @PersonName varchar(max)

	select @PersonID = PersonID from inserted
	select @PersonName = PersonName from inserted

	Insert into PersonLog values (@PersonID, @PersonName, 'Update', GETDATE());
END;

CREATE TRIGGER tr_Person_after_Delete
ON PersonInfo
AFTER DELETE
AS
BEGIN
	DECLARE @PersonID int;
	DECLARE @PersonName varchar(max)

	select @PersonID = PersonID from inserted
	select @PersonName = PersonName from inserted

	Insert into PersonLog values (@PersonID, @PersonName, 'DELETE', GETDATE());
END;

--3. Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo
--table. For that, log all operations performed on the person table into PersonLog.
CREATE TRIGGER tr_Person_instead_Operation
ON PersonInfo
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	INSERT INTO PersonLog
	SELECT PersonID, PersonName, 'INSTEAD OF OPERATION', GETDATE() FROM inserted;
END;
--4. Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into
--uppercase whenever the record is inserted.
CREATE TRIGGER tr_Person_after_Insert_Name_Uppercase
ON PersonInfo
AFTER INSERT
AS
BEGIN
	UPDATE PersonInfo
	SET PersonName = UPPER(PersonName)
	WHERE PersonID IN (SELECT PersonID FROM inserted);
END;
--5. Create trigger that prevent duplicate entries of person name on PersonInfo table.
CREATE TRIGGER tr_Prevent_Duplicate_Name
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM PersonInfo P INNER JOIN inserted I ON P.PersonName = I.PersonName)
    BEGIN
        PRINT 'Duplicate PersonName is not allowed';
    END
    ELSE
    BEGIN
        INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
        SELECT PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate FROM inserted;
    END
END;

--6. Create trigger that prevent Age below 18 years.
CREATE TRIGGER tr_Prevent_Underage
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM inserted WHERE Age < 18)
	BEGIN
		PRINT 'Age must be 18 or older';
	END
	ELSE
	BEGIN
		INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
		SELECT PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate FROM inserted;
	END
END;

--Part – B

--7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update
--that age in Person table.
CREATE TRIGGER tr_Person_after_Insert_Calculates_age_Update
ON PersonInfo
AFTER INSERT
AS
BEGIN 
	update PersonInfo
	set Age = DATEDIFF(YEAR,BIRTHDATE,GETDATE())
	where PersonID IN (SELECT PersonID FROM INSERTED)

END;

--8. Create a Trigger to Limit Salary Decrease by a 10%.
CREATE TRIGGER tr_Person_after_Insert_Limit_Decrease
ON PersonInfo
AFTER INSERT
AS
BEGIN 
	DECLARE @PersonID int, @newSalary int, @oldSalary int;

	update PersonInfo
	set Salary = Salary - (Salary*0.1)
	where PersonID = @PersonID
	
	select @newSalary = Salary from inserted
	select @oldSalary = Salary from deleted

	if @newSalary < @oldSalary*0.9
	Begin
		update PersonInfo
		set Salary = @oldSalary 
		where PersonID = @PersonID
	End

END;

--Part – C

--9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL
--during an INSERT.
CREATE TRIGGER tr_Person_Date_Diffrence
ON PersonInfo
AFTER INSERT
AS
BEGIN
	DECLARE @PersonID int;
	DECLARE @joiningdate datetime;

	select @PersonID = PersonID from inserted
	select @joiningdate = JoiningDate from inserted

    if @joiningdate is null
	begin
		update PersonInfo
		set JoiningDate = GETdate()
		where PersonID = @PersonID 
	end

END

--10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints
--‘Record deleted successfully from PersonLog’.Create Trigger TR_Delete_PersonLog
on PersonLog
After Delete
As
Begin 
	print 'Record deleted successfully from PersonLog'
End;