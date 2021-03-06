
/****** Object:  UserDefinedFunction [scotia].[svfRemoveNonNumeric]    Script Date: 07/08/2013 13:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
