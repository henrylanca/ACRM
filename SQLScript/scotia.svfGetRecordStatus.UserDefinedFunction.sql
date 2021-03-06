IF OBJECT_ID('scotia.svfGetRecordStatus','FN') IS NOT NULL DROP FUNCTION scotia.svfGetRecordStatus;
GO



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
