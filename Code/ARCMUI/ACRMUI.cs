/* TODO: ********************************************************************************
 *                                                                                      *
 * Instructions:                                                                        *
 *                                                                                      *
 * - Create and compile the project with the DTO (data object) class the UI will use.   *
 * - Add reference to the data object's assemby.                                        *
 * - Set the reference path to the client bin directory in the project's properties.    *
 * - Change the assembly name in the project's properties.                              *
 * - Change the reference to the namespace of the data object.                          *
 * - Change all occurrences of ASBADTO to the type of the data object.                  *
 * - Check other TODO comments in the code.                                             *
 *                                                                                      *
 * After successful compilation:                                                        *
 * - Copy Xml\UI.xml and Xml\UITemplate.xml files to                *
 *   OPXSYS\XML directory.                                                              *
 * - Add the xml line found in ConfigurationData\UI_menu.xml                  *
 *   to OPSXYX\XML\menu.xml file.                                                       *
 * - Add the xml line found in ConfigurationData\UI_SecondaryWindows.config   *
 *   to OPXSYS\XML\SecondaryWindows.config file.                                        *
 * - Copy the compiled dll to the client bin folder.                                                                                     *
 *                                                                                      *
 * ************************************************************************************ */


using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System;


using Misys.OpicsPlus.Framework.PresentationLayer.Controls;
using Misys.OpicsPlus.Framework.PresentationLayer.ProcessingComponents;
using Misys.OpicsPlus.Framework.PresentationLayer.ScreenComponents;
using Misys.OpicsPlus.Framework.PresentationLayer.SecondaryWindows;
using Misys.OpicsPlus.Framework.ServiceMessages;
// TODO: Change the namespace of the data object.
//using Misys.OpicsPlus.Application.Batch.ASBA.DataObjects;


namespace Scotia.OpicsPlus.Application.ACRM
{
    public class ACRMUI : SpecializedBatchSecondaryWindow
    {
        #region General declarations

        // Transaction streams
        // TODO: - Change the transaction stream name if necessary. 
        //       - Make sure the transaction stream names are same as 
        //       - the TX stream names in the TransactionStreams.xml file. 
        //         TransactionStreams.xml file can be found in the 
        //         Business Component project.
        private const string UIASTART = "ACRMASTART";


        // Buttons and tools on the screen (defined in UI.xml file or in the framework)
        private const string ASTART = "ASTART";
        private const string BCLEAR = "BCLEAR";

        // Controls (defined in UITemplate.xml file)
        //private const string TB_BRANCH = "BRANCH";
        private const string TB_FULLLOAD = "FULLLOAD";
        private const string TB_EXTRACTDATE = "EXTRACTDATE";


        #endregion

        #region Initialize Class

        public ACRMUI()
            : base()
        {
        }
        #endregion

        #region Overriden Methods

        /// <summary>
        /// This method handles the tool click events on the screen. 
        /// </summary>
        /// <param name="sender">sender object</param>
        /// <param name="e">tool click event arguments</param>
        /// <param name="handled">bool, output parameter - indicates whether the tool click event was handled</param>
        protected override void GenericToolProcessing(object sender, Infragistics.Win.UltraWinToolbars.ToolClickEventArgs e, out bool handled)
        {
            // NOTE: e.Tool.Key is the tool name in the control xml file.
            switch (e.Tool.Key)
            {
                // This is where any custom button logic goes. 
                case (BCLEAR):
                    ClearProcessing();
                    handled = true;
                    break;
                case (ASTART):
                    if (ValidateInput())
                    {
                        AStartProcessing();
                    }
                    handled = true;
                    break;
                default:
                    base.GenericToolProcessing(sender, e, out handled);
                    break;
            }
        }

        /// <summary>
        /// This method clears the screen and sets the defaults values of the controls.
        /// </summary>
        protected override void ClearProcessing()
        {
            base.ClearProcessing();
            //this.ControlsCollection[TB_BRANCH].Text = SessionParameters.Branch;
            this.ControlsCollection[TB_EXTRACTDATE].Text = "";
            this.ControlsCollection[TB_FULLLOAD].SetValue("False");

            SetFocus();
            // TODO: uncomment the following lines if the UI should not perform the batch processing.
            //this.FormToolbars.Toolbars["ApplicationToolbar"].Tools[ASTART].SharedProps.Enabled = false;
            //base.DisplayMessage(4384); //Can not run the program ONLINE

        }

        /// <summary>
        /// This method calls the business component to start the batch processing 
        /// based on the entered screen data.
        /// </summary>
        protected override void AStartProcessing()
        {
            //TODO: see LongRunningTask routine below for long running execution
            IProcessingComponent proc;
            base.Execute(UIASTART, out proc);
            if (!DisplayError(proc.Message))
            {
                SetFocus();
                base.DisplayMessage(114); // Processing complete.
            }
        }

        #region [long running process]
        /// <summary>
        /// This routine calls application server in a long running task.
        /// </summary>
        private void LongRunningTask()
        {
            //Call execute extended for long running task
            base.ExecuteExtended(UIASTART);
        }

        /// <summary>
        /// This routine is to prepare screen for execution or after execution.
        /// </summary>
        /// <param name="transactionStream"></param>
        /// <param name="endExecution"></param>
        protected override void PrepareScreenForExecute(string transactionStream, bool endExecution)
        {
            base.PrepareScreenForExecute(transactionStream, endExecution);

            //TODO: add logic to disable or enable screen controls before execution or after execution
        }

        /// <summary>
        /// This routine is to do post processing of execute extended after calling application
        /// </summary>
        /// <param name="processingComponent"></param>
        /// <param name="arg"></param>
        protected override void ExecuteExtendedCompleted(IProcessingComponent processingComponent, ProcessingComponentsArgs arg)
        {
            base.ExecuteExtendedCompleted(processingComponent, arg);

            //TODO: after execution completed, inspect xml out for any errors or post processing
            ServiceMessage msg = new ServiceMessage(arg.XmlOut);
            if (!DisplayError(msg))
            {
                SetFocus();
                base.DisplayMessage(114); // Processing complete.
            }

        }
        #endregion

        /// <summary>
        /// This method adds the UI data to service message that will be sent to the business component.
        /// </summary>
        /// <param name="sm">UI service message containing the xml message to the business component</param>
        protected override void AddScreenDataToServiceMessage(UIServiceMessage sm)
        {
            // Create a data object from the screen data and add it to the service message
            ACRMDTO dto = GetDTO();
            sm.AddMessageDTO(ACRMDTO.SM_DTO_NAME, dto);
        }

        /// <summary>
        /// This method initializes the screen. 
        /// </summary>
        protected override void InitScreenData()
        {
            base.InitScreenData();
            // TODO: uncomment the following lines if the UI should not perform the batch processing.
            //this.FormToolbars.Toolbars["ApplicationToolbar"].Tools[ASTART].SharedProps.Enabled = false;
            //base.DisplayMessage(4384); //Can not run the program ONLINE
            SetFocus();
        }

        #endregion

        #region [Private methods]

        /// <summary>
        /// This method sets the default focus on the screen.
        /// </summary>
        private void SetFocus()
        {
            //this.ControlsCollection[TB_BRANCH].SetFocus();
        }

        /// <summary>
        /// This method creates and returns a data object with the data from the screen.
        /// </summary>
        /// <returns>data object</returns>
        private ACRMDTO GetDTO()
        {
            ACRMDTO dto = new ACRMDTO();
            //dto.Branch = this.ControlsCollection[TB_BRANCH].Text;

            if (string.IsNullOrEmpty(this.ControlsCollection[TB_EXTRACTDATE].Text))
                dto.ExtractDate = DateTime.Today;
            else
                dto.ExtractDate = DateTime.Parse(this.ControlsCollection[TB_EXTRACTDATE].Text);

            dto.IsFullload = Convert.ToBoolean(this.ControlsCollection[TB_FULLLOAD].GetValue());
            return dto;
        }

        /// <summary>
        /// This method highlights the error fields and displays the error message.
        /// </summary>
        /// <param name="msg">service message containing the error information</param>
        /// <returns>bool</returns>
        private bool DisplayError(ServiceMessage msg)
        {
            Error error = null;

            if (msg.Header.ServiceErrors.Count > 0)
            {
                error = msg.Header.ServiceErrors[0];
            }
            else if (msg.Body.Errors.Count > 0)
            {
                error = msg.Body.Errors[0];
            }

            if (error == null) return false;

            base.DisplayDataErrors(msg.Body.Errors);

            return true;
        }

        /// <summary>
        /// This method validates user input
        /// </summary>
        /// <returns></returns>
        private bool ValidateInput()
        {
            DateTime dtExtract = DateTime.Today;

            if (!string.IsNullOrEmpty(this.ControlsCollection[TB_EXTRACTDATE].Text))
            {
                if (!DateTime.TryParse(this.ControlsCollection[TB_EXTRACTDATE].Text, out dtExtract))
                {
                    MessageBox.Show("Invalid Extract date", "Date Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return false;
                }
            }

            return true;
        }

        #endregion
    }
}




