DELETE FROM BBFT WHERE PGMNAME = 'ACRM'
GO

INSERT INTO BBFT (BR, PGMNAME, TYPE, PGMDESC, RESTDESC, COMMAND, COMMT, LSTMNTDTE, TRXSTREAM)
VALUES
('02', 'ACRM', 'P', 'ACRM Ertaction', 'RERUN STEP', '02,,FALSE', '', GETDATE(), 'ACRMEOS')
GO
