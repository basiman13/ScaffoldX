
Partial Class ViewModel
    Inherits System.Web.UI.Page

    Public libId As Integer
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Try
            libId = Request.QueryString("libid")
        Catch ex As Exception

        End Try

    End Sub
End Class
