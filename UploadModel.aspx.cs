
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Text.RegularExpressions;
using System.Text;
using System.Configuration;
using System.IO;
using System.Net;

using Autodesk.Forge;
using Autodesk.Forge.Model;


public partial class UploadModel : System.Web.UI.Page
{
    OleDbConnection con, conDoc;
    OleDbCommand com, com1, com2, com3;
    OleDbDataReader dr, dr1, dr2, dr3;
    public int model_exist_count = 0;
    public string ftp = "", ftpFolder = "", ftpUsername = "", ftpPassword = "", ftp_url = "";
    public int meta_objects, meta_type, libraryId, flag, dataCollectFlag;
    public double model_center_x, model_center_y, model_center_z;
    public string model_unit;
    int projectId = 1;
    bool connectDbAndSessions()
    {
        try
        {
            string ConnString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            con = new OleDbConnection(ConnString);
            con.Open();

            com = new OleDbCommand();
           

            return true;
        }
        catch (Exception ex)
        {
            Response.Write("Master DB : " + ex.Message);
            return false;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            flag = Convert.ToInt32(Request.QueryString["flag"]);
        }
        catch (Exception ex)
        {
        }
        try
        {
            libraryId = Convert.ToInt32(Request.QueryString["libid"]);
        }
        catch (Exception ex)
        {
        }
        try
        {
            dataCollectFlag = Convert.ToInt32(Request.QueryString["dataflag"]);
        }
        catch (Exception)
        {

            dataCollectFlag = 1;
        }

        if (connectDbAndSessions() == false)
        {
            Response.Write("System Error: Unable to connect server. Please try after sometime.");
            return;
        }


        Page.DataBind();
        try
        {
            con.Close();
        }
        catch (Exception ex) { 
          Response.Write(ex.Message);
        }
    }
    protected async void UploadBimModel(object sender, EventArgs e)
    {
        // create a randomg bucket name (fixed prefix + randomg guid)
        string bucketKey = "forgeapp" + Guid.NewGuid().ToString("N").ToLower();

        // upload the file (to your server)
        string fileSavePath = Path.Combine(HttpContext.Current.Server.MapPath("~/App_Data"), bucketKey, FileUpload1.FileName);
        Directory.CreateDirectory(Path.GetDirectoryName(fileSavePath));
        FileUpload1.SaveAs(fileSavePath);

        ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;

        string client_id = ConfigurationManager.AppSettings["Client_ID"];
        string client_secret = ConfigurationManager.AppSettings["Client_Secret"];

        // get a write enabled token
        TwoLeggedApi oauthApi = new TwoLeggedApi();
        dynamic bearer = await oauthApi.AuthenticateAsync(
            client_id,
            client_secret,
            "client_credentials",
            new Scope[] { Scope.BucketCreate, Scope.DataCreate, Scope.DataWrite, Scope.DataRead });

        // create the Forge bucket
        PostBucketsPayload postBucket = new PostBucketsPayload(bucketKey, null, PostBucketsPayload.PolicyKeyEnum.Persistent /* erase after 24h*/ );
        BucketsApi bucketsApi = new BucketsApi();
        bucketsApi.Configuration.AccessToken = bearer.access_token;
        dynamic newBucket = await bucketsApi.CreateBucketAsync(postBucket);

        // upload file (a.k.a. Objects)
        ObjectsApi objectsApi = new ObjectsApi();
        oauthApi.Configuration.AccessToken = bearer.access_token;
        dynamic newObject;
        using (StreamReader fileStream = new StreamReader(fileSavePath))
        {
            newObject = await objectsApi.UploadObjectAsync(bucketKey, FileUpload1.FileName,
                (int)fileStream.BaseStream.Length, fileStream.BaseStream,
                "application/octet-stream");
        }

        // translate file
        string objectIdBase64 = ToBase64(newObject.objectId);
        List<JobPayloadItem> postTranslationOutput = new List<JobPayloadItem>()
            {
                new JobPayloadItem(
                JobPayloadItem.TypeEnum.Svf /* Viewer*/,
                new List<JobPayloadItem.ViewsEnum>()
                {
                   JobPayloadItem.ViewsEnum._3d,
                   JobPayloadItem.ViewsEnum._2d
                })
            };
        JobPayload postTranslation = new JobPayload(
            new JobPayloadInput(objectIdBase64),
            new JobPayloadOutput(postTranslationOutput));
        DerivativesApi derivativeApi = new DerivativesApi();
        derivativeApi.Configuration.AccessToken = bearer.access_token;
        dynamic translation = await derivativeApi.TranslateAsync(postTranslation);

        // check if is ready
        int progress = 0;
        do
        {
            System.Threading.Thread.Sleep(1000); // wait 1 second
            try
            {
                dynamic manifest = await derivativeApi.GetManifestAsync(objectIdBase64);
                progress = (string.IsNullOrWhiteSpace(Regex.Match(manifest.progress, @"\d+").Value) ? 100 : Int32.Parse(Regex.Match(manifest.progress, @"\d+").Value));
            }
            catch (Exception ex)
            {

            }
        } while (progress < 100);

        // ready!!!!

        // register a client-side script to show this model
        //Response.Write(objectIdBase64);
        //Upload_Model_File_To_server();

        Insert_Model_Urn(objectIdBase64);
        //Insert_upload_logs();

        var collectFlag = Convert.ToInt32(dataFlag.Value);

        string url = "UploadModel.aspx?pid=" + projectId + "&flag=1&libid=" + libraryId + "&dataflag=" + collectFlag + "";
        Response.Redirect(url);

        //Page.ClientScript.RegisterStartupScript(this.GetType(), "ShowModel", string.Format("<script>showModel('{0}');</script>", objectIdBase64));

        Response.Write(objectIdBase64);
        // clean up
        Directory.Delete(Path.GetDirectoryName(fileSavePath), true);
    }
    public string ToBase64(string input)
    {
        var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(input);
        return System.Convert.ToBase64String(plainTextBytes);
    }
    public void Insert_Model_Urn(string urn)
    {
        string title = libraryttl.Value;
        try
        {
            con.Open();
            com.CommandText = "insert into cms_3d_library (project_id,title,model_urn) values (" + projectId + ",'" + title + "','" + urn + "') SELECT SCOPE_IDENTITY()";
            com.Connection = con;
            libraryId = Convert.ToInt32(com.ExecuteScalar());
            con.Close();
        }
        catch (Exception ex)
        {

            Response.Write(ex.Message);
        }
    }
}