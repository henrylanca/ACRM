/******************************************************************************************************************************************
 * Description: This Common module is to centralized shared components across Scotia modules
 * 
 * Revision:
 *  Feb 09, 2012    Louis Li    Created
 *  Feb 09, 2012    Louis Li    Added LogHelper class
 ******************************************************************************************************************************************/
using System;
using System.Threading;
using System.Diagnostics;
using Misys.OpicsPlus.Framework.Common.ApplicationLogging.DataObjects.TransactionStreams;
using Misys.OpicsPlus.Framework.Common;
using Misys.OpicsPlus.Framework.Common.Errors;
using Misys.OpicsPlus.Framework.Common.ApplicationLogging.Core;
using Misys.OpicsPlus.Framework.ServiceMessages;

namespace Scotia.OpicsPlus.Application.Common
{
    /// <summary>
    /// Scotia Common Libraray - Log helper
    /// This helper library is to generate application logs in log database and tables.
    /// Usage:
    ///     1. Create instance in application code
    ///     2. Call either one of 2 log methods to generate log message. 
    /// </summary>
    public class LogHelper
    {
           
        public LogHelper()
        {
        }

        /// <summary>
        /// Create an LogEntry object for future use
        /// </summary>
        /// <param name="logMessageType">
        /// Incoming = 0,
        /// Outgoing = 1,
        /// InProgress = 2,
        /// Unspecified = 3,
        /// SqlStatement = 4,
        /// SqlResult = 5,
        /// Error = 6,
        /// Log = 7,
        /// Service = 8,
        /// </param>
        /// <returns></returns>
        public LogEntry CreateLogEntry(LogMessageType logMessageType)
        {
            LogEntry logEntry = new LogEntry();
            try
            {
                string sRID = Convert.ToString(SessionParameters.GetObjectBroker("SRID"));
                logEntry.Category = "LOG";
                logEntry.InstanceName = SessionParameters.Common.InstanceId;
                logEntry.SessionID = SessionParameters.Common.SessionId;
                logEntry.SrId = sRID;
                logEntry.ThreadId = Thread.CurrentThread.ManagedThreadId.ToString();
                logEntry.Time = DateTime.Now;
                logEntry.Type = logMessageType;
                logEntry.UserId = SessionParameters.UserId;
                logEntry.Branch = SessionParameters.Branch;
            }
            catch (Exception exception)
            {
                Debug.WriteLine(string.Format("OpicsLoggerHelper.CreateLogEntry(LogMessageType logMessageType): {0}", exception));
                logEntry = null;
            }
            return logEntry;
        }


        /// <summary>
        /// Format error message string
        /// </summary>
        /// <param name="error">Error object</param>
        /// <returns>Formatted error string</returns>
        public string GetErrorString(Misys.OpicsPlus.Framework.Common.Errors.Error error)
        {
            return string.Format("Error {0} of type '{2}' occurred.\n{1}", error.Number, error.Text, error.Type);
        }

        /// <summary>
        /// Log message in database
        /// </summary>
        /// <param name="message">Message body</param>
        /// <param name="transactionStreamName">Transaction stream name</param>
        /// <param name="functionCode">function code: Free text for querying purposes</param>
        /// <param name="logMessageType">
        /// Incoming = 0,
        /// Outgoing = 1,
        /// InProgress = 2,
        /// Unspecified = 3,
        /// SqlStatement = 4,
        /// SqlResult = 5,
        /// Error = 6,
        /// Log = 7,
        /// Service = 8,
        /// </param>
        /// <param name="category">Free text parameter, generally assigned with module name</param>
        public void Log(string message, string transactionStreamName, string functionCode, LogMessageType logMessageType, string category)
        {
            try
            {
                LogEntry logEntry = this.CreateLogEntry(logMessageType);
                if (logEntry != null)
                {
                    logEntry.FunctionCode = functionCode;
                    logEntry.Message = message;
                    OpicsLogger.Instance.Write(logEntry);
                }
            }
            catch (Exception exception)
            {
                Debug.WriteLine(string.Format("OpicsLoggerHelper.Log(): {0}", exception));
            }
        }

        /// <summary>
        /// Log message in database
        /// </summary>
        /// <param name="message">Message body</param>
        /// <param name="transactionStreamName">Transaction stream name</param>
        /// <param name="functionCode">function code: Free text for querying purposes</param>
        /// <param name="logMessageType">
        /// Incoming = 0,
        /// Outgoing = 1,
        /// InProgress = 2,
        /// Unspecified = 3,
        /// SqlStatement = 4,
        /// SqlResult = 5,
        /// Error = 6,
        /// Log = 7,
        /// Service = 8,
        /// </param>
        /// <param name="category">Free text parameter, generally assigned with module name</param>
        /// <param name="username">User name related to this message</param>
        /// <param name="branch">branch nuumber</param>
        public void Log(string message, string transactionStreamName, string functionCode, LogMessageType logMessageType, string category, string username, string branch)
        {
            try
            {
                LogEntry logEntry = this.CreateLogEntry(logMessageType);
                if (logEntry != null)
                {
                    logEntry.FunctionCode = functionCode;
                    logEntry.UserId = username;
                    logEntry.Branch = branch;
                    logEntry.Message = message;
                    OpicsLogger.Instance.Write(logEntry);
                }
            }
            catch (Exception exception)
            {
                Debug.WriteLine(string.Format("OpicsLoggerHelper.Log(): {0}", exception));
            }
        }

        /// <summary>
        /// Log outgoing messages
        /// </summary>
        /// <param name="error">Misys.OpicsPlus.Framework.Common.Errors.Error</param>
        /// <param name="outgoingMessage">Message that is going out (to client)</param>
        public void LogOutgoingErrors(Misys.OpicsPlus.Framework.Common.Errors.Error error, ServiceMessage outgoingMessage)
        {
            string empty;
            string str;
            try
            {
                if (error.Occurred())
                {
                    Log(string.Format("Error {0}: '{1}'", error.Number, error.Text), string.Empty, "ServiceRedirector.LogOutgoingErrors", LogMessageType.Error, "MBRE");
                }
                if (outgoingMessage.Header.ServiceErrors.Count > 0)
                {
                    foreach (Misys.OpicsPlus.Framework.ServiceMessages.Error serviceError in outgoingMessage.Header.ServiceErrors)
                    {
                        empty = string.Empty;
                        foreach (Field field in serviceError.Fields)
                        {
                            empty = string.Concat(empty, string.Format("Field: {0}, Location: {1};", field.Name, field.Location));
                        }
                        str = string.Empty;
                        foreach (Param parameter in serviceError.Parameters)
                        {
                            str = string.Concat(str, string.Format("Parameter: {0}, Value: {1};", parameter.Name, parameter.Value));
                        }
                        Log(string.Format("Error {0}. Fields: '{1}'; Parameters: '{2}'", serviceError.Name, empty, str), string.Empty, "ServiceRedirector.LogOutgoingErrors", LogMessageType.Error, "MBRE");
                    }
                }
                if (outgoingMessage.Body.Errors.Count > 0)
                {
                    foreach (Misys.OpicsPlus.Framework.ServiceMessages.Error error2 in outgoingMessage.Body.Errors)
                    {
                        empty = string.Empty;
                        foreach (Field field in error2.Fields)
                        {
                            empty = string.Concat(empty, string.Format("Field: {0}, Location: {1};", field.Name, field.Location));
                        }
                        str = string.Empty;
                        foreach (Param parameter in error2.Parameters)
                        {
                            str = string.Concat(str, string.Format("Parameter: {0}, Value: {1};", parameter.Name, parameter.Value));
                        }
                        this.Log(string.Format("Error {0}. Fields: '{1}'; Parameters: '{2}'", error2.Name, empty, str), string.Empty, "ServiceRedirector.LogOutgoingErrors", LogMessageType.Error, "MBRE");
                    }
                }
            }
            catch (Exception exception)
            {
                Debug.WriteLine(string.Format("OpicsLoggerHelper.LogOutgoingErrors(Common.Errors.Error error, ServiceMessage outgoingMessage): {0}", exception));
            }
        }
    }
}