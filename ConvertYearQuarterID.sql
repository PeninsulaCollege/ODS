/*
The CTC college system uses a special format to indicate the Year/Quarter information
This script prints out all the year/quarters available.
*/
USE ODS

GO
WITH [YRQBase32] AS (
       SELECT
                     [YearQuarterID]                                               AS     [YearQuarterID]
              ,      LEFT([YearQuarterID], 1)                                      AS     [Digit1]
              ,      ASCII(LEFT([YearQuarterID], 1))                               AS     [ASCII1]
              ,      SUBSTRING([YearQuarterID], 2, 1)                              AS     [Digit2]
              ,      ASCII(SUBSTRING([YearQuarterID], 2, 1))                       AS     [ASCII2]
              ,      SUBSTRING([YearQuarterID], 3, 1)                              AS     [Digit3]
              ,      ASCII(SUBSTRING([YearQuarterID], 3, 1))                       AS     [ASCII3]
              ,      SUBSTRING([YearQuarterID], 4, 1)                              AS     [Digit4]
              ,      ASCII(SUBSTRING([YearQuarterID], 4, 1))                       AS     [ASCII4]
              ,      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'                        AS     [Base36]
       FROM   [YearQuarter]
)
SELECT
              CHARINDEX([Digit1], [Base36], 1) - 11                                AS [DecadeMultiplier]
       ,      2000 + ((CHARINDEX([Digit1], [Base36], 1) - 11) * 10) + [Digit2]     AS [YearStart]
       ,      CASE
              WHEN CHARINDEX([Digit2], [Base36], 1) > CHARINDEX([Digit3], [Base36], 1) THEN
                     2000 + ((CHARINDEX([Digit1], [Base36], 1) - 11) * 10) + [Digit3] + 10
              ELSE
                     2000 + ((CHARINDEX([Digit1], [Base36], 1) - 11) * 10) + [Digit3]
              END                                                                  AS [YearEnd]
       ,      CASE
              WHEN [Digit4] = 1 THEN 'Summer'
              WHEN [Digit4] = 2 THEN 'Fall'
              WHEN [Digit4] = 3 THEN 'Winter'
              WHEN [Digit4] = 4 THEN 'Spring'
              ELSE '?'
              END                                                                  AS [QuarterName]
       ,      *
FROM   [YRQBase32]
WHERE YearQuarterID = 'B014'
