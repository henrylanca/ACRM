using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.IO;

namespace Scotia.OpicsPlus.Application.Common
{
    /// <summary>
    /// This is a helper class to support XML document
    /// </summary>
    public static class XmlHelper
    {
        /// <summary>
        /// Convert XML document to string with UTF8 format
        /// </summary>
        /// <param name="xml"></param>
        /// <returns></returns>
        public static string XmlToString(XmlDocument xml)
        {
            string result = string.Empty;
            using (var stringWriter = new StringWriter())
            using (var xmlTextWriter = XmlWriter.Create(stringWriter))
            {
                xml.WriteTo(xmlTextWriter);
                xmlTextWriter.Flush();
                result = stringWriter.GetStringBuilder().ToString();
            }
            return result;
        }

        /// <summary>
        /// This class is to be used to generate XML string with no declaration
        /// </summary>
        public class XmlTextWriterFormattedNoDeclaration : System.Xml.XmlTextWriter
        {
            public XmlTextWriterFormattedNoDeclaration(System.IO.TextWriter w)
                : base(w)
            {
                //Formatting = System.Xml.Formatting.Indented;
            }

            public override void WriteStartDocument()
            {
                // suppress
            }
        }

        /// <summary>
        /// Check whether ErrorMessage node exists in given XML string
        /// </summary>
        public static bool ErrorExists(string Xml, out string ErrorMessage)
        {
            XmlDocument xd = StringToXml(Xml);
            XmlNodeList xdl = xd.GetElementsByTagName("ErrorMessage");
            if (xdl != null && xdl.Count > 0)
            {
                ErrorMessage = xdl[0].InnerText;
                return true;
            }
            else
            {
                ErrorMessage = string.Empty;
                return false;
            }
        }


        /// <summary>
        /// Converts string into a XmlDocument type
        /// </summary>
        /// <param name="Xml"></param>
        /// <returns></returns>
        public static XmlDocument StringToXml(string Xml)
        {
            XmlDocument xd = new XmlDocument();
            xd.LoadXml(Xml);
            return xd;
        }
    }
}
