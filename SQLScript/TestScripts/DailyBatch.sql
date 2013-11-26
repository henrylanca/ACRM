declare @ACRMDate	smalldatetime

select @ACRMDate =BRANPRCDATE from BRPS
where BR='02'

EXEC	[scotia].[usp_ExtractCIFs]
		@ExtractDate = @ACRMDate,
		@ExtractType = 0,
		@IsEOD = 1

