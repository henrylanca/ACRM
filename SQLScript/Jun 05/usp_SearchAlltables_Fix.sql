USE [MSDEV]
GO
/****** Object:  StoredProcedure [dbo].[usp_SearchAllTables_FIX]    Script Date: 05/29/2013 12:12:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_SearchAllTables_FIX]
(
    @SearchStr nvarchar(100)
)
AS
BEGIN


    CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

    SET NOCOUNT ON

    DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
    
    SET  @TableName = ''
    SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')

    WHILE @TableName IS NOT NULL
    BEGIN
        SET @ColumnName = ''
        SET @TableName = 
        (
            SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
            FROM    INFORMATION_SCHEMA.TABLES
            WHERE       TABLE_TYPE = 'BASE TABLE'
                AND QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
                AND OBJECTPROPERTY(
                        OBJECT_ID(
                            QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
                             ), 'IsMSShipped'
                               ) = 0
        )

        WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
        BEGIN
            SET @ColumnName =
            (
                SELECT MIN(QUOTENAME(COLUMN_NAME))
                FROM    INFORMATION_SCHEMA.COLUMNS
                WHERE       TABLE_SCHEMA    = PARSENAME(@TableName, 2)
                    AND TABLE_NAME  = PARSENAME(@TableName, 1)
                    AND DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
                    AND QUOTENAME(COLUMN_NAME) > @ColumnName
            )

            IF @ColumnName IS NOT NULL
            BEGIN
                INSERT INTO #Results
                EXEC
                (
                    'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
                    FROM ' + @TableName + ' (NOLOCK) ' +
                    ' WHERE ' + @ColumnName + ' = '  + '''' +@SearchStr +''''
                )
            END
        END 
    END

    SELECT ColumnName, ColumnValue FROM #Results
END

