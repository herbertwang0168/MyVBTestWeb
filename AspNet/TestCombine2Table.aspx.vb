
Imports System.Data

Partial Class AspNet_TestCombine2Table
    Inherits System.Web.UI.Page



    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        If Page.IsPostBack = False Then '判斷是否第一次執行
            Dim dr As DataRow
            Dim dt1 As New DataTable
            dt1.Columns.Add("ID", GetType(Integer))
            dt1.Columns.Add("Name", GetType(String))
            dr = dt1.NewRow
            dr("ID") = 1
            dr("Name") = "Peter"
            dt1.Rows.Add(dr)

            dr = dt1.NewRow
            dr("ID") = 1
            dr("Name") = "Herbert"
            dt1.Rows.Add(dr)

            dr = dt1.NewRow
            dr("ID") = 2
            dr("Name") = "Anna"
            dt1.Rows.Add(dr)

            dr = dt1.NewRow
            dr("ID") = 3
            dr("Name") = "John"
            dt1.Rows.Add(dr)
            REM End Dt1

            REM Dt2
            Dim Dt2 As New DataTable
            Dt2.Columns.Add("ID", GetType(Integer))
            Dt2.Columns.Add("Name", GetType(String))
            Dt2.Columns.Add("YearOfBirth", GetType(Integer))
            Dt2.Columns.Add("data1", GetType(String))

            dr = Dt2.NewRow
            dr("ID") = 1
            dr("Name") = "Herbert"
            dr("YearOfBirth") = 1968
            dr("data1") = "Herbert"
            Dt2.Rows.Add(dr)

            dr = Dt2.NewRow
            dr("ID") = 1
            dr("Name") = "Peter"
            dr("YearOfBirth") = 1970
            dr("data1") = "Peter1"
            Dt2.Rows.Add(dr)

            dr = Dt2.NewRow
            dr("ID") = 1
            dr("Name") = "Peter"
            dr("YearOfBirth") = 1970
            dr("data1") = "Peter2"
            Dt2.Rows.Add(dr)

            dr = Dt2.NewRow
            dr("ID") = 2
            dr("Name") = "Anna"
            dr("YearOfBirth") = 1980
            Dt2.Rows.Add(dr)
            REM End Dt2

            Dim Dt3 As New DataTable


            Dim JoinedDT As New DataTable
            JoinedDT.Columns.Add("ID", GetType(Integer))
            JoinedDT.Columns.Add("Name", GetType(String))
            JoinedDT.Columns.Add("YearOfBirth", GetType(Integer))
            JoinedDT.Columns.Add("data1", GetType(String))
            ' other stuff

            Dim query As IEnumerable(Of DataRow) = (From dr1 In dt1.AsEnumerable()
                                                    Group Join dr2 In Dt2.AsEnumerable()
                                                    On dr1.Field(Of Integer)("ID") Equals dr2.Field(Of Integer)("ID") And
                                                        dr1.Field(Of String)("Name") Equals dr2.Field(Of String)("Name")
                                                    Into joined = Group
                                                    From j In joined.DefaultIfEmpty()
                                                    Where dr1.Field(Of Integer)("ID") = 1
                                                    Select New With
                                                    {
                                                        .ID = dr1.Field(Of Integer)("ID"),
                                                        .Name = dr1.Field(Of String)("Name"),
                                                        .YearOfBirth = If(j IsNot Nothing, j.Field(Of Integer)("YearOfBirth"), 0),
                                                        .data1 = If(j IsNot Nothing, j.Field(Of String)("data1"), "")
                                                    }).Select(Function(r)
                                                                  ' use `DataTable.NewRow` here
                                                                  Dim row As DataRow = JoinedDT.NewRow()
                                                                  row("ID") = r.ID
                                                                  row("Name") = r.Name
                                                                  row("YearOfBirth") = r.YearOfBirth
                                                                  row("data1") = r.data1
                                                                  Return row
                                                              End Function)

            Dt3 = query.CopyToDataTable()





        End If

    End Sub













End Class
