USE [OP_DEV2]
GO
/****** Object:  StoredProcedure [scotia].[usp_ExtractCIFs]    Script Date: 10/15/2013 13:35:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Henry Lan
-- Create date:	May 13, 2013
-- Description:	The procedure loads full-load and Daily delata CIFs into ACRM table
-- =============================================
CREATE PROCEDURE [scotia].[usp_ExtractCIFs] 	
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
    
    SELECT @ACRMCount=COUNT(1) FROM scotia.ACRM
    
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
	   INSERT INTO scotia.ACRM(CIFKey, ExtractDate, RecordID, LocalCountryCode, TransitNo, CustomerType,
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
	   select distinct
	   A.CUSTOMERCODE as CIFKey,
	   @ExtractDate AS ExtractDate,
	   'D' AS RecordID,
	   'JM' AS LocalCountryCode,
	   49775 AS TransitNo, 
	   CASE scotia.svfGetCodeInformation(-1,A.CUSTOMERTYPE) 
		  WHEN 'Retail' THEN 'INDIVIDUAL'
		  ELSE 'BUSINESS'
	   END as CustomerType,	   
	   B.SURNAME AS Lastname,
	   B.UBNAMEATBIRTH AS SecondLastName,
	   B.FORENAME AS FirstMiddleName,
	   NULL AS Alias,
	   A.UBCREATEDTTM AS CustomerSince,
	   scotia.svfGetCodeInformation('017',B.SEX) AS Sex,
	   scotia.svfGetCodeInformation('002',B.TITLE) AS CustomerTitle,
	   scotia.svfGetCodeInformation('023',A.PREFERREDLANGUAGE) AS CustomerLanguage,
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
	   scotia.svfGetCodeInformation('1073',E.UBPOSITION) AS OccupationDesc,
	   F.UBCUSTCONNECTIONNAME AS Employer,
	   NULL AS WorkPhone,
	   scotia.svfRemoveNonNumeric((SELECT UBCONTACTMEDIUMDETAILS FROM bfub.UBTB_CUSTOMERCONTACT
	   WHERE UBCUSTOMERCODE=A.CUSTOMERCODE AND UBCONTACTMEDIUMTYPE='001')) AS HomePhone,
	   (SELECT UBCONTACTMEDIUMDETAILS FROM bfub.UBTB_CUSTOMERCONTACT
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
	   I.SCDESCRIPTIONPRODUCT AS BusinessNature,
	   --dbo.svfGetCodeInformation('1086',G.UBISSUBSIDIARYORPARENT) AS BusinessStructure,
	   A.UBCUSTOMERSUBTYPE AS BusinessStructure,
	   NULL AS KeyContactPerson,
	   scotia.svfRemoveNonNumeric((SELECT UBCONTACTMEDIUMDETAILS FROM bfub.UBTB_CUSTOMERCONTACT
	   WHERE UBCUSTOMERCODE=A.CUSTOMERCODE AND UBCONTACTMEDIUMTYPE='001' AND UBISPREFERREDCONTACT='Y')) AS KeyContactPersonPhone,
	   NULL AS PrincipleOwner,
	   scotia.svfGetSignings(A.CUSTOMERCODE) AS SignatureAuthroity,
	   G.NOOFEMPLOYEES AS NoOfFullTime,
	   NULL AS NoOfPartTime,
	   scotia.svfGetCodeInformation('1089',G.UBPRIMARYBUSINESSACTIVITY) AS AnnualSalesExpectedSource,
	   G.ANNUALTURNOVER AS AnnualSalesExpectedAmount,
	   NULL AS SupplierOne,
	   NULL AS SupplierTwo,
	   NULL AS AptUnitFloor,
	   'C' AS RecordStatus,
	   1 AS DatabaseId,
	   'T' as ExtractFlag
	   from  bfub.CUSTOMER A
	   LEFT JOIN bfub.PERSONDETAILS B ON A.CUSTOMERCODE=B.CUSTOMERCODE
	   LEFT JOIN bfub.CUSTOMERDOCDTL C ON C.CUSTOMERCODE=A.CUSTOMERCODE AND C.DOCTYPE='021'
	   LEFT JOIN bfub.ADDRESS D On D.DOCID = C.DOCID 
	   LEFT JOIN bfub.UBTB_CUSTEMPLOYMENTDETAILS E ON E.CUSTOMERCODE=A.CUSTOMERCODE AND E.UBISCURRENTEMPLOYER='Y'
	   LEFT JOIN bfub.UBTB_CUSTOMERCONNECTIONDETAILS F ON F.UBCUSTCONNECTIONIDPK = E.UBCUSTCONNECTIONID
	   LEFT JOIN bfub.ORGDETAILS G On A.CUSTOMERCODE=G.CUSTOMERCODE
	   LEFT JOIN bfub.CUSTOMERDOCDTL H ON H.CUSTOMERCODE=A.CUSTOMERCODE AND H.DOCTYPE='Legal'
	   LEFT JOIN bfub.SCOTIA_CORPORATEINFO I ON I.SCCUSTNO=A.CUSTOMERCODE
	   JOIN CUST Z on A.CUSTOMERCODE collate SQL_Latin1_General_CP1_CS_AS =Z.CNO collate SQL_Latin1_General_CP1_CS_AS			   
	   JOIN PBAD Y ON Y.Customer=Z.CNO and Y.BR='02'
	   WHERE A.CUSTOMERTYPE in ('1062','1063')
	   AND A.BRANCHSORTCODE='00000002'
	   AND (scotia.svfCheckUserBalance(A.CUSTOMERCODE)>0 	   
	   or scotia.svfCheckUserBalance(Y.ACCNO)>0)
	   
	   DELETE FROM scotia.ACRM WHERE ExtractFlag='F'
	   
	   UPDATE scotia.ACRM SET ExtractFlag='F' WHERE ExtractFlag='T'
	   	   
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
	   DELETE FROM scotia.ACRM WHERE ExtractFlag='D' AND ExtractDate< DATEADD(mm,-1,@ExtractDate)
	   
	   --Insert daily bankFusion CIFs into ACRM    
	   INSERT INTO scotia.ACRM(CIFKey, ExtractDate, RecordID, LocalCountryCode, TransitNo, CustomerType,
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
	   select distinct
	   A.CUSTOMERCODE as CIFKey,
	   @ExtractDate AS ExtractDate,
	   'D' AS RecordID,
	   'JM' AS LocalCountryCode,
	   49775 AS TransitNo, 
	   CASE scotia.svfGetCodeInformation(-1,A.CUSTOMERTYPE) 
		  WHEN 'Retail' THEN 'INDIVIDUAL'
		  ELSE 'BUSINESS'
	   END as CustomerType,
	   B.SURNAME AS Lastname,
	   B.UBNAMEATBIRTH AS SecondLastName,
	   B.FORENAME AS FirstMiddleName,
	   NULL AS Alias,
	   A.UBCREATEDTTM AS CustomerSince,
	   scotia.svfGetCodeInformation('017',B.SEX) AS Sex,
	   scotia.svfGetCodeInformation('002',B.TITLE) AS CustomerTitle,
	   scotia.svfGetCodeInformation('023',A.PREFERREDLANGUAGE) AS CustomerLanguage,
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
	   scotia.svfGetCodeInformation('1073',E.UBPOSITION) AS OccupationDesc,	   
	   F.UBCUSTCONNECTIONNAME AS Employer,
	   NULL AS WorkPhone,
	   scotia.svfRemoveNonNumeric((SELECT UBCONTACTMEDIUMDETAILS FROM bfub.UBTB_CUSTOMERCONTACT
	   WHERE UBCUSTOMERCODE=A.CUSTOMERCODE AND UBCONTACTMEDIUMTYPE='001')) AS HomePhone,
	   (SELECT UBCONTACTMEDIUMDETAILS FROM bfub.UBTB_CUSTOMERCONTACT
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
	   I.SCDESCRIPTIONPRODUCT AS BusinessNature,
	   --dbo.svfGetCodeInformation('1086',G.UBISSUBSIDIARYORPARENT) AS BusinessStructure,
	   A.UBCUSTOMERSUBTYPE AS BusinessStructure,
	   NULL AS KeyContactPerson,
	   scotia.svfRemoveNonNumeric((SELECT UBCONTACTMEDIUMDETAILS FROM bfub.UBTB_CUSTOMERCONTACT
	   WHERE UBCUSTOMERCODE=A.CUSTOMERCODE AND UBCONTACTMEDIUMTYPE='001' AND UBISPREFERREDCONTACT='Y')) AS KeyContactPersonPhone,
	   NULL AS PrincipleOwner,
	   scotia.svfGetSignings(A.CUSTOMERCODE) AS SignatureAuthroity,
	   G.NOOFEMPLOYEES AS NoOfFullTime,
	   NULL AS NoOfPartTime,
	   scotia.svfGetCodeInformation('1089',G.UBPRIMARYBUSINESSACTIVITY) AS AnnualSalesExpectedSource,
	   G.ANNUALTURNOVER AS AnnualSalesExpectedAmount,
	   NULL AS SupplierOne,
	   NULL AS SupplierTwo,
	   NULL AS AptUnitFloor,
	   scotia.svfGetRecordStatus(A.CUSTOMERCODE) AS RecordStatus,
	   1 AS DatabaseId,
	   'T' as ExtractFlag
	   from  bfub.CUSTOMER A
	   LEFT JOIN bfub.PERSONDETAILS B ON A.CUSTOMERCODE=B.CUSTOMERCODE
	   LEFT JOIN bfub.CUSTOMERDOCDTL C ON C.CUSTOMERCODE=A.CUSTOMERCODE AND C.DOCTYPE='021'
	   LEFT JOIN bfub.ADDRESS D On D.DOCID = C.DOCID 
	   LEFT JOIN bfub.UBTB_CUSTEMPLOYMENTDETAILS E ON E.CUSTOMERCODE=A.CUSTOMERCODE AND E.UBISCURRENTEMPLOYER='Y'
	   LEFT JOIN bfub.UBTB_CUSTOMERCONNECTIONDETAILS F ON F.UBCUSTCONNECTIONIDPK = E.UBCUSTCONNECTIONID
	   LEFT JOIN bfub.ORGDETAILS G On A.CUSTOMERCODE=G.CUSTOMERCODE
	   LEFT JOIN bfub.CUSTOMERDOCDTL H ON H.CUSTOMERCODE=A.CUSTOMERCODE AND H.DOCTYPE='Legal'
	   LEFT JOIN bfub.SCOTIA_CORPORATEINFO I ON I.SCCUSTNO=A.CUSTOMERCODE
	   JOIN CUST Z on A.CUSTOMERCODE collate SQL_Latin1_General_CP1_CS_AS =Z.CNO collate SQL_Latin1_General_CP1_CS_AS			   
	   JOIN PBAD Y ON Y.Customer=Z.CNO and Y.BR='02'
	   WHERE A.CUSTOMERTYPE in ('1062','1063')
	   AND A.BRANCHSORTCODE='00000002'
	   AND (scotia.svfCheckUserBalance(A.CUSTOMERCODE)>0 
	   or scotia.svfCheckUserBalance(Y.ACCNO)>0)
	   
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
    from scotia.ACRM
    Where RecordStatus in ('N','C')
    And ExtractFlag=@ExtractFlag
    and cast(ExtractDate as Date) = CAST(@ExtractDate as Date)		
END
GO
