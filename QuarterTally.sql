/*** Quarter Tally Results ***/
USE ODS
Select
	--cc.RegistrationDay
	cc.BranchCode
	,CASE
		WHEN cc.SectionStatusID1 = 'X' THEN 'Cancelled'
		ELSE ''
	END [Cancelled]
	,cc.ItemNumber
	,cc.CourseID
	,cc.Section
	,cc.CourseTitle
	,cc.InstructorName
	--,cc.InstructorSID
	--,cc.CourseNumber
	,cc.StudentsEnrolled
	,cc.ClassCapacity
	,CASE
		WHEN cc.StudentsEnrolled > ClassCapacity THEN cc.StudentsEnrolled - ClassCapacity
		ELSE 0
	END [WaitList]
	,isNULL(cc.ClassClosed,'') as Closed
	,[day].Title AS [Days]
	,CASE
		WHEN cc.StartTime IS NULL THEN 'ARRANGED'
		ELSE RTRIM(REPLACE(LTRIM(RIGHT(CONVERT(char,cc.StartTime,109),18)),':00:000',' '))+ ' - ' + RTRIM(REPLACE(LTRIM(RIGHT(CONVERT(char,cc.EndTime,109),18)),':00:000',' '))
	END [Time]
	,cc.Room -- Human readable please
From
	ODSDW.dbo.ClassChange as cc JOIN
	  ODS.dbo.[Day] ON cc.DayID = [Day].DayID,
	(Select max(RegistrationDay) as RegistrationDay, ClassID from ODSDW.dbo.ClassChange group by ClassID) maxresults
Where (cc.RegistrationDay = maxresults.RegistrationDay and cc.ClassID = maxresults.ClassID)
		AND (cc.SectionStatusID1 NOT IN ('Z') OR cc.SectionStatusID1 IS NULL)
		AND (cc.SectionStatusID2 NOT IN('A') OR cc.SectionStatusID2 IS NULL)
		AND (cc.SectionStatusID4 NOT IN('N','M') OR cc.SectionStatusID4 IS NULL)
		AND (cc.ItemNumber NOT IN ('9999') AND cc.ItemNumber NOT LIKE ('C%') AND cc.ItemNumber NOT LIKE 'W%' AND cc.ItemNumber NOT LIKE 'X%')
		AND cc.Department != 'BASED'
ORDER BY CourseID