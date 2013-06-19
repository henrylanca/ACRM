/******************************************************************************************************************************************
 * Description: This Common module is to centralized shared components across Scotia modules
 * 
 * Revision:
 *  Feb 08, 2012    Louis Li    Created
 *  Feb 08, 2012    Louis Li    Added SharedParameters class
 ******************************************************************************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Scotia.OpicsPlus.Application.Common
{
    /// <summary>
    /// Scotia Common Libraray - Shared Parameters
    /// This library contains static const strings used by other common libraries
    /// </summary>
    public static class SharedParameters
    {

        /// <summary>
        /// Format of trace message used by TraceHelper
        /// </summary>
        public static class TraceMessages
        {
            /// <summary>
            /// Message format for entering module message
            /// </summary>
            public const string EnterModule = "Enter {0}";

            /// <summary>
            /// Message format for exiting module message
            /// </summary>
            public const string ExitModule = "Exit {0}";

            /// <summary>
            /// Message format for informational message body
            /// </summary>
            public const string Information = "Information: {0}";

            /// <summary>
            /// Message format for warning message body
            /// </summary>
            public const string Warning = "Warning: {0}";

            /// <summary>
            /// Message format for error message body
            /// </summary>
            public const string Error = "ERROR: {0}";
        }
    }
}
