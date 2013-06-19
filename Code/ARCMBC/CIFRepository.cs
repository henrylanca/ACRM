using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace Scotia.OpicsPlus.Application.ACRM
{
    public class CIFRepository
    {
        public void AddCIFRecord(CIFEntity cif)
        {
            string sql =
@"INSERT INTO ARCMCIF(RecordID, LocalCountryCode, TransitNo, CustomerType, CIFKey,
Lastname, SecondLastName, FirstMiddleName, Alias, CustomerSince, Sex, CustomerTitle,
CustomerLanguage, BirthDate, TaxID, AddressLineOne, AddressLineTwo, City, Province, CountryOfAddress,
CountryOfCitizenship, CountryOfDomicile, ClientTypeDesc, OccupationCode, OccupationDesc,
Employer, WorkPhone, HomePhone, Email, NameOfSpouse, SpousalTaxID, NameLineOne,
NameLineTwo, SICCOde, CountryOfBirth, CityOfBirth, FatherName, MotherName, ChildName1,
ChildName2, TradingName, DateOfBusinessEstablished, RegistrationNo, LocationOfRegisterdOffice,
BusinessTypeDesc, BusinessNature, BusinessStructure, KeyContactPerson, KeyContactPersonPhone, 
PrincipleOwner, SignatureAuthroity, NoOfFullTime, NoOfPartTime, AnnualSalesExpectedSource,
AnnualSalesExpectedAmount, SupplierOne, SupplierTwo, AptUnitFloor, ExtractDate, 
RecordStatus, DataBaseID) 
Values(@RecordID, @LocalCountryCode, @TransitNo, @CustomerType, @CIFKey,
@Lastname, @SecondLastName, @FirstMiddleName, @Alias, @CustomerSince, @Sex, @CustomerTitle,
@CustomerLanguage, @BirthDate, @TaxID, @AddressLineOne, @AddressLineTwo, @City, @Province, @CountryOfAddress,
@CountryOfCitizenship, @CountryOfDomicile, @ClientTypeDesc, @OccupationCode, @OccupationDesc,
@Employer, @WorkPhone, @HomePhone, @Email, @NameOfSpouse, @SpousalTaxID, @NameLineOne,
@NameLineTwo, @SICCOde, @CountryOfBirth, @CityOfBirth, @FatherName, @MotherName, @ChildName1,
@ChildName2, @TradingName, @DateOfBusinessEstablished, @RegistrationNo, @LocationOfRegisterdOffice,
@BusinessTypeDesc, @BusinessNature, @BusinessStructure, @KeyContactPerson, @KeyContactPersonPhone, 
@PrincipleOwner, @SignatureAuthroity, @NoOfFullTime, @NoOfPartTime, @AnnualSalesExpectedSource,
@AnnualSalesExpectedAmount, @SupplierOne, @SupplierTwo, @AptUnitFloor, @ExtractDate, 
@RecordStatus, @DataBaseID)";

            using (SqlConnection conn = new SqlConnection(""))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add(new SqlParameter("@RecordID", cif.RecordID));
                cmd.Parameters.Add(new SqlParameter("@LocalCountryCode", cif.LocalCountryCode));
                cmd.Parameters.Add(new SqlParameter("@TransitNo", cif.TransitNo));
                cmd.Parameters.Add(new SqlParameter("@CustomerType", cif.CustomerType));
                cmd.Parameters.Add(new SqlParameter("@CIFKey", cif.CIFKey));
                cmd.Parameters.Add(new SqlParameter("@Lastname", cif.LastName));
                cmd.Parameters.Add(new SqlParameter("@SecondLastName", cif.SecondLastName));
                cmd.Parameters.Add(new SqlParameter("@FirstMiddleName", cif.FirstOrMiddleName));
                cmd.Parameters.Add(new SqlParameter("@Alias", cif.Alias));
                cmd.Parameters.Add(new SqlParameter("@CustomerSince", cif.CustomerSince));
                cmd.Parameters.Add(new SqlParameter("@Sex", cif.Sex));
                cmd.Parameters.Add(new SqlParameter("@CustomerTitle", cif.CustomerTitle));
                cmd.Parameters.Add(new SqlParameter("@CustomerLanguage", cif.CustomerLanguage));
                cmd.Parameters.Add(new SqlParameter("@BirthDate", cif.Brithdate));
                cmd.Parameters.Add(new SqlParameter("@TaxID", cif.TaxID));
                cmd.Parameters.Add(new SqlParameter("@AddressLineOne", cif.AddressLineOne));
                cmd.Parameters.Add(new SqlParameter("@AddressLineTwo", cif.AddressLineTwo));
                cmd.Parameters.Add(new SqlParameter("@City", cif.City));
                cmd.Parameters.Add(new SqlParameter("@Province", cif.Province));
                cmd.Parameters.Add(new SqlParameter("@CountryOfAddress", cif.CountryOfAddress));
                cmd.Parameters.Add(new SqlParameter("@CountryOfCitizenship", cif.CountryOfCitizenship));
                cmd.Parameters.Add(new SqlParameter("@CountryOfDomicile", cif.CountryOfDomicile));
                cmd.Parameters.Add(new SqlParameter("@ClientTypeDesc", cif.ClientTypeDesciption));
                cmd.Parameters.Add(new SqlParameter("@OccupationCode", cif.OccupaionCode));
                cmd.Parameters.Add(new SqlParameter("@OccupationDesc", cif.OccupationDescription));
                cmd.Parameters.Add(new SqlParameter("@Employer", cif.Employer));
                cmd.Parameters.Add(new SqlParameter("@WorkPhone", cif.WorkPhone));
                cmd.Parameters.Add(new SqlParameter("@HomePhone", cif.HomePhone));
                cmd.Parameters.Add(new SqlParameter("@Email", cif.Email));
                cmd.Parameters.Add(new SqlParameter("@NameOfSpouse", cif.NameofSpouse));
                cmd.Parameters.Add(new SqlParameter("@SpousalTaxID", cif.SpouseTaxId));
                cmd.Parameters.Add(new SqlParameter("@NameLineOne", cif.NameLineOne));
                cmd.Parameters.Add(new SqlParameter("@NameLineTwo", cif.NameLineTwo));
                cmd.Parameters.Add(new SqlParameter("@SICCOde", cif.SICCodeDescription));
                cmd.Parameters.Add(new SqlParameter("@CountryOfBirth", cif.CountryOfBirth));
                cmd.Parameters.Add(new SqlParameter("@CityOfBirth", cif.CityOfBirth));
                cmd.Parameters.Add(new SqlParameter("@FatherName", cif.FatherName));
                cmd.Parameters.Add(new SqlParameter("@MotherName", cif.MotherName));
                cmd.Parameters.Add(new SqlParameter("@ChildName1", cif.ChildName1));
                cmd.Parameters.Add(new SqlParameter("@ChildName2", cif.ChildName2));
                cmd.Parameters.Add(new SqlParameter("@TradingName", cif.TradingName));
                cmd.Parameters.Add(new SqlParameter("@DateOfBusinessEstablished", cif.DateOfBusinessEstablished));
                cmd.Parameters.Add(new SqlParameter("@RegistrationNo", cif.RegistrationNumber));
                cmd.Parameters.Add(new SqlParameter("@LocationOfRegisterdOffice", cif.LocationofRegisteredoffice));
                cmd.Parameters.Add(new SqlParameter("@BusinessTypeDesc", cif.BusinessTypeDescription));
                cmd.Parameters.Add(new SqlParameter("@BusinessNature", cif.BusinessNature));
                cmd.Parameters.Add(new SqlParameter("@BusinessStructure", cif.BusinessStructure));
                cmd.Parameters.Add(new SqlParameter("@KeyContactPerson", cif.KeyContactPersonName));
                cmd.Parameters.Add(new SqlParameter("@KeyContactPersonPhone", cif.KeyContactpersonPhoneNo));
                cmd.Parameters.Add(new SqlParameter("@PrincipleOwner", cif.PrincipalOwner));
                cmd.Parameters.Add(new SqlParameter("@SignatureAuthroity", cif.SigningAuthority));
                cmd.Parameters.Add(new SqlParameter("@NoOfFullTime", cif.NoOfFullTimeEmployees));
                cmd.Parameters.Add(new SqlParameter("@NoOfPartTime", cif.NumberOfPartTimeEmployees));
                cmd.Parameters.Add(new SqlParameter("@AnnualSalesExpectedSource", cif.AnnualSalesExpectedSource));
                cmd.Parameters.Add(new SqlParameter("@AnnualSalesExpectedAmount", cif.AnnualSalesExpectedAmount));
                cmd.Parameters.Add(new SqlParameter("@SupplierOne", cif.SupplierName1));
                cmd.Parameters.Add(new SqlParameter("@SupplierTwo", cif.SupplierName2));
                cmd.Parameters.Add(new SqlParameter("@AptUnitFloor", cif.AptUnitFloor));
                cmd.Parameters.Add(new SqlParameter("@ExtractDate", cif.ExtracDate));
                cmd.Parameters.Add(new SqlParameter("@RecordStatus", CIFEntity.ConvertRecordStatus(cif.RecordStatus)));
                cmd.Parameters.Add(new SqlParameter("@DataBaseID", cif.DatabaseID));


                int result = cmd.ExecuteNonQuery();

                conn.Close();
            }
        }

        public List<CIFEntity> GetDelta(DateTime extractDate)
        {
            return null;
        }

        public List<CIFEntity> GetFullLoad(DateTime extractDate)
        {
            return null;
        }

        public static CIFEntity GetCIFEntity(DataRow dr)
        {
            CIFEntity cif = new CIFEntity();

            cif.RecordID = RecordType.Detail;
            cif.LocalCountryCode = Convert.ToString(dr["LocalCountryCode"]);
            cif.TransitNo = dr["TransitNo"]==DBNull.Value ? default(int?) : Convert.ToInt32(dr["TransitNo"]);
            cif.CustomerTitle = Convert.ToString(dr["CustomerType"]);
            cif.CIFKey = Convert.ToString(dr["CIFKey"]);
            cif.LastName = Convert.ToString(dr["Lastname"]);
            cif.SecondLastName = Convert.ToString(dr["SecondLastName"]);
            cif.FirstOrMiddleName = Convert.ToString(dr["FirstMiddleName"]);
            cif.Alias = Convert.ToString(dr["Alias"]);
            cif.CustomerSince = dr["CustomerSince"] == DBNull.Value ? default(DateTime?) : Convert.ToDateTime(dr["CustomerSince"]);
            cif.Sex = Convert.ToString(dr["Sex"]);
            cif.CustomerTitle = Convert.ToString(dr["CustomerTitle"]);
            cif.CustomerLanguage = Convert.ToString(dr["CustomerLanguage"]);
            cif.Brithdate = dr["BirthDate"] == DBNull.Value ? default(DateTime?) : Convert.ToDateTime(dr["BirthDate"]);
            cif.TaxID = Convert.ToString(dr["TaxID"]);
            cif.AddressLineOne = Convert.ToString(dr["AddressLineOne"]);
            cif.AddressLineTwo = Convert.ToString(dr["AddressLineTwo"]);
            cif.City = Convert.ToString(dr["City"]);
            cif.Province = Convert.ToString(dr["Province"]);
            cif.CountryOfAddress = Convert.ToString(dr["CountryOfAddress"]);
            cif.CountryOfCitizenship = Convert.ToString(dr["CountryOfCitizenship"]);
            cif.CountryOfDomicile = Convert.ToString(dr["CountryOfDomicile"]);
            cif.ClientTypeDesciption = Convert.ToString(dr["ClientTypeDesc"]);
            cif.OccupaionCode = Convert.ToString(dr["OccupationCode"]);
            cif.OccupationDescription = Convert.ToString(dr["OccupationDesc"]);
            cif.Employer = Convert.ToString(dr["Employer"]);
            cif.WorkPhone = dr["WorkPhone"] == DBNull.Value ? default(long?) : Convert.ToInt64(dr["WorkPhone"]);
            cif.HomePhone = dr["HomePhone"] == DBNull.Value ? default(long?) : Convert.ToInt64(dr["HomePhone"]);
            cif.Email = Convert.ToString(dr["Email"]);
            cif.NameofSpouse = Convert.ToString(dr["NameOfSpouse"]);
            cif.SpouseTaxId = Convert.ToString(dr["SpousalTaxID"]);
            cif.NameLineOne = Convert.ToString(dr["NameLineOne"]);
            cif.NameLineTwo = Convert.ToString(dr["NameLineTwo"]);
            cif.SICCodeDescription = Convert.ToString(dr["SICCOde"]);
            cif.CountryOfBirth = Convert.ToString(dr["CountryOfBirth"]);
            cif.CityOfBirth = Convert.ToString(dr["CityOfBirth"]);
            cif.FatherName = Convert.ToString(dr["FatherName"]);
            cif.MotherName = Convert.ToString(dr["MotherName"]);
            cif.ChildName1 = Convert.ToString(dr["ChildName1"]);
            cif.ChildName2 = Convert.ToString(dr["ChildName2"]);
            cif.TradingName = Convert.ToString(dr["TradingName"]);
            cif.DateOfBusinessEstablished = dr["DateOfBusinessEstablished"] == DBNull.Value ? default(DateTime?)
                : Convert.ToDateTime(dr["DateOfBusinessEstablished"]);
            cif.RegistrationNumber = Convert.ToString(dr["RegistrationNo"]);
            cif.LocationofRegisteredoffice = Convert.ToString(dr["LocationOfRegisterdOffice"]);
            cif.BusinessTypeDescription = Convert.ToString(dr["BusinessTypeDesc"]);
            cif.BusinessNature = Convert.ToString(dr["BusinessNature"]);
            cif.KeyContactPersonName = Convert.ToString(dr["KeyContactPerson"]);
            cif.KeyContactpersonPhoneNo = dr["KeyContactPersonPhone"] == DBNull.Value ? default(long?) 
                : Convert.ToInt64(dr["KeyContactPersonPhone"]);
            cif.PrincipalOwner = Convert.ToString(dr["PrincipleOwner"]);
            cif.SigningAuthority = Convert.ToString(dr["SignatureAuthroity"]);
            cif.NoOfFullTimeEmployees = dr["NoOfFullTime"] == DBNull.Value ? default(int?) : Convert.ToInt32(dr["NoOfFullTime"]);
            cif.NumberOfPartTimeEmployees = dr["NoOfPartTime"] == DBNull.Value ? default(int?) : Convert.ToInt32(dr["NoOfPartTime"]);
            cif.AnnualSalesExpectedSource = Convert.ToString(dr["AnnualSalesExpectedSource"]);
            cif.AnnualSalesExpectedAmount = dr["AnnualSalesExpectedAmount"] == DBNull.Value ? default(long?) 
                : Convert.ToInt64(dr["AnnualSalesExpectedAmount"]);
            cif.SupplierName1 = Convert.ToString(dr["SupplierOne"]);
            cif.SupplierName2 = Convert.ToString(dr["SupplierTwo"]);
            cif.AptUnitFloor = Convert.ToString(dr["AptUnitFloor"]);
            cif.ExtracDate = Convert.ToDateTime(dr["ExtractDate"]);
            cif.RecordStatus = CIFEntity.ConvertBacktoRecordStatus(Convert.ToString(dr["RecordStatus"]));
            cif.DatabaseID = Convert.ToString(dr["DataBaseID"]);

            return cif;
        }
    }
}
