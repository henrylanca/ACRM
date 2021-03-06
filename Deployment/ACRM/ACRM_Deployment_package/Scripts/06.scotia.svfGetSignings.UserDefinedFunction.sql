
/****** Object:  UserDefinedFunction [scotia].[svfGetSignings]    Script Date: 07/08/2013 13:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
    FROM MSDEV.WASADMIN.UBTB_CUSTOMERCONNECTIONDETAILS
    WHERE UBCUSTCONNECTIONIDPK IN
    (
	   select UBCUSTCONNECTIONID from MSDEV.WASADMIN.UBTB_CUSTOMERRELATIONSHIP
	   where UBCUSTOMERCODE=@CIFKey
	   and UBRELATIONSHIPTYPEID in ('003','005','029')    
    )
          
    RETURN @AllSignings

END
GO
