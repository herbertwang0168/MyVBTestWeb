<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Main.master" CodeFile="BootstrapTest.aspx.vb"
    Inherits="BootstrapTest" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="head">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div class="container panel-default">
        <div class="row">
            <header class="col-md-12">
    頁首
    </header>
        </div>
        <div class="row">
            <div class="col-md-offset-4-col-md-4">
                1/3
            </div>
            <div class="col-md-4">
                1/3
            </div>
        </div>
    </div>
    <div>
        測試 頁首
    </div>
    <div>
        test
    </div>
    <div class="container col-md-6">
        <asp:Button ID="Button1" class="btn-default" runat="server" Text="Button" />
        <asp:Button ID="Button2" class="btn-primary" runat="server" Text="Button" />
        <asp:Button ID="Button3" class="btn-success" runat="server" Text="Button" />
        <asp:Button ID="Button4" class="btn btn-info btn-sm" runat="server" Text="Button" />
        <asp:Button ID="Button5" class="btn-warning" runat="server" Text="Button" />
        <asp:Button ID="Button6" class="btn-danger" runat="server" Text="Button" />
        <asp:Button ID="Button7" class="btn-link" runat="server" Text="Button" />
        <button type="button" class="btn btn-primary btn-lg">
            Large</button>
        <button type="button" class="btn btn-primary btn-md">
            Medium</button>
        <button type="button" class="btn btn-primary btn-sm">
            Small</button>
        <button type="button" class="btn btn-primary btn-xs">
            XSmall</button>
    </div>
    <div class="container">
        <div class="input-group">
            <span class="input-group-btn">
                <button class="btn btn-success" type="button">
                    搜尋
                </button>
            </span>
            <input type="text" class="form-control" placeholder="請輸入頁面標題" />
        </div>
    </div>
    <div class="panel panel-default rounded" style="border: 1px solid red;">
        <div class="panel-body">
            这是一个基本的面板
        </div>
    </div>
    <table class="table table-striped">
        <tr>
            <td>
                Jill
            </td>
            <td>
                Smith
            </td>
            <td>
                50
            </td>
        </tr>
        <tr>
            <td>
                Eve
            </td>
            <td>
                Jackson
            </td>
            <td>
                94
            </td>
        </tr>
    </table>
</asp:Content>
