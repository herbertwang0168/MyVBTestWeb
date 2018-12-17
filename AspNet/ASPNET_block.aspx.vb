
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




Public Class KnowledgeExpandFunc : Implements IHttpHandler

    Dim ConnString As String = WebConfigurationManager.ConnectionStrings("ConnString").ConnectionString
    Dim sWebUrl As String = System.Web.Configuration.WebConfigurationManager.AppSettings("KMWebURL")

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim str As String = context.Request("QTitle")
        Dim sParam As String = context.Request("Param")
        sParam = IIf(sParam = "", "1", sParam)
        Dim rtnStr As String = ""


        Try
            If str.Trim() <> "" And Not InStr(str, "'") > 0 Then
                Dim sqlstr As String = "declare @QTitle varchar(100); " & _
                   "set @QTitle = '{0}' " & _
                   "SELECT Top (5) iCUItem ,topCat ,sTitle ,vGroup,xPostDate,siteId,B.id_count,C.mValue " & _
                   "FROM ( " & _
                   "  SELECT iCUItem,topCat,sTitle,vGroup,xPostDate,siteId FROM CuDTGeneric " & _
                   "  INNER JOIN KnowledgeForum ON CuDTGeneric.iCUItem = KnowledgeForum.gicuitem and (KnowledgeForum.status = 'N')  " & _
                   "  Where CuDTGeneric.fCTUPublic='Y' and siteId='3' and iCTUnit=932 " & _
                   "  ) A  LEFT JOIN (  " & _
                   "    select REPORT_ID,count(REPORT_ID) As id_count FROM coa.dbo.REPORT_KEYWORD_FREQUENCY " & _
                   "    where Keyword in " & _
                   "   ( " & _
                   "     SELECT distinct Keyword FROM coa.dbo.REPORT_KEYWORD_FREQUENCY " & _
                   "     where NOT KEYWORD IN " & _
                   "     ( " & _
                   "       select top 1 KEYWORD from coa.dbo.REPORT_KEYWORD_FREQUENCY GROUP BY KEYWORD ORDER BY COUNT(*) DESC " & _
                   "     ) " & _
                   "     AND exists " & _
                   "     ( " & _
                   "       SELECT STITLE FROM CUDTGENERIC WHERE ( @QTitle LIKE '%' + KEYWORD + '%' ) " & _
                   "     ) " & _
                   "   ) " & _
                   "  AND exists ( " & _
                   "     SELECT STITLE FROM CUDTGENERIC WHERE ICUITEM=coa.dbo.REPORT_KEYWORD_FREQUENCY.REPORT_ID and ( STITLE LIKE '%' + KEYWORD + '%' or xbody LIKE '%' + KEYWORD + '%' ) " & _
                   "  ) " & _
                   "  group by REPORT_ID" & _
                   " )B ON A.iCUITem = B.REPORT_ID LEFT JOIN  " & _
                   " ( select mValue,mCode from CodeMain where codeMetaID = 'KnowledgeType' " & _
                   " )C on A.topCat = C.mCode " & _
                   " where NOT B.REPORT_ID IS NULL  order by id_count desc , xPostDate desc" & _
                   ""

                sqlstr = String.Format(sqlstr, str)

                Using myReader As SqlDataReader = SqlHelper.ReturnReader("ODBCDSN", sqlstr)
                    If myReader.Read Then

                        While myReader.Read()
                            If sParam = "1" Then '電腦版
                                rtnStr = rtnStr & "<li class=""knowledge-content-list""><a href=""" & sWebUrl & "/knowledge/knowledge_cp.aspx?ArticleId=" & myReader("iCUItem") & "&ArticleType=" & myReader("topCat") & "&CategoryId=&kpi=0&dateS=&dateE="" target=""_blank"">" & myReader("sTitle") & "</a></li>"
                            ElseIf sParam = "2" Then '行動版
                                rtnStr = rtnStr & "<li><a href=""" & sWebUrl & "/knowledge/knowledge_cp.aspx?ArticleId=" & myReader("iCUItem") & "&ArticleType=" & myReader("topCat") & "&CategoryId=&kpi=0&dateS=&dateE="" target=""_blank"">" & myReader("sTitle") & "</a></li>"
                            End If
                        End While

                    End If
                    If rtnStr <> "" And sParam = "2" Then
                        rtnStr = "<ul style=""list-style-type:disc;color:#2F7F7F;"">" & rtnStr & "</ul>"
                    End If
                End Using

                'If Not myReader.IsClosed Then myReader.Close()

            End If

            rtnStr = "<div class=""knowledge-content""><span>相關知識</span><p>發現相似問題！！請點選觀看，避免重複發問，謝謝！</p><ul class=""knowledge-content-menu"">" & _
                rtnStr & _
                "</ul><div class=""knowledge-content-bottom""><div class=""bottom-blackboard""></div><div class=""left-book""></div><div class=""right-book""></div></div></div>"
            '<ul style=""color:#5CB3E2;"">相關知識</ul><ul>發現相似問題！！請點選觀看，避免重複發問，謝謝！" & rtnStr & "</ul>"
        Catch ex As Exception
            rtnStr = ex.Message
        End Try



        context.Response.ContentType = "text/plain"
        context.Response.Write(rtnStr)
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
