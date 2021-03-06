USE [OP_DEV2]
GO
/****** Object:  UserDefinedFunction [dbo].[svfRemoveNonNumeric]    Script Date: 05/29/2013 12:14:18 ******/
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
/****** Object:  Table [dbo].[ACRM]    Script Date: 05/29/2013 12:14:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ACRM](
	[CIFKey] [varchar](15) NOT NULL,
	[ExtractDate] [smalldatetime] NOT NULL,
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
	[AddressLineOne] [varchar](40) NOT NULL,
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
	[DataBaseID] [char](1) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[svfGetSignings]    Script Date: 05/29/2013 12:14:18 ******/
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
/****** Object:  UserDefinedFunction [dbo].[svfGetCodeInformation]    Script Date: 05/29/2013 12:14:18 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ExtractCIFs]    Script Date: 05/29/2013 12:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Lan
-- Create date: May 13, 2013
-- Description:	The procedure loads full-load and Daily delata CIFs into ACRM table
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExtractCIFs] 	
	@ExtractDate smalldatetime = null, --@ExtractDate means latest date when the value is null	
	@ExtractType int = 0 --@ExtractType: 0 - Daily delata, 1- full-load
AS
BEGIN
    DECLARE @ACRMCount INT
    
    SELECT @ACRMCount=COUNT(1) FROM ACRM
    
	If @ExtractDate is null
	BEGIN
		set @ExtractDate = GETDATE()
	END

    --Suppress string or binary data would be truncated messages with the ANSI WARNINGS setting
    SET ANSI_WARNINGS OFF

	--Step 1, Insert initial full-load CIFs into ACRM	
    IF @ACRMCount<=0
    BEGIN 
            
    --Step 1.1 Insert initial full-load OPICS CIFs into ACRM    
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
	SupplierTwo, AptUnitFloor, RecordStatus, DataBaseID)
	   select 
	   A.CNO as CIFKey,
	   GetDate() AS ExtractDate,
	   'D' AS RecordID,
	   'JM' AS LocalCountryCode,
	   NULL AS TransitNo, 
	   A.CTYPE as CustomerType,
	   SUBSTRING(A.CFN1,1,30) AS Lastname,
	   NULL AS SecondLastName,
	   NULL AS FirstMiddleName,
	   SUBSTRING(A.SN,1,10) AS Alias,
	   NULL AS CustomerSince,
	   NULL AS Sex,
	   NULL AS CustomerTitle,
	   NULL AS CustomerLanguage,
	   A.BirthDate AS BirthDate,
	   A.TAXID AS TaxID,
	   A.CA1 AS AddressLineOne,
	   A.CA2 AS AddressLineTwo,
	   A.CA3 AS City,
	   A.CA4 AS Province,
	   A.CA5 AS CountryOfAddress,
	   NULL AS CountryOfCitizenship,
	   NULL AS CountryOfDomicile,
	   NULL AS ClientTypeDesc,
	   NULL AS OccupationCode,
	   NULL AS OccupationDesc,
	   NULL AS Employer,
	   NULL AS WorkPhone,
	   NULL AS HomePhone,
	   NULL AS Email,
	   NULL AS NameOfSpouse,
	   NULL AS SpousalTaxID,
	   A.CFN1 AS NameLineOne,
	   A.CFN2 AS NameLineTwo,
	   A.SIC AS SICCOde,
	   NULL AS CountryOfBirth,
	   NULL AS CityOfBirth,
	   NULL AS FatherName,
	   NULL AS MotherName,
	   NULL AS ChildName1,
	   NULL AS ChildName2,
	   NULL AS TradingName,
	   NULL AS DateOfBusinessEstablished,
	   NULL AS RegistrationNo,
	   NULL AS LocationOfRegisterdOffice,
	   NULL AS BusinessTypeDesc,
	   NULL AS BusinessNature,
	   NULL AS BusinessStructure,
	   NULL AS KeyContactPerson,
	   NULL AS KeyContactPersonPhone,
	   NULL AS PrincipleOwner,
	   NULL AS SignatureAuthroity,
	   NULL AS NoOfFullTime,
	   NULL AS NoOfPartTime,
	   NULL AS AnnualSalesExpectedSource,
	   NULL AS AnnualSalesExpectedAmount,
	   NULL AS SupplierOne,
	   NULL AS SupplierTwo,
	   NULL AS AptUnitFloor,
	   'C' AS RecordStatus,
	   1 AS DatabaseId
	   from  CUST A 
	   Where A.CNO collate SQL_Latin1_General_CP1_CS_AS NOT in
	   (
	   SELECT CUSTOMERCODE collate SQL_Latin1_General_CP1_CS_AS FROM MSDEV.WASADMIN.CUSTOMER
	   )


    --Step 1.2 Insert initial full-load bankFusion CIFs into ACRM    
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
	SupplierTwo, AptUnitFloor, RecordStatus, DataBaseID) 
    select 
    A.CUSTOMERCODE asCIFKey,
    GetDate() AS ExtractDate,
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
	   1 AS DatabaseId
from  MSDEV.WASADMIN.CUSTOMER A
LEFT JOIN MSDEV.WASADMIN.PERSONDETAILS B ON A.CUSTOMERCODE=B.CUSTOMERCODE
LEFT JOIN MSDEV.WASADMIN.CUSTOMERDOCDTL C ON C.CUSTOMERCODE=A.CUSTOMERCODE AND C.DOCTYPE='021'
LEFT JOIN MSDEV.WASADMIN.ADDRESS D On D.DOCID = C.DOCID 
LEFT JOIN MSDEV.WASADMIN.UBTB_CUSTEMPLOYMENTDETAILS E ON E.CUSTOMERCODE=A.CUSTOMERCODE
LEFT JOIN MSDEV.WASADMIN.UBTB_CUSTOMERCONNECTIONDETAILS F ON F.UBCUSTCONNECTIONIDPK = E.UBCUSTCONNECTIONID
LEFT JOIN MSDEV.WASADMIN.ORGDETAILS G On A.CUSTOMERCODE=G.CUSTOMERCODE
LEFT JOIN MSDEV.WASADMIN.CUSTOMERDOCDTL H ON H.CUSTOMERCODE=A.CUSTOMERCODE AND H.DOCTYPE='Legal'
LEFT JOIN MSDEV.SCOTIA.SCOTIA_CORPORATEINFO I ON I.SCCUSTNO=A.CUSTOMERCODE
JOIN CUST Z on A.CUSTOMERCODE collate SQL_Latin1_General_CP1_CS_AS =Z.CNO collate SQL_Latin1_General_CP1_CS_AS			   
    WHERE A.CUSTOMERTYPE in ('1062','1063')
    END

    SET ANSI_WARNINGS OFF

	
	--Final Step, Extract full-load or Daily delta CIFs
	
	--Extract Daily Delta CIFs
	IF @ExtractType = 0
		BEGIN
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
		and cast(ExtractDate as Date) = CAST(@ExtractDate as Date)
		END
	Else
		Begin
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
		from ACRM A
		Where RecordStatus in ('N','C')
		and cast(ExtractDate as Date) = 
		(Select cast(max(ExtractDate) as Date) from ACRM where 
		RecordStatus in ('N','C') and CIFKey=A.CIFKey and ExtractDate <= @ExtractDate)
		End
END
GO
/****** Object:  UserDefinedFunction [dbo].[svfCheckUserBalance]    Script Date: 05/29/2013 12:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[svfCheckUserBalance]
(
    @Customer char(11),
    @BR  char(2)
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
	   JOIN PBAD on FXDH.CUST= PBAD.ACCNO
	   WHERE PBAD.CUSTOMER=@Customer AND FXDH.BR=@BR
	   group by FXDH.ccy

	   union 

	   select DLDT.CCY AS CCY, sum(DLDT.CCYAMT) AS AMT from DLDT
	   JOIN PBAD on DLDT.CNO= PBAD.ACCNO
	   WHERE PBAD.CUSTOMER=@Customer AND DLDT.BR =@BR
	   group by ccy

	   UNION

	   select ACCT.CCY AS CCY, sum(ACDW.CCYAMT) AS AMT from ACCT
	   JOIN PBAD on ACCT.CNO= PBAD.ACCNO
	   JOIN ACDW ON ACCT.ACCOUNTNO = ACDW.ACCOUNTNO 
	   WHERE PBAD.CUSTOMER=@Customer AND ACDW.BR = @BR
	   group by ccy

	   union

	   select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   JOIN PBAD on SPSH.CNO= PBAD.ACCNO
	   JOIN SECM ON SPSH.SECID=SECM.SECID
	   WHERE PBAD.CUSTOMER=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='FI' AND SPSH.BR =@BR 
	   group by SPSH.CCY

	   Union

	   select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   JOIN PBAD on SPSH.CNO= PBAD.ACCNO
	   JOIN SECM ON SPSH.SECID=SECM.SECID
	   WHERE PBAD.CUSTOMER=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='EQ' AND SPSH.BR =@BR 
	   group by SPSH.CCY

	   UNION

	   select SLDH.CCY AS CCY, sum(COMPROCAMT) AS AMT from SLDH
	   JOIN PBAD on SLDH.CNO= PBAD.ACCNO
	   WHERE PBAD.CUSTOMER=@Customer AND SLDH.BR =@BR
	   group by ccy

	   UNION

	   select RPDT.CCY AS CCY, sum(RPDT.FACEAMT) AS AMT from RPDT
	   JOIN PBAD on RPDT.CNO= PBAD.ACCNO
	   WHERE PBAD.CUSTOMER=@Customer AND RPDT.BR =@BR
	   group by ccy

	   UNION

	   select SWDT.NOTCCY AS CCY, sum(SWDT.NOTCCYAMT) AS AMT from SWDH
	   JOIN PBAD on SWDH.CNO= PBAD.ACCNO
	   JOIN SWDT ON SWDH.DEALNO = SWDT.DEALNO
	   WHERE PBAD.CUSTOMER=@Customer AND SWDH.BR =@BR
	   group by SWDT.NOTCCY

	   UNION

	   select FFDH.CUSTFEECCY AS CCY, sum(FFDH.CCYAMT) AS AMT from FFDH
	   JOIN PBAD on FFDH.CNO= PBAD.ACCNO
	   WHERE PBAD.CUSTOMER=@Customer AND FFDH.BR =@BR
	   group by FFDH.CUSTFEECCY
	   
	   UNION
	   
	   --The second part is for OPICS Clients which do not have account concept. 
	   --The Transactions are mapping to customer directly
	   
	   select FXDH.CCY AS CCY, sum(FXDH.CCYAMT) AS AMT from FXDH
	   WHERE FXDH.CUST=@Customer AND FXDH.BR=@BR
	   group by FXDH.ccy

	   union 

	   select DLDT.CCY AS CCY, sum(DLDT.CCYAMT) AS AMT from DLDT
	   WHERE DLDT.CNO=@Customer AND DLDT.BR =@BR
	   group by ccy

	   UNION

	   select ACCT.CCY AS CCY, sum(ACDW.CCYAMT) AS AMT from ACCT
	   JOIN ACDW ON ACCT.ACCOUNTNO = ACDW.ACCOUNTNO 
	   WHERE ACCT.CNO=@Customer AND ACDW.BR = @BR
	   group by ccy

	   union

	   select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   JOIN SECM ON SPSH.SECID=SECM.SECID
	   WHERE SPSH.CNO=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='FI' AND SPSH.BR =@BR 
	   group by SPSH.CCY

	   Union

	   select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   JOIN SECM ON SPSH.SECID=SECM.SECID
	   WHERE SPSH.CNO=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='EQ' AND SPSH.BR =@BR 
	   group by SPSH.CCY

	   UNION

	   select SLDH.CCY AS CCY, sum(COMPROCAMT) AS AMT from SLDH
	   WHERE SLDH.CNO=@Customer AND SLDH.BR =@BR
	   group by ccy

	   UNION

	   select RPDT.CCY AS CCY, sum(RPDT.FACEAMT) AS AMT from RPDT
	   WHERE RPDT.CNO=@Customer AND RPDT.BR =@BR
	   group by ccy

	   UNION

	   select SWDT.NOTCCY AS CCY, sum(SWDT.NOTCCYAMT) AS AMT from SWDH
	   JOIN SWDT ON SWDH.DEALNO = SWDT.DEALNO
	   WHERE SWDH.CNO=@Customer AND SWDH.BR =@BR
	   group by SWDT.NOTCCY

	   UNION

	   select FFDH.CUSTFEECCY AS CCY, sum(FFDH.CCYAMT) AS AMT from FFDH
	   WHERE FFDH.CNO=@Customer AND FFDH.BR =@BR
	   group by FFDH.CUSTFEECCY	   
    ) A
    Where A.AMT>0
    
      
    RETURN @HasBalance

END
GO
