select 
A.CNO asCIFKey,
GetDate() AS ExtractDate,
'D' AS RecordID,
'JM' AS LocalCountryCode,
NULL AS TransitNo, 
A.CTYPE as CustomerType,
A.CFN1 AS Lastname,
NULL AS SecondLastName,
NULL AS FirstMiddleName,
A.SN AS Alias,
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
NULL AS AptUnitFloor
from  CUST A 

