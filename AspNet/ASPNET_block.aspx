<%@ Page Title="" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false"
    CodeFile="ASPNET_block.aspx.vb" Inherits="AspNet_ASPNET_block" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="Server">
    <asp:UpdatePanel ID="btnRegin" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Button ID="btnTest" runat="server" Text="Button"  />
            <input type="button" id="btnTest2" value="Button2" onclick="busyBox.Show();alert('testxxx');" />
            <br />
            <br />
            <br />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnTest" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
</asp:Content>
