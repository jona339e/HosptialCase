-- Opgave 1

--Hardware requirements for sql server 2022
--
--Minimum 6gb storage
--Memory min: 1gb, recommended: 4gb
--processor speed min: 1.4ghz, recommended: 2.0ghz or faster
--Processor type 64 bit processor required for 2022 server. AMD Opteron, AMD Athlon 64, Intel Xeon with Intel EM64T support, Intel Pentium IV with EM64T support
--
--AMD Athlon 64 came out in 2003 and was discontinued in 2009
--in 2023 any newer computer should easily be able to run sql server 2022
-- 
-- the laptop given by the school has 8gb memory
-- the cpu has 1.60Ghz and 4 cores.
-- the storage has a capacity of 250gb
--
-- these are all over the minimum requirements needed to run sql server 2022


-- Opgave 2, 5 & 10

USE master
GO
CREATE DATABASE [Patient Database]
GO
USE [Patient Database]
GO


GO
-- Create the login for the admin user
CREATE LOGIN Niels WITH PASSWORD = 'Passw0rd';
GO

-- Grant administrative rights to the login
ALTER SERVER ROLE sysadmin ADD MEMBER Niels;
GO

-- Create the user in the database and assign necessary permissions

CREATE USER Niels FOR LOGIN Niels;
GO

ALTER ROLE db_owner ADD MEMBER Niels;
GO


CREATE LOGIN Ole WITH PASSWORD = 'Passw0rd';
GO

-- Create the read-only user in the database and assign necessary permissions

CREATE USER Ole FOR LOGIN Ole;
GO

ALTER ROLE db_datareader ADD MEMBER Ole;
GO


use msdb
GO
CREATE USER Niels FOR LOGIN Niels;
GO

EXEC sp_addrolemember 'SQLAgentOperatorRole', 'Niels';
GO



-- opgave 3
use [Patient Database]
GO


EXEC xp_instance_regread 
    'HKEY_LOCAL_MACHINE',
    'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Np'
GO
EXEC xp_instance_regread
    'HKEY_LOCAL_MACHINE',
    'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Tcp'

GO
-- Sets dac to true (1)
EXEC sp_configure 'remote admin connections', 1;
RECONFIGURE;

-- Views dac configuration
GO
EXEC sp_configure 'remote admin connections';

GO
-- sets backup compression to true (1)
EXEC sp_configure 'backup compression default', 1;
RECONFIGURE WITH OVERRIDE;

GO
-- views backup compressions configuration
EXEC sp_configure 'backup compression default';


-- Opgave 4
USE [Patient Database]
GO

CREATE TABLE Afdeling(
ID int IDENTITY(1,1) PRIMARY KEY,
Afdeling nvarchar(255),
);

CREATE TABLE Læge(
id int IDENTITY(1,1) PRIMARY KEY,
[Læge Fornavn] nvarchar(255),
[Læge Efternavn] nvarchar(255),
AfdelingId int FOREIGN KEY REFERENCES Afdeling(id)
);


CREATE TABLE Patient(
Id int identity(1,1) PRIMARY KEY,
[Patient Fornavn] nvarchar(255),
[Patient Efternavn] nvarchar(255),
[Patient Tlf.] int,
);


CREATE TABLE LægePatient (
    PatientId INT FOREIGN KEY REFERENCES Patient(Id),
    LægeId INT FOREIGN KEY REFERENCES Læge(Id),
    PRIMARY KEY (PatientId, LægeId)
);

CREATE TABLE ServerMessage(
Id int IDENTITY(1,1) primary key,
msg nvarchar(255)
);



-- INSERTS

INSERT INTO Afdeling VALUES('Akutafdeling');
INSERT INTO Afdeling VALUES('Bedøvelse og Intensiv');
INSERT INTO Afdeling VALUES('Børne- og Ungeafdeling');
INSERT INTO Afdeling VALUES('Hjerne- og Nervesygdomme');
INSERT INTO Afdeling VALUES('Radiologi');
INSERT INTO Afdeling VALUES('Kirugi');

insert into Læge values ('Tobiah', 'Garstang', 1);
insert into Læge values ('Tiphany', 'Hebburn', 2);
insert into Læge  values ('Myrilla', 'Mountford', 3);
insert into Læge  values ('Benson', 'Jouaneton', 4);
insert into Læge  values ('Vaclav', 'Belford', 5);
insert into Læge  values ('Nona', 'Coggles', 6);
insert into Læge  values ('Maxim', 'Kyncl', 1);
insert into Læge values ('Dallon', 'Caen', 2);
insert into Læge  values ('Dorree', 'Greeson', 3);
insert into Læge  values ('Tybie', 'Walklett', 4);


INSERT INTO Patient VALUES('Kristien', 'Cawthorn', 43188911);
INSERT INTO Patient VALUES('Cicily', 'Maffeo', 96375407 );
INSERT INTO Patient VALUES('Jerrie', 'Gronous', 78361915);
INSERT INTO Patient VALUES('Quinn', 'Greensides', 42898722);
INSERT INTO Patient VALUES('Jerrie', 'Farre', 24259809);
INSERT INTO Patient VALUES('Chickie', 'Gammet', 55578814);
INSERT INTO Patient VALUES('Evvie', 'Stewartson', 87929697);
INSERT INTO Patient VALUES('Misti', 'Beare', 53077407);
INSERT INTO Patient VALUES('Philipa', 'Benardeau', 59530431);
INSERT INTO Patient VALUES('Jerrie', 'Maffeo', 76789827);
INSERT INTO Patient VALUES('Quinn', 'Stewartson', 76788792);
INSERT INTO Patient VALUES('Cicily', 'Poundsford', 98099827);
INSERT INTO Patient VALUES('Kristien', 'Gammet', 43189827);


INSERT INTO LægePatient VALUES(1, 1);
INSERT INTO LægePatient VALUES(2, 2);
INSERT INTO LægePatient VALUES(3, 3);
INSERT INTO LægePatient VALUES(4, 4);
INSERT INTO LægePatient VALUES(5, 5);
INSERT INTO LægePatient VALUES(6, 6);
INSERT INTO LægePatient VALUES(7, 7);
INSERT INTO LægePatient VALUES(8, 8);
INSERT INTO LægePatient VALUES(9, 9);
INSERT INTO LægePatient VALUES(10, 10);
INSERT INTO LægePatient VALUES(11, 7);
INSERT INTO LægePatient VALUES(12, 8);
INSERT INTO LægePatient VALUES(13, 9);

-- Opgave 6
USE [Patient Database]
GO
GO
CREATE VIEW PatientKontakt AS
	SELECT CONCAT(Patient.[Patient Fornavn], ' ', Patient.[Patient Efternavn]) as [Patient Navn], 
		Patient.[Patient Tlf.], CONCAT(Læge.[Læge Fornavn], ' ', Læge.[Læge Efternavn]) as [Læge Navn],
		Afdeling.Afdeling FROM LægePatient
			JOIN Patient on LægePatient.PatientId = Patient.Id
			JOIN Læge on LægePatient.LægeId = Læge.id
			JOIN Afdeling on Læge.AfdelingId = Afdeling.ID

GO
CREATE VIEW PatientLægeAfdeling AS
SELECT CONCAT(Patient.[Patient Fornavn], ' ', Patient.[Patient Efternavn]) as [Patient Navn], CONCAT(Læge.[Læge Fornavn], ' ', Læge.[Læge Efternavn]) as [Læge Navn],
		Afdeling.Afdeling FROM LægePatient
			JOIN Patient on LægePatient.PatientId = Patient.Id
			JOIN Læge on LægePatient.LægeId = Læge.id
			JOIN Afdeling on Læge.AfdelingId = Afdeling.ID
GO
Create View AmountOfLæge AS
SELECT CONCAT(Patient.[Patient Fornavn], ' ', Patient.[Patient Efternavn]) as [Patient Navn], COUNT(LægePatient.LægeId) AS [Antal Læger]
	FROM Patient  
	JOIN
    LægePatient ON Patient.Id = LægePatient.PatientId
	GROUP BY
    Patient.Id, Patient.[Patient Fornavn], Patient.[Patient Efternavn];
GO
CREATE VIEW AmountOfPatient AS
	SELECT CONCAT(Læge.[Læge Fornavn], ' ', Læge.[Læge Efternavn]) as [Læge Navn], COUNT(LægePatient.PatientId) AS [Antal Patienter]
	From Læge
	JOIN LægePatient on Læge.id = LægePatient.LægeId
	Group by
	Læge.id, Læge.[Læge Fornavn], Læge.[Læge Efternavn];

GO


SELECT * FROM PatientKontakt
SELECT * FROM PatientLægeAfdeling
SELECT * FROM AmountOfLæge
SELECT * FROM AmountOfPatient


-- opgave 7
USE [Patient Database]
GO
Alter table Patient ADD Alder int;
GO
UPDATE Patient SET Alder = 25 WHERE [Patient Fornavn] = 'Kristien' AND [Patient Efternavn] = 'Cawthorn';
UPDATE Patient SET Alder = 32 WHERE [Patient Fornavn] = 'Cicily' AND [Patient Efternavn] = 'Maffeo';
UPDATE Patient SET Alder = 45 WHERE [Patient Fornavn] = 'Jerrie' AND [Patient Efternavn] = 'Gronous';
UPDATE Patient SET Alder = 37 WHERE [Patient Fornavn] = 'Quinn' AND [Patient Efternavn] = 'Greensides';
UPDATE Patient SET Alder = 50 WHERE [Patient Fornavn] = 'Jerrie' AND [Patient Efternavn] = 'Farre';
UPDATE Patient SET Alder = 28 WHERE [Patient Fornavn] = 'Chickie' AND [Patient Efternavn] = 'Gammet';
UPDATE Patient SET Alder = 41 WHERE [Patient Fornavn] = 'Evvie' AND [Patient Efternavn] = 'Stewartson';
UPDATE Patient SET Alder = 33 WHERE [Patient Fornavn] = 'Misti' AND [Patient Efternavn] = 'Beare';
UPDATE Patient SET Alder = 29 WHERE [Patient Fornavn] = 'Philipa' AND [Patient Efternavn] = 'Benardeau';
UPDATE Patient SET Alder = 29 WHERE [Patient Fornavn] = 'Angelie' AND [Patient Efternavn] = 'Poundsford';
UPDATE Patient SET Alder = 35 WHERE [Patient Fornavn] = 'Jerrie' AND [Patient Efternavn] = 'Maffeo';
UPDATE Patient SET Alder = 42 WHERE [Patient Fornavn] = 'Quinn' AND [Patient Efternavn] = 'Stewartson';
UPDATE Patient SET Alder = 26 WHERE [Patient Fornavn] = 'Cicily' AND [Patient Efternavn] = 'Poundsford';
UPDATE Patient SET Alder = 30 WHERE [Patient Fornavn] = 'Kristien' AND [Patient Efternavn] = 'Gammet';
GO
SELECT AVG(Alder) AS AverageAge FROM Patient;

GO
-- Opgave 8
USE [Patient Database]
GO
CREATE INDEX idx_Patient_Alder ON Patient(Alder);

-- opgave 9
GO
USE [Patient Database]
GO
BACKUP DATABASE [Patient Database] TO DISK ='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\PatientBackup.bak'


go
USE MASTER
GO
DROP DATABASE [Patient Database]

Restore Database [Patient Database] FROM DISK ='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\PatientBackup.bak' with recovery;



-- opgave 10 lav job

GO
USE msdb;
GO

-- Step 1: Create the job
EXEC dbo.sp_add_job
    @job_name = N'admin-job',
    @enabled = 0;

-- Step 2: Define the job schedule
EXEC dbo.sp_add_schedule
    @schedule_name = N'NightSchedule',
    @freq_type = 4, 
	@freq_interval = 1,
    @active_start_time = 033000;

-- Step 3: Attach the schedule to the job
EXEC dbo.sp_attach_schedule
    @job_name = N'admin-job',
    @schedule_name = N'NightSchedule';

-- Step 4: Define the job steps
EXEC dbo.sp_add_jobstep
    @job_name = N'admin-job',
    @step_name = N'Step_1',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE [Patient Database] TO DISK ="C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\PatientBackup.bak"',
    @database_name = N'Patient Database';

-- Step 5: Assign the job to the SQL Server Agent
EXEC dbo.sp_add_jobserver
    @job_name = N'admin-job',
    @server_name = N'(local)';




-- when niels is logged in he can enable the previously created job with these commands
use msdb
GO
UPDATE dbo.sysjobs
SET enabled = 1
WHERE name = 'admin-job';



-- opgave 11

USE [Patient Database]
GO

CREATE PROCEDURE usp_registration_insert
(
    @PatientFornavn nvarchar(255),
    @PatientEfternavn nvarchar(255),
    @PatientTlf int,
	@Alder int,
    @LægeFornavn nvarchar(255),
    @LægeEfternavn nvarchar(255)

)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LægeId int;
    
    -- Insert patient into the Patient table
    INSERT INTO Patient ([Patient Fornavn], [Patient Efternavn], [Patient Tlf.], Alder)
    VALUES (@PatientFornavn, @PatientEfternavn, @PatientTlf, @Alder);
    
    -- Retrieve the matching doctor's ID from the Læge table
    SELECT @LægeId = id
    FROM Læge
    WHERE [Læge Fornavn] = @LægeFornavn AND [Læge Efternavn] = @LægeEfternavn;
    
    -- Insert the patient ID and doctor ID into the LægePatient table
    INSERT INTO LægePatient (PatientId, LægeId)
    VALUES (SCOPE_IDENTITY(), @LægeId);
END;





GO
CREATE TRIGGER tr_CheckPatientCount
ON LægePatient
AFTER INSERT
AS
BEGIN
    -- Variables
    DECLARE @LægeId INT;
    DECLARE @PatientCount INT;
    DECLARE @LægeFornavn NVARCHAR(255);
    DECLARE @LægeEfternavn NVARCHAR(255);
    DECLARE @Message NVARCHAR(1000);

    -- Get the inserted LægeId
    SELECT @LægeId = LægeId
    FROM inserted;

    -- Get the Læge details
    SELECT @LægeFornavn = [Læge Fornavn],
           @LægeEfternavn = [Læge Efternavn]
    FROM Læge
    WHERE id = @LægeId;

    -- Count the number of patients for the LægeId
    SELECT @PatientCount = COUNT(*)
    FROM LægePatient
    WHERE LægeId = @LægeId;

    -- Check if the Læge has 3 or more patients
    IF @PatientCount >= 3
    BEGIN
        -- Create the message
        SET @Message = CONCAT('Læge ', @LægeFornavn, ' ', @LægeEfternavn, ' har ', @PatientCount, ' patienter.');

        -- Insert the message into the ServerMessage table
        INSERT INTO ServerMessage (msg)
        VALUES (@Message);
    END;
END;

exec usp_registration_insert
    @PatientFornavn = 'Aske',
    @PatientEfternavn = 'Jensen',
    @PatientTlf = 10958671,
	@alder = 25,
    @LægeFornavn = 'Tiphany',
    @LægeEfternavn = 'Hebburn';

exec usp_registration_insert
    @PatientFornavn = 'John',
    @PatientEfternavn = 'Skovgaard',
    @PatientTlf = 12345678,
	@alder = 44,
    @LægeFornavn = 'Tiphany',
    @LægeEfternavn = 'Hebburn';

exec usp_registration_insert
    @PatientFornavn = 'Lone',
    @PatientEfternavn = 'Møller',
    @PatientTlf = 55389482,
	@alder = 58,
    @LægeFornavn = 'Tiphany',
    @LægeEfternavn = 'Hebburn';



-- opgave 12
GO
USE [Patient Database]
GO
CREATE VIEW PatientAfdeling AS
SELECT CONCAT(Patient.[Patient Fornavn], ' ', Patient.[Patient Efternavn]) as [Patient Navn], Afdeling.Afdeling From LægePatient
			JOIN Patient on LægePatient.PatientId = Patient.Id
			JOIN Læge on LægePatient.LægeId = Læge.id
			JOIN Afdeling on Læge.AfdelingId = Afdeling.ID
GO

CREATE LOGIN KlinikAssistent WITH PASSWORD = 'Assistent';


CREATE USER KlinikAssistent FOR LOGIN KlinikAssistent;

GRANT SELECT on PatientAfdeling TO KlinikAssistent;

