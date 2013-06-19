/******************************************************************************************************************************************
 * Description: This Common module is to centralized shared components across Scotia modules
 * 
 * Revision:
 *  Feb 08, 2012    Louis Li    Created
 *  Feb 08, 2012    Louis Li    Added DAL class
 *  Feb 09, 2012    Louis Li    Changed class name from DAL to DataAccessHelper
 ******************************************************************************************************************************************/

using System;
using System.Diagnostics;
using System.Data;
using System.Xml;
using System.IO;

//Misys Reference
using Misys.OpicsPlus.Framework.DataAccessLayer;
using Misys.OpicsPlus.Framework.Common;


namespace Scotia.OpicsPlus.Application.Common
{
    /// <summary>
    /// Scotia Common Libraray - Data Access helper
    /// This helper library is to connect to OpicsPlus database using Misys Framework.
    /// This library is static, therefore, there is no need to create instance to use this library. Simply call methods.
    /// </summary>
    public static class DataAccessHelper
    {

        //Stored procedure name to retrieve Scotia config value(s)
        private const string SP_SCOTIA_CONFIG = "Scotia.USP_SCOTIA_CONFIG_GET";
        private const string SP_SCOTIA_REQUEST_DISTRIBUTOR = "Scotia.usp_REQUEST_DISTRIBUTOR";


        /// <summary>
        /// Retrieve configuration value in a dataset for given Branch number, module name and key name
        /// Stored Procedure name 
        /// </summary>
        /// <param name="Da">Opics build in Data Access object</param>
        /// <param name="BR">Branch Number</param>
        /// <param name="ModuleName">Module Name for config table</param>
        /// <param name="KeyName">Key name for configuration Key/value pair</param>
        /// <returns>
        ///     Success: Table 0 populated with returned data
        ///     Failure: Null
        /// </returns>
        public static DataSet GetConfigValue(DataAccessProxy Da,string BR, string ModuleName, string KeyName)
        {
            TraceOutput.EnterModule(string.Format("GetConfigValue: {0} {1} {2}",BR,ModuleName,KeyName));

            DataSet ds = new DataSet();
            ds = CallStoredProcedure(Da, SP_SCOTIA_CONFIG, new string[3] { BR, ModuleName, KeyName });

            TraceOutput.ExitModule("GetConfigValue");
            return ds;
            
        }

        /// <summary>
        /// Retrieve configuration value in a dataset for given Branch number, module name
        /// Stored Procedure name 
        /// </summary>
        /// <param name="Da">Opics build in Data Access object</param>
        /// <param name="BR">Branch Number</param>
        /// <param name="ModuleName">Module Name for config table</param>
        /// <returns>
        ///     Success: Table 0 populated with returned data
        ///     Failure: Null
        /// </returns>
        public static DataSet GetConfigValue(DataAccessProxy Da, string BR, string ModuleName)
        {
            TraceOutput.EnterModule(string.Format("GetConfigValue: {0} {1}", BR, ModuleName));

            DataSet ds = new DataSet();
            ds = CallStoredProcedure(Da, SP_SCOTIA_CONFIG, new string[3] { BR, ModuleName, DBNull.Value.ToString()});

            TraceOutput.ExitModule("GetConfigValue");
            return ds;

        }

        /// <summary>
        /// Return single configuration value for given Branch number, module name and key name
        /// Stored Procedure name 
        /// </summary>
        /// <param name="Da">Opics build in Data Access object</param>
        /// <param name="BR">Branch Number</param>
        /// <param name="ModuleName">Module Name for config table</param>
        /// <param name="KeyName">Key name for configuration Key/value pair</param>
        /// <returns>
        ///     Success: Value in string
        ///     Failure: Empty string
        /// </returns>
        public static string GetConfigSingleValue(DataAccessProxy Da, string BR, string ModuleName, string KeyName)
        {
            TraceOutput.EnterModule(string.Format("GetConfigValue: {0} {1} {2}", BR, ModuleName, KeyName));

            DataSet ds = new DataSet();
            ds = CallStoredProcedure(Da, SP_SCOTIA_CONFIG, new string[3] { BR, ModuleName, KeyName });

            string result = string.Empty;

            try
            {
                // Returned data: BR, MODULENAME, KEY, VALUE
                result = ds.Tables[0].Rows[0].ItemArray[3].ToString(); //Item #4 is Value

                postGetConfigData(ref result);
            }
            catch
            {
                TraceOutput.Error(string.Format("Scotia_Config Key: {0} not found! Returning empty value."));
            }

            TraceOutput.ExitModule("GetConfigValue");
            return result;

        }

        /// <summary>
        /// Replace system folder variable with server folder name
        /// </summary>
        /// <param name="foldername">folder name with variable</param>
        public static string SystemFolderUpdate(string foldername)
        {
            postGetConfigData(ref foldername);
            return foldername;
        }

        /// <summary>
        /// Check whethere system folder variable is return, if yes, convert to system folder
        /// </summary>
        /// <param name="data"></param>
        private static void postGetConfigData(ref string data)
        {
            string upperData = data.Trim().ToUpper();

            upperData = upperData.Replace("@OPXDIRS.ACCESS", SessionParameters.OpxDirs.ACCESS);
            upperData = upperData.Replace("@OPXDIRS.ANA", SessionParameters.OpxDirs.ANA);
            upperData = upperData.Replace("@OPXDIRS.ARC", SessionParameters.OpxDirs.ARC);
            upperData = upperData.Replace("@OPXDIRS.BAK", SessionParameters.OpxDirs.BAK);
            upperData = upperData.Replace("@OPXDIRS.COM", SessionParameters.OpxDirs.COM);
            upperData = upperData.Replace("@OPXDIRS.DAT", SessionParameters.OpxDirs.DAT);
            upperData = upperData.Replace("@OPXDIRS.DB", SessionParameters.OpxDirs.DB);
            upperData = upperData.Replace("@OPXDIRS.FAX", SessionParameters.OpxDirs.FAX);
            upperData = upperData.Replace("@OPXDIRS.GRSS", SessionParameters.OpxDirs.GRSS);
            upperData = upperData.Replace("@OPXDIRS.HLP", SessionParameters.OpxDirs.HLP);
            upperData = upperData.Replace("@OPXDIRS.IQ", SessionParameters.OpxDirs.IQ);
            upperData = upperData.Replace("@OPXDIRS.JOB", SessionParameters.OpxDirs.JOB);
            upperData = upperData.Replace("@OPXDIRS.LOG", SessionParameters.OpxDirs.LOG);
            upperData = upperData.Replace("@OPXDIRS.PUB", SessionParameters.OpxDirs.PUB);
            upperData = upperData.Replace("@OPXDIRS.PWD", SessionParameters.OpxDirs.PWD);
            upperData = upperData.Replace("@OPXDIRS.RPT", SessionParameters.OpxDirs.RPT);
            upperData = upperData.Replace("@OPXDIRS.SYS", SessionParameters.OpxDirs.SYS);
            upperData = upperData.Replace("@OPXDIRS.UPR", SessionParameters.OpxDirs.UPR);

            upperData = upperData.Replace("@BR", SessionParameters.Branch);

            //Set return value
            data = upperData;

        }

        /// <summary>
        /// Call Stored Procedure using Misys Framework
        /// </summary>
        /// <param name="Da">Build in Data Access object</param>
        /// <param name="StoredProcedureName">Stored Procedure Name</param>
        /// <param name="Parameters">Storec Procuedure Parameters array</param>
        /// <returns>
        ///     Success: Table 0 populated with return data
        ///     Failure: Null
        /// </returns>
        public static DataSet CallStoredProcedure(DataAccessProxy Da,string StoredProcedureName, string[] Parameters)
        {
            TraceOutput.EnterModule(string.Format("CallStoredProcedure: {0}", StoredProcedureName));

            try
            {
                //Get data access proxy
                if (Da == null)
                {
                    Da = DataAccessProxy.GetDataProxy();
                }

                // Make a call to database to get data
                for (int i = 0; i < 300; i++) Da.DBFields[i] = string.Empty;

                //Parameters.CopyTo(Da.DBFields, Parameters.Length);
                for (int i = 1; i <= Parameters.Length; i++)
                    Da.DBFields[i] = Parameters[i - 1];

                Da.ColumnCount = Parameters.Length;

                //Call database
                TraceOutput.Information(string.Format("Calling Stored Procedure: {0}", StoredProcedureName));
                Da.DBCALL(Misys.OpicsPlus.Framework.DataAccessLayer.CommandType.STOREDPROCEDURE.ToString(), string.Empty, StoredProcedureName);

                //Scan result
                TraceOutput.Information(string.Format("Stored Procedure returned: ", Da.Result.ToString()));
                if (Da.Result != ReturnType.dbFAIL)
                {
                    //Data has been returned successfully, exit with dataset
                    SessionParameters.Result.ErrorNumber = 0;
                    TraceOutput.ExitModule("CallStoredProcedure");
                    return Da.Output.Data;
                }
                
                //Trace error message
                TraceOutput.Error(string.Format("CallStoredProcedure failed: {0} {1}", Da.Error.ErrorCode, Da.Error.ErrorMessage));
                //Error happened, return error message and exit
                SessionParameters.Result.ErrorNumber = 21;

            
            }
            catch (Exception ex)
            {
                TraceOutput.Error(ex.Message);
                SessionParameters.Result.SetError(17201, new object[] { ex.Message });

            }
            TraceOutput.ExitModule("CallStoredProcedure");
            return null;

        }

        /// <summary>
        /// This method will call named Stored Procedure and return result
        /// </summary>
        /// <param name="Da"></param>
        /// <param name="StoredProcedureName"></param>
        /// <param name="Parameters"></param>
        /// <returns></returns>
        public static DataSet CallStoredProcedure(DataAccessProxy Da, string StoredProcedureName, string[] Parameters, out string[,] OutputResult)
        {
            TraceOutput.EnterModule(string.Format("CallStoredProcedure: {0}", StoredProcedureName));
            OutputResult = null;
            try
            {
                //Get data access proxy
                if (Da == null)
                {
                    Da = DataAccessProxy.GetDataProxy();
                }

                // Make a call to database to get data
                for (int i = 0; i < 300; i++) Da.DBFields[i] = string.Empty;

                //Parameters.CopyTo(Da.DBFields, Parameters.Length);
                for (int i = 1; i <= Parameters.Length; i++)
                    Da.DBFields[i] = Parameters[i - 1];

                Da.ColumnCount = Parameters.Length;

                //Call database
                TraceOutput.Information(string.Format("Calling Stored Procedure: {0}", StoredProcedureName));
                Da.DBCALL(Misys.OpicsPlus.Framework.DataAccessLayer.CommandType.STOREDPROCEDURE.ToString(), string.Empty, StoredProcedureName, out OutputResult);

                //Scan result
                TraceOutput.Information(string.Format("Stored Procedure returned: ", Da.Result.ToString()));
                if (Da.Result != ReturnType.dbFAIL)
                {
                    //Data has been returned successfully, exit with dataset
                    SessionParameters.Result.ErrorNumber = 0;
                    TraceOutput.ExitModule("CallStoredProcedure");
                    return Da.Output.Data;
                }

                //Trace error message
                TraceOutput.Error(string.Format("CallStoredProcedure failed: {0} {1}", Da.Error.ErrorCode, Da.Error.ErrorMessage));
                //Error happened, return error message and exit
                SessionParameters.Result.ErrorNumber = 21;
            }
            catch (Exception ex)
            {
                TraceOutput.Error(ex.Message);
                SessionParameters.Result.SetError(17201, new object[] { ex.Message });
            }
            TraceOutput.ExitModule("CallStoredProcedure");
            return null;


        }


        /// <summary>
        /// Calls Request Distributor stored procedure to process XML request
        /// </summary>
        /// <param name="Da">Data access adaptor</param>
        /// <param name="ModuleName">Module Name</param>
        /// <param name="Action">Action</param>
        /// <param name="Message">XML Message</param>
        /// <returns>XML</returns>
        public static string CallRequestDistributor(DataAccessProxy Da, string FunctionCode, string Message)
        {
            TraceOutput.EnterModule("CallRequestDistributor: ");
            try
            {
                //Composing XML message
                XmlDocument xml = new XmlDocument();
                XmlNode root = xml.CreateElement("Request");
                XmlAttribute functionCode = xml.CreateAttribute("FunctionCode");
                functionCode.Value = FunctionCode;
                root.Attributes.Append(functionCode);
                //Append message
                root.InnerXml = Message;

                //Finalize xml
                xml.AppendChild(root);

                //Sending out message
                string[] para = new string[1];
                para[0] = XmlHelper.XmlToString(xml);
                string[,] outputXml;
                CallStoredProcedure(Da, SP_SCOTIA_REQUEST_DISTRIBUTOR, para ,out outputXml);
                TraceOutput.Information(outputXml.Length.ToString());
                
                return outputXml[1,1];
            }
            catch (Exception ex)
            {
                TraceOutput.Error(ex.Message);
            }
            TraceOutput.ExitModule("CallStoredProcedure");
            return null;


        }

    
    
    }


}
