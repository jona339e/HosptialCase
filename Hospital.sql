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

CREATE TABLE L�ge(
id int IDENTITY(1,1) PRIMARY KEY,
[L�ge Fornavn] nvarchar(255),
[L�ge Efternavn] nvarchar(255),
AfdelingId int FOREIGN KEY REFERENCES Afdeling(id)
);


CREATE TABLE Patient(
Id int identity(1,1) PRIMARY KEY,
[Patient Fornavn] nvarchar(255),
[Patient Efternavn] nvarchar(255),
[Patient Tlf.] int,
);


CREATE TABLE L�gePatient (
    PatientId INT FOREIGN KEY REFERENCES Patient(Id),
    L�geId INT FOREIGN KEY REFERENCES L�ge(Id),
    PRIMARY KEY (PatientId, L�geId)
);

CREATE TABLE ServerMessage(
Id int IDENTITY(1,1) primary key,
msg nvarchar(255)
);



-- INSERTS

INSERT INTO Afdeling VALUES('Akutafdeling');
INSERT INTO Afdeling VALUES('Bed�velse og Intensiv');
INSERT INTO Afdeling VALUES('B�rne- og Ungeafdeling');
INSERT INTO Afdeling VALUES('Hjerne- og Nervesygdomme');
INSERT INTO Afdeling VALUES('Radiologi');
INSERT INTO Afdeling VALUES('Kirugi');

insert into L�ge values ('Tobiah', 'Garstang', 1);
insert into L�ge values ('Tiphany', 'Hebburn', 2);
insert into L�ge  values ('Myrilla', 'Mountford', 3);
insert into L�ge  values ('Benson', 'Jouaneton', 4);
insert into L�ge  values ('Vaclav', 'Belford', 5);
insert into L�ge  values ('Nona', 'Coggles', 6);
insert into L�ge  values ('Maxim', 'Kyncl', 1);
insert into L�ge values ('Dallon', 'Caen', 2);
insert into L�ge  values ('Dorree', 'Greeson', 3);
insert into L�ge  values ('Tybie', 'Walklett', 4);


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


INSERT INTO L�gePatient VALUES(1, 1);
INSERT INTO L�gePatient VALUES(2, 2);
INSERT INTO L�gePatient VALUES(3, 3);
INSERT INTO L�gePatient VALUES(4, 4);
INSERT INTO L�gePatient VALUES(5, 5);
INSERT INTO L�gePatient VALUES(6, 6);
INSERT INTO L�gePatient VALUES(7, 7);
INSERT INTO L�gePatient VALUES(8, 8);
INSERT INTO L�gePatient VALUES(9, 9);
INSERT INTO L�gePatient VALUES(10, 10);
INSERT INTO L�gePatient VALUES(11, 7);
INSERT INTO L�gePatient VALUES(12, 8);
INSERT INTO L�gePatient VALUES(13, 9);

-- Opgave 6
USE [Patient Database]
GO
GO
CREATE VIEW PatientKontakt AS
	SELECT CONCAT(Patient.[Patient Fornavn], ' ', Patient.[Patient Efternavn]) as [Patient Navn], 
		Patient.[Patient Tlf.], CONCAT(L�ge.[L�ge Fornavn], ' ', L�ge.[L�ge Efternavn]) as [L�ge Navn],
		Afdeling.Afdeling FROM L�gePatient
			JOIN Patient on L�gePatient.PatientId = Patient.Id
			JOIN L�ge on L�gePatient.L�geId = L�ge.id
			JOIN Afdeling on L�ge.AfdelingId = Afdeling.ID

GO
CREATE VIEW PatientL�geAfdeling AS
SELECT CONCAT(Patient.[Patient Fornavn], ' ', Patient.[Patient Efternavn]) as [Patient Navn], CONCAT(L�ge.[L�ge Fornavn], ' ', L�ge.[L�ge Efternavn]) as [L�ge Navn],
		Afdeling.Afdeling FROM L�gePatient
			JOIN Patient on L�gePatient.PatientId = Patient.Id
			JOIN L�ge on L�gePatient.L�geId = L�ge.id
			JOIN Afdeling on L�ge.AfdelingId = Afdeling.ID
GO
Create View AmountOfL�ge AS
SELECT CONCAT(Patient.[Patient Fornavn], ' ', Patient.[Patient Efternavn]) as [Patient Navn], COUNT(L�gePatient.L�geId) AS [Antal L�ger]
	FROM Patient  
	JOIN
    L�gePatient ON Patient.Id = L�gePatient.PatientId
	GROUP BY
    Patient.Id, Patient.[Patient Fornavn], Patient.[Patient Efternavn];
GO
CREATE VIEW AmountOfPatient AS
	SELECT CONCAT(L�ge.[L�ge Fornavn], ' ', L�ge.[L�ge Efternavn]) as [L�ge Navn], COUNT(L�gePatient.PatientId) AS [Antal Patienter]
	From L�ge
	JOIN L�gePatient on L�ge.id = L�gePatient.L�geId
	Group by
	L�ge.id, L�ge.[L�ge Fornavn], L�ge.[L�ge Efternavn];

GO


SELECT * FROM PatientKontakt
SELECT * FROM PatientL�geAfdeling
SELECT * FROM AmountOfL�ge
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
    @L�geFornavn nvarchar(255),
    @L�geEfternavn nvarchar(255)

)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @L�geId int;
    
    -- Insert patient into the Patient table
    INSERT INTO Patient ([Patient Fornavn], [Patient Efternavn], [Patient Tlf.], Alder)
    VALUES (@PatientFornavn, @PatientEfternavn, @PatientTlf, @Alder);
    
    -- Retrieve the matching doctor's ID from the L�ge table
    SELECT @L�geId = id
    FROM L�ge
    WHERE [L�ge Fornavn] = @L�geFornavn AND [L�ge Efternavn] = @L�geEfternavn;
    
    -- Insert the patient ID and doctor ID into the L�gePatient table
    INSERT INTO L�gePatient (PatientId, L�geId)
    VALUES (SCOPE_IDENTITY(), @L�geId);
END;





GO
CREATE TRIGGER tr_CheckPatientCount
ON L�gePatient
AFTER INSERT
AS
BEGIN
    -- Variables
    DECLARE @L�geId INT;
    DECLARE @PatientCount INT;
    DECLARE @L�geFornavn NVARCHAR(255);
    DECLARE @L�geEfternavn NVARCHAR(255);
    DECLARE @Message NVARCHAR(1000);

    -- Get the inserted L�geId
    SELECT @L�geId = L�geId
    FROM inserted;

    -- Get the L�ge details
    SELECT @L�geFornavn = [L�ge Fornavn],
           @L�geEfternavn = [L�ge Efternavn]
    FROM L�ge
    WHERE id = @L�geId;

    -- Count the number of patients for the L�geId
    SELECT @PatientCount = COUNT(*)
    FROM L�gePatient
    WHERE L�geId = @L�geId;

    -- Check if the L�ge has 3 or more patients
    IF @PatientCount >= 3
    BEGIN
        -- Create the message
        SET @Message = CONCAT('L�ge ', @L�geFornavn, ' ', @L�geEfternavn, ' har ', @PatientCount, ' patienter.');

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
    @L�geFornavn = 'Tiphany',
    @L�geEfternavn = 'Hebburn';

exec usp_registration_insert
    @PatientFornavn = 'John',
    @PatientEfternavn = 'Skovgaard',
    @PatientTlf = 12345678,
	@alder = 44,
    @L�geFornavn = 'Tiphany',
    @L�geEfternavn = 'Hebburn';

exec usp_registration_insert
    @PatientFornavn = 'Lone',
    @PatientEfternavn = 'M�ller',
    @PatientTlf = 55389482,
	@alder = 58,
    @L�geFornavn = 'Tiphany',
    @L�geEfternavn = 'Hebburn';



-- opgave 12
GO
USE [Patient Database]
GO
CREATE VIEW PatientAfdeling AS
SELECT CONCAT(Patient.[Patient Fornavn], ' ', Patient.[Patient Efternavn]) as [Patient Navn], Afdeling.Afdeling From L�gePatient
			JOIN Patient on L�gePatient.PatientId = Patient.Id
			JOIN L�ge on L�gePatient.L�geId = L�ge.id
			JOIN Afdeling on L�ge.AfdelingId = Afdeling.ID
GO

CREATE LOGIN KlinikAssistent WITH PASSWORD = 'Assistent';


CREATE USER KlinikAssistent FOR LOGIN KlinikAssistent;

GRANT SELECT on PatientAfdeling TO KlinikAssistent;

