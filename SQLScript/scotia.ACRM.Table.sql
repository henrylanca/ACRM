USE [OP_DEV2]
GO
/****** Object:  Table [scotia].[ACRM]    Script Date: 07/08/2013 13:32:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [scotia].[ACRM](
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
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'N=New, C=Change, T=Terminated' , @level0type=N'SCHEMA',@level0name=N'scotia', @level1type=N'TABLE',@level1name=N'ACRM', @level2type=N'COLUMN',@level2name=N'RecordStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'F=Full-load record, D=Daily Delta record, T=Temporary Record' , @level0type=N'SCHEMA',@level0name=N'scotia', @level1type=N'TABLE',@level1name=N'ACRM', @level2type=N'COLUMN',@level2name=N'ExtractFlag'
GO
