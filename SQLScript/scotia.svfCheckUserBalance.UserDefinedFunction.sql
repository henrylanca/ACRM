USE [OP_DEV2]
GO
/****** Object:  UserDefinedFunction [scotia].[svfCheckUserBalance]    Script Date: 08/30/2013 11:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [scotia].[svfCheckUserBalance]
(
    @Customer char(11)
)
RETURNS int
AS
BEGIN
    DECLARE @HasBalance int
    
    select @HasBalance = COUNT(1) from gbal
    where CNO=@Customer
    group by CNO, CCY
    having SUM(TDYAMCLSG)>0
    order by CNO    

    --select @HasBalance=COUNT(1) FROM
    --(
    --	   --The first part is for BankFusion Clients which. 
	   ----The Transactions are mapping to account (PBAD), and then to customer again
	   --select FXDH.CCY AS CCY, sum(FXDH.CCYAMT) AS AMT from FXDH
	   --JOIN PBAD on FXDH.CUST= PBAD.ACCNO AND FXDH.BR=PBAD.BR
	   --WHERE PBAD.CUSTOMER=@Customer 
	   --group by FXDH.ccy

	   --union 

	   --select DLDT.CCY AS CCY, sum(DLDT.CCYAMT) AS AMT from DLDT
	   --JOIN PBAD on DLDT.CNO= PBAD.ACCNO AND DLDT.BR=PBAD.BR
	   --WHERE PBAD.CUSTOMER=@Customer 
	   --group by ccy

	   --UNION

	   --select ACCT.CCY AS CCY, sum(ACDW.CCYAMT) AS AMT from ACCT
	   --JOIN PBAD on ACCT.CNO= PBAD.ACCNO 
	   --JOIN ACDW ON ACCT.ACCOUNTNO = ACDW.ACCOUNTNO AND ACDW.BR=PBAD.BR
	   --WHERE PBAD.CUSTOMER=@Customer 
	   --group by ccy

	   --union

	   --select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   --JOIN PBAD on SPSH.CNO= PBAD.ACCNO AND SPSH.BR=PBAD.BR
	   --JOIN SECM ON SPSH.SECID=SECM.SECID
	   --WHERE PBAD.CUSTOMER=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='FI' 
	   --group by SPSH.CCY

	   --Union

	   --select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   --JOIN PBAD on SPSH.CNO= PBAD.ACCNO
	   --JOIN SECM ON SPSH.SECID=SECM.SECID AND SPSH.BR=PBAD.BR
	   --WHERE PBAD.CUSTOMER=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='EQ' 
	   --group by SPSH.CCY

	   --UNION

	   --select SLDH.CCY AS CCY, sum(COMPROCAMT) AS AMT from SLDH
	   --JOIN PBAD on SLDH.CNO= PBAD.ACCNO AND SLDH.BR=PBAD.BR
	   --WHERE PBAD.CUSTOMER=@Customer 
	   --group by ccy

	   --UNION

	   --select RPDT.CCY AS CCY, sum(RPDT.FACEAMT) AS AMT from RPDT
	   --JOIN PBAD on RPDT.CNO= PBAD.ACCNO AND RPDT.BR=PBAD.BR
	   --WHERE PBAD.CUSTOMER=@Customer 
	   --group by ccy

	   --UNION

	   --select SWDT.NOTCCY AS CCY, sum(SWDT.NOTCCYAMT) AS AMT from SWDH
	   --JOIN PBAD on SWDH.CNO= PBAD.ACCNO AND SWDH.BR=PBAD.BR
	   --JOIN SWDT ON SWDH.DEALNO = SWDT.DEALNO
	   --WHERE PBAD.CUSTOMER=@Customer 
	   --group by SWDT.NOTCCY

	   --UNION

	   --select FFDH.CUSTFEECCY AS CCY, sum(FFDH.CCYAMT) AS AMT from FFDH
	   --JOIN PBAD on FFDH.CNO= PBAD.ACCNO AND FFDH.BR=PBAD.BR
	   --WHERE PBAD.CUSTOMER=@Customer 
	   --group by FFDH.CUSTFEECCY
	   
	   --UNION
	   
	   ----The second part is for OPICS Clients which do not have account concept. 
	   ----The Transactions are mapping to customer directly
	   
	   --select FXDH.CCY AS CCY, sum(FXDH.CCYAMT) AS AMT from FXDH
	   --WHERE FXDH.CUST=@Customer 
	   --group by FXDH.ccy

	   --union 

	   --select DLDT.CCY AS CCY, sum(DLDT.CCYAMT) AS AMT from DLDT
	   --WHERE DLDT.CNO=@Customer 
	   --group by ccy

	   --UNION

	   --select ACCT.CCY AS CCY, sum(ACDW.CCYAMT) AS AMT from ACCT
	   --JOIN ACDW ON ACCT.ACCOUNTNO = ACDW.ACCOUNTNO 
	   --WHERE ACCT.CNO=@Customer 
	   --group by ccy

	   --union

	   --select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   --JOIN SECM ON SPSH.SECID=SECM.SECID
	   --WHERE SPSH.CNO=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='FI' 
	   --group by SPSH.CCY

	   --Union

	   --select SPSH.CCY AS CCY, sum(SPSH.FACEAMT) AS AMT from SPSH
	   --JOIN SECM ON SPSH.SECID=SECM.SECID
	   --WHERE SPSH.CNO=@Customer AND SECM.PRODUCT='SECUR' AND SECM.PRODTYPE='EQ'  
	   --group by SPSH.CCY

	   --UNION

	   --select SLDH.CCY AS CCY, sum(COMPROCAMT) AS AMT from SLDH
	   --WHERE SLDH.CNO=@Customer 
	   --group by ccy

	   --UNION

	   --select RPDT.CCY AS CCY, sum(RPDT.FACEAMT) AS AMT from RPDT
	   --WHERE RPDT.CNO=@Customer 
	   --group by ccy

	   --UNION

	   --select SWDT.NOTCCY AS CCY, sum(SWDT.NOTCCYAMT) AS AMT from SWDH
	   --JOIN SWDT ON SWDH.DEALNO = SWDT.DEALNO
	   --WHERE SWDH.CNO=@Customer 
	   --group by SWDT.NOTCCY

	   --UNION

	   --select FFDH.CUSTFEECCY AS CCY, sum(FFDH.CCYAMT) AS AMT from FFDH
	   --WHERE FFDH.CNO=@Customer 
	   --group by FFDH.CUSTFEECCY	   
    --) A
    --Where A.AMT>0
    
      
    RETURN ISNULL(@HasBalance,0)

END
GO
