IF OBJECT_ID('scotia.svfCheckUserBalance','FN') IS NOT NULL DROP FUNCTION scotia.svfCheckUserBalance;
GO

CREATE FUNCTION [scotia].[svfCheckUserBalance]
(
    @Customer char(11)
)
RETURNS int
AS
BEGIN
    DECLARE @HasBalance int
    
    select @HasBalance = COUNT(1) from gbal
    where CNO=@Customer
    group by CNO, CCY
    having SUM(TDYAMCLSG)>0
    order by CNO    
      
    RETURN ISNULL(@HasBalance,0)

END
GO
