use SchoolDatabase
/*
--Q8-1) Find the student numbers of students who have earned A’s or B’s in
courses taught in the fall semester. Do this in two ways, first using a
subquery and then using a join
*/
--FIRST USING SUBSQUERY) 
SELECT  S.STNO AS 'STUDENT NUMBER'
FROM	Student S 
WHERE	S.STNO IN (
		SELECT  GR.STUDENT_NUMBER 
		FROM	Grade_report GR
		WHERE	GR.GRADE IN ('A','B')
		AND		GR.SECTION_ID IN (
		SELECT	SE.SECTION_ID
		FROM	Section SE
		WHERE	SE.SEMESTER ='FALL'
		))
--2ND USING JOIN)

SELECT	DISTINCT(S.STNO) AS 'STUDENT NUMBER'
FROM	Student S INNER JOIN 
		(Grade_report GR INNER JOIN Section SE
		 ON SE.SECTION_ID = GR.SECTION_ID
		 )
ON	S.STNO = GR.STUDENT_NUMBER
WHERE	SE.SEMESTER = 'FALL'
AND		GR.GRADE IN ('A','B')

/*
--Q8-2) Find all students who took a course offered by the Accounting (ACCT)
department. List the student name and student number, the course
name, and the grade in that course. (Hint: Begin with Department to
major and use an appropriate WHERE clause). Note that this cannot
be done with a multilevel subquery. Why?

--IT CAN NOT BE DONE BY SUBQUERY, BECAUSE OF WE WANT TO RETRIVE INFORMATION
FROM ALL TABLES THAT WILL BE USED IN THE QUERY
*/
--FIRST) CREATING THE COURSE THAT 'ACCOUNTING ' DEPARTING IS OFFERING
CREATE VIEW DEPART_COURSE_ACCT_VIEW AS
SELECT	C.COURSE_NUMBER,C.COURSE_NAME
FROM	Course C
WHERE   C.OFFERING_DEPT LIKE 'ACC%'


--SECOND) CREATING THE VIEW BETWEEN COURSE AND SECTION FOR GETTING SO THAT WE CAN JOIN WITH GRADE_GROUP
CREATE VIEW COURSE_GRADE_SECTION_VIEW AS
SELECT	DCV.COURSE_NAME,GR.GRADE,GR.STUDENT_NUMBER
FROM	DEPART_COURSE_ACCT_VIEW DCV INNER JOIN 
		(Section SE INNER JOIN Grade_report GR
		 ON  SE.SECTION_ID = GR.SECTION_ID)
ON		DCV.COURSE_NUMBER = SE.COURSE_NUM

--THIRD) COMPLETING THE QUERY FINALLY
SELECT	S.SNAME AS 'STUDENT NAME'
		, S.STNO AS 'STUDENT NUMBER'
		, CGSV.COURSE_NAME
		, CGSV.GRADE
FROM	Student S INNER JOIN COURSE_GRADE_SECTION_VIEW CGSV
ON		S.STNO = CGSV.STUDENT_NUMBER

/*
--Q8-3) For all students who are sophomores (class = 2), find their names and
the names of the departments that include the students’ majors.
*/
SELECT  S.SNAME AS 'STUDENT NAMES', D.DNAME AS 'DEPARTEMENT NAME'
FROM	Student S INNER JOIN Department_to_major D
ON		S.MAJOR = D.DCODE 
WHERE	S.CLASS = 2

/*
--Q8-4) Find the names of the departments that offer courses at the junior or
senior levels (either one) but not at the freshman level. The course level
is the first digit after the prefix; for example, AAAA3yyy is a junior
course.
*/

--FIRST) CREATING VIEW OF DEPARTEMENTS OF JUNIORS- SENIORS
CREATE VIEW DEP_COURSE_JUN_SEN_VIEW AS
SELECT	DISTINCT(DJ.DNAME) AS 'DEPARTEMENT NAMES'
FROM	Department_to_major  DJ INNER JOIN COURSE C
ON		DJ.DCODE = C.OFFERING_DEPT
WHERE	C.COURSE_NUMBER LIKE ('____[2-9]___') 

--SECOND) CREATING VIEW OF DEPARTEMENTS OF PRESSURE COURSE PROVIDE
CREATE VIEW DEP_COURSE_FRESH_VIEW AS 
SELECT	DISTINCT(DJ.DNAME) AS 'DEPARTEMENT NAMES'
FROM	Department_to_major DJ inner join Course C
ON		DJ.DCODE = C.OFFERING_DEPT
WHERE	C.COURSE_NUMBER NOT LIKE ('____[2-9]___')


--THIRD) COMPLETING THE QUERY OF DEPARTEMENT THAT DOES NOT PROVIDE FRESH COURSE
SELECT  *
FROM	DEP_COURSE_JUN_SEN_VIEW D1
WHERE	D1.[DEPARTEMENT NAMES] NOT IN (
		SELECT	*
		FROM	DEP_COURSE_FRESH_VIEW)

/*
--Q8-5)  Find the names of courses that are prerequisites for other courses. List
the course number and name, and the course number and name of the
prerequisite.
*/
SELECT	C.COURSE_NAME,C.COURSE_NUMBER,P.PREREQ
FROM	Course C INNER JOIN Prereq P
ON		C.COURSE_NUMBER = P.COURSE_NUMBER

/*
--Q8-6)  List the names of instructors who teach courses that have other than
three-hour credits. Do the problem in two ways, once with IN and once
with NOT .. IN.
*/
--FIRST) JUST USING IN SUBQUERY
SELECT	DISTINCT(SE.INSTRUCTOR)
FROM	Section SE 
WHERE	SE.COURSE_NUM IN (
		SELECT	C.COURSE_NUMBER
		FROM	Course C
		WHERE	C.CREDIT_HOURS <> 3  -- != OR <> WORKS SAME HERE
		)
--SECOND) USING NOT IN QUERY
SELECT  DISTINCT(SE.INSTRUCTOR)
FROM	Section SE
WHERE	SE.COURSE_NUM NOT IN (
		SELECT	C.COURSE_NUMBER
		FROM	Course C
		WHERE	C.CREDIT_HOURS = 3
		)

/*
--Q7-7)  Create a table called Secretary with the columns dcode (of data
type CHAR(4)) for department code and name (of data type VARCHAR(20)) for the secretary name. Insert records into the table so
you have:
*/
CREATE TABLE Secretary (
dcode CHAR(4)   NULL,
name  VARCHAR(20)   NULL
)

INSERT INTO Secretary 
VALUES('ACCT','Beryl')
	  ,('COSC','Kaitlyn')
     ,('ENGL','David')
	 ,('HIST','Christina')
	 ,('BENG','Fred')
	 ,('HIND','Chloe')
/*
--Q8-7)
--Q8-7A)Create a query that lists the names of departments that have secretarie
*/
SELECT D.DNAME 'DEPARTEMENT NAMES'
FROM   Department_to_major D
WHERE  D.DCODE IN (
	   SELECT	S.dcode
	   FROM		Secretary S
	   )
--Q8-7B) DEPARTEMENT THAT HAVE NO SECRETARY -- not in will give no result if null in table
--use 'not exists' instead of not in
SELECT  D.DNAME 'DEPARTEMENT NAMES HAVE NO SECRETARY'
FROM	Department_to_major D
WHERE	D.DCODE NOT IN(
		SELECT  dcode
		FROM	Secretary
		WHERE   dcode IS NOT NULL)

INSERT INTO Secretary 
VALUES(NULL,'Brenda')

/*
--Q8-8)Devise a list of course names that are offered in the fall semester in
rooms where the capacity is equal to or above the average room size
*/

--

SELECT  C.COURSE_NAME
FROM	COURSE C
WHERE	C.COURSE_NUMBER IN (
		SELECT  SE.COURSE_NUM
		FROM	Section SE 
		WHERE	SE.SEMESTER = 'FALL'
		AND		SE.ROOM IN (
		SELECT  R.ROOM
		FROM	Room R
		GROUP BY SE.R	R.CAPACITY >=AVG(R.ROOM)
		))


