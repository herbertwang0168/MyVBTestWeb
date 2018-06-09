Imports System.Web.Services

Partial Class VBAjax_SendMail
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load




    End Sub

    Protected Sub SendMail_Click(sender As Object, e As System.EventArgs) Handles SendMail.Click
        Dim str As String = ""
    End Sub


    <WebMethod()>
    Public Shared Function TestAjax(strBody As String) As String

        Dim selectedProduct As String = String.Format("{0}", strBody)

        System.Threading.Thread.Sleep(5000)


        HttpContext.Current.Session("test") = selectedProduct

        Return HttpContext.Current.Session("test").ToString()

    End Function



End Class
