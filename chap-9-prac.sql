use SchoolDatabase
/*
--Q9-1) Display a list of courses (course names) that have prerequisites and the
number of prerequisites for each course. Order the list by the number
of prerequisites
*/
SELECT  C.COURSE_NAME, COUNT(ISNULL(P.PREREQ,0)) AS [NUMBER OF PREREQ FOR EACH COURSE]
FROM	Course C,Prereq P
WHERE	C.COURSE_NUMBER = P.COURSE_NUMBER
GROUP BY	C.COURSE_NAME
ORDER BY	[NUMBER OF PREREQ FOR EACH COURSE] -- use only the aliased name otherwise prereq not works

--Q9-2)  How many juniors (class = 3) are there in the Student table?
SELECT	COUNT(*)
FROM	Student 
WHERE	CLASS = 3

/*
--Q9-3)  Group and count all MATH majors by class and display the count if
there are two or more in a class.
*/
SELECT CLASS,COUNT(*) [NUMBER OF STUDENTS MAJOR IN MATH]
FROM	Student 
WHERE	MAJOR = 'MATH'
GROUP BY   CLASS
HAVING	 COUNT(*) >=2  --NUMBER OF STUDENTS IN A CLASS GREATER OR EQUALL TO 2

--Q9-4)Print the counts of A’s, B’s, and so on from the Grade report table

SELECT	GRADE,COUNT(GRADE) [TOTAL NUMBER OF GRADE]
FROM	Grade_report GR
GROUP BY GRADE

/*
--Q9-5`A) Using temporary tables (local or global), print the lowest count
of the grades (that is, if there were 20 A’s, 25 B’s, and 18 C’s, you
should print the lowest count of grades as C) from the Grade report
table
*/
 --FIRST) CREATING A LOCAL TABLE THAT COUNTS NUMBER OF GRADES FOR EACH GRADE
SELECT  GRADE,COUNT(*) AS [TOTAL] INTO #TOTAL_EACH_GRADE_TEMP 
FROM	Grade_report GR
GROUP BY  GRADE


--SECOND) FIND THE LOWEST COUNT OF GRADE 
--METHODE 1)
SELECT	GRADE,COUNT(*) AS [TOTAL GRADES]
FROM	Grade_report
GROUP BY  GRADE
HAVING    COUNT(*) = (
		  SELECT MIN(TOTAL)
		  FROM	#TOTAL_EACH_GRADE_TEMP
		  )

--METHODE 2)
SELECT   MIN(V.TOTAL) [TOTAL_GRADE]     --MENTIONING THE GRADE NAME ALSO GIVES COMPLETE LIST OF TOATAL GRADE BACK
FROM	 (
		  SELECT  GRADE,COUNT(*) [TOTAL]
		  FROM    Grade_report GR
		  GROUP BY   GRADE 
		  )AS V

--Q9-4B) Using inline views, print the highest count of the grades 
SELECT	MAX(V.TOTAL)
FROM	(
		SELECT	COUNT(*) [TOTAL]
		FROM	Grade_report
		GROUP BY GRADE
		) AS V

/*
--Q9-5)Print the counts of course numbers offered in descending order by
count. Use the Section table only
*/
SELECT	COURSE_NUM,COUNT(COURSE_NUM) [NUMEBR OF SECTION OFFERED]
FROM	Section
GROUP BY COURSE_NUM
ORDER BY COURSE_NUM DESC

/*
--Q9-6)Create a table with names and number-of-children (NOC). Insert five
or six rows into this table, Use COUNT, SUM, AVG, MIN, and MAX
on the NOC attribute in one query and check that the numbers you
get are what you expect.
*/
--FIRST) CREATING TABLE
CREATE TABLE PARENT_CHILD(
NAMES	VARCHAR(20)  NOT  NULL,
NUMBER_OF_CHILDREN	SMALLINT   NULL
)


--INSERTING VALUES IN THE TABLE TO PERFORM THE AGGREGRATE FUNCTIONS
INSERT PARENT_CHILD
VALUES('RAHEL',0),
	  ('RAZIA',3),
	  ('SHAMES',10),
	  ('AHMED',5),
	  ('RANI',7),
	  ('RANVEER',3),
	  ('QASEEMS',10),
	  ('AHMED',2)
	  

--NOW PERFORMING THE AGGREGATE FUNCTIONS ON ABOVE CREATED TABLE
--FIRST) COUNT NUMBER OF PARENTS HAVING CHILDRENS(NULL,0 CHILDREN ARE NOT MENTION)
SELECT  COUNT(NULLIF(NUMBER_OF_CHILDREN,0)) AS [NUMBER OF PARENTS HAVING CHILD] --PARENT HAVING ZERO(0) CHILDREN ARE NOT INCLUDED
FROM	PARENT_CHILD 

--SECOND) COUNT ALL PARENTS EITHER HAVE CHILDREN OR NOT ( NOW ZERO(0) CHILDREN AND NULL ALSO INCLUDED)
SELECT	COUNT(ISNULL(NUMBER_OF_CHILDREN,0)) [TOTAL NUMBER OF PARENTS] --ISNULL HELPS TO INCLUDE IN COUNTING THE NULL ENTRIES
FROM	PARENT_CHILD

--3RD) NAME OF PARENTS HAIVING NULL OR ZERO CHILDREN
SELECT *
FROM	PARENT_CHILD
WHERE	NUMBER_OF_CHILDREN  IS NULL OR NUMBER_OF_CHILDREN = 0  -- = NULL WILL GIVE NO ERROR BUT NULL WILL NOT INCLUDE

--4TH) TOTAL CHILDRENS IN RECORDS
SELECT	SUM(NUMBER_OF_CHILDREN) 'TOTAL CHILDREN'
FROM	PARENT_CHILD

--5TH) AVERAGE,MINIMUM(MINIMUM IS ZERO SHOULD NOT INCLUDED),AND MAXIMUM NUMBER OF CHILDRENS OF  PARENTS
SELECT	AVG(NUMBER_OF_CHILDREN),MIN(NULLIF(NUMBER_OF_CHILDREN,0)) [MINIMUM CHILDREN],MAX(NUMBER_OF_CHILDREN) [MAXIMUM CHILDREN]
FROM	PARENT_CHILD

/*
 Q9-7) Create a table of names, salaries, and job locations. Insert at least 10
rows into this table and no fewer than three job locations. (There will
be several employees at each location.) Find the average salary for each
job location with one SELECT.
*/
CREATE TABLE Employee(
NAMES	VARCHAR(20)  NOT NULL,
SALARY  INT	NULL,
JOB_LOCATION	VARCHAR(20) NULL
)


INSERT Employee
VALUES ('RANA',20000,'KARACHI'),
	   ('AHMED',35000,'LAHORE'),
	   ('THANVEER',40000,'ISLAMABAD'),
	   ('SHAJHAN',250000,'PESHAWARE'),
	   ('ALI',30000,'LAHORE'),
	   ('QASEEM',33000,'KARACHI'),
	   ('AZHAR',40000,'LAHORE'),
	   ('REHMAN',38000,'ISLAMABAD'),
	   ('SHOIAB',36000,'KARACHI'),
	   ('SHABEER',33000,'PESHAWARE')

--finding the average salary for each location
SELECT   JOB_LOCATION , AVG(SALARY) [AVERAGE SALARY]
FROM	 Employee 
GROUP BY JOB_LOCATION

/*
--Q9-8)Print an ordered list of instructors and the number of A’s they assigned
to students. Order the output by number of A’s (lowest to highest).
You can (and probably will) ignore instructors that assign no A’s.
*/
SELECT	  SE.INSTRUCTOR,COUNT(GR.GRADE) [NUMBER OF A'S ASSIGNED TO STUDENTS]
FROM	  Section SE,Grade_report GR
WHERE	  SE.SECTION_ID = GR.SECTION_ID
AND		  GR.GRADE = 'A'
GROUP BY  SE.INSTRUCTOR
ORDER BY  [NUMBER OF A'S ASSIGNED TO STUDENTS]

/*
--Q9-9)  Create a table called Employees with a name, a salary, and a job title.
Include exactly six rows. Make the salary null in one row, the job title
null in another, and both the salary and the job title null in another
*/

--1ST) CREATING TABLE Employees 
CREATE TABLE Employees(
NAME	VARCHAR(20)	NOT NULL,
SALARY	INT			NULL,
JOB_TITLE	VARCHAR(20) NULL
)

--INSERTING VALUES IN EMPLOYEES TABLE
INSERT Employees
VALUES ('Mary', 1000 , 'Programmer'),
	   ('Brenda', 3000,NULL),
	   ('Stephanie',NULL,'Artist'),
	   ('Alice',NULL,NULL),
	   ('Lindsay', 2000, 'Artist'),
	   ('Christina', 500, 'Programmer')



--A) DISPLAY THE EMPLOYEES TABLE
SELECT	*
FROM	Employees

--B) DISPLAY,MIN,MAX,AVG,COUNT,SUM OF SALARY
SELECT COUNT(SALARY) [TOTAL EMPLOYEES HAVING SALARY],
	   SUM(SALARY)	[TOTAL SALARY OF EMPLOYEES],
	   MIN(SALARY) [MINIMUM SALARY OF EMOLOYEES],
	   MAX(SALARY) [MAXIMUM SALARY OF EMPLOYEES]
FROM	Employees


--C) DISPLAY, MIN, MAX,AVG,COUNT,SUM OF SALARY,COUNTING SALARY AS 0, IF NO SALARY  
SELECT	COUNT(ISNULL(SALARY,0)) [COUNT EMPLOYEES HAVING SALRAY OR NOT],
		SUM(ISNULL(SALARY,0)) [TOTAL SALARY OF EMPLOYEES],
		MAX(ISNULL(SALARY,0)) [MAXIMUM SALARY],
		MIN(SALARY) [MINIMUM SALARY WITHOUT INCLUDE 0],
		MIN(ISNULL(SALARY,0)) [MINIMUM SALARY WITH INCLUDE 0]
FROM	Employees

--D) DISPLAY THE AVG SALARY GROUP BY JOB TITLE
SELECT  AVG(SALARY) [AVERAGE SALARY]
FROM	Employees
GROUP BY JOB_TITLE

/*
--E)Display the average salary grouped by job title when the null salary
is counted as 0
*/
SELECT   JOB_TITLE,AVG(ISNULL(SALARY,0)) [AVERAGE SALARY]
FROM	Employees
GROUP BY JOB_TITLE

/*
--F) Display the average salary grouped by job title when the null salary
is counted as 0 IF IT IS NULL AND INCLUDE A VALUE WHEN THERE IS NO JOB TITLE
*/
-- THE QUERY NEEDS ONLY THE SALARY AVG TO BE DISPLAYED, THAT'S WHY THE INLINE QUERY USED
SELECT  V.[AVERAGE SALARY]
FROM	(
		SELECT  ISNULL(JOB_TITLE,'NEW_TITLE_TO_NULL') JOB_TITLE,
				AVG(ISNULL(SALARY,0)) [AVERAGE SALARY]
		FROM	Employees 
		GROUP BY  JOB_TITLE
		) AS  V
/*
--Q9-10) Find the instructor and the section where the highest number of A’s
were awarded
*/
--CREATING THE LOCAL TEMP TABLE FOR EACH SECTION THE INSTRUCTOR PROVIDED NUMBER OF A PROVIDED TO STUDENTS
SELECT  SE.INSTRUCTOR,SE.SECTION_ID,
		COUNT(GR.GRADE) [TOTAL A'S IN SECTION] 
INTO	#TOTAL_A_GRADE_IN_SECTION_BY_INSTRUC 
FROM	Section SE, Grade_report GR
WHERE	SE.SECTION_ID = GR.SECTION_ID
AND		GR.GRADE = 'A'   
GROUP BY  SE.INSTRUCTOR,SE.SECTION_ID

--NOW JOINING THE TEMP ABOVE TABLE AS INNER QUERY 
--INNER QUERY(INLINE QUERY(V1)) PROVIDES THE HIGHEST GRADE NUMBER
-- THE OUTER QUERY(V2) PROVIDES THE INSTRUCTOR AND SECTION THAT MATCHES WITH HIGHEST GRADE NUMBER V1
SELECT	 V2.INSTRUCTOR,V2.SECTION_ID,V1.[HIGHEST A'S IN SECTION]
FROM	 ( SELECT	MAX([TOTAL A'S IN SECTION]) [HIGHEST A'S IN SECTION]--INSTRUCTOR,SECTION_ID
			FROM		#TOTAL_A_GRADE_IN_SECTION_BY_INSTRUC
		 ) AS V1 
		 INNER JOIN  #TOTAL_A_GRADE_IN_SECTION_BY_INSTRUC AS V2
ON		V1.[HIGHEST A'S IN SECTION] = V2.[TOTAL A'S IN SECTION]

/*
--Q9-11)Find the COUNT of the number of students by class who are taking
classes offered by the computer science (COSC) department. Perform
the query in two ways: once using a condition in the WHERE clause
and once filtering with a HAVING clause. (Hint: These queries need a
five-table join.)
*/
--USING HAVING AS FOR CONDITION OF COS DEPARTEMENT
SELECT	--S.CLASS,
		--D.DCODE,
		COUNT(S.STNO) [NUMBER OF STUDENTS IN A CLASS]
FROM	Student S INNER JOIN 
		(Grade_report GR INNER JOIN 
		(Section SE		 INNER JOIN
		(Course  C		 INNER JOIN Department_to_major D
		ON		C.OFFERING_DEPT = D.DCODE)
		ON		SE.COURSE_NUM   = C.COURSE_NUMBER)
		ON		SE.SECTION_ID   = GR.SECTION_ID)
ON	  GR.STUDENT_NUMBER = S.STNO 
GROUP BY S.CLASS,D.DCODE
HAVING  D.DCODE = 'COSC'
    
--USING WHERE CLAUSE COSC DEPARTEMENT SELECTION
SELECT	--S.CLASS,
		--D.DCODE,
		COUNT(S.STNO) [NUMBER OF STUDENTS IN A CLASS]
FROM	Student S INNER JOIN 
		(Grade_report GR INNER JOIN 
		(Section SE		 INNER JOIN
		(Course  C		 INNER JOIN Department_to_major D
		ON		C.OFFERING_DEPT = D.DCODE)
		ON		SE.COURSE_NUM   = C.COURSE_NUMBER)
		ON		SE.SECTION_ID   = GR.SECTION_ID)
ON		GR.STUDENT_NUMBER = S.STNO
WHERE   D.DCODE = 'COSC'
GROUP BY S.CLASS --,D.DCODE

--DROPING ALL TABLES CREATED FOR PRACTISING THIS TABLE
DROP TABLE teststu,Employee,Employees,PARENT_CHILD,T1,TABLE1,TABLE2

--