USE master
GO
CREATE DATABASE [Patient Database]
GO
USE [Patient Database]
GO



CREATE TABLE L�ge(
id int IDENTITY(1,1) PRIMARY KEY,
[L�ge Fornavn] nvarchar(255),
[L�ge Efternavn] nvarchar(255),
);

CREATE TABLE Afdeling(
ID int IDENTITY(1,1) PRIMARY KEY,
Afdeling nvarchar(255),
);

CREATE TABLE Patient(
Id int identity(1,1) PRIMARY KEY,
[Patient Fornavn] nvarchar(255),
[Patient Efternavn] nvarchar(255),
[Patient Tlf.] int,
AfdelingId int FOREIGN KEY REFERENCES afdeling(id)
);

CREATE TABLE L�geAfdeling(
    L�geId INT FOREIGN KEY REFERENCES L�ge(Id),
    AfdelingId INT FOREIGN KEY REFERENCES Afdeling(Id),
    PRIMARY KEY (L�geId, AfdelingId)
);


CREATE TABLE PatientAfdeling (
    PatientId INT FOREIGN KEY REFERENCES Patient(Id),
    AfdelingId INT FOREIGN KEY REFERENCES Afdeling(Id),
    PRIMARY KEY (PatientId, AfdelingId)
);



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
USE [Patient Database];
GO

CREATE USER Ole FOR LOGIN Ole;
GO

ALTER ROLE db_datareader ADD MEMBER Ole;
GO


-- INSERTS



SELECT * FROM Patient
SELECT * FROM L�GE
SELECT * FROM Afdeling

insert into L�ge ([L�ge Fornavn], [L�ge Efternavn]) values ('Tobiah', 'Garstang');
insert into L�ge ([L�ge Fornavn], [L�ge Efternavn]) values ('Tiphany', 'Hebburn');
insert into L�ge ([L�ge Fornavn], [L�ge Efternavn]) values ('Myrilla', 'Mountford');
insert into L�ge ([L�ge Fornavn], [L�ge Efternavn]) values ('Benson', 'Jouaneton');
insert into L�ge ([L�ge Fornavn], [L�ge Efternavn]) values ('Vaclav', 'Belford');
insert into L�ge ([L�ge Fornavn], [L�ge Efternavn]) values ('Nona', 'Coggles');
insert into L�ge ([L�ge Fornavn], [L�ge Efternavn]) values ('Maxim', 'Kyncl');
insert into L�ge ([L�ge Fornavn], [L�ge Efternavn]) values ('Dallon', 'Caen');
insert into L�ge ([L�ge Fornavn], [L�ge Efternavn]) values ('Dorree', 'Greeson');
insert into L�ge ([L�ge Fornavn], [L�ge Efternavn]) values ('Tybie', 'Walklett');




INSERT INTO Afdeling VALUES('Akutafdeling');
INSERT INTO Afdeling VALUES('Bed�velse og Intensiv');
INSERT INTO Afdeling VALUES('B�rne- og Ungeafdeling');
INSERT INTO Afdeling VALUES('Hjerne- og Nervesygdomme');
INSERT INTO Afdeling VALUES('Radiologi');
INSERT INTO Afdeling VALUES('Kirugi');

INSERT INTO Patient VALUES('Kristien', 'Cawthorn', 43188911, 1);
INSERT INTO Patient VALUES('Cicily', 'Maffeo', 96375407 , 2);
INSERT INTO Patient VALUES('Jerrie', 'Gronous', 78361915, 3);
INSERT INTO Patient VALUES('Quinn', 'Greensides', 42898722, 1);
INSERT INTO Patient VALUES('Jerrie', 'Farre', 24259809, 2);
INSERT INTO Patient VALUES('Chickie', 'Gammet', 55578814, 3);
INSERT INTO Patient VALUES('Evvie', 'Stewartson', 87929697, 4);
INSERT INTO Patient VALUES('Misti', 'Beare', 53077407, 5);
INSERT INTO Patient VALUES('Philipa', 'Benardeau', 59530431, 6);
INSERT INTO Patient VALUES('Angelle', 'Poundsford', 76789827, 6);

INSERT INTO PatientAfdeling VALUES(1, 2);
INSERT INTO PatientAfdeling VALUES(2, 1);
INSERT INTO PatientAfdeling VALUES(3, 3);
INSERT INTO PatientAfdeling VALUES(4, 1);
INSERT INTO PatientAfdeling VALUES(5, 3);
INSERT INTO PatientAfdeling VALUES(6, 4);
INSERT INTO PatientAfdeling VALUES(7, 5);
INSERT INTO PatientAfdeling VALUES(8, 6);
INSERT INTO PatientAfdeling VALUES(9, 5);
INSERT INTO PatientAfdeling VALUES(10, 4);

INSERT INTO L�geAfdeling VALUES(1, 2);
INSERT INTO L�geAfdeling VALUES(2, 1);
INSERT INTO L�geAfdeling VALUES(3, 3);
INSERT INTO L�geAfdeling VALUES(4, 1);
INSERT INTO L�geAfdeling VALUES(5, 3);
INSERT INTO L�geAfdeling VALUES(6, 4);
INSERT INTO L�geAfdeling VALUES(7, 5);
INSERT INTO L�geAfdeling VALUES(8, 6);
INSERT INTO L�geAfdeling VALUES(9, 5);
INSERT INTO L�geAfdeling VALUES(10, 4);





GO
CREATE VIEW PatientKontakt AS
	SELECT CONCAT(Patient.[Patient Fornavn], ' ', Patient.[Patient Efternavn]) as [Patient Navn], 
		Patient.[Patient Tlf.], CONCAT(L�ge.[L�ge Fornavn], ' ', L�ge.[L�ge Efternavn]) as [L�ge Navn],
		Afdeling.Afdeling FROM PatientAfdeling
			JOIN Patient on PatientAfdeling.PatientId = Patient.Id
			JOIN Afdeling on PatientAfdeling.AfdelingId = Afdeling.ID
			JOIN L�geAfdeling on Afdeling.ID = L�geAfdeling.AfdelingId
			JOIN L�ge on L�geAfdeling.L�geId = L�ge.id
GO

SELECT * FROM PatientKontakt


GO
EXEC xp_instance_regread 
    'HKEY_LOCAL_MACHINE',
    'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Np\Enabled'
GO
EXEC xp_instance_regread
    'HKEY_LOCAL_MACHINE',
    'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Tcp\Enabled'


-- Sets dac to true (1)
EXEC sp_configure 'remote admin connections', 1;
RECONFIGURE;

-- Views dac configuration
GO
EXEC sp_configure 'remote admin connections';



