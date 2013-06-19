/* TODO: ***********************************************************
 *                                                                 *
 * Instructions:                                                   *
 *                                                                 *
 * - Change the assembly name in the project's properties.         *
 * - Set the reference path to the server bin directory.           *
 * - Check TODO comments in the project.                           *
 *                                                                 *
 * After successful compilation:                                   *                                        *
 * - Copy the compiled dll to the client and server bin folders.   *
 *                                                                 *
 * *************************************************************** */

using System;
using Misys.OpicsPlus.Framework.Common.BusinessData;

namespace Scotia.OpicsPlus.Application.ACRM
{

    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false)]
    [Serializable()]
    public class ACRMDTO : DataTransferObject
    {
        public const string SM_DTO_NAME = "ACRMDTO";

        //private string branch;
        private DateTime extractDate;
        private bool isfullload;

        public ACRMDTO()
        {
        }

        //[System.Xml.Serialization.XmlElementAttribute("BRANCH", Form = System.Xml.Schema.XmlSchemaForm.Unqualified)]
        //public string Branch
        //{
        //    get
        //    {
        //        return this.branch;
        //    }
        //    set
        //    {
        //        this.branch = value;
        //    }
        //}

        [System.Xml.Serialization.XmlElementAttribute("EXTRACTDATE", Form = System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public DateTime ExtractDate
        {
            get
            {
                return this.extractDate;
            }

            set
            {
                this.extractDate = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("FULLLOAD", Form = System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public bool IsFullload
        {
            get
            {
                return this.isfullload;
            }

            set
            {
                this.isfullload = value;
            }
        }

        public override bool Equals(object other)
        {
            if ((base.Equals(other) == false))
            {
                return false;
            }
            if ((this.GetType().Equals(other.GetType()) == false))
            {
                return false;
            }
            ACRMDTO otherObj = ((ACRMDTO)(other));
            //if ((this.Branch == null))
            //{
            //    if ((otherObj.Branch != null))
            //    {
            //        return false;
            //    }
            //}
            //else
            //{
            //    if ((this.Branch.Equals(otherObj.Branch) == false))
            //    {
            //        return false;
            //    }
            //}

            if (this.ExtractDate != otherObj.ExtractDate ||
                this.IsFullload != otherObj.IsFullload)
                return false;

            return true;
        }

        public override int GetHashCode()
        {
            int hashCode = base.GetHashCode();
            //if ((this.Branch != null))
            //{
            //    hashCode = (hashCode ^ this.Branch.GetHashCode());
            //}

            hashCode = hashCode ^ this.ExtractDate.GetHashCode() ^ this.IsFullload.GetHashCode();
            return hashCode;
        }
    }

}
