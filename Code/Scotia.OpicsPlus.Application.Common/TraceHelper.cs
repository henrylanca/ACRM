/******************************************************************************************************************************************
 * Description: This Common module is to centralized shared components across Scotia modules
 * 
 * Revision:
 *  Feb 08, 2012    Louis Li    Created
 *  Feb 08, 2012    Louis Li    Added
 *  Feb 09, 2012    Louis Li    Changed class name from TraceOutput to TraceHelper
 ******************************************************************************************************************************************/

using System;
using System.Diagnostics;

namespace Scotia.OpicsPlus.Application.Common
{

    /// <summary>
    /// Scotia Common Libraray - Trace helper
    /// This helper library is to generate detailed trace message for developers. Trace messages will NOT be captured 
    /// in Opics database nor logging table. It will only be visible using development tools.
    /// 
    /// This library is static, therefore, there is no need to create instance to use this library. Simply call methods.
    /// </summary>
    public static class TraceOutput
    {

        /// <summary>
        /// Generate trace for enttering module. Calling this method at the begining of each module is recommended.
        /// </summary>
        /// <param name="Modulename">Module Name</param>
        public static void EnterModule(string Modulename)
        {
            Trace.WriteLine(string.Format(SharedParameters.TraceMessages.EnterModule, Modulename));
        }

        /// <summary>
        /// Generate trace for exiting module. Calling this method at the begining of each module is recommended.
        /// </summary>
        /// <param name="Modulename">Module Name</param>
        public static void ExitModule(string Modulename)
        {
            Trace.WriteLine(string.Format(SharedParameters.TraceMessages.ExitModule, Modulename));
        }

        /// <summary>
        /// Generate trace for information. 
        /// </summary>
        /// <param name="Message">Messagebody</param>
        public static void Information(string Message)
        {
            Trace.WriteLine(string.Format(SharedParameters.TraceMessages.Information, Message));
        }

        /// <summary>
        /// Generate trace for information. 
        /// </summary>
        /// <param name="Message">Messagebody</param>
        public static void Warning(string Message)
        {
            Trace.WriteLine(string.Format(SharedParameters.TraceMessages.Warning, Message));
        }


        /// <summary>
        /// Generate trace for information. Emitting error messages is highly recommended.
        /// </summary>
        /// <param name="Message">Messagebody</param>
        public static void Error(string Message)
        {
            Trace.WriteLine(string.Format(SharedParameters.TraceMessages.Error, Message));
        }


    }
}
