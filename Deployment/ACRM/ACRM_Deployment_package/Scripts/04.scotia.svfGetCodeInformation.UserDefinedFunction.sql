
/****** Object:  UserDefinedFunction [scotia].[svfGetCodeInformation]    Script Date: 07/08/2013 13:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
    
    SELECT @CodeDesc=CBDESCRIPTION FROM MSDEV.CBS.CBVW_GENERICCODE
    WHERE CBCODETYPE=@ParentType
    AND CBSUBCODETYPE=@SubType
    
    RETURN @CodeDesc

END
GO
