using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Runtime.Serialization;
using System.Xml;
using System.Linq;

/*TODO: ****************************************************************************
 *                                                                                *                                                                                     *
 * Instructions:                                                                  *
 *                                                                                *
 * - Create and compile the project with the DTO class.                           *                                                                                     *
 * - Add references to the DTO assembly.                                          *
 * - Set the reference path to the server bin directory.                          *
 * - Change the assembly name in the project//s properties.                        *
 * - Change the references to the namespace of the DTO clas.                      *
 * - Change all occurrences of ASBADTO to the type of the data object.            *
 * - Check the names in the TransactionStreams.xml file and change if necessary.  *
 *   The new TX stream names should match the Transaction Stream names            *
 *   in the UI code.                                                              *
 * - Check other TODO comments in the code.                                       *
 *                                                                                *
 * After successful compilation:                                                  *
 * - Copy Schemas\BCSchema.XSD and Schemas\BCDTO.XSD files    *
 *   to the Schemas folder under the AppServer directory.                         *
 * - Add the transaction stream information found in                              *
 *   TransactionStream\TransactionStreams.xml file to the system                  *
 *   using the TRXS screen.                                                       *
 * - Assign permissions to the entered transaction streams using the PWMT screen. *
 * - Copy the compiled dll to the server bin folder.                              *
 *                                                                                *
 ******************************************************************************** */

using Misys.OpicsPlus.Application.Architecture;
using Misys.OpicsPlus.Application.Static.BBFT.Dalc;
using Misys.OpicsPlus.Application.Static.BBFT.DataObjects;
//TODO : Change the namespace for the data object.
//using Misys.OpicsPlus.Application.Batch.ASBA.DataObjects;

using Misys.OpicsPlus.Framework;
using Misys.OpicsPlus.Framework.BusinessComponents;
using Misys.OpicsPlus.Framework.Common;
using Misys.OpicsPlus.Framework.Common.BusinessData;
using Misys.OpicsPlus.Framework.DataAccessLayer;
using Misys.OpicsPlus.Framework.Formatting;
using Misys.OpicsPlus.Framework.ServiceMessages;
using Misys.OpicsPlus.Framework.Scheduler;

using Scotia.OpicsPlus.Application.Common;

namespace Scotia.OpicsPlus.Application.ACRM
{
    public class ACRMBC : BatchBusinessBase, IOSYSBusinessComponent
    {
        #region "[Variables]"
        // TODO: Change the type of the data object.
        private ACRMDTO dto = null;
        private DataAccessProxy da = DataAccessProxy.GetDataProxy();
        private string cmd = String.Empty;
        private string runStatus = String.Empty;
        private string textResult = String.Empty;
        private Sub13 Sub13Object = Sub13.GetReference();
        private Sub0 Sub0Object = Sub0.GetReference();
        private Sub4 Sub4Object = Sub4.GetReference();

        private bool _isEOD = false;
        private const string OUTPUTFORMAT =
@"{0,1}{1,-2}{2,5:#####}{3,-10}{4,-15}{5,-30}{6,-30}{7,-30}{8,-10}{9,6:yyyyMM}{10,-10}{11,-15}{12,-15}{13,10:yyyy-MM-dd}{14,-20}{15,-40}{16,-40}{17,-24}{18,-30}{19,-30}{20,-30}{21,-30}{22,-30}{23,-30}{24,-30}{25,-30}{26,11}{27,11}{28,-50}{29,-20}{30,-20}{31,-61}{32,-45}{33,-30}{34,-30}{35,-24}{36,-20}{37,-20}{38,-20}{39,-20}{40,-40}{41,10:yyyy-MM-dd}{42,-10}{43,-30}{44,-30}{45,-80}{46,-30}{47,-20}{48,11}{49,-20}{50,-120}{51,5}{52,5}{53,-40}{54,13}{55,-20}{56,-20}{57,-32}{58,-15}{59,26:yyyy-MM-dd HH.mm.ss.ffffff}{60,1}{61,-10}{62,10:yyyy-MM-dd}{63,10}{64,1}";
        #endregion

        #region "[BatchBusinessComponentBase implementations]"
        protected override string Trans
        {
            get
            {
                return "ACRMDTO";
            }
        }


        /// <summary>
        /// This is the main method with the batch processing logic.
        /// </summary>
        public override void BatchProcessing()
        {
            //AUTORUN PROGRAM WITH BRANCH
            //if (dto.Branch.Trim() != string.Empty)
            //{
            //    ASTART_Click();
            //}

            ASTART_Click();
        }


        /// <summary>
        /// This method does the OSYS (intra-day) processing.
        /// </summary>
        void IOSYSBusinessComponent.OSYSProcessing()
        {
        //    //TODO : Enable OSYS processing only if intra-day processing is allowed for this component.
        //    if (dto.Branch.Trim() != "")   //AUTORUN PROGRAM WITH BRANCH
        //    {
        //        ASTART_Click();
        //    }

            ASTART_Click();
        }

        /// <summary>
        /// This method retrieves the input parameters for this batch run.
        /// </summary>
        /// <param name="functionCode">function code</param>
        /// <param name="programCommand">command parameters</param>
        protected override void MapBBFTParameters(string functionCode, string[] programCommand)
        {
            // Note: The batch parameters can be set up on the BBFT screen.
            dto = new ACRMDTO();
            if (functionCode == BatchFunctionCode)
            {
                runStatus = "BSYS";

                for (int t = 0; t < programCommand.Length; t++)
                {
                    if (programCommand[t] == null)
                    {
                        programCommand[t] = String.Empty;
                    }
                }

                //dto.Branch = programCommand[0].Trim();
                if (string.IsNullOrEmpty(programCommand[1]))
                    dto.ExtractDate = DateTime.Today;
                else
                    dto.ExtractDate = DateTime.Parse(programCommand[1]);

                if (string.IsNullOrEmpty(programCommand[2]))
                    dto.IsFullload = false;
                else
                    dto.IsFullload = Convert.ToBoolean(programCommand[2]);
                    

            }
            else if (functionCode == OSYSFunctionCode)
            {
                runStatus = "OSYS";

                for (int t = 0; t < programCommand.Length; t++)
                {
                    if (programCommand[t] == null)
                    {
                        programCommand[t] = string.Empty;
                    }
                }

                //dto.Branch = programCommand[1].Trim();
            }
        }

        /// <summary>
        /// This method maps the incoming data to the data object.
        /// </summary>
        /// <param name="functionCode">function code</param>
        protected override void MapIncomingData(string functionCode)
        {
            dto = (ACRMDTO)(Msg.GetMessageDTO(SessionParameters.TRANS, typeof(ACRMDTO)));
        }

        /// <summary>
        /// This method maps the content of the data object to the outgoing message.
        /// </summary>
        /// <param name="functionCode">function code</param>
        protected override void MapOutgoingData(string functionCode)
        {
            if (functionCode != BatchFunctionCode &&
                functionCode != OSYSFunctionCode)
            {
                Msg.UpdateMessageDTO(SessionParameters.TRANS, dto);
            }
        }


        /// <summary>
        /// This method does the batch pre-processing.
        /// </summary>
        /// <param name="functionCode">function code</param>
        protected override void PreProcessing(string functionCode)
        {
            if(string.Compare(functionCode,"EOD")==0)
                this._isEOD=true;

            base.PreProcessing(functionCode);
            if (SessionParameters.Result.Occurred())
            {
                return;
            }

            InitializeValues();
            if (SessionParameters.Result.Occurred())
            {
                return;
            }
        }

        //****************************************************************************
        // Procedure:   Processing                                                   *
        // Description: This procedure is responsible for the processing of the      * 
        //              transaction streams that point to this business component.   *
        //****************************************************************************
        /// <summary>
        /// This method is responsible for the handling and  processing of 
        /// all valid function codes.
        /// </summary>
        /// <param name="functionCode">function code</param>
        protected override void Processing(string functionCode)
        {
            switch (functionCode)
            {
                case ("ASTART"):
                    ASTART_Click();
                    break;
                case ("EOD"):
                    ASTART_Click();
                    break;
            }
        }

        #endregion

        #region "[private methods]"
        /// <summary>
        /// This method is used to do the necessary initializations. 
        /// </summary>
        private void InitializeValues()
        {
            if (runStatus.Trim().ToUpper() == "BSYS")
            {
                SessionParameters.Common.LogLevel = "LOG";
            }
        }


        /// <summary>
        /// This method has the batch processing logic for the ASTART function code.
        /// </summary>
        private void ASTART_Click()
        {
            BatchFunction();
            if (SessionParameters.Result.ErrorNumber != 0)
            {
                return;
            }
            SessionParameters.Result.ErrorNumber = 0;
        }


        /// <summary>
        /// This method validates the input fields and runs the batch processing.
        /// </summary>
        private void BatchFunction()
        {
            //string branch = dto.Branch.Trim();

            ValidateFields();
            if (SessionParameters.Result.ErrorNumber != 0)
            {
                return;
            }

            DoProcessing();
            if (SessionParameters.Result.ErrorNumber != 0)
            {
                return;
            }

            SessionParameters.Result.ErrorNumber = 0;
        }


        /// <summary>
        /// This method validates the input data.
        /// </summary>
        private void ValidateFields()
        {

            // TODO: Put validation logic here.

            /* ********************
            //Example:
            
            //Make sure a valid branch has been entered:
            Sub0Object.IsRequired(dto.Branch, "BRANCH", Errors);
            if (SessionParameters.Result.ErrorNumber != 0)
            {
                SessionParameters.Result.ErrorNumber = 8; //Highlighted fields are required.
                return;
            }

            string str = dto.Branch;
            Sub0Object.ValidateValue(ref str, 54);
            if (SessionParameters.Result.ErrorNumber != 0)
            {
                SessionParameters.Result.ErrorNumber = 2009; //No quotes, apostrophes, or commas  allowed.
                return;
            }

            str = dto.Branch;
            Sub0Object.ValidateValue(ref str, 14);
            if (SessionParameters.Result.ErrorNumber != 0)
            {
                SessionParameters.Result.ErrorNumber = 31; //Branch record not found.
                return;
            }
            ******************** */
            SessionParameters.Result.ErrorNumber = 0;
        }


        /// <summary>
        /// This method contains the actual batch processing logic.
        /// </summary>
        /// <param name="branch">branch</param>
        private void DoProcessing()
        {

            string[] paras = new string[3];
            paras[0] = dto.ExtractDate.ToShortDateString();
            paras[1] = dto.IsFullload ? "1" : "0";
            paras[2] = this._isEOD ? "true" : "false";

            DataSet ds = DataAccessHelper.CallStoredProcedure(null, "scotia.usp_ExtractCIFs", paras);

            List<CIFEntity> cifEntities = new List<CIFEntity>();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                cifEntities.Add(CIFRepository.GetCIFEntity(dr));
            }

            string fileType = "D";
            if (dto.IsFullload)
                fileType = "M";

            string extractFolder = "";
            string[] configParas = new string[3];
            configParas[0] = "02";
            configParas[1] = "ACRM";
            configParas[2] = "EXTRACTPATH";
            DataSet dsConfig = DataAccessHelper.CallStoredProcedure(null, "scotia.usp_SCOTIA_CONFIG_GET", configParas);
            foreach(DataRow dr in dsConfig.Tables[0].Rows)
            {
                extractFolder = Convert.ToString(dr["Value"]);
            }

            CreateExtractionFile(cifEntities,
                string.Format(@"{0}JM2FPP001{1}{2:yyMMdd}", extractFolder, fileType, DateTime.Today));

            SessionParameters.Result.ErrorNumber = 0;
        }

        private static void CreateExtractionFile(List<CIFEntity> cifEntities, string filePath)
        {
            string recordiD = "D";
            using (StreamWriter sw = new StreamWriter(File.Create(filePath), Encoding.UTF8))
            {
                foreach (CIFEntity cif in cifEntities)
                {
                    sw.WriteLine(string.Format(
//@"{0,1}{1,-2}{2,5:#####}{3,-10}{4,-15}{5,-30}{6,-30}{7,-30}{8,-10}{9,6}{10,-10}{11,-15}{12,-15}{13,10:yyyy-MM-dd}{14,-20}{15,-40}{16,-40}{17,-24}{18,-30}{19,-30}{20,-30}{21,-30}{22,-30}{23,-30}{24,-30}{25,-30}{26,11}{27,11}{28,-50}{29,-20}{30,-20}{31,-61}{32,-45}{33,-30}{34,-30}{35,-24}{36,-20}{37,-20}{38,-20}{39,-20}{40,-40}{41,10:yyyy-MM-dd}{42,-10}{43,-30}{44,-30}{45,-80}{46,-30}{47,-20}{48,11}{49,-20}{50,-120}{51,5}{52,5}{53,-40}{54,13}{55,-20}{56,-20}{57,-32}{58,-15}{59,26:yyyy-MM-dd HH.mm.ss.ffffff}{60,1}{61,-10}{62,10:yyyy-MM-dd}{63,10}{64,1}",
                    OUTPUTFORMAT,
                    recordiD, cif.LocalCountryCode, cif.TransitNo%100000, cif.CustomerType, cif.CIFKey,
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
                    CIFEntity.ConvertRecordStatus(cif.RecordStatus), cif.JobName, cif.ExtracDate, cif.Count, cif.DatabaseID));
                }

                recordiD="T";
                sw.WriteLine(string.Format(OUTPUTFORMAT,
                    recordiD, null, null, null, null,
                    null, null, null, null, null,
                    null, null, null, null, null,
                    null, null, null, null, null,
                    null, null, null,
                    null, null, null, null,
                    null, null, null, null, null,
                    null, null, null, null,
                    null, null, null, null, null,
                    null, null, null,
                    null, null, null, null,
                    null, null, null, null,
                    null, null, null,
                    null, null, null, null, null,
                    null, "ACRM", DateTime.Now, cifEntities.Count, 1));
                 sw.Close();
            }
        }

        #endregion

    }

}

