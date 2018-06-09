<%@ Page Language="VB" AutoEventWireup="false" CodeFile="VBAjax_SendMail.aspx.vb"
    Inherits="VBAjax_SendMail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Scripts/JqueryAll/jquery-1.12.4.js" type="text/javascript"></script>
    <script src="Scripts/JqueryAll/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#SendMail').click(function () {
//                debugger;
                $.blockUI();
                var email = $("#txtMail").val();
                var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;

                if (!regex.test(email)) {
                    alert('請輸入eamil');
                    $.unblockUI();
                    return false;
                }




                var str = $("#BodyStr").html();
                var result = $.ajax({
                    type: "POST",
                    url: "VBAjax_SendMail.aspx/TestAjax",
                    data: '{ strBody: "' + str + '" }',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: succeeded,
                    failure: function (msg) {
                        alert(msg);
                    },
                    error: function (xhr, err) {
                        alert(err);
                    }
                });
            });

            //            //'{ strBody: "1833", qty: "13", lblType: "1" }',
        })

        function succeeded(msg) {
            //            debugger;
            $.unblockUI();
            alert(msg.d);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="BodyStr">
        <h1>
            test vvv
        </h1>
    </div>
    <asp:TextBox ID="txtMail" runat="server"></asp:TextBox>
    <asp:Button ID="SendMail" runat="server" Text="AjaxSendMail" />
    </form>
</body>
</html>
