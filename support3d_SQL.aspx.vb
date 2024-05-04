Imports System.Collections.Generic
Imports System.IO
Imports System.Net
Imports System.Drawing
Imports System.Data.OleDb

Partial Class user_logout
    Inherits System.Web.UI.Page

    Dim con As New Data.OleDb.OleDbConnection
    Dim com As New Data.OleDb.OleDbCommand
    Dim dr As Data.OleDb.OleDbDataReader
    Dim com1 As New Data.OleDb.OleDbCommand
    Dim dr1 As Data.OleDb.OleDbDataReader
    Dim com2 As New Data.OleDb.OleDbCommand
    Dim dr2 As Data.OleDb.OleDbDataReader
    Dim com3 As New Data.OleDb.OleDbCommand
    Dim dr3 As Data.OleDb.OleDbDataReader
    'User
   
    Public userDetails, str, comboStr, titleStr, type, scriptStr, script As String


    Function connectDbAndSessions() As Boolean

        Try
            Dim ConnString As String = ConfigurationManager.ConnectionStrings("ConnectionString").ConnectionString
            con = New OleDbConnection(ConnString)
            con.Open()
            com = New OleDbCommand()

            Return True
        Catch ex As Exception
            Response.Write("Master DB : " & ex.Message)
            Return False
        End Try

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        'Connect Database Master
        If connectDbAndSessions() = False Then
            Response.Write("System Error: Unable to connect server. Please try after sometime.")
            Exit Sub
        End If

       

        Dim flag As Integer = Request.QueryString("flag")

        Select Case flag
            Case 1
              
            Case 2
               

            Case 3
               
            Case 39
                Response.Write("obj=[")
                Try
                    com.CommandText = "select * from cms_3d_library"
                    com.Connection = con
                    dr = com.ExecuteReader
                    While dr.Read
                        Response.Write("{id:" & dr("library_id") & ",ttl:'" & dr("title") & "'},")
                    End While
                    dr.Close()
                Catch ex As Exception
                    Response.Write(ex.ToString)
                End Try
                Response.Write("];")
            Case Else

        End Select

        Page.DataBind()
        Try
            con.Close()
        Catch ex As Exception

        End Try
    End Sub
    
    
End Class
