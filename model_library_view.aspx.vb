Imports System.Collections.Generic
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
    Public userDetails, str, comboStr, titleStr, type As String


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
        If Not IsPostBack Then


        End If


        Page.DataBind()
        Try
            con.Close()
        Catch ex As Exception

        End Try

    End Sub


End Class
