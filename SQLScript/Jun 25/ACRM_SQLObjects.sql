USE [OP_DEV2]
GO
/****** Object:  UserDefinedFunction [dbo].[svfRemoveNonNumeric]    Script Date: 06/25/2013 16:19:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[svfRemoveNonNumeric](@String varchar(1000))
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
/****** Object:  UserDefinedFunction [dbo].[tvfGetUpdatedCNO]    Script Date: 06/25/2013 16:19:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[tvfGetUpdatedCNO]
(

)
RETURNS 
@changedCNO TABLE 
(
    CNO nvarchar(25)
)
AS
BEGIN
    declare @last_synchronization_version bigint
    set @last_synchronization_version = 0

    INSERT INTO @changedCNO(CNO)
    SELECT DISTINCT A.CNO FROM
    (
    select CT.CUSTOMERCODE COLLATE SQL_Latin1_General_CP1_CI_AS AS CNO from 
    CHANGETABLE(CHANGES MSDEV.WASADMIN.CUSTOMER, @last_synchronization_version) AS CT

    UNION

    select CT.CUSTOMERCODE COLLATE SQL_Latin1_General_CP1_CI_AS AS CNO from 
    CHANGETABLE(CHANGES MSDEV.WASADMIN.PERSONDETAILS, @last_synchronization_version) AS CT

    UNION

    select A.CUSTOMERCODE COLLATE SQL_Latin1_General_CP1_CI_AS AS CNO from 
    CHANGETABLE(CHANGES MSDEV.WASADMIN.CUSTOMERDOCDTL, @last_synchronization_version) AS CT
    JOIN MSDEV.WASADMIN.CUSTOMERDOCDTL A ON CT.DOCID = A.DOCID
    WHERE A.DOCTYPE IN ('021','Legal')

    UNION

    select B.CUSTOMERCODE COLLATE SQL_Latin1_General_CP1_CI_AS AS CNO from 
    CHANGETABLE(CHANGES MSDEV.WASADMIN.ADDRESS, @last_synchronization_version) AS CT
    JOIN MSDEV.WASADMIN.ADDRESS A ON A.ADDRESSID=CT.ADDRESSID
    JOIN MSDEV.WASADMIN.CUSTOMERDOCDTL B ON A.DOCID=B.DOCID

    UNION

    select A.UBREFCUSTOMERCODE COLLATE SQL_Latin1_General_CP1_CI_AS AS CNO from 
    CHANGETABLE(CHANGES MSDEV.WASADMIN.UBTB_CUSTOMERCONNECTIONDETAILS, @last_synchronization_version) AS CT
    JOIN MSDEV.WASADMIN.UBTB_CUSTOMERCONNECTIONDETAILS A 
    ON A.UBCUSTCONNECTIONIDPK=CT.UBCUSTCONNECTIONIDPK

    UNION

    select CT.CUSTOMERCODE COLLATE SQL_Latin1_General_CP1_CI_AS AS CNO from 
    CHANGETABLE(CHANGES MSDEV.WASADMIN.ORGDETAILS, @last_synchronization_version) AS CT

    UNION

    select CT.SCCUSTNO COLLATE SQL_Latin1_General_CP1_CI_AS AS CNO from 
    CHANGETABLE(CHANGES MSDEV.SCOTIA.SCOTIA_CORPORATEINFO, @last_synchronization_version) AS CT

    UNION

    select CT.CNO COLLATE SQL_Latin1_General_CP1_CI_AS AS CNO from 
    CHANGETABLE(CHANGES CUST, @last_synchronization_version) AS CT
    ) A
	
	RETURN 
END
GO
/****** Object:  Table [dbo].[ACRM]    Script Date: 06/25/2013 16:19:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ACRM](
	[CIFKey] [varchar](15) NOT NULL,
	[ExtractDate] [datetime] NOT NULL,
	[RecordID] [char](1) NOT NULL,
	[LocalCountryCode] [char](2) NOT NULL,
	[TransitNo] [int] NULL,
	[CustomerType] [varchar](10) NOT NULL,
	[Lastname] [varchar](30) NULL,
	[SecondLastName] [varchar](30) NULL,
	[FirstMiddleName] [varchar](30) NULL,
	[Alias] [varchar](10) NULL,
	[CustomerSince] [smalldatetime] NULL,
	[Sex] [varchar](10) NULL,
	[CustomerTitle] [varchar](15) NULL,
	[CustomerLanguage] [varchar](15) NULL,
	[BirthDate] [smalldatetime] NULL,
	[TaxID] [varchar](20) NULL,
	[AddressLineOne] [varchar](40) NULL,
	[AddressLineTwo] [varchar](40) NULL,
	[City] [varchar](24) NULL,
	[Province] [varchar](30) NULL,
	[CountryOfAddress] [varchar](30) NULL,
	[CountryOfCitizenship] [varchar](30) NULL,
	[CountryOfDomicile] [varchar](30) NULL,
	[ClientTypeDesc] [varchar](30) NULL,
	[OccupationCode] [varchar](30) NULL,
	[OccupationDesc] [varchar](30) NULL,
	[Employer] [varchar](30) NULL,
	[WorkPhone] [decimal](18, 0) NULL,
	[HomePhone] [decimal](18, 0) NULL,
	[Email] [varchar](50) NULL,
	[NameOfSpouse] [varchar](20) NULL,
	[SpousalTaxID] [varchar](20) NULL,
	[NameLineOne] [varchar](61) NULL,
	[NameLineTwo] [varchar](45) NULL,
	[SICCOde] [varchar](30) NULL,
	[CountryOfBirth] [varchar](30) NULL,
	[CityOfBirth] [varchar](30) NULL,
	[FatherName] [varchar](20) NULL,
	[MotherName] [varchar](20) NULL,
	[ChildName1] [varchar](20) NULL,
	[ChildName2] [varchar](20) NULL,
	[TradingName] [varchar](40) NULL,
	[DateOfBusinessEstablished] [smalldatetime] NULL,
	[RegistrationNo] [varchar](10) NULL,
	[LocationOfRegisterdOffice] [varchar](30) NULL,
	[BusinessTypeDesc] [varchar](30) NULL,
	[BusinessNature] [varchar](80) NULL,
	[BusinessStructure] [varchar](30) NULL,
	[KeyContactPerson] [varchar](20) NULL,
	[KeyContactPersonPhone] [decimal](18, 0) NULL,
	[PrincipleOwner] [varchar](20) NULL,
	[SignatureAuthroity] [varchar](120) NULL,
	[NoOfFullTime] [int] NULL,
	[NoOfPartTime] [int] NULL,
	[AnnualSalesExpectedSource] [varchar](40) NULL,
	[AnnualSalesExpectedAmount] [decimal](18, 0) NULL,
	[SupplierOne] [varchar](20) NULL,
	[SupplierTwo] [varchar](20) NULL,
	[AptUnitFloor] [varchar](32) NULL,
	[RecordStatus] [char](1) NOT NULL,
	[DataBaseID] [char](1) NOT NULL,
	[ExtractFlag] [char](1) NULL,
	[RowValue]  AS (checksum([CIFKEY],[LocalCountryCode],[TransitNo],[CustomerType],[Lastname],[SecondLastName],[FirstMiddleName],[Alias],[CustomerSince],[Sex],[CustomerTitle],[CustomerLanguage],[BirthDate],[TaxID],[AddressLineOne],[AddressLineTwo],[City],[Province],[CountryOfAddress],[CountryOfCitizenship],[CountryOfDomicile],[ClientTypeDesc],[OccupationCode],[OccupationDesc],[Employer],[WorkPhone],[HomePhone],[Email],[NameOfSpouse],[SpousalTaxID],[NameLineOne],[NameLineTwo],[SICCOde],[CountryOfBirth],[CityOfBirth],[FatherName],[MotherName],[ChildName1],[ChildName2],[TradingName],[DateOfBusinessEstablished],[RegistrationNo],[LocationOfRegisterdOffice],[BusinessTypeDesc],[BusinessNature],[BusinessStructure],[KeyContactPerson],[KeyContactPersonPhone],[PrincipleOwner],[SignatureAuthroity],[NoOfFullTime],[NoOfPartTime],[AnnualSalesExpectedSource],[AnnualSalesExpectedAmount],[SupplierOne],[SupplierTwo],[AptUnitFloor]))
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'N=New, C=Change, T=Terminated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACRM', @level2type=N'COLUMN',@level2name=N'RecordStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'F=Full-load record, D=Daily Delta record, T=Temporary Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACRM', @level2type=N'COLUMN',@level2name=N'ExtractFlag'
GO
/****** Object:  UserDefinedFunction [dbo].[svfGetSignings]    Script Date: 06/25/2013 16:19:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[svfGetSignings]
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
/****** Object:  UserDefinedFunction [dbo].[svfGetRecordStatus]    Script Date: 06/25/2013 16:19:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[svfGetRecordStatus]
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
/****** Object:  UserDefinedFunction [dbo].[svfGetCodeInformation]    Script Date: 06/25/2013 16:19:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[svfGetCodeInformation]
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
/****** Object:  UserDefinedFunction [dbo].[svfCheckUserBalance]    Script Date: 06/25/2013 16:19:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[svfCheckUserBalance]
(
    @Customer char(11)
)
RETURNS int
AS
BEGIN
    DECLARE @HasBalance int

    select @HasBalance=COUNT(1) FROM
    (
    	   --The first part is for BankFusion Clients which. 
	   --The Transactions are mapping to account (PBAD), and then to customer again
	   select FXDH.CCY AS CCY, sum(FXDH.CCYAMT) AS AMT from FXDH
	   JOIN PBAD on FXDH.CUST= PBAD.ACCNO AND FXDH.BR=PBAD.BR
	   WHERE PBAD.CUSTOMER=@Customer 
	   group by FXDH.ccy

	   union 

	   select DLDT.CCY AS CCY, sum(DLDT.CCYAMT) AS AMT from DLDT
	   JOIN PBAD on DLDT.CNO= PBAD.ACCNO AND DLDT.BR=PBAD.BR
	   WHERE PBAD.CUSTOMER=@Customer 
	   group by ccy

	   UNION

	   select ACCT.CCY AS CCY, sum(ACDW.CCYAMT) AS AMT from ACCT
	   JOIN PBAD on ACCT.CNO= PBAD.ACCNO 
	   JOIN ACDW ON ACCT.ACCOUNTNO = ACDW.ACCOUNTNO AND ACDW.BR=PBAD.BR
	   WHERE PBAD.CUSTOMER=@Customer 
	   group by ccy

	   union

	   select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   JOIN PBAD on SPSH.CNO= PBAD.ACCNO AND SPSH.BR=PBAD.BR
	   JOIN SECM ON SPSH.SECID=SECM.SECID
	   WHERE PBAD.CUSTOMER=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='FI' 
	   group by SPSH.CCY

	   Union

	   select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   JOIN PBAD on SPSH.CNO= PBAD.ACCNO
	   JOIN SECM ON SPSH.SECID=SECM.SECID AND SPSH.BR=PBAD.BR
	   WHERE PBAD.CUSTOMER=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='EQ' 
	   group by SPSH.CCY

	   UNION

	   select SLDH.CCY AS CCY, sum(COMPROCAMT) AS AMT from SLDH
	   JOIN PBAD on SLDH.CNO= PBAD.ACCNO AND SLDH.BR=PBAD.BR
	   WHERE PBAD.CUSTOMER=@Customer 
	   group by ccy

	   UNION

	   select RPDT.CCY AS CCY, sum(RPDT.FACEAMT) AS AMT from RPDT
	   JOIN PBAD on RPDT.CNO= PBAD.ACCNO AND RPDT.BR=PBAD.BR
	   WHERE PBAD.CUSTOMER=@Customer 
	   group by ccy

	   UNION

	   select SWDT.NOTCCY AS CCY, sum(SWDT.NOTCCYAMT) AS AMT from SWDH
	   JOIN PBAD on SWDH.CNO= PBAD.ACCNO AND SWDH.BR=PBAD.BR
	   JOIN SWDT ON SWDH.DEALNO = SWDT.DEALNO
	   WHERE PBAD.CUSTOMER=@Customer 
	   group by SWDT.NOTCCY

	   UNION

	   select FFDH.CUSTFEECCY AS CCY, sum(FFDH.CCYAMT) AS AMT from FFDH
	   JOIN PBAD on FFDH.CNO= PBAD.ACCNO AND FFDH.BR=PBAD.BR
	   WHERE PBAD.CUSTOMER=@Customer 
	   group by FFDH.CUSTFEECCY
	   
	   UNION
	   
	   --The second part is for OPICS Clients which do not have account concept. 
	   --The Transactions are mapping to customer directly
	   
	   select FXDH.CCY AS CCY, sum(FXDH.CCYAMT) AS AMT from FXDH
	   WHERE FXDH.CUST=@Customer 
	   group by FXDH.ccy

	   union 

	   select DLDT.CCY AS CCY, sum(DLDT.CCYAMT) AS AMT from DLDT
	   WHERE DLDT.CNO=@Customer 
	   group by ccy

	   UNION

	   select ACCT.CCY AS CCY, sum(ACDW.CCYAMT) AS AMT from ACCT
	   JOIN ACDW ON ACCT.ACCOUNTNO = ACDW.ACCOUNTNO 
	   WHERE ACCT.CNO=@Customer 
	   group by ccy

	   union

	   select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   JOIN SECM ON SPSH.SECID=SECM.SECID
	   WHERE SPSH.CNO=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='FI' 
	   group by SPSH.CCY

	   Union

	   select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   JOIN SECM ON SPSH.SECID=SECM.SECID
	   WHERE SPSH.CNO=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='EQ'  
	   group by SPSH.CCY

	   UNION

	   select SLDH.CCY AS CCY, sum(COMPROCAMT) AS AMT from SLDH
	   WHERE SLDH.CNO=@Customer 
	   group by ccy

	   UNION

	   select RPDT.CCY AS CCY, sum(RPDT.FACEAMT) AS AMT from RPDT
	   WHERE RPDT.CNO=@Customer 
	   group by ccy

	   UNION

	   select SWDT.NOTCCY AS CCY, sum(SWDT.NOTCCYAMT) AS AMT from SWDH
	   JOIN SWDT ON SWDH.DEALNO = SWDT.DEALNO
	   WHERE SWDH.CNO=@Customer 
	   group by SWDT.NOTCCY

	   UNION

	   select FFDH.CUSTFEECCY AS CCY, sum(FFDH.CCYAMT) AS AMT from FFDH
	   WHERE FFDH.CNO=@Customer 
	   group by FFDH.CUSTFEECCY	   
    ) A
    Where A.AMT>0
    
      
    RETURN @HasBalance

END
GO
/****** Object:  StoredProcedure [dbo].[usp_ExtractCIFs]    Script Date: 06/25/2013 16:19:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Lan
-- Create date:	May 13, 2013
-- Description:	The procedure loads full-load and Daily delata CIFs into ACRM table
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExtractCIFs] 	
	@ExtractDate smalldatetime = null, --@ExtractDate means latest date when the value is null	
	@ExtractType int = 0, --@ExtractType: 0 - Daily delata, 1- full-load
	@IsEOD bit = 0 --EOD bathc flag, 1 - True, 0 - false
AS
BEGIN
    --Suppress string or binary data would be truncated messages with the ANSI WARNINGS setting
    SET ANSI_WARNINGS OFF

    DECLARE @ErrMsg NVARCHAR(4000)
    DECLARE @ErrSeverity INT;
    DECLARE @ErrState INT;
    
    DECLARE @TranName VARCHAR(20);
    SELECT @TranName = 'ACRMTransaction';    

    DECLARE @ExtractFlag CHAR(1)

    DECLARE @ACRMCount INT    
    
    If @ExtractDate is null
    BEGIN
	   set @ExtractDate = GETDATE()
    END    
    
    SELECT @ACRMCount=COUNT(1) FROM ACRM
    
    --Performs full-load for the first daily delta extraction
    IF @IsEOD=1 and @ACRMCount<=0
    BEGIN
	   SET @ExtractType = 1
    END
    
    --Performs full-load Extraction
    IF @ExtractType = 1
    BEGIN
	   
	   BEGIN TRY
	   BEGIN TRAN @TranName;
	   
	   --Step 1.1 Insert initial full-load bankFusion CIFs into ACRM    
	   INSERT INTO ACRM(CIFKey, ExtractDate, RecordID, LocalCountryCode, TransitNo, CustomerType,
	   Lastname, SecondLastName, FirstMiddleName, Alias, CustomerSince, Sex, CustomerTitle,
	   CustomerLanguage, BirthDate, TaxID, AddressLineOne, AddressLineTwo, City,
	   Province, CountryOfAddress, CountryOfCitizenship, CountryOfDomicile, ClientTypeDesc,
	   OccupationCode, OccupationDesc, Employer, WorkPhone, HomePhone, Email, NameOfSpouse,
	   SpousalTaxID, NameLineOne, NameLineTwo, SICCOde, CountryOfBirth, CityOfBirth,
	   FatherName, MotherName, ChildName1, ChildName2, TradingName, DateOfBusinessEstablished,
	   RegistrationNo, LocationOfRegisterdOffice, BusinessTypeDesc, BusinessNature, BusinessStructure,
	   KeyContactPerson, KeyContactPersonPhone, PrincipleOwner, SignatureAuthroity, NoOfFullTime,
	   NoOfPartTime, AnnualSalesExpectedSource,AnnualSalesExpectedAmount, SupplierOne,
	   SupplierTwo, AptUnitFloor, RecordStatus, DataBaseID, ExtractFlag) 
	   select 
	   A.CUSTOMERCODE as CIFKey,
	   @ExtractDate AS ExtractDate,
	   'D' AS RecordID,
	   'JM' AS LocalCountryCode,
	   A.BRANCHSORTCODE AS TransitNo, 
	   dbo.svfGetCodeInformation(-1,A.CUSTOMERTYPE) as CustomerType,
	   B.SURNAME AS Lastname,
	   NULL AS SecondLastName,
	   B.FORENAME AS FirstMiddleName,
	   B.UBNAMEATBIRTH AS Alias,
	   A.UBCREATEDTTM AS CustomerSince,
	   dbo.svfGetCodeInformation('017',B.SEX) AS Sex,
	   dbo.svfGetCodeInformation('002',B.TITLE) AS CustomerTitle,
	   dbo.svfGetCodeInformation('023',A.PREFERREDLANGUAGE) AS CustomerLanguage,
	   B.DATEOFBIRTH AS BirthDate,
	   A.TAXNUMBER AS TaxID,
	   D.ADDRESSLINE1 AS AddressLineOne,
	   D.ADDRESSLINE2 AS AddressLineTwo,
	   D.ADDRESSLINE5 AS City,
	   D.ADDRESSLINE6 AS Province,
	   D.ADDRESSLINE7 AS CountryOfAddress,
	   B.UBCITIZENSHIP AS CountryOfCitizenship,
	   B.COUNTRYOFDOMICILE AS CountryOfDomicile,
	   NULL AS ClientTypeDesc,
	   NULL AS OccupationCode,
	   dbo.svfGetCodeInformation('1073',E.UBPOSITION) AS OccupationDesc,
	   F.UBCUSTCONNECTIONNAME AS Employer,
	   NULL AS WorkPhone,
	   dbo.svfRemoveNonNumeric((SELECT UBCONTACTMEDIUMDETAILS FROM MSDEV.WASADMIN.UBTB_CUSTOMERCONTACT
	   WHERE UBCUSTOMERCODE=A.CUSTOMERCODE AND UBCONTACTMEDIUMTYPE='001')) AS HomePhone,
	   (SELECT UBCONTACTMEDIUMDETAILS FROM MSDEV.WASADMIN.UBTB_CUSTOMERCONTACT
	   WHERE UBCUSTOMERCODE=A.CUSTOMERCODE AND UBCONTACTMEDIUMTYPE='004') AS Email,
	   NULL AS NameOfSpouse,
	   NULL AS SpousalTaxID,
	   G.ORGNAME AS NameLineOne,
	   NULL AS NameLineTwo,
	   Z.SIC AS SICCOde,
	   B.UBCOUNTRYOFBIRTH AS CountryOfBirth,
	   B.UBPLACEOFBIRTH AS CityOfBirth,
	   B.FATHERNAME AS FatherName,
	   B.UBMOTHERMAIDENNAME AS MotherName,
	   NULL AS ChildName1,
	   NULL AS ChildName2,
	   H.UBDOCUNIQUEREF AS TradingName,
	   G.ESTABLISHEDDATE AS DateOfBusinessEstablished,
	   H.UBTRADINGREGNUM AS RegistrationNo,
	   H.UBPLACEISSUEREG AS LocationOfRegisterdOffice,
	   I.SCDESCRIPTIONBUSINESS AS BusinessTypeDesc,
	   NULL AS BusinessNature,
	   dbo.svfGetCodeInformation('1086',G.UBISSUBSIDIARYORPARENT) AS BusinessStructure,
	   NULL AS KeyContactPerson,
	   dbo.svfRemoveNonNumeric((SELECT UBCONTACTMEDIUMDETAILS FROM MSDEV.WASADMIN.UBTB_CUSTOMERCONTACT
	   WHERE UBCUSTOMERCODE=A.CUSTOMERCODE AND UBCONTACTMEDIUMTYPE='001' AND UBISPREFERREDCONTACT='Y')) AS KeyContactPersonPhone,
	   NULL AS PrincipleOwner,
	   dbo.svfGetSignings(A.CUSTOMERCODE) AS SignatureAuthroity,
	   G.NOOFEMPLOYEES AS NoOfFullTime,
	   NULL AS NoOfPartTime,
	   dbo.svfGetCodeInformation('1089',G.UBPRIMARYBUSINESSACTIVITY) AS AnnualSalesExpectedSource,
	   G.ANNUALTURNOVER AS AnnualSalesExpectedAmount,
	   NULL AS SupplierOne,
	   NULL AS SupplierTwo,
	   NULL AS AptUnitFloor,
	   'C' AS RecordStatus,
	   1 AS DatabaseId,
	   'T' as ExtractFlag
	   from  MSDEV.WASADMIN.CUSTOMER A
	   LEFT JOIN MSDEV.WASADMIN.PERSONDETAILS B ON A.CUSTOMERCODE=B.CUSTOMERCODE
	   LEFT JOIN MSDEV.WASADMIN.CUSTOMERDOCDTL C ON C.CUSTOMERCODE=A.CUSTOMERCODE AND C.DOCTYPE='021'
	   LEFT JOIN MSDEV.WASADMIN.ADDRESS D On D.DOCID = C.DOCID 
	   LEFT JOIN MSDEV.WASADMIN.UBTB_CUSTEMPLOYMENTDETAILS E ON E.CUSTOMERCODE=A.CUSTOMERCODE AND E.UBISCURRENTEMPLOYER='Y'
	   LEFT JOIN MSDEV.WASADMIN.UBTB_CUSTOMERCONNECTIONDETAILS F ON F.UBCUSTCONNECTIONIDPK = E.UBCUSTCONNECTIONID
	   LEFT JOIN MSDEV.WASADMIN.ORGDETAILS G On A.CUSTOMERCODE=G.CUSTOMERCODE
	   LEFT JOIN MSDEV.WASADMIN.CUSTOMERDOCDTL H ON H.CUSTOMERCODE=A.CUSTOMERCODE AND H.DOCTYPE='Legal'
	   LEFT JOIN MSDEV.SCOTIA.SCOTIA_CORPORATEINFO I ON I.SCCUSTNO=A.CUSTOMERCODE
	   JOIN CUST Z on A.CUSTOMERCODE collate SQL_Latin1_General_CP1_CS_AS =Z.CNO collate SQL_Latin1_General_CP1_CS_AS			   
	   WHERE A.CUSTOMERTYPE in ('1062','1063')
	   AND dbo.svfCheckUserBalance(A.CUSTOMERCODE)>0 	   
	   
	   DELETE FROM ACRM WHERE ExtractFlag='F'
	   
	   UPDATE ACRM SET ExtractFlag='F' WHERE ExtractFlag='T'
	   	   
	   COMMIT TRAN @TranName;
	   END TRY
	   BEGIN CATCH
    	   ROLLBACK TRAN @TranName    	   
    	   
    	   SELECT @ErrMsg = 'Full-load extraction failed: '+ERROR_MESSAGE(),
    	   @ErrSeverity = ERROR_SEVERITY(),
    	   @ErrState = ERROR_STATE()
    	   
    	   RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
	   END CATCH;   
    END
    
    ELSE
    BEGIN
	   ----Performs EOD Daily Delta Extraction    
	   IF @IsEOD=1 
	   BEGIN
	   BEGIN TRY
	   
	   BEGIN TRAN @TranName
	   	   
	   --Delete delta rows recorded one month ago
	   DELETE FROM ACRM WHERE ExtractFlag='D' AND ExtractDate< DATEADD(mm,-1,@ExtractDate)
	   
	   --Insert daily bankFusion CIFs into ACRM    
	   INSERT INTO ACRM(CIFKey, ExtractDate, RecordID, LocalCountryCode, TransitNo, CustomerType,
	   Lastname, SecondLastName, FirstMiddleName, Alias, CustomerSince, Sex, CustomerTitle,
	   CustomerLanguage, BirthDate, TaxID, AddressLineOne, AddressLineTwo, City,
	   Province, CountryOfAddress, CountryOfCitizenship, CountryOfDomicile, ClientTypeDesc,
	   OccupationCode, OccupationDesc, Employer, WorkPhone, HomePhone, Email, NameOfSpouse,
	   SpousalTaxID, NameLineOne, NameLineTwo, SICCOde, CountryOfBirth, CityOfBirth,
	   FatherName, MotherName, ChildName1, ChildName2, TradingName, DateOfBusinessEstablished,
	   RegistrationNo, LocationOfRegisterdOffice, BusinessTypeDesc, BusinessNature, BusinessStructure,
	   KeyContactPerson, KeyContactPersonPhone, PrincipleOwner, SignatureAuthroity, NoOfFullTime,
	   NoOfPartTime, AnnualSalesExpectedSource,AnnualSalesExpectedAmount, SupplierOne,
	   SupplierTwo, AptUnitFloor, RecordStatus, DataBaseID, ExtractFlag) 
	   select 
	   A.CUSTOMERCODE as CIFKey,
	   @ExtractDate AS ExtractDate,
	   'D' AS RecordID,
	   'JM' AS LocalCountryCode,
	   A.BRANCHSORTCODE AS TransitNo, 
	   dbo.svfGetCodeInformation(-1,A.CUSTOMERTYPE) as CustomerType,
	   B.SURNAME AS Lastname,
	   NULL AS SecondLastName,
	   B.FORENAME AS FirstMiddleName,
	   B.UBNAMEATBIRTH AS Alias,
	   A.UBCREATEDTTM AS CustomerSince,
	   dbo.svfGetCodeInformation('017',B.SEX) AS Sex,
	   dbo.svfGetCodeInformation('002',B.TITLE) AS CustomerTitle,
	   dbo.svfGetCodeInformation('023',A.PREFERREDLANGUAGE) AS CustomerLanguage,
	   B.DATEOFBIRTH AS BirthDate,
	   A.TAXNUMBER AS TaxID,
	   D.ADDRESSLINE1 AS AddressLineOne,
	   D.ADDRESSLINE2 AS AddressLineTwo,
	   D.ADDRESSLINE5 AS City,
	   D.ADDRESSLINE6 AS Province,
	   D.ADDRESSLINE7 AS CountryOfAddress,
	   B.UBCITIZENSHIP AS CountryOfCitizenship,
	   B.COUNTRYOFDOMICILE AS CountryOfDomicile,
	   NULL AS ClientTypeDesc,
	   NULL AS OccupationCode,
	   dbo.svfGetCodeInformation('1073',E.UBPOSITION) AS OccupationDesc,	   
	   F.UBCUSTCONNECTIONNAME AS Employer,
	   NULL AS WorkPhone,
	   dbo.svfRemoveNonNumeric((SELECT UBCONTACTMEDIUMDETAILS FROM MSDEV.WASADMIN.UBTB_CUSTOMERCONTACT
	   WHERE UBCUSTOMERCODE=A.CUSTOMERCODE AND UBCONTACTMEDIUMTYPE='001')) AS HomePhone,
	   (SELECT UBCONTACTMEDIUMDETAILS FROM MSDEV.WASADMIN.UBTB_CUSTOMERCONTACT
	   WHERE UBCUSTOMERCODE=A.CUSTOMERCODE AND UBCONTACTMEDIUMTYPE='004') AS Email,
	   NULL AS NameOfSpouse,
	   NULL AS SpousalTaxID,
	   G.ORGNAME AS NameLineOne,
	   NULL AS NameLineTwo,
	   Z.SIC AS SICCOde,
	   B.UBCOUNTRYOFBIRTH AS CountryOfBirth,
	   B.UBPLACEOFBIRTH AS CityOfBirth,
	   B.FATHERNAME AS FatherName,
	   B.UBMOTHERMAIDENNAME AS MotherName,
	   NULL AS ChildName1,
	   NULL AS ChildName2,
	   H.UBDOCUNIQUEREF AS TradingName,
	   G.ESTABLISHEDDATE AS DateOfBusinessEstablished,
	   H.UBTRADINGREGNUM AS RegistrationNo,
	   H.UBPLACEISSUEREG AS LocationOfRegisterdOffice,
	   I.SCDESCRIPTIONBUSINESS AS BusinessTypeDesc,
	   NULL AS BusinessNature,
	   dbo.svfGetCodeInformation('1086',G.UBISSUBSIDIARYORPARENT) AS BusinessStructure,
	   NULL AS KeyContactPerson,
	   dbo.svfRemoveNonNumeric((SELECT UBCONTACTMEDIUMDETAILS FROM MSDEV.WASADMIN.UBTB_CUSTOMERCONTACT
	   WHERE UBCUSTOMERCODE=A.CUSTOMERCODE AND UBCONTACTMEDIUMTYPE='001' AND UBISPREFERREDCONTACT='Y')) AS KeyContactPersonPhone,
	   NULL AS PrincipleOwner,
	   dbo.svfGetSignings(A.CUSTOMERCODE) AS SignatureAuthroity,
	   G.NOOFEMPLOYEES AS NoOfFullTime,
	   NULL AS NoOfPartTime,
	   dbo.svfGetCodeInformation('1089',G.UBPRIMARYBUSINESSACTIVITY) AS AnnualSalesExpectedSource,
	   G.ANNUALTURNOVER AS AnnualSalesExpectedAmount,
	   NULL AS SupplierOne,
	   NULL AS SupplierTwo,
	   NULL AS AptUnitFloor,
	   dbo.svfGetRecordStatus(A.CUSTOMERCODE) AS RecordStatus,
	   1 AS DatabaseId,
	   'T' as ExtractFlag
	   from  MSDEV.WASADMIN.CUSTOMER A
	   LEFT JOIN MSDEV.WASADMIN.PERSONDETAILS B ON A.CUSTOMERCODE=B.CUSTOMERCODE
	   LEFT JOIN MSDEV.WASADMIN.CUSTOMERDOCDTL C ON C.CUSTOMERCODE=A.CUSTOMERCODE AND C.DOCTYPE='021'
	   LEFT JOIN MSDEV.WASADMIN.ADDRESS D On D.DOCID = C.DOCID 
	   LEFT JOIN MSDEV.WASADMIN.UBTB_CUSTEMPLOYMENTDETAILS E ON E.CUSTOMERCODE=A.CUSTOMERCODE AND E.UBISCURRENTEMPLOYER='Y'
	   LEFT JOIN MSDEV.WASADMIN.UBTB_CUSTOMERCONNECTIONDETAILS F ON F.UBCUSTCONNECTIONIDPK = E.UBCUSTCONNECTIONID
	   LEFT JOIN MSDEV.WASADMIN.ORGDETAILS G On A.CUSTOMERCODE=G.CUSTOMERCODE
	   LEFT JOIN MSDEV.WASADMIN.CUSTOMERDOCDTL H ON H.CUSTOMERCODE=A.CUSTOMERCODE AND H.DOCTYPE='Legal'
	   LEFT JOIN MSDEV.SCOTIA.SCOTIA_CORPORATEINFO I ON I.SCCUSTNO=A.CUSTOMERCODE
	   JOIN CUST Z on A.CUSTOMERCODE collate SQL_Latin1_General_CP1_CS_AS =Z.CNO collate SQL_Latin1_General_CP1_CS_AS			   
	   WHERE A.CUSTOMERTYPE in ('1062','1063')
	   AND dbo.svfCheckUserBalance(A.CUSTOMERCODE)>0 
	   
	   --Remove today's deplicated delta records
	   DELETE FROM ACRM
	   WHERE ExtractFlag='T'
	   AND RowValue IN (SELECT RowValue FROM ACRM Where ExtractFlag<>'T')
	   	  
	   UPDATE ACRM SET ExtractFlag='D' WHERE ExtractFlag='T'
	   
	   COMMIT TRAN @TranName
	   END TRY
	   BEGIN CATCH
	   
	   ROLLBACK TRAN @TranName
    	   
    	   
    	   SELECT @ErrMsg = 'Full-load extraction failed: '+ERROR_MESSAGE(),
    	   @ErrSeverity = ERROR_SEVERITY(),
    	   @ErrState = ERROR_STATE()
    	   
    	   RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);	   
	   
	   END CATCH	   
	   END
    END
    
    --Final Step, Extract full-load or Daily delta CIFs		
    IF @ExtractType = 0
    BEGIN		
	   SELECT @ExtractFlag ='D'
    END
    Else
    Begin
	   SELECT @ExtractFlag ='F'
    End
		
    Select 
    CIFKey, ExtractDate, RecordID, LocalCountryCode, TransitNo, CustomerType,
    Lastname, SecondLastName, FirstMiddleName, Alias, CustomerSince, Sex, CustomerTitle,
    CustomerLanguage, BirthDate, TaxID, AddressLineOne, AddressLineTwo, City,
    Province, CountryOfAddress, CountryOfCitizenship, CountryOfDomicile, ClientTypeDesc,
    OccupationCode, OccupationDesc, Employer, WorkPhone, HomePhone, Email, NameOfSpouse,
    SpousalTaxID, NameLineOne, NameLineTwo, SICCOde, CountryOfBirth, CityOfBirth,
    FatherName, MotherName, ChildName1, ChildName2, TradingName, DateOfBusinessEstablished,
    RegistrationNo, LocationOfRegisterdOffice, BusinessTypeDesc, BusinessNature, BusinessStructure,
    KeyContactPerson, KeyContactPersonPhone, PrincipleOwner, SignatureAuthroity, NoOfFullTime,
    NoOfPartTime, AnnualSalesExpectedSource,AnnualSalesExpectedAmount, SupplierOne,
    SupplierTwo, AptUnitFloor, RecordStatus, DataBaseID
    from ACRM
    Where RecordStatus in ('N','C')
    And ExtractFlag=@ExtractFlag
    and cast(ExtractDate as Date) = CAST(@ExtractDate as Date)		
END
GO
