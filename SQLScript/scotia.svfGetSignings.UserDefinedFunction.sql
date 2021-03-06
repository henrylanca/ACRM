IF OBJECT_ID('scotia.svfGetSignings','FN') IS NOT NULL DROP FUNCTION scotia.svfGetSignings;
GO

CREATE FUNCTION [scotia].[svfGetSignings]
(
    @CIFKey nvarchar(25)
)
RETURNS nvarchar(2000)
AS
BEGIN
    DECLARE @AllSignings nvarchar(2000)
    
    SELECT @AllSignings = COALESCE(@AllSignings + ', ', '') + UBCUSTCONNECTIONNAME 
    FROM bfub.UBTB_CUSTOMERCONNECTIONDETAILS
    WHERE UBCUSTCONNECTIONIDPK IN
    (
	   select UBCUSTCONNECTIONID from bfub.UBTB_CUSTOMERRELATIONSHIP
	   where UBCUSTOMERCODE=@CIFKey
	   and UBRELATIONSHIPTYPEID in ('003','005','029')    
    )
          
    RETURN @AllSignings

END
GO
