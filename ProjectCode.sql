-- CLIENT TABLE--
CREATE TABLE Clientss(
Customer_ID INT IDENTITY(1,1),
First_Name VARCHAR(100) NOT NULL,
Last_Name VARCHAR(100) NOT NULL,
Gender CHAR(50) CHECK(Gender IN('Male','Female','Other')),
Age INT ,
Phone_Number DECIMAL(10,0) UNIQUE NOT NULL,
CONSTRAINT chk_phone CHECK (Phone_Number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
CONSTRAINT PK_Customers PRIMARY KEY(Customer_ID)
);

-- WORKER TABLE--
CREATE TABLE Workerss(
Worker_ID INT NOT NULL UNIQUE IDENTITY(10,1),
First_Name VARCHAR(100) NOT NULL,
Last_Name VARCHAR(100) NOT NULL,
Worker_Type VARCHAR(100) NOT NULL CHECK(Worker_Type IN('Plumber','Cook','Electrician','Maid','Handyman','Carpenter','All')),
Worker_Hourly_Rate DECIMAL(4,2) NOT NULL,
Gender CHAR(50) CHECK(Gender IN('Male','Female','Other')),
Age INT,
Phone_Number DECIMAL(10,0) UNIQUE NOT NULL,
CONSTRAINT check_phone CHECK (Phone_Number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
CONSTRAINT PK_Worker PRIMARY KEY(Worker_ID)
);

ALTER TABLE Workerss
ADD Reviews DECIMAL(2,0);

-- HOUSE TABLE--
CREATE TABLE Housess(
Customer_ID INT,
House_Registration_Number DECIMAL(5,0) UNIQUE NOT NULL,
House_Number INT NOT NULL,
Street_Name VARCHAR(250) NOT NULL,
City VARCHAR(100) NOT NULL,
ZipCode DECIMAL(5,0) NOT NULL CHECK ( [ZipCode] LIKE '[0-9][0-9][0-9][0-9][0-9]'),
CONSTRAINT PK_House PRIMARY KEY(Customer_ID,House_Registration_Number),
CONSTRAINT FK_House FOREIGN KEY(Customer_ID) REFERENCES Clientss(Customer_ID)
);

-- BOOKING TABLE--
CREATE TABLE Bookingsss(
Booking_ID INT IDENTITY(100,1),
Worker_ID  INT NOT NULL,
Customer_ID  INT NOT NULL,
House_Registration_Number DECIMAL(5,0) NOT NULL,
Booking_Total DECIMAL(4,2) NOT NULL,
Time_Slot_Booked DATETIME NOT NULL,
CONSTRAINT PK_Book PRIMARY KEY(Booking_ID),
CONSTRAINT FK_Review_Worker FOREIGN KEY(Worker_ID) REFERENCES Workerss(Worker_ID),
CONSTRAINT FK_Review_Workers FOREIGN KEY(Customer_ID,House_Registration_Number) REFERENCES Housess(Customer_ID,House_Registration_Number)
);


--WORKDONE TABLE--
CREATE TABLE Workdoness(
Worker_ID INT,
Dates DATETIME NOT NULL,
Work_Description VARCHAR(250),
CONSTRAINT PK_Workdone PRIMARY KEY(Worker_ID,Dates),
CONSTRAINT FK_Review_Workerdone FOREIGN KEY(Worker_ID) REFERENCES Workerss(Worker_ID)
);

--REVIEW TABLE--
CREATE TABLE Reviewss(
Review_ID INT IDENTITY(1000,1),
Customer_ID INT NOT NULL,
Worker_ID INT NOT NULL,
Review_Rating DECIMAL(2,0) NOT NULL CHECK(Review_Rating<=10),
CONSTRAINT PK_Review PRIMARY KEY(Review_ID),
CONSTRAINT FK_Review_Cus FOREIGN KEY(Customer_ID) REFERENCES Clientss(Customer_ID),
CONSTRAINT FK_Revie_Worker FOREIGN KEY(Worker_ID) REFERENCES Workerss(Worker_ID)
);

--Client Values--
INSERT INTO Clientss VALUES('Romil','Godha','Male',21,3153720414)
INSERT INTO Clientss VALUES('Monty','Lulla','Male',21,8482563660)
INSERT INTO Clientss VALUES('Jessie','Bird','Female',25,3153720478)
INSERT INTO Clientss VALUES('Yamini','Bajaj','Female',22,5185963844)
INSERT INTO Clientss VALUES('Rohan','Saxena','Male',31,4183720414)

--Worker Values--
INSERT INTO Workerss VALUES('Josh','Jackson','Plumber',12.5,'Male',21,3153320414)
INSERT INTO Workerss VALUES('Dolly','Singh','Cook',22,'Female',21,8482564440)
INSERT INTO Workerss VALUES('Karan','Sharma','Electrician',15.6,'Male',25,3153723378)
INSERT INTO Workerss VALUES('Love','Bird','Maid',11.4,'Female',22,5185944844)
INSERT INTO Workerss VALUES('Bharat','Jen','Handyman',18.5,'Male',31,4183220414)

--House Values--
INSERT INTO Housess VALUES(1,10000,201,'Dell Street','Syracuse',13210)
INSERT INTO Housess VALUES(2,20000,518,'Avery Street','Troy',43210)
INSERT INTO Housess VALUES(3,30000,255,'Brayant Street','Rochester',83412)
INSERT INTO Housess VALUES(4,40000,523,'Columbus Street','Syracuse',64866)
INSERT INTO Housess VALUES(5,50000,504,'Westcott Street','Syracuse',23550)

--Review Values--
INSERT INTO Reviewss VALUES(1,10,8)
INSERT INTO Reviewss VALUES(2,10,10)
INSERT INTO Reviewss VALUES(3,12,8)
INSERT INTO Reviewss VALUES(4,13,9)
INSERT INTO Reviewss VALUES(4,11,10)



--Workdone Values--
INSERT INTO Workdoness VALUES(10,'2018-04-14 12:00:00.707','Fixed Tap')
INSERT INTO Workdoness VALUES(10,'2018-04-15 13:00:00.707','Meal for two')
INSERT INTO Workdoness VALUES(12,'2018-04-13 14:00:00.707','Fixed bulb')
INSERT INTO Workdoness VALUES(13,'2018-04-12 15:00:00.707','Cleaned House')
INSERT INTO Workdoness VALUES(11,'2018-04-10 16:00:00.707','Fixed Gate')

--Bookingss Values--
INSERT INTO Bookingsss VALUES(10,1,10000,12.5,'2018-04-14 12:00:00.707')
INSERT INTO Bookingsss VALUES(10,2,20000,12.5,'2018-04-15 13:00:00.707')
INSERT INTO Bookingsss VALUES(12,3,30000,15.6,'2018-04-13 14:00:00.707')
INSERT INTO Bookingsss VALUES(13,4,40000,11.4,'2018-04-12 15:00:00.707')
INSERT INTO Bookingsss VALUES(11,4,40000,22,'2018-04-10 16:00:00.707')

CREATE TRIGGER 
finaltrig
ON Reviewss
FOR INSERT,UPDATE
AS
IF @@ROWCOUNT >=1 
BEGIN
UPDATE Workerss
SET Reviews= Work.RRate
FROM
(SELECT w.Worker_ID, AVG(r.Review_Rating) AS 'RRate'
FROM Workerss w
INNER JOIN inserted r ON w.Worker_ID=r.Worker_ID
GROUP BY w.Worker_ID) AS Work
WHERE Work.Worker_ID=Workerss.Worker_ID
END;

INSERT INTO Reviewss VALUES(4,14,10)

Select *from Workerss
