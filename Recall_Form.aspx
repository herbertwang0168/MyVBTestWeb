<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Recall_Form.aspx.cs" Inherits="_Recall_Form" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>富邦人壽預約諮詢服務</title>
    <link type="text/css" href="Content/bootstrap.min.css" rel="stylesheet" />
    <style type="text/css">
        form
        {
            font-family: Microsoft JhengHei, Calibri, sans-serif;
        }
        
        form label
        {
            font-size: medium;
            margin-bottom: 3px;
        }
        
        .form-group-sm
        {
            margin-bottom: 10px;
        }
        
        input[type="checkbox"]
        {
            vertical-align: text-top;
            cursor: pointer;
        }
        
        input[type="radio"]
        {
            display: none;
        }
        
        input[type="radio"] + label
        {
            margin: 0px;
            padding: 0px;
            width: 15px;
            height: 15px;
            border-radius: 100%;
            border: 2px solid lightgray;
            cursor: pointer;
        }
        
        input[type="radio"]:checked + label
        {
            border: 4px solid orange;
            cursor: pointer;
        }
        
        .error
        {
            border-color: red;
        }
        
        .errorLabel
        {
            color: red;
        }
        
        .tooltip > .tooltip-inner
        {
            background-color: white;
            color: red;
            border: 1px solid red;
            padding: 5px;
            font-size: small;
            text-align: left;
        }
        
        .tooltip.right > .tooltip-arrow
        {
            border-right: 5px solid red;
        }
    </style>
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <script src="Scripts/jquery.validate.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script>

        var messages = {
            'nameError': '請填寫您的姓名',
            'phoneError': '請填寫聯絡電話',
            'phoneFormatError': '聯絡電話格式不正確，請重新輸入',
            'isCustError': '請選擇是否為富邦保戶',
            'idRequiredError': '富邦保戶請填寫身分證字號或護照號碼',
            'idFormatError': '身分證字號或護照號碼格式不正確，請重新輸入',
            'serviceTypeError': '請選擇您需要的服務類型',
            'contactTimeError': '請選擇您方便的聯絡時段',
            'personalDataError': '請勾選個人資料保戶法告知說明事項',
            'generalError': '請注意必填欄位尚未填寫完成'
        };

        $(function () {

            $('#ConnectionTime_DropDownList option[value=disabled]').prop('disabled', true);

            $('#Submit_Button').on('click', function () {

                var errorMsgList = [];
                var name = document.getElementById('CustomerName_TextBox').value;
                var phone = document.getElementById('CustomerPhone_TextBox').value;
                var custId = document.getElementById('CustomerId_TextBox').value;

                if (name === "") {
                    errorMsgList.push(messages['nameError']);
                    document.getElementById('CustomerName_TextBox').classList.add('error');
                    $('label[for=CustomerName_TextBox]').addClass('errorLabel');
                }
                else {
                    document.getElementById('CustomerName_TextBox').classList.remove('error');
                    $('label[for=CustomerName_TextBox]').removeClass('errorLabel');
                }

                if (phone === "") {
                    errorMsgList.push(messages['phoneError']);
                    document.getElementById('CustomerPhone_TextBox').classList.add('error');
                    $('label[for=CustomerPhone_TextBox]').addClass('errorLabel');
                }
                else if (phone.substr(0, 2) === "09" && phone.length != 10) {
                    errorMsgList.push(messages['phoneFormatError']);
                    document.getElementById('CustomerPhone_TextBox').classList.add('error');
                    $('label[for=CustomerPhone_TextBox]').addClass('errorLabel');
                }
                else {
                    document.getElementById('CustomerPhone_TextBox').classList.remove('error');
                    $('label[for=CustomerPhone_TextBox]').removeClass('errorLabel');
                }

                if (!document.getElementById('IsFubonCustomer_RadioButton').checked && !document.getElementById('NotFubonCustomer_RadioButton').checked) {
                    errorMsgList.push(messages['isCustError']);
                    $('label[for=IsFubonCustomer]').addClass('errorLabel');
                    $('label[for=IsFubonCustomer_RadioButton]').addClass('errorLabel');
                    $('label[for=NotFubonCustomer_RadioButton]').addClass('errorLabel');
                }
                else {
                    $('label[for=IsFubonCustomer]').removeClass('errorLabel');
                    $('label[for=IsFubonCustomer_RadioButton]').removeClass('errorLabel');
                    $('label[for=NotFubonCustomer_RadioButton]').removeClass('errorLabel');
                }

                if (document.getElementById('IsFubonCustomer_RadioButton').checked) {
                    if (custId === "") {
                        errorMsgList.push(messages['idRequiredError']);
                        document.getElementById('CustomerId_TextBox').classList.add('error');
                    }
                    else if (!validateId(custId)) {
                        errorMsgList.push(messages['idFormatError']);
                        document.getElementById('CustomerId_TextBox').classList.add('error');
                    }
                    else {
                        document.getElementById('CustomerId_TextBox').classList.remove('error');
                    }
                }
                else {
                    document.getElementById('CustomerId_TextBox').classList.remove('error');
                }

                if (document.getElementById('ServiceType_DropDownList').value === "") {
                    errorMsgList.push(messages['serviceTypeError']);
                    document.getElementById('ServiceType_DropDownList').classList.add('error');
                    $('label[for=ServiceType_DropDownList]').addClass('errorLabel');
                }
                else {
                    document.getElementById('ServiceType_DropDownList').classList.remove('error');
                    $('label[for=ServiceType_DropDownList]').removeClass('errorLabel');
                }

                if (document.getElementById('ConnectionTime_DropDownList').value === "") {
                    errorMsgList.push(messages['contactTimeError']);
                    document.getElementById('ConnectionTime_DropDownList').classList.add('error');
                    $('label[for=ConnectionTime_DropDownList]').addClass('errorLabel');
                }
                else {
                    document.getElementById('ConnectionTime_DropDownList').classList.remove('error');
                    $('label[for=ConnectionTime_DropDownList]').removeClass('errorLabel');
                }

                if (!document.getElementById('IsAgreement_CheckBox').checked) {
                    errorMsgList.push(messages['personalDataError']);
                    $('label[for=IsAgreement_CheckBox]').css('color', 'red');
                }
                else {
                    $('label[for=IsAgreement_CheckBox]').css('color', '#474747');
                }

                if (errorMsgList.length !== 0) {
                    if (errorMsgList.length === 1) {
                        //$(this).data('title', errorMsgList[0]).tooltip({ container: 'body' }).tooltip('show');
                        $("#Result_Label").css('color', 'red').text(errorMsgList[0]);
                    }
                    else {
                        //$(this).data('title', messages['generalError']).tooltip({ container: 'body' }).tooltip('show');
                        $("#Result_Label").css('color', 'red').text(messages['generalError']);
                    }
                    return false;
                }
            });

        });

        // 驗證身分證字號
        function validateId(id) {
            var result = true;

            if (id !== "" && id.length === 10 && /^[A-Za-z]{1}[12]{1}/.test(id)) {
                var c = id.substring(0, 1).toLowerCase();
                var index = "abcdefghjklmnpqrstuvwxyzio".indexOf(c);
                var targetString = (index + 10) + id.substr(1, 9);
                var targetTimes = "19876543211";
                var count = 0;

                for (var i = 0; i < 11; i++) {
                    count += (targetString.substr(i, 1) * targetTimes.substr(i, 1));
                }

                if (count % 10 !== 0) {
                    result = false;
                }
            }

            return result;
        }

        //當request(SC)=null
        function goto() {
            alert('此網頁功能關閉，若您有需要預約回電，\n敬請由富邦人壽官網或保戶會員專區登入，\n請稍候，將為您導入富邦人壽官網。');
            window.open('https://www.fubon.com/life/home/index.htm', '_blank', '');
            window.opener = null;
            window.close();
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="container">
        <div class="row">
            <div class="col-sm-3">
            </div>
            <div class="col-sm-6">
                <div class="row">
                    <div class="col-sm-12">
                        <div style="text-align: center;">
                            <h1 style="color: #0088D1; font-weight: bold;">
                                預約回電</h1>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div style="background-color: lightgray; border-radius: 10px; padding: 15px; margin-bottom: 10px;">
                            <span style="color: #474747; font-size: small;">● 無法立刻拿起電話的客戶，您預約、我回電，請填寫下方資料。<br />
                                ● 想文字留言，放棄預約回電，點選
                                <asp:HyperLink ID="LeaveMessage_HyperLink" runat="server" Target="_blank">前往文字留言</asp:HyperLink>。
                            </span>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-8">
                        <div class="form-group-sm">
                            <div>
                                <label for="CustomerName_TextBox">
                                    姓名</label>
                                <span style="color: red;">*</span>
                                <br />
                                <asp:TextBox ID="CustomerName_TextBox" runat="server" CssClass="form-control" data-toggle="tooltip"
                                    data-placement="right"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group-sm">
                            <div>
                                <label for="CustomerPhone_TextBox">
                                    連絡電話</label>
                                <span style="color: red;">*</span> <span style="color: #474747; font-size: xx-small;">
                                    &nbsp;&nbsp;範例：0912345678 / 02-22123456</span>
                                <br />
                                <asp:TextBox ID="CustomerPhone_TextBox" runat="server" CssClass="form-control" placeholder="請以手機號碼為主"
                                    data-toggle="tooltip" data-placement="right"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group-sm">
                            <div class="row">
                                <div class="col-sm-12">
                                    <label for="IsFubonCustomer">
                                        是否為富邦保戶</label>
                                    <span style="color: red;">*</span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <div style="width: 15%; float: left; padding-top: 3px;">
                                        <asp:RadioButton ID="IsFubonCustomer_RadioButton" runat="server" GroupName="IsFubonCustomer"
                                            value="Y" />
                                        <label for="IsFubonCustomer_RadioButton">
                                        </label>
                                        <label for="IsFubonCustomer_RadioButton" style="vertical-align: text-bottom; margin-bottom: 0px;">
                                            是</label>
                                    </div>
                                    <div style="width: 85%; float: left;">
                                        <asp:TextBox ID="CustomerId_TextBox" runat="server" CssClass="form-control" placeholder="請填寫身分證字號，外籍身分請填寫護照號碼。"
                                            data-toggle="tooltip" data-placement="right"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <asp:RadioButton ID="NotFubonCustomer_RadioButton" runat="server" GroupName="IsFubonCustomer"
                                        value="N" />
                                    <label for="NotFubonCustomer_RadioButton">
                                    </label>
                                    <label for="NotFubonCustomer_RadioButton" style="vertical-align: text-bottom; margin-bottom: 0px;">
                                        否</label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group-sm">
                            <div>
                                <label for="ServiceType_DropDownList">
                                    服務類型</label>
                                <span style="color: red;">*</span>
                                <br />
                                <asp:DropDownList ID="ServiceType_DropDownList" runat="server" CssClass="form-control"
                                    data-toggle="tooltip" data-placement="right">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="form-group-sm">
                            <div>
                                <label for="ConnectionTime_DropDownList">
                                    方便聯絡時段</label>
                                <span style="color: red;">*</span>
                                <br />
                                <asp:DropDownList ID="ConnectionTime_DropDownList" runat="server" CssClass="form-control"
                                    data-toggle="tooltip" data-placement="right">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="form-group-sm">
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div style="text-align: right;">
                            <span style="color: #474747; font-size: xx-small;">* 為必填欄位</span>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div style="margin-bottom: 10px;">
                            <asp:CheckBox ID="IsAgreement_CheckBox" runat="server" />
                            <label for="IsAgreement_CheckBox" style="color: #474747; font-size: small;">
                                我已詳細閱讀並同意Fubon.com「
                                <asp:HyperLink ID="IsAgreement_HyperLink" runat="server" Target="_blank">個人資料保護法告知說明</asp:HyperLink>
                                」事項。
                            </label>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12" style="text-align: center;">
                        <div style="float: left; width: 39%;">
                            &nbsp;</div>
                        <div style="float: left; width: 22%;">
                            <asp:LinkButton ID="Submit_Button" runat="server" CssClass="btn btn-primary" OnClick="Submit_Button_Click"
                                data-toggle="tooltip" data-placement="right">
                                送出
                                <i class="glyphicon glyphicon-chevron-right" aria-hidden="true"></i>
                            </asp:LinkButton>
                        </div>
                        <div style="float: left; width: 39%; text-align: left;">
                            <asp:Label ID="Result_Label" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-3">
            </div>
        </div>
    </div>
    </form>
</body>
</html>
