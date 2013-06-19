using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace Scotia.OpicsPlus.Application.ACRM
{
    public class BC
    {
        public void CreateExtractionFile(List<CIFEntity> cifEntities, string filePath)
        {
            using (StreamWriter sw = new StreamWriter(File.Create(filePath),Encoding.UTF8))
            {
                foreach (CIFEntity cif in cifEntities)
                {
                    sw.WriteLine(string.Format(
@"{0,1}{1,-2}{2,5}{3,-10}{4,-15}{5,-30}{6,-30}{7,-30}{8,-10}{9,6}{10,-10}{11,-15}{12,-15}{13,10:yyyy-MM-dd}
{14,-20}{15,-40}{16,-40}{17,-24}{18,-30}{19,-30}{20,-30}{21,-30}{22-30}{23,-30}{24,-30}{25,-30}{26,11}
{27,11}{28,-50}{29,-20}{30,-20}{31,-61}{32,-45}{33,-30}{34,-30}{35,-24}{36,-20}{37,-20}{38,-20}{39,-20}
{40,-40}{41,10:yyyy-MM-dd}{42,-10}{43,-30}{44,-30}{45,-80}{46,-30}{47,-20}{48,11}{49,-20}{50,-120}
{51,{52,5}{53,-40}{54,13}{55,-20}{56,-20}{57,-32}{58,-15}{59,26:yyyy-MM-dd HH.mm.ss.ffffff}{60,1}
{61,-10}{62,10:yyyy-MM-dd}{63,10}{64,1}",
                    cif.RecordID, cif.LocalCountryCode, cif.TransitNo, cif.CustomerType, cif.CIFKey,
                    cif.LastName, cif.SecondLastName, cif.FirstOrMiddleName, cif.Alias, cif.CustomerSince,
                    cif.Sex, cif.CustomerTitle, cif.CustomerLanguage, cif.Brithdate, cif.TaxID,
                    cif.AddressLineOne, cif.AddressLineTwo, cif.City, cif.Province, cif.CountryOfAddress,
                    cif.CountryOfCitizenship, cif.CountryOfDomicile, cif.ClientTypeDesciption,
                    cif.OccupaionCode, cif.OccupationDescription, cif.Employer, cif.WorkPhone,
                    cif.HomePhone, cif.Email, cif.NameofSpouse, cif.SpouseTaxId, cif.NameLineOne,
                    cif.NameLineTwo, cif.SICCodeDescription, cif.CountryOfBirth, cif.CityOfBirth,
                    cif.FatherName, cif.MotherName, cif.ChildName1, cif.ChildName2, cif.TradingName,
                    cif.DateOfBusinessEstablished, cif.RegistrationNumber, cif.LocationofRegisteredoffice,
                    cif.BusinessTypeDescription, cif.BusinessNature, cif.BusinessStructure, cif.KeyContactPersonName,
                    cif.KeyContactpersonPhoneNo, cif.PrincipalOwner, cif.SigningAuthority, cif.NoOfFullTimeEmployees,
                    cif.NumberOfPartTimeEmployees, cif.AnnualSalesExpectedSource, cif.AnnualSalesExpectedAmount,
                    cif.SupplierName1, cif.SupplierName2, cif.AptUnitFloor, cif.CIFKey, cif.ExtracDate,
                    cif.RecordStatus, cif.JobName, cif.ExtracDate, cif.Count, cif.DatabaseID));
                }

                sw.Close();
            }
        }
    }
}
