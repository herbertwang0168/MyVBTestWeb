<%@ Page Language="VB" AutoEventWireup="false" CodeFile="BootstrapTest2.aspx.vb"
    Inherits="BootstrapTest2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1" />
    <meta http-equiv="X-UA-Compatible" content="IE=9" />
    <title></title>
    <link href="..//Styles/css/bootstrap.css" rel="stylesheet" type="text/css" />
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
  <script src="http://apps.bdimg.com/libs/html5shiv/3.7/html5shiv.min.js"></script>
  <script src="http://apps.bdimg.com/libs/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
    <script src="../Scripts/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="../Scripts/js/bootstrap.js" type="text/javascript"></script>
    <style>
    .uppercase
{
    text-transform: uppercase;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="container">
        test
        <asp:TextBox ID="TextBox3" runat="server" ></asp:TextBox>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <textarea id="TextArea1" cols="20" rows="2" ></textarea>
        <asp:TextBox ID="TextBox1" runat="server" onkeydown="this.value=this.value.toUpperCase();" onchange="javascript: callchange(this);" onblur="javascript: callblur(this);"></asp:TextBox>
        <asp:Button ID="Button1" runat="server" Text="Button" />
        <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
        <asp:TextBox ID="TextBox2" runat="server" onblur="javascript: getTest(this);" Text="xxxvvv"></asp:TextBox>
    </div>
    </form>
</body>
</html>
<script type="text/javascript">
    //            var txt = document.getElementById("TextBox3");
    //            txt.addEventListener('onkeyup', toupperword(txt));
    //            function toupperword(txt) {
    //                txt.value = txt.value.toUpperCase();
    //                return true;
    //            }
    function getTest(ctl) {
        //            debugger;
        //            document.getElementById("TextBox1").value = "123";
        //            console.log(ctl.value);
    }
    function callblur(res) {
        alert('blur:' + res.value);
        return true;
    }

    function callchange(res) {
        alert('change:' + res.value);
        return true;
    }
        
</script>
<script type="text/javascript">
// <![CDATA[
//        $(function () {

//            $("#TextBox3").keyup(function (e) {
//                var str = $(this).val();
//                str = str.toUpperCase();
//                $(this).val(str);
//            });
//        });
//        var textarea = document.getElementById('TextBox3');
//        textarea.addEventListener('keyup',toUpperWord );
//        function toUpperWord(){
//            textarea.value = textarea.value.toUpperCase();
//        }
// ]]>
</script>
