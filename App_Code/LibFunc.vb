Imports Microsoft.VisualBasic
Imports System.Data

Public Class LibFunc


    ''' <summary>
    ''' List To datatable
    ''' </summary>
    ''' <typeparam name="t"></typeparam>
    ''' <param name="list"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function ConvertToDataTable(Of t)(
                                                  ByVal list As IList(Of t)
                                               ) As DataTable
        Dim table As New DataTable()
        If Not list.Any Then
            'don't know schema ....
            Return table
        End If
        Dim fields() = list.First.GetType.GetProperties
        For Each field In fields
            table.Columns.Add(field.Name, field.PropertyType)
        Next
        For Each item In list
            Dim row As DataRow = table.NewRow()
            For Each field In fields
                Dim p = item.GetType.GetProperty(field.Name)
                row(field.Name) = p.GetValue(item, Nothing)
            Next
            table.Rows.Add(row)
        Next
        Return table
    End Function
End Class
