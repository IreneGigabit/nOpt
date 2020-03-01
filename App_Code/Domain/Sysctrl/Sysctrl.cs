using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// mapping table name: sysctrl
/// </summary>
namespace Saint.Sysctrl
{
    public class Sysctrl
    {
        /// <summary>
        /// 
        /// </summary>
        public Int32 sqlno { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public String scode { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public String branch { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public String dept { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public String sysdefault { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public String syscode { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public String logingrp { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime beg_date { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime end_date { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime visit_date { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime tran_date { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public String mark { get; set; }

    }
}