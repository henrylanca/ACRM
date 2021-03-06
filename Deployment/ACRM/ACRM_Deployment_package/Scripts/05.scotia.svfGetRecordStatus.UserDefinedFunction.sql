
/****** Object:  UserDefinedFunction [scotia].[svfGetRecordStatus]    Script Date: 07/08/2013 13:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [scotia].[svfGetRecordStatus]
(
	-- Add the parameters for the function here
	@CNO VARCHAR(15)
)
RETURNS CHAR(1)
AS
BEGIN
    DECLARE @Status CHAR(1)
    DECLARE @Count int
    
    SET @Status = 'C'
        
    SELECT @Count = COUNT(1) FROM ACRM
    WHERE CIFKey = @CNO
    
    IF @Count<=0
    BEGIN
	   SET @Status = 'N'
    END
   
    return @Status

END
GO
