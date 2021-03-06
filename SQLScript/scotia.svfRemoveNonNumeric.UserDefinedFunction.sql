IF OBJECT_ID('scotia.svfRemoveNonNumeric','FN') IS NOT NULL DROP FUNCTION scotia.svfRemoveNonNumeric;
GO


CREATE FUNCTION [scotia].[svfRemoveNonNumeric](@String varchar(1000))
RETURNS VARCHAR(50)
BEGIN
DECLARE @Cur_Index INT
SET @Cur_Index = PATINDEX('%[^0-9]%',@String)

WHILE @Cur_Index > 0
BEGIN
SET @String = STUFF(@String,@Cur_Index,1,'')
SET @Cur_Index = PATINDEX('%[^0-9]%',@String)

END

RETURN @String

END
GO
