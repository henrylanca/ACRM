USE [OP_DEV2]
GO
/****** Object:  StoredProcedure [dbo].[usp_ExtractCIFs]    Script Date: 05/29/2013 11:39:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Lan
-- Create date: May 13, 2013
-- Description:	The procedure loads full-load and Daily delata CIFs into ACRM table
-- =============================================
ALTER PROCEDURE [dbo].[usp_ExtractCIFs] 	
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
