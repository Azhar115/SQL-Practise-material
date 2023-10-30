--1a)
SELECT	*
FROM	Course

--1b) display first five rows/records]
SELECT TOP(5) *
FROM Course

--2a) displaying all those students number and name who are class 3 juniors
SELECT d.SNAME as 'student names', d.STNO as 'student numbers'
FROM	Student d
where	d.CLASS=3

--2b) displaying in descending order by name to the 2a query
SELECT	d.SNAME [student names], d.STNO [student number]	
FROM	Student AS d
WHERE d.CLASS=3
ORDER BY d.SNAME DESC

--3a) displaying all course name and number  that are 3 credit hourse
SELECT	c.COURSE_NAME  'course name', c.COURSE_NUMBER [Course number]  
FROM	Course AS c
where	c.CREDIT_HOURS=3

--3b) displaying course name and number in ascending order by course name
SELECT	[Course name]=c.COURSE_NAME, [course number]=c.COURSE_NUMBER 
FROM	Course  c
ORDER BY  c.COURSE_NAME --by default in ascending orde

--4) displaying the room number, building number, room capacity with proper aliases
SELECT	r.BLDG as [building number], r.CAPACITY [room capacity],r.ROOM [room number]
FROM	Room r

--5) display course number,instructor,building number,offered in fall 2008 courseS with appropriate aliases
SELECT	s.COURSE_NUM 'course number', s.INSTRUCTOR [cour_instructor],s.BLDG [course_building]
FROM	Section AS s
WHERE	S.SEMESTER ='FALL'
AND		S.YEAR = '08'

-- 6) list all student number of grade c or d
SELECT	sg.STUDENT_NUMBER as 'student number'
FROM	Grade_report AS sg
WHERE	sg.GRADE='C'
OR		sg.GRADE='D'

--7) list of offering departement that of all courses that are more than 3 hourse
SELECT	c.OFFERING_DEPT [offering departement]
FROM	Course as c
WHERE	C.CREDIT_HOURS>3

--8) LIST student name whose major are 'COSC'
SELECT	st.SNAME [student name]
FROM	Student as st
where	st.MAJOR='COSC'

--9) find capacity of room 120 building = 36
SELECT	R.CAPACITY AS [CAPACITY OF ROOM NUMBER 120, BUIDLING 36]
FROM	Room AS R
WHERE	R.ROOM=120 
AND		R.BLDG =36

--10) all student display order by major
SELECT *
FROM Student
ORDER BY MAJOR

--11)all student display order by major,AND	within major order by class 
SELECT *
FROM Student
ORDER BY MAJOR,CLASS

--12) count departement in department to major table
SELECT COUNT(DCODE)
FROM	Department_to_major

--13) count number of building in room table
SELECT	COUNT(BLDG)
FROM	Room

--14) ERROR IS THAT THE COUNT GIVES NOT NULL VALUE OF 
SELECT COUNT(class)
FROM Student
WHERE class IS  NULL

--15) USE BETWEEN SPHORMOUSE,SENIOR
SELECT  st.SNAME [student names],st.CLASS
FROM	Student AS st
where	st.CLASS 
BETWEEN	  3 AND  7

--16) JUNIORSE OPPOSIT 16 QUIRY
SELECT  st.SNAME [student names],st.CLASS
FROM	Student AS st
where	st.CLASS 
NOT BETWEEN	  3 AND  7

--17) CREATE SYNONYMS FOR EACH STUDENT DATABASE TABLES,AND VIEW IN EXPLORE
CREATE SYNONYM C
FOR  Course

CREATE SYNONYM ST
FOR Student

CREATE SYNONYM DTM
FOR Department_to_major

CREATE SYNONYM DP
FOR	Dependent

CREATE SYNONYM GR
FOR Grade_report

Create SYNONYM L
FOR Languages

Create SYNONYM P
FOR Plants

Create SYNONYM PRQ
FOR Prereq

Create SYNONYM R
FOR Room

Create SYNONYM Sec
FOR Section




--4) 






