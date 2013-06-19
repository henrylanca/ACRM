using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Scotia.OpicsPlus.Application.Common
{
    /// <summary>
    /// Shared common library 
    /// </summary>
    public static class CommonLib
    {
        /// <summary>
        /// This method returns a clean money value
        /// </summary>
        /// <param name="MoneyValue"></param>
        /// <returns></returns>
        public static string CleanMoneyValue(string MoneyValue)
        {

            MoneyValue.Trim();
            MoneyValue.Replace("+", string.Empty);
            MoneyValue.Replace(",", string.Empty);
            MoneyValue.Replace("K", "000");
            MoneyValue.Replace("M", "000000");
            MoneyValue = (string.IsNullOrEmpty(MoneyValue) ? "0" : MoneyValue);

            return MoneyValue;
        }

        /// <summary>
        /// This method returns a clean percentage value
        /// </summary>
        /// <param name="PercentageValue"></param>
        /// <returns></returns>
        public static string CleanPercentageValue(string PercentageValue)
        {

            PercentageValue.Trim();
            PercentageValue.Replace("%", string.Empty);

            return PercentageValue;
        }
    }
}
