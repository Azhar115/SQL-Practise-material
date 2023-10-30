 

--1) display the total the count of the student,grade report, section tables using cartesion product
SELECT	COUNT(*)
FROM	Student,Grade_report,Section

--2) DISPLAY THE COUNT OF  SECTION_IDS FROM SECTION AND DISTINCT FROM GRADE_REPORT TABLE.
SELECT	COUNT(S.SECTION_ID) [SECTION TABLE SEC_ID], COUNT(DISTINCT(G.SECTION_ID)) [GRADE_REP SEC_ID]
FROM	Section S,Grade_report G

--3) Write, execute, and print a query to list student names and grades
--(just two attributes) using the table alias feature. Restrict the list to
--students who have either A�s or B�s in courses with ACCT prefixe only.
--METHODE 1)
SELECT	S.SNAME [STUDENT NAMES], G.GRADE [STUDENT GRADE]--,SE.COURSE_NUM
FROM	Student S,Grade_report G,Section SE
WHERE	S.STNO=G.STUDENT_NUMBER
AND		G.SECTION_ID=SE.SECTION_ID
AND		G.GRADE IN ('A','B')
AND		SE.COURSE_NUM LIKE 'ACCT%'

--METHODE 2) JOIN
SELECT	ST.SNAME [STUDENT NAMES ], GR.GRADE [STUDENT GRADE 'A,B' WITH ACCT COURSE NUMBER PREFIX]
FROM	Section SE INNER JOIN 
		( Grade_report GR INNER JOIN Student ST
		ON	ST.STNO = GR.STUDENT_NUMBER
		AND		GR.GRADE IN ('A','B'))
ON		SE.SECTION_ID = GR.SECTION_ID
WHERE	SE.COURSE_NUM LIKE 'ACCT%'

--3A) HOW MANY STUDENTS NAMES SMITH
SELECT	COUNT(ST.SNAME) AS [NUMBER OF STUDENT NAMES 'SMITH']
FROM	Student ST
WHERE	ST.SNAME LIKE 'SMITH'

--3B) HOW MANY HAVE SEQUENCE 'SMITH' 
SELECT	COUNT(ST.SNAME) AS [NUMBER OF STUDENT NAMES SEQUENCE 'SMITH']
FROM	STUDENT ST
WHERE	ST.SNAME LIKE '%SMITH%'

--3C) HOW MANY NAMES OF STUDENTS END 'LD'
SELECT	COUNT(ST.SNAME) AS [STUDENT NAMES ENDS WITH 'LD']
FROM	Student ST
WHERE	ST.SNAME LIKE '%LD'

--3D) HOW MANY STUDENT NAMES STARTS WITH 'S'
SELECT	COUNT(ST.SNAME) AS 'STUDENT NAMES START WITH S'
FROM	Student ST
WHERE	ST.SNAME LIKE 'S%'

--3E)HOW MANY STUDENT NAMES DO NOT HAVE 'I'  AS THE SECOND  LETTER?
SELECT  COUNT(ST.SNAME)
FROM	STUDENT ST
WHERE   ST.SNAME  NOT LIKE '_I%' -- like '[A-Za-z]S%'

--3F)  Would �SELECT * FROM Student WHERE sname
--LIKE @Smith%�� find someone whose name is:
SELECT * 
FROM Student 
WHERE sname LIKE '@Smith%'

--ANSER NO

--4A) LIST ALL COURSES OF JUNIOR LEVEL 'COSC3xxx' AND NAMES OF THE COURSES
SELECT		C.COURSE_NAME
FROM		Course C
WHERE		C.COURSE_NUMBER LIKE 'COSC3%'

--4B) NOT LIKE OF 4A QUERY
SELECT		C.COURSE_NAME
FROM		COURSE C
WHERE		C.COURSE_NUMBER NOT LIKE 'COSC3%'

--6) TELL ME IF THERE IS DUPLICATE NAMES AND NUMBER OF STUDENTS
SELECT  COUNT(DISTINCT(ST.SNAME)) [TOTAL DISTINCT NAMES],COUNT(ST.SNAME)[TOTAL NAMES WITH DUPLICATES],COUNT(DISTINCT(ST.STNO)) [DISTINCT STUDENT NUMBER],COUNT(ST.STNO)[ STUDENT NUMBER WITH DUPLICATE]
FROM	Student ST

--7A) HOW MANY MATH COURSES ARE THERE IN SECTION?
SELECT	COUNT(DISTINCT(COURSE_NUM))	
FROM	SECTION SE
WHERE	SE.COURSE_NUM LIKE 'MATH%'

--7B) YES THERE ARE TOTAL SIX COURSES OFFERED IN COURSE TABLE BUT THE SECTION TABLE HAVE ONLY THREE COURSES

--7C) THERE ARE THREE COURSE NOT OFFERED IN SECTION 

SELECT	COUNT(DISTINCT(C.COURSE_NUMBER))
FROM	COURSE C 
WHERE	C.COURSE_NUMBER LIKE 'MATH%'

--7d)courses that is not unique in each grade_report,section,course
--methode1)
SELECT  COUNT(C.COURSE_NUMBER)
FROM	COURSE C--
WHERE	C.COURSE_NUMBER 
NOT IN (SELECT DISTINCT(SE.COURSE_NUM)
		FROM Section SE INNER JOIN Grade_report GR
		ON		SE.SECTION_ID = GR.SECTION_ID)

--methode2)
SELECT  COUNT(C.COURSE_NUMBER)
FROM	Course C LEFT OUTER JOIN 
		(SELECT DISTINCT(SE.COURSE_NUM)
		FROM Section SE INNER JOIN Grade_report GR
		ON		SE.SECTION_ID = GR.SECTION_ID) AS A
ON		A.COURSE_NUM=C.COURSE_NUMBER
WHERE	A.COURSE_NUM IS NULL

--7E) THAT DOES NOT WORK DUE TO THE PRIMERY KEY OF SECTION IS FORIEGN AT GRADE_REPORT SO IT WILL GIVE EMPITY SET

--9) PERFORM AVERAGE,MIN,MAX,SUM,COUNT  AGGREGATE FUNCTION ON ROOM CAPACITY ATTRIBUTE COLUMN
SELECT	STR(COUNT(ISNULL(CAPACITY,40))) [COUNT CAPACITY NUMBER],STR(SUM(ISNULL(CAPACITY,40)),5,2) [TOTAL CAPACITY],STR(AVG(ISNULL(CAPACITY,40)),5,2) [AVG CAPACITY],STR(MIN(ISNULL(CAPACITY,40)),4,1) [MINIMUM CAPACITY],STR(MAX(ISNULL(CAPACITY,40)),4,2) [MAXIMUM CAPACITY]
FROM	Room

--10) WRITE NAME AND APPEND INITIALS WITH HALF+1
SELECT	UPPER(SNAME)+','+UPPER(SUBSTRING(SNAME,(LEN(SNAME)/2)+1,1))+'.' AS[NAMES]
FROM	Student 

--11A) FIND THE NAMES OF BOTTOM 50% OF STUDENTS ORDERED BY GRADE

SELECT TOP(50)PERCENT ST.SNAME,GR.GRADE
FROM	Student ST INNER JOIN Grade_report GR
ON		GR.STUDENT_NUMBER=ST.STNO
ORDER BY GR.GRADE  DESC

--11b) FIND 25% SENIOR TOP NAMES ORDER BY GRADE
SELECT	TOP 25 PERCENT ST.SNAME
FROM	Student ST INNER JOIN Grade_report GR
ON		ST.STNO = GR.STUDENT_NUMBER
ORDER BY GR.GRADE

--11C) USE WITH TIESE IN 11B QRY will give those column with same name too
SELECT	TOP 25 PERCENT  WITH TIES ST.SNAME
FROM	Student ST INNER JOIN Grade_report GR
ON		ST.STNO = GR.STUDENT_NUMBER
ORDER BY  GR.GRADE

--12a) count the number of courses tought by each instructor
SELECT  count(COURSE_NUM),INSTRUCTOR
FROM	Section 
GROUP BY INSTRUCTOR
ORDER BY INSTRUCTOR

--to see the above qry table output
SELECT  COURSE_NUM,INSTRUCTOR
FROM	Section 
ORDER BY INSTRUCTOR

-- 12b) count the number of distinct courses tought by each teacher

SELECT	COUNT(DISTINCT(COURSE_NUM)),INSTRUCTOR
FROM	Section
GROUP BY INSTRUCTOR
ORDER BY  INSTRUCTOR

--13) COUNT THE NUMBER OF CLASSES EACH STUDENT IS TAKING
SELECT	ST.SNAME,COUNT(CLASS) AS [NUMBER OF CLASSES TAKING]
FROM	Student ST
GROUP BY  ST.SNAME

--14) DISPLAY NAMES THAT ARE LESS THAN FIVE CHARACTER LONG
SELECT	SNAME AS [STUDENT NAMES]
FROM	Student
WHERE	LEN(SNAME)<5

--15) LIST STUDENT NUMBERS IN 140s RANGE
SELECT	STNO AS[STUDENT NUMBER]
FROM	Student
WHERE	STNO LIKE '14_' -- 14[0-9]

--16) FIND ALL STUDENTS WHO RECIEVED A AND B
SELECT	DISTINCT(ST.SNAME)
FROM	Student ST INNER JOIN Grade_report GR
ON		GR.STUDENT_NUMBER = ST.STNO
WHERE	GR.GRADE LIKE '[A-B]'

--17) ADD AN ASTERIK(*) TO ALL SENIORS AND JUNIORS WHO RECIEVED AT LEAST ONE 'A'
SELECT	ST.SNAME+'*' [STUDENT NAMES]
FROM	Student ST INNER JOIN Grade_report GR
ON		GR.STUDENT_NUMBER = ST.STNO
WHERE	GR.GRADE LIKE 'A'
GROUP BY ST.SNAME, GR.GRADE
HAVING	 COUNT(GR.GRADE)>=1













