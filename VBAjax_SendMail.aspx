<%@ Page Language="VB" AutoEventWireup="false" CodeFile="VBAjax_SendMail.aspx.vb"
    Inherits="VBAjax_SendMail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1" />
    <meta http-equiv="X-UA-Compatible" content="IE=9" />
    <title></title>
    <link href="Styles/css/bootstrap.css" rel="stylesheet" type="text/css" />
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
  <script src="http://apps.bdimg.com/libs/html5shiv/3.7/html5shiv.min.js"></script>
  <script src="http://apps.bdimg.com/libs/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
    <script src="Scripts/jquery-2.2.4.min.js" type="text/javascript"></script>
    <script src="Scripts/js/bootstrap.js" type="text/javascript"></script>
    <script src="Scripts/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $('#winopen').click(function () {
                window.open('default.aspx', '', config = 'height=450,width=450,toolbar=no');
                window.open('', '_self', ''); //不會出現 確認視窗關閉
                window.close();
            });



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
    <div class="container">
        <asp:Button ID="winopen" class="btn-default" runat="server" Text="打開後關閉" />
    </div>
    </form>
</body>
</html>
