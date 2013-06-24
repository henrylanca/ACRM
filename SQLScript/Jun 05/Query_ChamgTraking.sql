declare @last_synchronization_version bigint
set @last_synchronization_version = 0

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