Imports System.Net.NetworkInformation
Imports System.Net
Imports System.Threading
Imports System.IO
Imports System.Web.Services
Imports System.Configuration
Imports System.Text
Imports System.Net.Mail
Imports System.Data
Imports System.Web.Script.Serialization
Imports System.Data.OleDb

Partial Class BIM_project_bim_view
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

    Public userId As Integer
    Public userFullName As String
    Public userEmail As String
    Public userKey As String
    Dim isUserValidated As Boolean
    Public userDetails, str, script As String
    Public enterpriseId, projectId, mid As Integer
    'model

    Public Token, model_urn As String

    Public flag, autolink_flag As Integer

    Public sid, lid, boqid, boqspec, discipline, pour, libId, isupdate As Integer

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

        'Get user Id
        Try
            userId = 0
            userId = Request.QueryString("uid")
        Catch ex As Exception
            userId = 0
        End Try

        'Get enterprice Id
        Try
            enterpriseId = 0
            enterpriseId = Request.QueryString("eid")
        Catch ex As Exception
            enterpriseId = 0
        End Try

        'Get project Id
        Try
            projectId = 0
            projectId = Request.QueryString("pid")
        Catch ex As Exception
            projectId = 0
        End Try

        'Get Flag

        Try
            flag = 0
            flag = Request.QueryString("flag")
        Catch ex As Exception
            flag = 0
        End Try

        Try
            libId = Request.QueryString("libid")
        Catch ex As Exception
            libId = 0
        End Try
        Try
            isupdate = Request.QueryString("isupdate")
        Catch ex As Exception
            isupdate = 0
        End Try
        'Get Autolink Flag
        Try
            autolink_flag = Request.QueryString("autolink")
        Catch ex As Exception
            autolink_flag = 0
        End Try

        'Get user info

      


        Get_acess_Token()
        Get_Model_Urn()

        If flag = 1 And isupdate = 0 Then
            Delete_All_Objects()
        End If


        Page.DataBind()
        Try
            con.Close()
        Catch ex As Exception

        End Try
    End Sub

    Public Sub Get_acess_Token()
        'Dim ser As JavaScriptSerializer = New JavaScriptSerializer
        'Dim json As String = (New WebClient).DownloadString("https://suspensible-stone.000webhostapp.com/GetAcessToken.php")
        'Dim tokenKey As ProjectToken = New ProjectToken
        'tokenKey = ser.Deserialize(Of ProjectToken)(json)
        'Token = tokenKey.access_token


        Dim client_id = ConfigurationManager.AppSettings("Client_ID")
        Dim client_secret = ConfigurationManager.AppSettings("Client_Secret")

        Dim ser As JavaScriptSerializer = New JavaScriptSerializer
        ServicePointManager.SecurityProtocol = 3072
        Dim s As HttpWebRequest
        Dim enc As UTF8Encoding
        Dim postdata As String
        Dim postdatabytes As Byte()
        s = HttpWebRequest.Create("https://developer.api.autodesk.com/authentication/v1/authenticate")
        enc = New System.Text.UTF8Encoding()
        postdata = "client_id=" & client_id & "&client_secret=" & client_secret & "&grant_type=client_credentials&scope=data:read"
        postdatabytes = enc.GetBytes(postdata)
        s.Method = "POST"
        s.ContentType = "application/x-www-form-urlencoded"
        s.ContentLength = postdatabytes.Length

        Using stream = s.GetRequestStream()
            stream.Write(postdatabytes, 0, postdatabytes.Length)
        End Using
        Dim result = s.GetResponse()
        Dim sr As New StreamReader(result.GetResponseStream())
        'Response.Write(sr.ReadToEnd)
        Dim tokenKey As ProjectToken = New ProjectToken
        tokenKey = ser.Deserialize(Of ProjectToken)(sr.ReadToEnd)
        'Response.Write(tokenKey.access_token)
        Token = tokenKey.access_token

    End Sub
    Public Sub Get_Model_Urn()
        Try
            com.CommandText = "select * from cms_3d_library where library_id=" & libId & ""
            com.Connection = con
            dr = com.ExecuteReader
            While dr.Read
                model_urn = dr("model_urn")
            End While
            dr.Close()
        Catch ex As Exception

        End Try
    End Sub
    Public Sub Delete_All_Objects()
        com.CommandText = "delete from cms_3d_library_elements where project_id=" & projectId & " and  library_id=" & libId & ""
        com.Connection = con
        com.ExecuteNonQuery()
    End Sub
    Public Sub delete_all_faces()
        com.CommandText = "delete from cms_3d_library_faces where project_id=" & projectId & " and  library_id=" & libId & " "
        com.Connection = con
        com.ExecuteNonQuery()
    End Sub
    Protected Sub SaveObjFace(ByVal sender As Object, ByVal e As EventArgs)
        con.Open()
        Try

            delete_all_faces()

            'model data
            Dim data As String = Request.Form("data")
            Dim all_data As String() = data.Split(New Char() {","c})

            For Each modeldata As String In all_data
                Dim object_data As String() = modeldata.Split(New Char() {"$"c})

                Dim x1 = object_data(0)
                Dim y1 = object_data(1)
                Dim z1 = object_data(2)

                Dim x2 = object_data(3)
                Dim y2 = object_data(4)
                Dim z2 = object_data(5)

                Dim x3 = object_data(6)
                Dim y3 = object_data(7)
                Dim z3 = object_data(8)

                Dim area = object_data(9)
                Dim obj_id = object_data(10)

                com.CommandText = "insert into cms_3d_library_faces (x1,y1,z1,x2,y2,z2,x3,y3,z3,library_id,object_id,project_id) values (" & x1 & "," & y1 & "," & z1 & "," & x2 & "," & y2 & "," & z2 & "," & x3 & "," & y3 & "," & z3 & "," & libId & "," & obj_id & "," & projectId & ")"
                com.Connection = con
                com.ExecuteNonQuery()


            Next

        Catch ex As Exception
            Response.Write(ex.ToString)
        End Try
        con.Close()

        Dim redirect_url As String = "library_model_data_collect.aspx?eid=" & enterpriseId & "&pid=" & projectId & "&uid=" & userId & "&uk=" & userKey & "&flag=0&libid=" & libId & ""
        Response.Redirect(redirect_url)
    End Sub

    Protected Sub SaveModelData(ByVal sender As Object, ByVal e As EventArgs)

        Dim Nxtflag As Integer = 2
        If flag = 3 Then
            Nxtflag = 4
        End If



        Dim Redirect_url As String = "library_model_data_collect.aspx" & "?eid=" & enterpriseId & "" & "&pid=" & projectId & "" & "&uid=" & userId & "" & "&uk=" & userKey & "&flag=" & Nxtflag & "&autolink=0&libid=" & libId & ""
        con.Open()
        Try

            Delete_All_Objects()

            'model data
            Dim data As String = Request.Form("data")
            Dim all_data As String() = data.Split(New Char() {","c})

            'com.CommandText = "update PROJECT set geography_flag=1,background_flag=2,texture_img='Bare-Land.jpg',sky_img='Blue-Sky.jpg',light_intensity=0.70,ground_limit=40 where project_id=" & projectId & ""
            'com.Connection = con
            'com.ExecuteNonQuery()

            For Each modeldata As String In all_data
                Dim object_data As String() = modeldata.Split(New Char() {"}"c})

                Dim objectid As String = object_data(0)
                Dim obj_name As String = object_data(1)
                Dim color As String = object_data(2)

                If isupdate = 0 Then
                    insert_objects(objectid, obj_name, color)
                Else
                    Dim count As Integer = 0
                    com.CommandText = "select count(*) as tot_count from cms_3d_library_elements where project_id=" & projectId & " and object_id=" & objectid & " and library_id=" & libId & ""
                    com.Connection = con
                    dr = com.ExecuteReader
                    While dr.Read
                        count = dr("tot_count")
                    End While
                    dr.Close()
                    If count = 0 Then
                        insert_objects(objectid, obj_name, color)
                    End If
                End If



            Next
            Response.Redirect(Redirect_url)
        Catch ex As Exception
            Response.Write(ex.ToString)
        End Try
        con.Close()
    End Sub

    Public Sub Get_structureid(ByVal structurename As String)
        Try
            com.CommandText = "select structure_id from introuter_structures where project_id=" & projectId & " and structure_name='" & structurename & "'"
            com.Connection = con
            dr = com.ExecuteReader
            While dr.Read
                sid = dr("structure_id")
            End While
            dr.Close()
        Catch ex As Exception
            Response.Write(ex.ToString)
        End Try
    End Sub

    Public Sub Get_Levelid(ByVal levelname As String)
        Try
            com.CommandText = "select level_id from introuter_levels where project_id=" & projectId & " and level_name='" & levelname & "' and strctr_id=" & sid & ""
            com.Connection = con
            dr = com.ExecuteReader
            While dr.Read
                lid = dr("level_id")
            End While
            dr.Close()
        Catch ex As Exception
            Response.Write(ex.ToString)
        End Try
    End Sub
    Public Sub insert_objects(ByVal objectid As Integer, ByVal obj_name As String, ByVal color As String)

        Dim ver_surface_area As Double = 0
        Dim ttl_surface_area As Double = 0
        Dim ins_type As String = "cad"
        Try
            com.CommandText = "insert into cms_3d_library_elements (project_id,object_id,title,color,library_id) values(" & projectId & "," & objectid & ",'" & obj_name & "','" & color & "'," & libId & ")"
            com.Connection = con
            com.ExecuteNonQuery()

        Catch ex As Exception
            Response.Write(ex.ToString)
        End Try

    End Sub

End Class
Class ProjectToken
    Public Property access_token As String
End Class