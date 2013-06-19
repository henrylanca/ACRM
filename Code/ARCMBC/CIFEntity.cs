using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Scotia.OpicsPlus.Application.ACRM
{
    public enum RecordType
    {
        Detail =0,
        Trailer =1
    }

    public enum RecordStatus
    {
        Unknown = -1,
        New = 0,
        Change = 1,
        Teminated = 2
    }

    public class CIFEntity
    {
        #region Properties
        public RecordType RecordID { get; set; }

        public string LocalCountryCode {get; set;}

        public int? TransitNo { get; set; }

        public string CustomerType { get; set; }

        public string CIFKey { get; set; }

        public string LastName { get; set; }

        public string SecondLastName { get; set; }

        public string FirstOrMiddleName { get; set; }

        public string Alias { get; set; }

        public DateTime? CustomerSince { get; set; }

        public string Sex { get; set; }

        public string CustomerTitle { get; set; }

        public string CustomerLanguage { get; set; }

        public DateTime? Brithdate {get; set;}

        public string TaxID { get; set; }

        public string AddressLineOne { get; set; }

        public string AddressLineTwo { get; set; }

        public string City { get; set; }

        public string Province { get; set; }

        public string CountryOfAddress { get; set; }

        public string CountryOfCitizenship { get; set; }

        public string ClientTypeDesciption { get; set; }

        public string CountryOfDomicile { get; set; }

        public string OccupaionCode { get; set; }

        public string OccupationDescription { get; set; }

        public string Employer { get; set; }

        public long? WorkPhone { get; set; }

        public long? HomePhone { get; set; }

        public string Email { get; set; }

        public string NameofSpouse { get; set; }

        public string SpouseTaxId { get; set; }

        public string NameLineOne { get; set; }

        public string NameLineTwo { get; set; }

        public string SICCodeDescription { get; set; }

        public string CountryOfBirth { get; set; }

        public string CityOfBirth { get; set; }

        public string FatherName { get; set; }

        public string MotherName { get; set; }

        public string ChildName1 { get; set; }

        public string ChildName2 { get; set; }

        public string TradingName { get; set; }

        public DateTime? DateOfBusinessEstablished { get; set; }

        public string RegistrationNumber { get; set; }

        public string LocationofRegisteredoffice { get; set; }

        public string BusinessTypeDescription { get; set; }

        public string BusinessNature { get; set; }

        public string BusinessStructure { get; set; }

        public string KeyContactPersonName { get; set; }

        public long? KeyContactpersonPhoneNo { get; set; }

        public string PrincipalOwner { get; set; }

        public string SigningAuthority { get; set; }

        public int? NoOfFullTimeEmployees { get; set; }

        public int? NumberOfPartTimeEmployees { get; set; }

        public string AnnualSalesExpectedSource { get; set; }

        public long? AnnualSalesExpectedAmount {get; set;}

        public string SupplierName1 { get; set; }

        public string SupplierName2 { get; set; }

        public string AptUnitFloor { get; set; }

        public string CIFCrossRefKey { get; set; }

        public DateTime TimestampOfExtract { get; set; }

        public RecordStatus RecordStatus { get; set; }

        public string JobName { get; set; }

        public DateTime ExtracDate { get; set; }

        public long Count { get; set; }

        public string DatabaseID { get; set; }

        #endregion

        public List<string> ValidaCIF()
        {
            List<string> errMsgs = new List<string>();

            if (string.IsNullOrEmpty(this.LocalCountryCode))
                errMsgs.Add(string.Format("{0} :Local Country Code is mandatory", this.CIFKey));

            if(string.IsNullOrEmpty(this.CustomerType))
                errMsgs.Add(string.Format("{0} :Customer Type is mandatory", this.CIFKey));

            if (string.IsNullOrEmpty(this.LastName))
                errMsgs.Add(string.Format("{0} :Last Name is mandatory", this.CIFKey));

            if (string.IsNullOrEmpty(this.AddressLineOne))
                errMsgs.Add(string.Format("{0} :Address Line One is mandatory", this.CIFKey));

            if (string.IsNullOrEmpty(this.NameLineOne))
                errMsgs.Add(string.Format("{0} :Name Line One is mandatory", this.CIFKey));

            return errMsgs;
        }

        public static string ConvertRecordStatus(RecordStatus status)
        {
            string statusVal = "";

            switch (status)
            {
                case RecordStatus.New:
                    statusVal = "N";
                    break;
                case RecordStatus.Change:
                    statusVal = "C";
                    break;
                case RecordStatus.Teminated:
                    statusVal = "T";
                    break;
                default:
                    statusVal = "";
                    break;
            }

            return statusVal;
        }

        public static RecordStatus ConvertBacktoRecordStatus(string status)
        {
            RecordStatus recordStatus = RecordStatus.Unknown;

            switch (status.ToUpper())
            {
                case "N":
                    recordStatus = RecordStatus.New;
                    break;
                case "C":
                    recordStatus = RecordStatus.Change;
                    break;
                case "T":
                    recordStatus = RecordStatus.Teminated;
                    break;
                default:
                    recordStatus = RecordStatus.Unknown;
                    break;
            }

            return recordStatus;
        }

    }
}
