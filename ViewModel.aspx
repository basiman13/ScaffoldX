<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ViewModel.aspx.vb" Inherits="ViewModel" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        html, body, form {
            height:100%;
            width:100%;
            padding:0px;
            margin:0px;
        }
        #full-height {
            height:100%;
            width:100%;
            overflow:hidden;
        }
        iframe {
            height:100%;
            width:100%;
            border:none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="full-height">
         <iframe id="data-frame"></iframe>
    </div>
    </form>
    <script>
        var libId = <%=libId%>;
    </script>
</body>
</html>
