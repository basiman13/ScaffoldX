using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Configuration;
using PasswordHash = HashPassword.PasswordHash;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [System.Web.Services.WebMethod(EnableSession = true)]
    public static UserData ValidateUsr(string email, string password)
    {
        bool is_usr_exist = false;
        UserData usr = new UserData();

        try
        {
         

        List<string> saltHashList = null;
        List<string> nameLsit = null;
        List<int> idList = null;
        List<int> typeList = null;

        OleDbDataReader dr;
        string ConnString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        using (OleDbConnection conn = new OleDbConnection(ConnString))
        {
            //string SqlString = "select user_id,user_type,first_name,last_name from kyc_users where email=? and password=?";
            string SqlString = "select password,user_id,user_type,first_name,last_name from kyc_users where email=?";
            using (OleDbCommand cmd = new OleDbCommand(SqlString, conn))
            {
                cmd.Parameters.Add(new OleDbParameter("?", email));
                //cmd.Parameters.Add(new OleDbParameter("?", password));
                conn.Open();
                dr = cmd.ExecuteReader();
                while (dr.HasRows && dr.Read())
                {
                    if (saltHashList == null)
                    {
                        saltHashList = new List<string>();
                        nameLsit = new List<string>();
                        idList = new List<int>();
                        typeList = new List<int>();
                    }
                    //is_usr_exist = true;
                    //HttpContext.Current.Session["Uid"] = Convert.ToInt32(dr["user_id"]);
                    //HttpContext.Current.Session["Utype"] = Convert.ToInt32(dr["user_type"]);
                    //HttpContext.Current.Session["Uname"] = dr.GetString(dr.GetOrdinal("first_name")) + " " + dr.GetString(dr.GetOrdinal("last_name"));
                    //usr.isVerified = is_usr_exist;
                    //usr.usrType = Convert.ToInt32(dr["user_type"]);

                    string saltHashes = dr.GetString(dr.GetOrdinal("password"));
                    saltHashList.Add(saltHashes);

                    string name = dr.GetString(dr.GetOrdinal("first_name")) + " " + dr.GetString(dr.GetOrdinal("last_name"));
                    nameLsit.Add(name);

                    idList.Add(Convert.ToInt32(dr["user_id"]));
                    typeList.Add(Convert.ToInt32(dr["user_type"]));
                }
                dr.Close();

                if (saltHashList != null)
                {

                    for (int i = 0; i < saltHashList.Count; i++)
                    {
                        bool validateUser = PasswordHash.ValidatePassword(password, saltHashList[i]);
                        if (validateUser == true)
                        {
                            HttpContext.Current.Session["Uid"] = idList[i];
                            HttpContext.Current.Session["Utype"] = typeList[i];
                            HttpContext.Current.Session["Uname"] = nameLsit[i];

                            usr.isVerified = true;
                            usr.usrType = Convert.ToInt32(typeList[i]);
                        }
                    }
                }
            }
        }

        
        }
        catch (Exception ex)
        {
            
            usr.error = ex.Message;
        }
        return usr;
    }
}
public class UserData
{
    public bool isVerified { get; set; }
    public int usrType { get; set; }
    public string error { get; set; }
}