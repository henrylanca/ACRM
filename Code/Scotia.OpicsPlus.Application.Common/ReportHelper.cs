/******************************************************************************************************************************************
 * Description: This Common module is to centralized shared components across Scotia modules
 * 
 * Revision:
 *  Feb 09, 2012    Louis Li    Created
 *  Feb 09, 2012    Louis Li    Added Config class
 ******************************************************************************************************************************************/
using System;

using Misys.OpicsPlus.Framework.Reporting;


namespace Scotia.OpicsPlus.Application.Common
{
    /// <summary>
    /// This library is to generate a pre-defined report directly from code
    /// </summary>
    public static class ReportHelper
    {
        public void StartOneReport(Report report, string userId, string instanceId, string branch, bool eodRequest)
        {
            ReportInformation reportInformationByReportName = StaticFunctions.GetReportInformationByReportName(report.ReportName);
            ReportHeader reportHeader = StaticFunctions.GetReportHeader(report.Branch, report.Parameters, reportInformationByReportName.ReportId, 0);
            if (reportHeader == null)
            {
                reportHeader = StaticFunctions.CreateReportHeader(report.Branch, report.Parameters, reportInformationByReportName);
                report.set_RHDR_ReportId(reportHeader.ReportId);
            }
            else
            {
                bool flag = this.ReportInProgress(reportHeader);
                report.set_RHDR_ReportId(reportHeader.ReportId);
                if (flag == 0)
                {
                    reportHeader.set_Status(1);
                    reportHeader.set_StatusUpdateDateTime(DateTime.Now);
                    reportHeader.set_ReportLines(0);
                    reportHeader.set_CreateDateTime(DateTime.Now);
                    reportHeader.set_PrintDateTime(DateTime.MinValue);
                    reportHeader.set_Locator(string.Empty);
                    reportHeader.set_ErrorCode(0);
                    StaticFunctions.UpdateReportHeader(reportHeader);
                    using (MessageManager messageManager = new MessageManager(this.reportManagerSettings.AdapterName))
                    {
                        ReportingServiceControlRequest reportingServiceControlRequest = this.BuildControlRequest(reportHeader, reportInformationByReportName, this.reportStartDto, instanceId);
                        reportingServiceControlRequest.set_UserId(userId);
                        reportingServiceControlRequest.set_Branch(branch);
                        this.SendControlRequestToQueue(messageManager, reportingServiceControlRequest);
                    }
                }
            }
        }

    }
}
