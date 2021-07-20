
--Tables' Creation


create table JOB
(JOB_CODE INT NOT NULL primary key,JOB_DESCRIPTION varchar(30) NOT NULL,JOB_CHG_HOUR DECIMAL (5,2) NOT NULL,
JOB_LAST_UPDATE varchar(20) NOT NULL)


create table EMPLOYEE
(EMP_NUM INT NOT NULL primary key ,EMP_LNAME nvarchar(20) NOT NULL,EMP_FNAME varchar(20) NOT NULL, 
EMP_INITIAL char(1),EMP_HIREDATE nvarchar(20), JOB_CODE INT references JOB(JOB_CODE), EMP_YEARS INT)


create table PROJECT
(PROJ_NUM INT primary key,PROJ_NAME varchar(20) NOT NULL,PROJ_VALUE DECIMAL(15,2) NOT NULL,
PROJ_BALANCE DECIMAL(15,2) NOT NULL,EMP_NUM INT references EMPLOYEE(EMP_NUM))


create table ASSIGNMENT
(ASSIGN_NUM INT NOT NULL primary key, ASSIGN_DATE varchar(20),PROJ_NUM INT references PROJECT(PROJ_NUM),
EMP_NUM INT references EMPLOYEE(EMP_NUM), ASSIGN_JOB INT NOT NULL, ASSIGN_CHG_HR DECIMAL(5,2) NOT NULL,
ASSIGN_HOURS DECIMAL(2,1) NOT NULL,ASSIGN_CHARGE DECIMAL(5,2) NOT NULL)


--INSERT DATA INTO TABLE JOB

INSERT INTO JOB VALUES ('500', 'Programmer', '35.75', '20-Nov-17')
INSERT INTO JOB VALUES ('501', 'Systems Analyst', '96.75', '20-Nov-17')
INSERT INTO JOB VALUES ('502', 'Database Designer', '125.00', '24-Mar-16')


--INSERT DATA INTO TABLE EMPLOYEE

INSERT INTO EMPLOYEE VALUES ('101', 'News', 'John', 'G', '08-Nov-00', '502','17')
INSERT INTO EMPLOYEE VALUES ('102', 'Senior', 'David', 'H', '12-Jul-89', '501','28')
INSERT INTO EMPLOYEE VALUES ('103', 'Arbough', 'June', 'E', '01-Dec-96', '500','21')
INSERT INTO EMPLOYEE VALUES ('104', 'Ramoras', 'Anne', 'K', '15-Nov-87', '501','30')
INSERT INTO EMPLOYEE VALUES ('105', 'Johnson', 'Alice', 'K', '01-Feb-93', '502','25')
INSERT INTO EMPLOYEE VALUES ('106', 'Smithfield', 'William', '', '22-Jun-04', '500','13')
INSERT INTO EMPLOYEE VALUES ('107', 'Alonzo', 'Maria', 'D', '10-Oct-93', '500','24')
INSERT INTO EMPLOYEE VALUES ('108', 'Washington', 'Ralph', 'B', '22-Aug-91', '501','26')
INSERT INTO EMPLOYEE VALUES ('109', 'Smith', 'Larry', 'W', '18-Jul-97', '501','20')
INSERT INTO EMPLOYEE VALUES ('110', 'Olenko', 'Gerald', 'A', '11-Dec-95', '505','22')


--INSERT DATA INTO TABLE PROJECT

INSERT INTO PROJECT VALUES ('15', 'Evergreen', '1453500.00', '1002350.00','103')
INSERT INTO PROJECT VALUES ('18', 'Amber Wave', '3500500.00', '2110346.00','108')
INSERT INTO PROJECT VALUES ('22', 'Rolling Tide', '805000.00', '500345.20','102')


--INSERT DATA INTO TABLE ASSIGNMENT

INSERT INTO ASSIGNMENT VALUES ('1001', '22-Mar-16', '18', '103', '503', '84.5','3.5','295.75')
INSERT INTO ASSIGNMENT VALUES ('1002', '22-Mar-16', '22', '105', '509', '34.55','4.2','145.11')
INSERT INTO ASSIGNMENT VALUES ('1003', '22-Mar-16', '18', '107', '509', '34.55','2','69.1')




SELECT * FROM EMPLOYEE--List of all employees


SELECT * FROM JOB --Show all the content of the table JOB


SELECT * FROM ASSIGNMENT--Show all the content of the table Assignment


SELECT * FROM PROJECT--Show all the content of the table Project



--List the employee number, last name, first name, and middle initial of all employees whose last names start with Smith

SELECT EMP_NUM, EMP_LNAME, EMP_FNAME, EMP_INITIAL
FROM EMPLOYEE
WHERE EMP_LNAME LIKE 'Smith%'
ORDER BY EMP_NUM


--Join the EMPLOYEE and PROJECT tables using EMP_NUM as the common attribute, sorted by project value


SELECT PROJ_NAME, PROJ_VALUE, PROJ_BALANCE,
EMP_LNAME,EMP_FNAME, EMP_INITIAL, JOB.JOB_CODE,
JOB_DESCRIPTION,JOB_CHG_HOUR
FROM PROJECT, EMPLOYEE, JOB
WHERE EMPLOYEE.EMP_NUM = PROJECT.EMP_NUM
AND JOB.JOB_CODE = EMPLOYEE.JOB_CODE
ORDER BY PROJ_VALUE

--Join the EMPLOYEE and PROJECT tables using EMP_NUM as the common attribute, sorted by employee name

SELECT PROJ_NAME, PROJ_VALUE, PROJ_BALANCE,
EMP_LNAME,EMP_FNAME, EMP_INITIAL, JOB.JOB_CODE,
JOB_DESCRIPTION,JOB_CHG_HOUR
FROM PROJECT, EMPLOYEE, JOB
WHERE EMPLOYEE.EMP_NUM = PROJECT.EMP_NUM
AND JOB.JOB_CODE = EMPLOYEE.JOB_CODE
ORDER BY EMP_LNAME

--List only the distinct project numbers in the ASSIGNMENT table, sorted by project number

SELECT distinct PROJ_NUM
FROM ASSIGNMENT
ORDER BY PROJ_NUM

--Validate the ASSIGN_CHARGE values in the ASSIGNMENT table, sorted by the assignment number

SELECT ASSIGN_NUM, EMP_NUM, PROJ_NUM, ASSIGN_CHARGE,
ASSIGN_CHG_HR * ASSIGN_HOURS AS CALCULATED_ASSIGNMENT_CHARGE
FROM ASSIGNMENT
ORDER BY ASSIGN_NUM
