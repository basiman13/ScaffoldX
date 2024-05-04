<%@ Page Language="C#" Async="true" AutoEventWireup="true" CodeFile="UploadModel.aspx.cs" Inherits="UploadModel" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Upload Model</title>
    <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <style>
        body{
            overflow:hidden;
        }
         #MainContainer {
            padding: 0px;
            height: 100%;
            position: absolute;
            width: 100%;
            overflow:auto;
        }
        .button {
         background-color: #00A2E8;
          border: none;
          color: white;
          padding: 6px 32px;
          text-align: center;
          text-decoration: none;
          display: inline-block;
          font-size: 16px;
          margin: 4px 2px;
          cursor: pointer;
          margin-top:10px;
        }
        .meta-data-config {
             margin-top: 50px;
            padding-left: 25px;
        }
            .meta-data-config .heading {
                font-size: 15px;
               font-weight: 600;
            }
        .tbl-holder {
            padding-top:10px;
        }
        select {
            min-width: 150px;
            padding: 5px;
            border-color: #d9d9d9;
        }
        .full-frame-holder {
            position:absolute;
            z-index:100;
            height:100%;
            width:100%;
            background-color:#fff;
            display:none;
        }
        .full-frame-holder .header {
                 height: 37px;
    color: #fff;
    padding-left: 10px;
    padding-right: 10px;
    background-color: #a5a5a5;
    line-height: 40px;
    border-bottom: solid 1px #5a5a5a;
        }
        .full-frame-holder .content-holder {
            height:calc(100% - 40px);

        }
        #frame-close {
            font-size:18px;
            cursor:pointer;
            float:right;
        }
        iframe {
            height:100%;
            width:100%;
            border:none;
        }
        #UploadContainer {
              float: left;
    width: 50%;
    border-right: none;
    height: 100%;
    padding: 40px;
    padding-left: 50px;
        }
        #updateContainer {
            float:left;
            width:50%;
            height:100%;
            display:none;
        }
        .generation-type-holder {
            padding-top:20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
  <div class="full-frame-holder">
            <div class="header">
                <span>Import Model Data</span>
                <span id="frame-close"><i class="fa fa-times" aria-hidden="true"></i></span>
            </div>
            <div class="content-holder">
                <iframe id="data-frame"></iframe>
            </div>
        </div>

     <div id="MainContainer">
         <div id="UploadContainer">
            
             <input style="display:none;" type="text" value="1" runat="server" id="dataFlag"/>


            <div style="color:#f6af25;font-size:18px;"><span>Upload 3D Library.</span></div>
             <div class="generation-type-holder">
                 <div><input  id="uSBim" type="radio" name="generateType" value="1"> <span>UsBim IFC</span></div>
                 <div><input  id="Revit" type="radio" name="generateType" value="3"> <span>Revit IFC</span></div>
             </div>
            <div style="padding-top: 20px;font-family: sans-serif;font-size: 15px;">
                <div style="padding-top:5px;"><span>(File Format : AutoDesk Revit Model Converted to IFC)</span></div>
            </div>
            <div style="padding-left: 0px;padding-top: 10px;">
                 <div style="padding-bottom:10px;">
                     <div><span>Library Name</span></div>
                     <div><input runat="server" type="text" id="libraryttl" name="libraryttl" class="form-control"  /></div>
                 </div>
                 <div style="padding-bottom:2px;"><span>Select BIM File</span></div> 
                <!--<input   class="form-control" id="file1" name = "file1" type="file" />--->
                 <asp:FileUpload  class="form-control" id="FileUpload1" runat="server"></asp:FileUpload>
                 <asp:Button style="margin-top:10px;background-color:#0c2a51;background-color:#0c2a51;" class="btn btn-primary" id="Uploadbtn" runat="server" Text="Upload"  OnClick="UploadBimModel"/>
            </div>
             <div id="loader" class="col-xs-12" style="margin-top:20px;padding-left:0px;font-size:16px;display:none"><img style="width:40px;height:40px;" src="Images/loader.gif" /> <span>Uploading...</span></div>
         </div>
         <div id="updateContainer">
             <iframe src=""></iframe>
         </div>
    </div>
    </form>
    <script>
        var model_exist_count =  <%=model_exist_count%>;
        var bim_unit = '<%=model_unit%>';
        var flag = <%=flag%>;
        var libraryId = <%=libraryId%>;
        var dataCollectFlag = <%=dataCollectFlag%>;
     
        if (flag==1) {
            $("#UploadContainer").hide();
            $(".full-frame-holder").show();
            $("#data-frame").attr("src",'library_model_data_collect.aspx?&flag='+dataCollectFlag+'&libid='+libraryId+'')
        }
        function libraryupdateCmplt(libId){
            $("#UploadContainer").hide();
            $(".full-frame-holder").show();
            $("#data-frame").attr("src",'library_model_data_collect.aspx?&flag=0&libid='+libId+'&isupdate=1')
        }
        $("#frame-close").click(function () {
            hide_frame(); 

        });

        function hide_frame(){
            $(".full-frame-holder").hide();
            $("#UploadContainer").show();
            $(".full-frame-holder").hide();
        }
        $("#Uploadbtn").click(function () {

            if ($("#uSBim").prop("checked") || $("#Revit").prop("checked")) {
                
                dataCollectFlag = $("input[name='generateType']:checked").val()
                $("#dataFlag").val(dataCollectFlag)

                var fileName = $("#FileUpload1").val();
                var title = $("#libraryttl").val();
                if (title!="") {
                
                    if (fileName) {
                        var ext = fileName.split('.').pop();
                        if (ext == "ifc" || ext == "rvt") {
                            $("#loader").show();
                    
                        }else{
                            alert("Please select  ifc or rvt file")
                            return false;
                        }

                    } else {
                        alert("no file selected");
                        return false;
                    }

                }else{
                    alert("please provide library name");
                    return false;
                }

            }else{
              
                alert("please select an import type")
                return false;
            }


        });
    </script>
</body>
</html>
