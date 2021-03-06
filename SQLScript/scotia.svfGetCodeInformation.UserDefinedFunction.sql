IF OBJECT_ID('scotia.svfGetCodeInformation','FN') IS NOT NULL DROP FUNCTION scotia.svfGetCodeInformation;
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [scotia].[svfGetCodeInformation]
(
    @ParentType nvarchar(50),
    @SubType nvarchar(50)
)
RETURNS nvarchar(255)
AS
BEGIN
    DECLARE @CodeDesc nvarchar(255)
    
    SELECT @CodeDesc=CBDESCRIPTION FROM bfub.CBVW_GENERICCODE
    WHERE CBCODETYPE=@ParentType
    AND CBSUBCODETYPE=@SubType
    
    RETURN @CodeDesc

END
GO
