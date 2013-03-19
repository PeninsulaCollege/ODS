/*
Fixes name case issues.  Names coming from the mainframe are all CAPS, previously, only
the first char was toUPPER, that didn't work for special cases such as hyphenated names
or names with apostrophe's, ie. O'Mack
*/
USE [ODS]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_ProperCaseAdv]    Script Date: 09/15/2012 12:14:58 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO


/* Found on: http://stackoverflow.com/a/1007802 */

CREATE FUNCTION [dbo].[ufn_ProperCaseAdv]
(
--The string to be converted to proper case
@input varchar(8000)
)
--This function returns the proper case string of varchar type
RETURNS varchar(8000)
AS
BEGIN
/* Debug*/
--DECLARE @input VARCHAR(50)
--SET @input = 'BROCKRICH'
IF @input IS NULL
BEGIN
--Just return NULL if input string is NULL
RETURN NULL
END

--Character variable declarations
DECLARE @output varchar(8000)
--Integer variable declarations
DECLARE @ctr int, @len int, @found_at int
--Constant declarations
DECLARE @LOWER_CASE_a int, @LOWER_CASE_z int, @Delimiter char(6), @UPPER_CASE_A int, @UPPER_CASE_Z int

--Variable/Constant initializations

SET @ctr = 1
SET @len = LEN(@input)
SET @output = ''
SET @LOWER_CASE_a = 97
SET @LOWER_CASE_z = 122
SET @Delimiter = ''',-, ' -- Look for Apostraphes, Hyphens and Spaces. Matches O'Neil, Van Helsing, Last-Last
SET @UPPER_CASE_A = 65
SET @UPPER_CASE_Z = 90

WHILE @ctr <= @len
BEGIN
--This loop will take care of reccuring white spaces
WHILE CHARINDEX(SUBSTRING(@input,@ctr,1), @Delimiter) > 0
BEGIN
SET @output = @output + SUBSTRING(@input,@ctr,1)
SET @ctr = @ctr + 1
END

IF ASCII(SUBSTRING(@input,@ctr,1)) BETWEEN @LOWER_CASE_a AND @LOWER_CASE_z
BEGIN
--Converting the first character to upper case
SET @output = @output + UPPER(SUBSTRING(@input,@ctr,1))
END
ELSE
BEGIN
SET @output = @output + SUBSTRING(@input,@ctr,1)
END

SET @ctr = @ctr + 1

WHILE CHARINDEX(SUBSTRING(@input,@ctr,1), @Delimiter) = 0 AND (@ctr <= @len)
BEGIN
IF ASCII(SUBSTRING(@input,@ctr,1)) BETWEEN @UPPER_CASE_A AND @UPPER_CASE_Z
BEGIN
SET @output = @output + LOWER(SUBSTRING(@input,@ctr,1))
END
ELSE
BEGIN
SET @output = @output + SUBSTRING(@input,@ctr,1)
END
SET @ctr = @ctr + 1
END

END
--SELECT @output /* Debug */
RETURN @output
END



GO


