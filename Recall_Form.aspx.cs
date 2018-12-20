using CTINotificationServiceReference;
using O2OWebReference;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;

public partial class _Recall_Form : System.Web.UI.Page
{

    #region field

    private DbAccess _dbAccess = null;
    private O2OService _o2oService = null;
    private NotificationService _notificationService = null;

    #endregion


    #region property

    /// <summary>
    /// 資料庫連線實體
    /// </summary>
    private DbAccess DbAccessInstance
    {
        get
        {
            if (_dbAccess == null)
            {
                _dbAccess = new DbAccess();
            }
            return _dbAccess;
        }
    }

    /// <summary>
    /// O2O WebService類別實體
    /// </summary>
    private O2OService O2OServiceInstance
    {
        get
        {
            if (_o2oService == null)
            {
                _o2oService = new O2OService();
            }
            return _o2oService;
        }
    }

    /// <summary>
    /// CTIWEB通知服務實體
    /// </summary>
    private NotificationService NotificationServiceInstance
    {
        get
        {
            if (_notificationService == null)
            {
                _notificationService = new NotificationService();
            }
            return _notificationService;
        }
    }

    /// <summary>
    /// 服務管道
    /// </summary>
    private string ServiceChennal
    {
        get
        {
            // 20181116 herbert 限1人壽官網 或 2網路E方便
            return Request.QueryString["SC"];

            //return "1";
        }
    }

    /// <summary>
    /// 姓名
    /// </summary>
    private string CustomerName
    {
        get { return CustomerName_TextBox.Text.Trim(); }
    }

    /// <summary>
    /// 連絡方式
    /// </summary>
    private string CustomerPhone
    {
        get { return CustomerPhone_TextBox.Text.Trim(); }
    }

    /// <summary>
    /// 身分證字號
    /// </summary>
    private string CustomerId
    {
        get { return CustomerId_TextBox.Text.Trim(); }
    }

    /// <summary>
    /// 是否勾選「是否為富邦保戶」選項
    /// </summary>
    private bool HasCheckedIsFubonCustomer
    {
        get
        {
            return IsFubonCustomer || NotFubonCustomer_RadioButton.Checked;
        }
    }

    /// <summary>
    /// 是否為富邦保戶
    /// </summary>
    private bool IsFubonCustomer
    {
        get { return IsFubonCustomer_RadioButton.Checked; }
    }

    /// <summary>
    /// 服務類型
    /// </summary>
    private string ServiceType
    {
        get { return ServiceType_DropDownList.SelectedValue.Trim(); }
    }

    /// <summary>
    /// 方便聯絡時段
    /// </summary>
    private string ContactDate
    {
        get { return ConnectionTime_DropDownList.SelectedValue.Trim(); }
    }

    /// <summary>
    /// 是否同意個資說明事項
    /// </summary>
    private bool IsAgreement
    {
        get { return IsAgreement_CheckBox.Checked; }
    }

    #endregion


    #region method

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                if (string.IsNullOrEmpty(ServiceChennal) || (ServiceChennal != "1" && ServiceChennal != "2"))
                {
                    string str = "<script language='javascript'>goto();</script>";
                    Page.ClientScript.RegisterStartupScript(Page.GetType(), "radconfirm", str);
                    return;
                }
                this.InitialControls();
            }
        }
        catch (Exception)
        {
            Response.Write("系統忙碌中請稍後再試！");
            Submit_Button.Enabled = false;
            return;
        }
    }

    protected void Submit_Button_Click(object sender, EventArgs e)
    {
        string resultMessage = null;
        string serviceCaseNo = null;
        try
        {
            #region validation

            if (String.IsNullOrEmpty(this.CustomerName))
            {
                throw new ArgumentNullException("請填寫姓名");
            }

            if (String.IsNullOrEmpty(this.CustomerPhone))
            {
                throw new ArgumentNullException("請填寫連絡電話");
            }
            else if (this.CustomerPhone.StartsWith("09") && this.CustomerPhone.Length != 10)
            {
                throw new ArgumentException("電話號碼格式錯誤");
            }

            if (!this.HasCheckedIsFubonCustomer)
            {
                throw new ArgumentNullException("請選擇是否為富邦保戶");
            }

            if (this.IsFubonCustomer)
            {
                if (String.IsNullOrEmpty(this.CustomerId))
                {
                    throw new ArgumentNullException("富邦保戶請填寫身分證字號");
                }
                else if (!this.CheckId(this.CustomerId))
                {
                    throw new ArgumentException("身分證字號格式錯誤");
                }
            }

            if (String.IsNullOrEmpty(this.ServiceType))
            {
                throw new ArgumentNullException("請選擇服務類型");
            }

            if (String.IsNullOrEmpty(this.ContactDate))
            {
                throw new ArgumentNullException("請選擇方便聯絡時段");
            }
            else
            {
                string[] contactDateArray = this.ContactDate.Split(' ');
                DateTime tempDateTime;

                if (contactDateArray.Length != 2)
                {
                    throw new ArgumentNullException("方便聯絡時段格式錯誤");
                }

                if (!DateTime.TryParse(contactDateArray[0], out tempDateTime))
                {
                    throw new ArgumentNullException("方便聯絡時段日期格式錯誤");
                }
            }

            if (!this.IsAgreement)
            {
                throw new ArgumentNullException("請勾選個人資料保護法告知說明事項");
            }

            #endregion

            #region call api insert data

            string resultCode = null;

            ExecuteResult executeResult = null;

            this.O2OServiceInstance.AddO2oPoolForRecall(
                this.ServiceChennal, this.ServiceType, this.CustomerId, this.CustomerName, this.CustomerPhone, this.IsAgreement ? "Y" : String.Empty, DateTime.Parse(this.ContactDate.Split(' ')[0]).Date, this.ContactDate.Split(' ')[1],
                ref resultCode, ref resultMessage, ref serviceCaseNo);

            if (resultCode != "1")
            {
                if (serviceCaseNo == "")
                {
                    serviceCaseNo = "19900101";
                }

                executeResult = ProcErrSendMail(resultMessage, serviceCaseNo);

                if (executeResult.Code != "00")
                {
                    throw new Exception(executeResult.Message);
                }

                throw new Exception(resultMessage);
            }

            #endregion

            #region send SMS

            if (this.CustomerPhone.StartsWith("09") && this.CustomerPhone.Length == 10)
            {
                string contentTemplate = this.GetSmsContentTemplate();

                if (String.IsNullOrEmpty(contentTemplate))
                {
                    throw new ArgumentNullException("取得簡訊樣板發生錯誤");
                }

                string msgContent = contentTemplate
                    .Replace("[@來電者姓名]", this.CustomerName)
                    .Replace("[@聯絡時間]", this.ConnectionTime_DropDownList.SelectedItem.Text);

                executeResult = this.NotificationServiceInstance.SendSMS(new SmsData
                {
                    PhoneNumber = this.CustomerPhone,
                    MsgContent = msgContent,
                    Timeout = "24",
                    ExtraInfo = new ExtraInfo
                    {
                        SysCode = "O2O-4",
                        SysDesc = "預約諮詢",
                        CaseNo = serviceCaseNo,
                        CustomerId = this.CustomerId,
                        CustomerName = this.CustomerName
                    }
                });

                if (executeResult.Code != "00")
                {
                    throw new Exception(executeResult.Message);
                }
            }

            #endregion

            this.Result_Label.ForeColor = System.Drawing.Color.Green;
            this.Result_Label.Text = "預約完成，我們將盡速與您聯絡，謝謝。";
            this.Submit_Button.Enabled = false;

        }
        catch (Exception)
        {
            //會產生驗證欄位也寄信
            //ProcErrSendMail(resultMessage, serviceCaseNo,"Exception");
            this.Result_Label.ForeColor = System.Drawing.Color.Red;
            this.Result_Label.Text = "預約失敗，建議您來電客服中心0809000550，謝謝。";
        }

    }


    #region 處理失敗後 寄信
    /// <summary>
    /// 寄失敗信
    /// </summary>
    /// <param name="ErrMsg"></param>
    /// <param name="srvCaseNo"></param>
    /// <returns></returns>
    public ExecuteResult ProcErrSendMail(string ErrMsg, string srvCaseNo, string Status = "Normal")
    {
        //聯絡窗口
        string SenderEMail = Convert.ToString(this.DbAccessInstance
            .GetDataScalar("select SMemo1 from tblSysCode where Stype='CT_Contact' and DeleteFlag='N' ;"));

        return this.NotificationServiceInstance.SendEmail(new EmailData
        {
            Subject = String.Format("客戶於「服務管道_預約諮詢」失敗，請儘速處理。{0}", DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss")),
            Content = getContentstr(Status, ErrMsg),
            FromEmail = SenderEMail,
            FromName = ConfigurationManager.AppSettings.Get("SenderName"),
            Recipients = this.GetEmailRecipients(),
            ExtraInfo = new ExtraInfo
            {
                SysCode = "O2O-4",
                SysDesc = "預約諮詢",
                CaseNo = srvCaseNo,
                CustomerId = this.CustomerId,
                CustomerName = this.CustomerName
            }
        });
    }

    /// <summary>
    /// eMail內容
    /// </summary>
    /// <param name="Status">顯示錯誤是一般產生或Exception</param>
    /// <returns></returns>
    public string getContentstr(string Status, string ErrMsg)
    {
        string sContent = string.Format(@" 
姓名：{0}
連絡電話：{1}
是否為富邦保戶：{2}
身分證字號：{3}
服務類型：{4}
方便聯絡時段：{5}
錯誤訊息：{6}
", GetPersonalMask(CustomerName_TextBox.Text, "*"), CustomerPhone_TextBox.Text
 , IsFubonCustomer ? "True" : "False", GetPersonalMask(CustomerId_TextBox.Text, "*"), ServiceType, ContactDate,ErrMsg );
        return sContent;
    }

    #region 資料遮罩 https://dotblogs.com.tw/kkman021/2014/05/14/145107
    static private string GetPersonalMask(string OriStr, string oPrefix, bool IsDis)
    {
        string oStr = "";
        OriStr = OriStr.Trim();
        char[] oStrArry = OriStr.ToCharArray();
        int[] oArray = new int[] { 0, OriStr.Trim().Length - 1 };
        if (Regex.IsMatch(OriStr.Trim(), @"^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$"))
        {
            oStr += GetPersonalMask(OriStr.Split('@')[0], oPrefix) + "@";
            for (int i = 0; i < OriStr.Split('@')[1].Split('.').Length; i++)
            {
                string oStrL = OriStr.Split('@')[1].Split('.')[i].ToString();
                if (i == 0)
                    oStr += GetPersonalMask(oStrL, oPrefix, false);
                else
                    oStr += "." + GetPersonalMask(oStrL, oPrefix, false);
            }
            return oStr;
        }
        else if (Regex.IsMatch(OriStr.Trim(), "^(09([0-9]){8})$"))
        {
            oArray = new int[] { 0, 1, 2, 7, 8, 9 };
        }
        else if (Regex.IsMatch(OriStr.Trim(), "^[a-zA-Z][0-9]{9}$"))
        {
            oArray = new int[] { 0, 1, 2, 3, 9 };
        }

        for (int i = 0; i < oStrArry.Length; i++)
        {
            if (IsDis)
                oStr += oArray.Contains(i) ? oStrArry[i].ToString() : oPrefix;
            else
                oStr += oArray.Contains(i) ? oPrefix : oStrArry[i].ToString();
        }
        return oStr;
    }
    static public string GetPersonalMask(string OriStr, string oPrefix)
    {
        return GetPersonalMask(OriStr, oPrefix, true);
    }
    #endregion


    #endregion


    /// <summary>
    /// 初始化控制項
    /// </summary>
    private void InitialControls()
    {
        this.LeaveMessage_HyperLink.NavigateUrl = this.GetLeaveMessageUrl();

        this.IsAgreement_HyperLink.NavigateUrl = this.GetPersonalDataNotificationUrl();

        this.InitialServiceType();

        this.InitialContactTime();
    }

    /// <summary>
    /// 初始化服務類型選單內容
    /// </summary>
    private void InitialServiceType()
    {
        ServiceType_DropDownList.Items.Add(new ListItem { Text = "請選擇", Value = String.Empty, Selected = true });

        DataTable dt = this.DbAccessInstance
            .GetDataTable("select code, sdesc from tblSysCode where Stype='CT_RegType' and DeleteFlag='N' order by smemo1;");

        foreach (DataRow row in dt.Rows)
        {
            ServiceType_DropDownList.Items.Add(new ListItem { Text = row.Field<string>("sdesc"), Value = row.Field<string>("code") });
        }
    }

    /// <summary>
    /// 初始化方便連絡時段選單內容
    /// </summary>
    private void InitialContactTime()
    {
        DateTime now = DateTime.Now;
        IFormatProvider culture = new CultureInfo("zh-TW", true);

        //20181109 herbert fix SMemo1存時間起迄 SMemo2改成人數
        DataTable contactTimeTable = this.DbAccessInstance
            .GetDataTable("select Code, sdesc as Text,substring(SMemo1,1,5) as StartTime,substring(SMemo1,7,5)  as EndTime, SMemo2 as Capacity from tblSysCode where Stype='CT_SC_App' and DeleteFlag='N' order by smemo1;");

        IEnumerable<string> workDayList = this.DbAccessInstance
            .GetDataTable(String.Format("select top 3 caldtime from cal where daytype='W' and caldtime > '{0}' order by caldtime;", now.Date.ToString("yyyy/MM/dd")))
            .AsEnumerable()
            .Select(x => x.Field<DateTime>("caldtime").ToString("yyyy/MM/dd"));

        List<ListItem> contactDateList = new List<ListItem>();
        int daysCount = 0;

        foreach (var workDay in workDayList)
        {
            if (daysCount == 2)
            {
                break;
            }

            bool isWorkDaySelected = false;

            foreach (DataRow row in contactTimeTable.Rows)
            {
                if (row.Field<string>("Text") == "皆可")
                {
                    continue;
                }

                string code = row.Field<string>("Code");
                string startTime = row.Field<string>("StartTime");
                string endTime = row.Field<string>("EndTime");

                DateTime target = DateTime.ParseExact(workDay + " " + startTime, "yyyy/MM/dd HH:mm", culture);

                if (target > now)
                {
                    string capacityString = row.Field<string>("Capacity");
                    int capacity;

                    if (!Int32.TryParse(capacityString, out capacity))
                    {
                        throw new ArgumentException("聯絡時段人數限制格式錯誤");
                    }

                    bool isContactTimeFull = this.IsContactTimeFull(capacity, target.Date, code);

                    contactDateList.Add(new ListItem
                    {
                        Text = String.Format("{0} {1}-{2}{3}", workDay, startTime, endTime, isContactTimeFull ? " (額滿)" : String.Empty),
                        Value = isContactTimeFull ? "disabled" : String.Format("{0} {1}", workDay, code)
                    });

                    isWorkDaySelected = true;
                }
            }

            if (isWorkDaySelected)
            {
                daysCount++;
            }
        }

        ConnectionTime_DropDownList.Items.Add(new ListItem { Text = "請選擇", Value = String.Empty, Selected = true });
        ConnectionTime_DropDownList.Items.AddRange(contactDateList.ToArray());
    }

    /// <summary>
    /// 取得「個人資料保護法告知說明 」連結位置
    /// </summary>
    /// <returns></returns>
    private string GetPersonalDataNotificationUrl()
    {
        return Convert.ToString(this.DbAccessInstance
            .GetDataScalar("select SMemo1 from tblSysCode where Stype='CT_URL' and DeleteFlag='N' and Code='1';"));
    }

    /// <summary>
    /// 取得「文字留言」連結位置
    /// </summary>
    /// <returns></returns>
    private string GetLeaveMessageUrl()
    {
        return Convert.ToString(this.DbAccessInstance
            .GetDataScalar("select SMemo1 from tblSysCode where Stype='CT_URL' and DeleteFlag='N' and Code='2';"));
    }

    /// <summary>
    /// 取得SMS簡訊內容樣板
    /// </summary>
    /// <returns></returns>
    private string GetSmsContentTemplate()
    {
        return this.DbAccessInstance
            .GetDataScalar("select prompt from TCaseRegSet r left join tblDocSet d on r.SMSNo1 = d.DocID where d.SYSID='CSWR' and d.DeleteFlag='N' and r.RegFrom='4'")
            .ToString();
    }

    /// <summary>
    /// 判斷預約時段是否額滿，額滿時傳回True；未額滿時傳回False。
    /// </summary>
    /// <param name="capacity">時段限制數</param>
    /// <param name="contactDate">預約日期</param>
    /// <param name="contactTimeCode">預約時段代碼</param>
    /// <returns></returns>
    private bool IsContactTimeFull(int capacity, DateTime contactDate, string contactTimeCode)
    {
        bool result = false;
        int dbCount;
        List<SqlParameter> parameters = new List<SqlParameter>
        {
            new SqlParameter{ ParameterName="RegFrom", Value = "4", SqlDbType = SqlDbType.NChar },
            new SqlParameter{ ParameterName="ConDate", Value = contactDate.Date, SqlDbType = SqlDbType.Date },
            new SqlParameter{ ParameterName="ConDT", Value = contactTimeCode, SqlDbType = SqlDbType.NChar }
        };

        string sql = "select count(TCaseNo) as count from TCasePool where RegFrom=@RegFrom and ConDate=@ConDate and ConDT=@ConDT;";
        string queryResult = Convert.ToString(this.DbAccessInstance.GetDataScalar(sql, parameters));

        if (Int32.TryParse(queryResult, out dbCount))
        {
            if (dbCount >= capacity)
            {
                result = true;
            }
        }

        return result;
    }

    /// <summary>
    /// 取得系統異常處理窗口
    /// </summary>
    /// <returns></returns>
    private string GetEmailRecipients()
    {
        List<string> result = new List<string>();

        DataTable recipients = this.DbAccessInstance
            .GetDataTable("select SMemo1,SMemo2,SMemo3 from tblSysCode where Stype='CT_Contact' and DeleteFlag='N';");

        if (!String.IsNullOrEmpty(recipients.Rows[0].Field<string>("SMemo1")))
        {
            result.Add(recipients.Rows[0].Field<string>("SMemo1"));
        }

        if (!String.IsNullOrEmpty(recipients.Rows[0].Field<string>("SMemo2")))
        {
            result.Add(recipients.Rows[0].Field<string>("SMemo2"));
        }

        if (!String.IsNullOrEmpty(recipients.Rows[0].Field<string>("SMemo3")))
        {
            result.Add(recipients.Rows[0].Field<string>("SMemo3"));
        }

        return String.Join(",", result);
    }

    /// <summary>
    /// 檢查是否符合身分證規則，符合時傳回True；不符合時傳回False。
    /// </summary>
    /// <param name="id">身分證字號</param>
    /// <returns></returns>
    private bool CheckId(string id)
    {
        bool result = true;

        if (id.Length == 10 && new Regex("^[A-Za-z]{1}[12]{1}").IsMatch(id))
        {
            string c = id.Substring(0, 1).ToLower();
            int index = "abcdefghjklmnpqrstuvwxyzio".IndexOf(c);
            string targetString = (index + 10).ToString() + id.Substring(1, 9);
            string targetTimes = "19876543211";
            int count = 0;

            for (int i = 0; i < 11; i++)
            {
                count += Int32.Parse(targetString.Substring(i, 1)) * Int32.Parse(targetTimes.Substring(i, 1));
            }

            if (count % 10 != 0)
            {
                result = false;
            }
        }

        return result;
    }

    #endregion


    //#region class

    ///// <summary>
    ///// 系統參數管理類別
    ///// </summary>
    //private class SystemCodeManager : BaseManager
    //{
    //    /// <summary>
    //    /// 取得系統參數
    //    /// </summary>
    //    /// <param name="condition">查詢條件</param>
    //    /// <returns></returns>
    //    public IEnumerable<SystemCodeEntity> GetList(Condition condition)
    //    {
    //        List<SystemCodeEntity> result = new List<SystemCodeEntity>();

    //        string sql = "select t2.Code,t2.SDesc,t2.SMemo1,t2.SMemo2,t2.SMemo3,t2.RecallDay from tblSysCode t1 inner join tblSysCode t2 on t1.Code = t2.Stype where t1.Stype='TCaseTYPE' ";
    //        List<string> whereConditionList = new List<string>();
    //        List<SqlParameter> sqlParameterList = new List<SqlParameter>();

    //        if (String.IsNullOrEmpty(condition.Key))
    //        {
    //            whereConditionList.Add("t1.SDesc=@SDesc");
    //            sqlParameterList.Add(new SqlParameter
    //            {
    //                SourceColumn = "@SDesc",
    //                SqlValue = condition.Key
    //            });
    //        }

    //        if (condition.IsDelete.HasValue)
    //        {
    //            whereConditionList.Add("t2.DeleteFlag=@DeleteFlag");
    //            sqlParameterList.Add(new SqlParameter
    //            {
    //                SourceColumn = "@DeleteFlag",
    //                SqlValue = condition.IsDelete.Value ? "Y" : "N"
    //            });
    //        }

    //        if (whereConditionList.Count > 0)
    //        {
    //            sql += String.Join(" and ", whereConditionList);
    //        }

    //        if (String.IsNullOrEmpty(condition.OrderBy))
    //        {
    //            sql += " order by" + condition.OrderBy;
    //        }

    //        return result;
    //    }
    //}

    ///// <summary>
    ///// 查詢條件類別
    ///// </summary>
    //private class Condition
    //{
    //    /// <summary>
    //    /// 查詢鍵值
    //    /// </summary>
    //    public string Key { get; set; }
    //    /// <summary>
    //    /// 是否刪除
    //    /// </summary>
    //    public bool? IsDelete { get; set; }
    //    /// <summary>
    //    /// 排序
    //    /// </summary>
    //    public string OrderBy { get; set; }
    //}

    ///// <summary>
    ///// 系統參數實體
    ///// </summary>
    //private class SystemCodeEntity
    //{
    //    /// <summary>
    //    /// 代碼
    //    /// </summary>
    //    public string Code { get; set; }
    //    /// <summary>
    //    /// 代碼說明
    //    /// </summary>
    //    public string Desc { get; set; }
    //    /// <summary>
    //    /// 代碼說明1
    //    /// </summary>
    //    public string Desc1 { get; set; }
    //    /// <summary>
    //    /// 代碼說明2
    //    /// </summary>
    //    public string Desc2 { get; set; }
    //    /// <summary>
    //    /// 代碼說明3
    //    /// </summary>
    //    public string Desc3 { get; set; }
    //    /// <summary>
    //    /// 代碼說明4
    //    /// </summary>
    //    public string Desc4 { get; set; }
    //}

    //private class BaseManager
    //{
    //    private DbAccess _dbAccess = null;

    //    /// <summary>
    //    /// 資料庫連線實體
    //    /// </summary>
    //    public DbAccess DbAccessInstance
    //    {
    //        get
    //        {
    //            if (_dbAccess == null)
    //            {
    //                _dbAccess = new DbAccess();
    //            }
    //            return _dbAccess;
    //        }
    //    }
    //}

    //#endregion

}