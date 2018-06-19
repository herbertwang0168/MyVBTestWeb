
Partial Class AspNet_ASPNET_block
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        If Page.IsPostBack = False Then '判斷是否第一次執行



        End If

    End Sub

    Protected Sub btnTest_Click(sender As Object, e As System.EventArgs) Handles btnTest.Click
        System.Threading.Thread.Sleep(5000)
    End Sub
End Class
