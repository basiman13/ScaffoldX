<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.js"></script>
    <script src="support/login/support_login.js?ver=2"></script>
    <style>
        @import url('https://fonts.googleapis.com/css?family=Oxygen:400,700');
        *{
          font-family: 'Oxygen', sans-serif;
        }
        input[type=text], input[type=password] {
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .error {
          /*border:2px solid red;*/
          background-color:#FF9494;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="full-height">
            <div style="position:fixed;float:left;width:50%;background-color:#8C2F28;color:white;top:0px;bottom:0px;left:0px;">
            <img src="images/loginImg.png" style="height:100%;width:100%;" />
        </div>

        <div style="position:fixed;width:50%;top:0px;bottom:0px;right:0px;background-color:#E2EAF5;" id="loginPage">
            <div style="left: 75px;top: 100px;position: relative;color: #00529B;font-weight: bold;font-size: 28px;">
                <div>ScaffoldX</div><div style="font-size:15px;padding-left:2px;">Complete Construction Management</div>
            </div>
            <div style="position:relative;top:130px;left:80px;">
               <!-- <span style="font-size:12px;color:#00529B;">Sign in with your login account</span><br />-->
                <input type="text" placeholder="User Name" autocomplete="off" style="width:400px;position:relative;" id="txtLoginUserName" /><br />
                <input type="password" placeholder="Password" style="width:400px;position:relative;top:0px;" id="txtLoginPassword" /><br />

                <button type="button" style="position:relative;top:15px;height:40px;width:200px;cursor:pointer;background-color:#00529B;border-radius:20px;color:white;font-size:16px;border-color:#F68A1F;" id="login-btn">Sign in</button><br />

              <!--  <span style="font-size:12px;color:#00529B;position:relative;top:30px;cursor:pointer;" onclick="showForgetPasswordForm();">Forgot Password ?</span><br />
                <span style="font-size:12px;color:#00529B;position:relative;top:35px;cursor:pointer;" onclick="showChangePasswordForm();">Change password ?</span><br />-->
            </div>
        </div>

        <div style="position:fixed;width:50%;top:0px;bottom:0px;right:0px;display:none;" id="forgotPasswordPage">
            <div style="text-align:right;padding-right:50px;padding-top:50px;">
                <img src="images/icons/close.png" height="40" style="cursor:pointer;" onclick="closeForgotPasswordPage();" />
            </div>
            <div style="position:relative;top:85px;left:80px;">
                <span style="font-size:20px;color:#00529B;">Get Password</span><br />
                <input name="forgetPasswordEmailBox" type="text" id="forgetPasswordEmailBox" placeholder="Email Address" autocomplete="off" style="width:400px;position:relative;top:10px;" /><br />
             
                <button id="getPwdbtn" type="button" style="position:relative;top:35px;height:40px;width:200px;cursor:pointer;background-color:#2771EB;border-radius:20px;color:white;font-size:16px;" onclick="sendCurrPassword();">Send Password</button>
                <img src="https://aws.rimpexpmis.com/uploads/images/fluiconnecto_loading.gif" id="getPwdImg" style="position:relative;top:35px;height:40px;display:none;" />
            </div>
        </div>

        <div style="position:fixed;width:50%;top:0px;bottom:0px;right:0px;display:none;" id="changePasswordPage">
            <div style="text-align:right;padding-right:50px;padding-top:50px;">
                <img src="images/icons/close.png" height="40" style="cursor:pointer;" onclick="closeChangePasswordPage();" />
            </div>
            <div style="position:relative;top:85px;left:80px;">
                <span style="font-size:20px;color:#00529B;">Change Password</span><br />
                <input name="changePasswordEmailBox" type="text" id="changePasswordEmailBox" placeholder="Email Address" autocomplete="off" style="width:400px;position:relative;top:10px;" /><br />
                <input name="changePasswordPwdBox" type="password" id="changePasswordPwdBox" placeholder="Password" style="width:400px;position:relative;top:20px;" /><br />
                <input name="changePasswordNewPwdBox" type="password" id="changePasswordNewPwdBox" placeholder="New Password" style="width:400px;position:relative;top:30px;" /><br />
                
                <button type="button" style="position:relative;top:40px;height:40px;width:200px;cursor:pointer;background-color:#2771EB;border-radius:20px;color:white;font-size:16px;" onclick="changePassword();">Change Password</button><br />
            </div>-->
        </div>

    </div>
    </form>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css" rel="stylesheet" />
   <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script>
        $("#login-btn").click(function () {

            var email = $("#txtLoginUserName").val().trim();
            var password = $("#txtLoginPassword").val().trim();
            var errors = "";
            if (!isEmail(email)) {
                errors += '<div class="error-msg">invalid Email</div>'
            }
            if (password == "") {
                errors += '<div class="error-msg">Password Required</div>'
            }

            if (errors != "") {

                $.confirm({
                    icon: 'fa fa-warning',
                    title: 'Error',
                    content: '' + errors + '',
                    type: 'red',
                    typeAnimated: true,
                    buttons: {

                        ok: {
                            text: 'Ok',
                            btnClass: '',
                            action: function () {


                            }
                        }

                    },
                    boxWidth: '30%',
                    useBootstrap: false,

                });



            } else {
                $(".btn-loader").css("display", "inline-block");

                var login_data = {
                    email: email,
                    password: password
                }
                console.log(login_data)
                $.ajax({
                    url: 'Login.aspx/ValidateUsr',
                    method: 'post',
                    contentType: "application/json",
                    data: JSON.stringify(login_data),
                    dataType: "json",
                    success: function (data) {
                        console.log(data.d)
                        $(".btn-loader").hide();
                        if (data.d.isVerified) {
                            if (data.d.usrType == 0) {
                                window.location = "AdminLeftMenu.aspx";
                            } else {
                                window.location = "AdminLeftMenu.aspx";
                            }

                        } else {
                            swal({
                                title: "Sorry",
                                text: "Email or Password is incorrect",
                                icon: "error",
                            });
                        }
                    },
                    error: function (err) {
                        console.log(err)
                    }
                });



            }
        });

        function isEmail(email) {
            var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            return regex.test(email);
        }
    </script>
</body>
</html>
