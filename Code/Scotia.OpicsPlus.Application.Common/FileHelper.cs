/******************************************************************************************************************************************
 * Description: This Common module is to centralized shared components across Scotia modules
 * 
 * Revision:
 *  Feb 09, 2012    Louis Li    Created
 *  Feb 09, 2012    Louis Li    Added FileHelper class
 ******************************************************************************************************************************************/
using System;
using System.IO;
using System.Data;

namespace Scotia.OpicsPlus.Application.Common
{
    /// <summary>
    /// Scotia Common Libraray - File helper
    /// This helper library is to handle file system requests.
    /// This library is static, therefore, there is no need to create instance to use this library. Simply call methods.
    /// </summary>
    public static class FileHelper
    {
        /// <summary>
        /// Generating a file using dataset and format string
        /// </summary>
        /// <param name="Fullname">folder name and file name</param>
        /// <param name="Format">format string</param>
        /// <param name="Data">dataset needs to be populated into file</param>
        /// <param name="Append">create new or append existing</param>
        public static void GenerateFile(string Fullname, string Format, DataSet Data, bool Append)
        {
            TraceOutput.EnterModule(string.Format("GenerateFile: {0} {1} {2} {3}", Fullname, Format, Data, Append));
            Fullname = DataAccessHelper.SystemFolderUpdate(Fullname);

            //Validate
            string folder = Path.GetFullPath(Fullname);
            string filename = Path.GetFileName(Fullname);

            GenerateFile(folder, filename, Format, Data, Append);
            TraceOutput.ExitModule("GenerateFile");
        }

        /// <summary>
        /// Generating a file using dataset and format string
        /// </summary>
        /// <param name="Foldername">Foldername</param>
        /// <param name="Filename">Filename</param>
        /// <param name="Format">format string</param>
        /// <param name="Data">dataset needs to be populated into file</param>
        /// <param name="Append">create new or append existing</param>
        public static void GenerateFile(string Foldername, string Filename, string Format, DataSet Data, bool Append)
        {
            TraceOutput.EnterModule(string.Format("GenerateFile: {0} {1} {2} {3}", Foldername, Filename, Format, Append));

            Foldername = DataAccessHelper.SystemFolderUpdate(Foldername);
            //Generate file
            if (Directory.Exists(Foldername) && Data != null && Data.Tables.Count > 0)
            {
                //Start generating file
                TraceOutput.Information(string.Format("Generating File -- Number of rows : {0}", Data.Tables[0].Rows.Count));
                using (StreamWriter sw = new StreamWriter(Path.Combine(Foldername, Filename), Append))
                {
                    foreach (DataRow row in Data.Tables[0].Rows)
                    {
                        sw.WriteLine(string.Format(Format, row.ItemArray));
                    }
                }
            }

            TraceOutput.ExitModule("GenerateFile");
        }

        /// <summary>
        /// Generating a file with single row. E.G. Can be used to insert file header.
        /// </summary>
        /// <param name="Foldername">Foldername</param>
        /// <param name="Filename">Filename</param>
        /// <param name="Format">format string</param>
        /// <param name="Row">Row content to be written into file</param>
        /// <param name="Append">create new or append existing</param>
        public static void GenerateFileWithSingleRow(string Foldername, string Filename, string Format, string Row, bool Append)
        {
            TraceOutput.EnterModule(string.Format("GenerateFile: {0} {1} {2} {3} {4}", Foldername, Filename, Format, Row, Append));
            Foldername = DataAccessHelper.SystemFolderUpdate(Foldername);

            if (Directory.Exists(Foldername))
            {
                //Write into file
                using (StreamWriter sw = new StreamWriter(Path.Combine(Foldername, Filename), Append))
                {
                    sw.WriteLine(Row);
                }
            }

            TraceOutput.ExitModule("GenerateFile");
        }

        /// <summary>
        /// Delete entire folder, including root folder
        /// </summary>
        /// <param name="Foldername">Folder name</param>
        public static void DeleteDirectory(string Foldername, bool Recursive)
        {
            TraceOutput.EnterModule(string.Format("Deleting Folder: {0}, recursive {1}", Foldername, Recursive));

            Foldername = DataAccessHelper.SystemFolderUpdate(Foldername);
            try
            {
                if (Directory.Exists(Foldername))
                {
                    Directory.Delete(Foldername, Recursive);
                }
                else
                {
                    TraceOutput.Warning(string.Format("Folder {0} does not exist.", Foldername));
                }

                TraceOutput.ExitModule("Folder deleted");
            }
            catch (Exception ex)
            {
                TraceOutput.Error(string.Format("Error: {0}", ex.Message));
                TraceOutput.ExitModule(string.Format("Folder {0} deleting failed.", Foldername));
            }
        }

        /// <summary>
        /// Clear entire folder, root folder stays
        /// </summary>
        /// <param name="Foldername">Folder name</param>
        public static void ClearDirectory(string Foldername, bool Recursive)
        {
            TraceOutput.EnterModule(string.Format("Clearing Folder: {0}, recursive {1}", Foldername, Recursive));

            Foldername = DataAccessHelper.SystemFolderUpdate(Foldername);
            try
            {
                if (Directory.Exists(Foldername))
                {
                    //Deleteing all files under root folder
                    foreach (string file in Directory.GetFiles(Foldername))
                    {
                        File.Delete(file);
                    }
                    
                    //Delete all sub-diretories
                    foreach (string dir in Directory.GetDirectories(Foldername))
                    {
                        DeleteDirectory(dir, Recursive);
                    }
                    
                }
                else
                {
                    TraceOutput.Warning(string.Format("Folder {0} does not exist.", Foldername));
                }

                TraceOutput.ExitModule("Folder cleared");
            }
            catch (Exception ex)
            {
                TraceOutput.Error(string.Format("Error: {0}", ex.Message));
                TraceOutput.ExitModule(string.Format("Folder {0} clearing failed.", Foldername));
            }
        }

        /// <summary>
        /// Create Directory if it does not exist
        /// </summary>
        /// <param name="Foldername"></param>
        public static void CreateDirectory(string Foldername)
        {
            TraceOutput.EnterModule(string.Format("Creating directory: {0}", Foldername));

            Foldername = DataAccessHelper.SystemFolderUpdate(Foldername);

            if (!Directory.Exists(Foldername))
            {
                Directory.CreateDirectory(Foldername);
            }
            else
            {
                TraceOutput.Warning(string.Format("Folder {0} already exists."));
            }

            TraceOutput.ExitModule("GenerateFile");

        }

        /// <summary>
        /// Copy file/folder from source location to destination
        /// </summary>
        /// <param name="From">Source folder or file</param>
        /// <param name="To">Destination folder name</param>
        public static void CopyFile(string From, string To)
        {
            TraceOutput.EnterModule(string.Format("Copy file {0} To {1}", From, To));

            From = DataAccessHelper.SystemFolderUpdate(From);
            To = DataAccessHelper.SystemFolderUpdate(To);

            if ((File.GetAttributes(From) & FileAttributes.Directory) == FileAttributes.Directory)
            {
                //This is a directory
                CopyDirectory(From,To , true);
            }
            else
            {
                //This is a file
                string filename = Path.GetFileName(From);
                File.Copy(From, Path.Combine(To,filename), true);
            }
            TraceOutput.ExitModule("File/Directory is copied.");
        }


        /// <summary>
        /// Copy files by given search pattern from source location to destination
        /// </summary>
        /// <param name="From">Source folder or file</param>
        /// <param name="To">Destination folder name</param>
        public static void CopyFiles(string From, string To)
        {
            TraceOutput.EnterModule(string.Format("Copy files {0} To {1}", From, To));

            From = DataAccessHelper.SystemFolderUpdate(From);
            To = DataAccessHelper.SystemFolderUpdate(To);

            DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(From));
            FileInfo[] fileList = dir.GetFiles(Path.GetFileName(From));

            foreach (FileInfo file in fileList)
            {
                file.CopyTo(To, true);
            }

            TraceOutput.ExitModule("Files are copied.");
        }

        /// <summary>
        /// Copy entire folder to another location
        /// </summary>
        /// <param name="From">Source folder name</param>
        /// <param name="To">Destination folder</param>
        /// <param name="CopySubDirs">Include subdirectories or no</param>
        public static void CopyDirectory(string From, string To, bool CopySubDirs)
        {
            TraceOutput.EnterModule(string.Format("DirectoryCopy {0} To {1}", From, To));

            From = DataAccessHelper.SystemFolderUpdate(From);
            To = DataAccessHelper.SystemFolderUpdate(To);

            DirectoryInfo dir = new DirectoryInfo(From);
            DirectoryInfo[] dirs = dir.GetDirectories();

            // If the source directory does not exist, throw an exception.
            if (!dir.Exists)
            {
                TraceOutput.Error(string.Format("DirectoryCopy source directory ({0}) does not exist.", From));
                return;
            }

            // If the destination directory does not exist, create it.
            if (!Directory.Exists(To))
            {
                Directory.CreateDirectory(To);
            }


            // Get the file contents of the directory to copy.
            FileInfo[] files = dir.GetFiles();

            foreach (FileInfo file in files)
            {
                // Create the path to the new copy of the file.
                string temppath = Path.Combine(To, file.Name);

                // Copy the file.
                file.CopyTo(temppath, true);
            }

            // If copySubDirs is true, copy the subdirectories.
            if (CopySubDirs)
            {

                foreach (DirectoryInfo subdir in dirs)
                {
                    // Create the subdirectory.
                    string temppath = Path.Combine(To, subdir.Name);

                    // Copy the subdirectories.
                    CopyDirectory(subdir.FullName, temppath, CopySubDirs);
                }
            }
            TraceOutput.ExitModule("Directory is copied.");
        }

    }
}
