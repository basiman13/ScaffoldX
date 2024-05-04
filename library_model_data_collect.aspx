<%@ Page Language="VB" AutoEventWireup="false" CodeFile="library_model_data_collect.aspx.vb" Inherits="BIM_project_bim_view" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <title></title>
     <meta name="viewport" content="width=device-width, minimum-scale=1.0, initial-scale=1, user-scalable=no" />
    <meta charset="utf-8">
     <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <!-- The Viewer CSS -->
     <link rel="stylesheet" href="https://developer.api.autodesk.com/modelderivative/v2/viewers/6.*/style.min.css" type="text/css">
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
     <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js"></script>
    <style>
        html, body,form {
          height: 100%;
          margin: 0;
          overflow:hidden;
         
        }
        
        #MyViewerDiv {
              overflow: hidden;
            height: 100%;
            padding: 2px;
            box-sizing: border-box;
            background-color: #f5f5f5;
            position: absolute;
            width: 100%;
          
        }
         /* Forge Viewer hide Toolbar
        .adsk-viewing-viewer #toolbar-modelStructureTool{display:none!important}
        .adsk-viewing-viewer #toolbar-explodeTool{display:none!important}
        .adsk-viewing-viewer #toolbar-measurementSubmenuTool{display:none!important}
        .adsk-viewing-viewer #toolbar-bimWalkTool{display:none!important}
        .adsk-viewing-viewer .adsk-button {
            display:none;
        }
        .adsk-viewing-viewer.dark-theme .adsk-control-group {
            display:none;
        }
        .adsk-control-group {
             display:none;
        }
        /* Forge Viewer hide Toolbar*/
        #loader {
            position:absolute;
            width:100%;
            height:100%;
            background-color:#f1f1f1;
            z-index:10;
            opacity:0.5;
            display:none;

        }
        #msgbox{
            width: 300px;
            height: 100px;
            position:absolute; /*it can be fixed too*/
            left:0; right:0;
            top:0; bottom:0;
            margin:auto;
            z-index:15;
            background-color:#fff;
            border:solid 1px red;
            text-align:center;
            line-height:100px;
            font-size:18px;
            display:none;
        }
        #fullheight {
            width:100%;
            height:100%;
            
            box-sizing:border-box;
            overflow:auto;
        }
        #box1 {
            float:left;
            box-sizing:border-box;
            width:30%;
              background-color:#fff;
              height:100%;
              border: solid 1px #dedcdc;
              display:none;
              
        }

        #box2 {
            float:left;
            box-sizing:border-box;
            width:100%;
               background-color: #f5f5f5;
              height:100%;
              border: solid 1px #dedcdc;
        }
        /*.adsk-viewing-viewer .adsk-toolbar {
            visibility:hidden;
        }*/
        #toolbar-cameraSubmenuTool {
            display:none !important;
        }
        #toolbar-orbitTools {
            display:none !important;
        }
        #toolbar-panTool {
            display:none !important;
        }
        #toolbar-zoomTool {
              display:none !important;
        }
        #toolbar-explodeTool {
            display:none !important;
        }
        #toolbar-modelStructureTool {
             display:none !important;
        }
        #toolbar-propertiesTool {
            display:none !important;
        }
        #toolbar-settingsTool {
              display:none !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <input type="text" id="data" name="data" style="display:none"/>
        <button runat="server" id="dataSavebtn" onserverclick="SaveModelData" style="display:none;"></button>
        <button runat="server" id="objfacesave" onserverclick="SaveObjFace" style="display:none;"></button>

            <div id="fullheight">
                <div id="box1">
                    <div style="height:30px;box-sizing:border-box;background-color:grey;color:#fff;padding-left: 5px;line-height: 28px;">
                        <span>3D Object Browser</span>
                    </div>
                    <div style="height:calc(100% - 30px);padding:5px;box-sizing:border-box;overflow:auto;">
                        <p id="objects">Loading.....</p>
                        <div id="SimpleJSTree"></div>
                    </div>
                </div>
                <div id="box2">
                    <div style="display:none;height:30px;box-sizing:border-box;background-color:grey;color:#fff;padding-left: 5px;line-height: 28px;padding-right:5px;">
                        <span style="float:left">3D Model</span>
                        <span style="float:right;cursor:pointer;" id="zoom">AutoZoom</span>
                    </div>
                    <div style="height:calc(100% - 0px);position:relative">
                         <div id="MyViewerDiv">
    
                         </div>
                    </div>
                </div>
            </div>
       

        <div id="loader">

        </div>
        <div id="msgbox">
            <div><span id="msg-box-ttl">Collecting Data...</span></div>
        </div>
    </form>
  <!-- The Viewer JS -->
    <script src="https://developer.api.autodesk.com/modelderivative/v2/viewers/6.*/viewer3D.min.js"></script>

    <!-----Tree Js ------------->
     <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>

    <script>
        var flag = <%=flag%>;
        var autolink_flag = <%=autolink_flag%>;
        var enterpriseid = <%=enterpriseId%>;
        var projectid = <%=projectId%>;
        var userid = <%=userId%>;
        var userkey = '<%=userKey%>';
        var isUpdate = <%=isupdate%>;

        var processed_data=[];


        var Token = '<%=Token%>';
        var urn = '<%=model_urn%>';
        var viewer;
        var instanceTree;
        var mydata
        var options = {
            env: 'AutodeskProduction',
            accessToken: Token
        };

        if (autolink_flag==1) {
            parent.parent.autoLink3DObjWithTasks()
        }

        if (flag==1 || flag==2 || flag==3 || flag==4) {
            $("#loader").show();
            $("#msgbox").show();
        }else{
            $("#loader").hide();
            $("#msgbox").hide();
        }

        var zoom_flag=1
        $("#zoom").click(function(){
            if (zoom_flag==1) {
                $("#zoom").css("color", "#c5bebe");
                zoom_flag=0
            }else{
                $("#zoom").css("color", "#fff");
                zoom_flag=1
            }
        });

        var documentId = 'urn:' + urn + '';
        Autodesk.Viewing.Initializer(options, function onInitialized() {
            Autodesk.Viewing.Document.load(documentId, onDocumentLoadSuccess, onDocumentLoadFailure);
        });

        /**
        * Autodesk.Viewing.Document.load() success callback.
        * Proceeds with model initialization.
        */
        function onDocumentLoadSuccess(doc) {

            // A document contains references to 3D and 2D viewables.
            var viewables = Autodesk.Viewing.Document.getSubItemsWithProperties(doc.getRootItem(), { 'type': 'geometry' }, true);
            if (viewables.length === 0) {
                console.error('Document contains no viewables.');
                return;
            }

            // Choose any of the avialble viewables
            var initialViewable = viewables[0];
            var svfUrl = doc.getViewablePath(initialViewable);
            var modelOptions = {
                sharedPropertyDbPath: doc.getPropertyDbPath()
            };

            var viewerDiv = document.getElementById('MyViewerDiv');
            viewer = new Autodesk.Viewing.Private.GuiViewer3D(viewerDiv);
            viewer.start(svfUrl, modelOptions, onLoadModelSuccess, onLoadModelError);

            
            viewer.addEventListener(Autodesk.Viewing.OBJECT_TREE_CREATED_EVENT, function () {

                instanceTree = viewer.model.getData().instanceTree;
                var rootId = this.rootId = instanceTree.getRootId();
                //viewer.hide(rootId);

                Setup_Model_for_view()

                viewer.addEventListener(Autodesk.Viewing.SELECTION_CHANGED_EVENT, onSelectionChanged)

                console.log("Object Tree Created Event");
                mydata = buildModelTree();
                document.getElementById("objects").innerHTML = "";
                createJSTree(mydata['children']);
                

                if (flag==1) {
                   // $("#loader").show();
                    //$("#msgbox").show();
                    setTimeout(function () {
                        /* Save_All_Objects(mydata['children'])
                         $("#data").val(processed_data.toString());
                         console.log(processed_data);
                         document.getElementById("dataSavebtn").click();*/
                       
                        getAllLeafComponents(NOP_VIEWER, function (dbIds) {
                            console.log('Found ' + dbIds.length + ' leaf nodes');
                            save_all_object_data(dbIds)
                            $("#data").val(processed_data.toString());
                            //console.log(processed_data);
                            document.getElementById("dataSavebtn").click();
                        })



                       // $("#loader").hide();
                       // $("#msgbox").hide();

                       
                    }, 100);
                    
                    //console.log(mydata['children'])
                }else if (flag==2) {
                    $("#msg-box-ttl").html("Importing Faces...")
                    setTimeout(function () {
                       Export_Faces()
                    }, 100);
                }else if (flag==3) {
                    var Layers = GetRevitLayers(mydata['children'],true);
                    SaveRevitLayers(Layers)
                    console.log(processed_data)
                    setTimeout(function () {
                        $("#data").val(processed_data.toString());
                        document.getElementById("dataSavebtn").click();
                    }, 100);

                }else if (flag==4) {
                    $("#msg-box-ttl").html("Importing Faces...")
                    var FaceObjects = GetRevitLayers(mydata['children'],false);
                    var Layers = GetRevitLayers(mydata['children'],true);
                   console.log(FaceObjects,Layers)
                    SaveRevitFaces(FaceObjects,Layers)
                    setTimeout(function () {
                        $("#data").val(processed_data.toString());
                        console.log(processed_data);
                        document.getElementById("objfacesave").click();
                    }, 100);
                }
                
            })
        }

        /**
         * Autodesk.Viewing.Document.load() failuire callback.
         */
        function onDocumentLoadFailure(viewerErrorCode) {
            console.error('onDocumentLoadFailure() - errorCode:' + viewerErrorCode);
        }

        /**
         * viewer.loadModel() success callback.
         * Invoked after the model's SVF has been initially loaded.
         * It may trigger before any geometry has been downloaded and displayed on-screen.
         */
        function onLoadModelSuccess(model) {
            console.log('onLoadModelSuccess()!');
            console.log('Validate model loaded: ' + (viewer.model === model));
            console.log(model);
        }

        /**
         * viewer.loadModel() failure callback.
         * Invoked when there's an error fetching the SVF file.
         */
        function onLoadModelError(viewerErrorCode) {
            console.error('onLoadModelError() - errorCode:' + viewerErrorCode);
        }
        function onSelectionChanged(event) {
            
            console.log(event)
            if (isUpdate==1) {
                if (event.dbIdArray.length>0) {
                    var dbId = event.dbIdArray[0];
                    try {
                        window.parent.updateObjid(dbId)
                    }
                    catch(err) {}
                }else{
                    try {
                        window.parent.updateObjid(0)
                    }
                    catch(err) {}
                }
            }
           
        }
        function SaveRevitLayers(data){

            instanceTree = viewer.model.getData().instanceTree;
            var rootId = this.rootId = instanceTree.getRootId();

            for (var i = 0; i < data.length; i++) {
             
                    
                var object_id ;
                var vol = 0;
                var area = 0;
                var x = 0;
                var y = 0;
                var z = 0;
                object_id = data[i].dbId;
                vol = getVolume(viewer, object_id).toFixed(3);
                area = getSurfaceArea(viewer,object_id).toFixed(3);
                   
                var obj_pos = Get_Object_CenterPoints(data[i])
                   
                x = obj_pos.x;
                y = obj_pos.y;
                z = obj_pos.z;
                    
                if (isNaN(x)) {
                    x=0;
                }
                if (isNaN(y)) {
                    y=0;
                }
                if (isNaN(y)) {
                    y=0;
                }
                if (isNaN(z)) {
                    z  = 0;
                }
                if (isNaN(area)) {
                    area  = 0;
                }

                var color = Get_object_original_color(object_id)
                var hex_color = rgbToHex(color[0], color[1], color[2])
                    
                var layer_name = data[i].text //instanceTree.getNodeName(object_id).trim()

                   
                var data_str=object_id+'}'+layer_name+'}'+hex_color;
                    
                if (!data_str.includes("undefined")) {
                    processed_data.push(data_str)
                    //console.log(layer_name)
                }else{
                    //console.log(node_name_str)
                }  
            }
        }
        function SaveRevitFaces(FaceObjects,Layers){

            
          
            for (var i = 0; i < FaceObjects.length; i++) {
                
                obj_id = FaceObjects[i].dbId;
                var lyrId = GetRevitLayerObjIdByFloor(Layers,FaceObjects[i].floorId,FaceObjects[i].text)
                if (obj_id==674) {
                    console.log(FaceObjects[i].floorId,FaceObjects[i].text,lyrId)
                }
                var tree = viewer.model.getData().instanceTree;
                tree.enumNodeFragments(obj_id,
                function(fragId) {

                    

                    var fragProxy = viewer.impl.getFragmentProxy(
                     viewer.model,
                     fragId);

                    var renderProxy = viewer.impl.getRenderProxy(
                        viewer.model,
                        fragId);

                    fragProxy.updateAnimTransform();

                    var matrix = new THREE.Matrix4();
                    fragProxy.getWorldMatrix(matrix);

                    var geometry = renderProxy.geometry;

                    var attributes = geometry.attributes;

                    var vA = new THREE.Vector3();
                    var vB = new THREE.Vector3();
                    var vC = new THREE.Vector3();

                    if (attributes.index !== undefined) {

                        var indices = attributes.index.array || geometry.ib;
                        var positions = geometry.vb ? geometry.vb : attributes.position.array;
                        var stride = geometry.vb ? geometry.vbstride : 3;
                        var offsets = geometry.offsets;

                        if (!offsets || offsets.length === 0) {

                            offsets = [{start: 0, count: indices.length, index: 0}];
                        }

                        for (var oi = 0, ol = offsets.length; oi < ol; ++oi) {

                            var start = offsets[oi].start;
                            var count = offsets[oi].count;
                            var index = offsets[oi].index;

                            for (var i = start, il = start + count; i < il; i += 3) {

                                var a = index + indices[i];
                                var b = index + indices[i + 1];
                                var c = index + indices[i + 2];

                                vA.fromArray(positions, a * stride);
                                vB.fromArray(positions, b * stride);
                                vC.fromArray(positions, c * stride);

                                vA.applyMatrix4(matrix);
                                vB.applyMatrix4(matrix);
                                vC.applyMatrix4(matrix);


                                var x1 = vA.x;
                                var y1 = vA.y;
                                var z1 = vA.z;

                                 
                                var x2 =vB.x;
                                var y2 =vB.y;
                                var z2 =vB.z;

                                var x3 = vC.x;
                                var y3 = vC.y;
                                var z3 = vC.z;

                                var D1 = (y2-y1)*(z3-z1)-(z2-z1)*(y3-y1);
                                var D2 = (z2-z1)*(x3-x1)-(x2-x1)*(z3-z1);
                                var D3 = (x2-x1)*(y3-y1)-(y2-y1)*(x3-x1);


                                var area = 0.5* Math.sqrt(D1*D1 + D2*D2 + D3*D3);
                                area.toFixed(2);
                                try {
                                    //area = ( x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2) )/2
                                    //area.toFixed(2);
                                }
                                catch(err) {
                                    //area = 0.0;
                                }
                      
                               
                                // console.log(area)

                                var data_str=vA.x+'$'+ vA.y+'$'+vA.z+'$'+vB.x+'$'+vB.y+'$'+vB.z+'$'+vC.x+'$'+vC.y+'$'+vC.z+'$'+area+'$'+lyrId;
                                if (!data_str.contains("NaN")) {
                                    //console.log(vA,vB,vC)
                                    //data_str = data_str.replace(/NaN/g, '0');
                                    processed_data.push(data_str)
                                }
                               
                                
                            }
                        }

                    }else{

                        var positions = geometry.vb ? geometry.vb : attributes.position.array;
                        var stride = geometry.vb ? geometry.vbstride : 3;

                        for (var i = 0, j = 0, il = positions.length; i < il; i += 3, j += 9) {

                            var a = i;
                            var b = i + 1;
                            var c = i + 2;

                            vA.fromArray(positions, a * stride);
                            vB.fromArray(positions, b * stride);
                            vC.fromArray(positions, c * stride);

                            vA.applyMatrix4(matrix);
                            vB.applyMatrix4(matrix);
                            vC.applyMatrix4(matrix);

                          

                            var x1 = vA.x;
                            var y1 = vA.y;
                            var z1 = vA.z;

                                 
                            var x2 =vB.x;
                            var y2 =vB.y;
                            var z2 =vB.z;

                            var x3 = vC.x;
                            var y3 = vC.y;
                            var z3 = vC.z;

                            var D1 = (y2-y1)*(z3-z1)-(z2-z1)*(y3-y1);
                            var D2 = (z2-z1)*(x3-x1)-(x2-x1)*(z3-z1);
                            var D3 = (x2-x1)*(y3-y1)-(y2-y1)*(x3-x1);


                            var area = 0.5* Math.sqrt(D1*D1 + D2*D2 + D3*D3);
                            area.toFixed(2);

                            //console.log(area)

                            var data_str=vA.x+'$'+ vA.y+'$'+vA.z+'$'+vB.x+'$'+vB.y+'$'+vB.z+'$'+vC.x+'$'+vC.y+'$'+vC.z+'$'+area+'$'+lyrId;
                            // processed_data.push(data_str)

                        }
                    }

                    
                },
                true);
            }
        }
        function GetRevitLayerObjIdByFloor(Layers,floorId,lyrName){
            var Id = 0;
            for (var i = 0; i < Layers.length; i++) {
            
                if (Layers[i].floorId==floorId && Layers[i].text==lyrName) {
                    Id = Layers[i].dbId;
                    break;
                }
            }
            return Id;
        }
        function GetRevitLayers(Tree,isFilter){

            var Layers = [];
            var RootParents = Tree[0].children[0].children;
         
            for (var i = 0; i < RootParents.length; i++) {
               
                if (RootParents[i].hasOwnProperty('children')) {
                    
                    var floors  = RootParents[i].children;
                    for (var j = 0; j < floors.length; j++) {
                      
                        var floorChilds = floors[j].children;
                        var floorId =  floors[j].dbId;
                        var flrTtl = floors[j].text;

                        for (var k = 0; k < floorChilds.length; k++) {
                            
                            var lyrName = floorChilds[k].text;
                            if (lyrName.includes(":")) {
                                lyrName =  lyrName.split(':')[0];
                            }
                            if (LayerExist(Layers,lyrName,floorId) && isFilter) {
                                continue;
                            }
                            var lyrdata = {
                                dbId:floorChilds[k].dbId,
                                text:lyrName,
                                floorId:floorId,
                                flrTtl:flrTtl,
                            }
                            Layers.push(lyrdata);
                        }
                    }

                }else{
                    var lyrName = RootParents[i].text;
                    var lyrdata = {
                        dbId:RootParents[i].dbId,
                        text:lyrName,
                        floorId:0,
                        flrTtl:"",
                    }
                    Layers.push(lyrdata);  
                }
            }
            return Layers;
        }
        function LayerExist(Layers,lyrName,floorId){
            var isExist = false;
            for (var i = 0; i < Layers.length; i++) {
                if (Layers[i].floorId==floorId && Layers[i].text==lyrName) {
                    isExist = true;
                    break;
                }
            }
            return isExist;
        }
        function save_all_object_data(data){
          
            instanceTree = viewer.model.getData().instanceTree;
            var rootId = this.rootId = instanceTree.getRootId();

            for (var i = 0; i < data.length; i++) {
             
                    
                    var object_id ;
                    var vol = 0;
                    var area = 0;
                    var x = 0;
                    var y = 0;
                    var z = 0;
                    object_id = data[i];
                    vol = getVolume(viewer, object_id).toFixed(3);
                    area = getSurfaceArea(viewer,object_id).toFixed(3);
                   
                    var obj_pos = Get_Object_CenterPoints(data[i])
                   
                    x = obj_pos.x;
                    y = obj_pos.y;
                    z = obj_pos.z;
                    
                    if (isNaN(x)) {
                        x=0;
                    }
                    if (isNaN(y)) {
                        y=0;
                    }
                    if (isNaN(y)) {
                        y=0;
                    }
                    if (isNaN(z)) {
                        z  = 0;
                    }
                    if (isNaN(area)) {
                        area  = 0;
                    }

                    var color = Get_object_original_color(object_id)
                    var hex_color = rgbToHex(color[0], color[1], color[2])
                    
                    var layer_name = instanceTree.getNodeName(object_id).trim()

                   
                    var data_str=object_id+'}'+layer_name+'}'+hex_color;
                    
                    if (!data_str.includes("undefined")) {
                        processed_data.push(data_str)
                        //console.log(layer_name)
                    }else{
                        //console.log(node_name_str)
                    }

                    
                    // console.log( obj_pos.x, obj_pos.y, obj_pos.z);
               
               
            }
           
        }

        var _lineMaterial = null;
        var tot_count=0;
        var current_count=0;
        var obj_id=0;
        function Export_Faces(){

            setTimeout(function() {
                getAllLeafComponents(NOP_VIEWER, function (dbIds) {
                    console.log('Found ' + dbIds.length + ' leaf nodes');
                    console.log(dbIds)
                    Save_All_Objects_faces(dbIds)
                })
                $("#data").val(processed_data.toString());
                console.log(processed_data);
                document.getElementById("objfacesave").click();
            }, 100);
          
        }
        function getAllLeafComponents(viewer, callback) {
            var cbCount = 0; // count pending callbacks
            var components = []; // store the results
            var tree; // the instance tree

            function getLeafComponentsRec(parent) {
                cbCount++;
                if (tree.getChildCount(parent) != 0) {
                    tree.enumNodeChildren(parent, function (children) {
                        getLeafComponentsRec(children);
                    }, false);
                } else {
                    components.push(parent);
                }
                if (--cbCount == 0) callback(components);
            }
            viewer.getObjectTree(function (objectTree) {
                tree = objectTree;
                var allLeafComponents = getLeafComponentsRec(tree.getRootId());
            });
        }      
        function Save_All_Objects_faces(dbIds){
            
           
            for (var i = 0; i < dbIds.length; i++) {
                
                /*if (processed_data.length>5000) {
                    break;
                }*/
                obj_id = dbIds[i] 

                var tree = viewer.model.getData().instanceTree;
                tree.enumNodeFragments(dbIds[i],
                function(fragId) {

                    

                    var fragProxy = viewer.impl.getFragmentProxy(
                     viewer.model,
                     fragId);

                    var renderProxy = viewer.impl.getRenderProxy(
                        viewer.model,
                        fragId);

                    fragProxy.updateAnimTransform();

                    var matrix = new THREE.Matrix4();
                    fragProxy.getWorldMatrix(matrix);

                    var geometry = renderProxy.geometry;

                    var attributes = geometry.attributes;

                    var vA = new THREE.Vector3();
                    var vB = new THREE.Vector3();
                    var vC = new THREE.Vector3();

                    if (attributes.index !== undefined) {

                        var indices = attributes.index.array || geometry.ib;
                        var positions = geometry.vb ? geometry.vb : attributes.position.array;
                        var stride = geometry.vb ? geometry.vbstride : 3;
                        var offsets = geometry.offsets;

                        if (!offsets || offsets.length === 0) {

                            offsets = [{start: 0, count: indices.length, index: 0}];
                        }

                        for (var oi = 0, ol = offsets.length; oi < ol; ++oi) {

                            var start = offsets[oi].start;
                            var count = offsets[oi].count;
                            var index = offsets[oi].index;

                            for (var i = start, il = start + count; i < il; i += 3) {

                                var a = index + indices[i];
                                var b = index + indices[i + 1];
                                var c = index + indices[i + 2];

                                vA.fromArray(positions, a * stride);
                                vB.fromArray(positions, b * stride);
                                vC.fromArray(positions, c * stride);

                                vA.applyMatrix4(matrix);
                                vB.applyMatrix4(matrix);
                                vC.applyMatrix4(matrix);


                                var x1 = vA.x;
                                var y1 = vA.y;
                                var z1 = vA.z;

                                 
                                var x2 =vB.x;
                                var y2 =vB.y;
                                var z2 =vB.z;

                                var x3 = vC.x;
                                var y3 = vC.y;
                                var z3 = vC.z;

                                var D1 = (y2-y1)*(z3-z1)-(z2-z1)*(y3-y1);
                                var D2 = (z2-z1)*(x3-x1)-(x2-x1)*(z3-z1);
                                var D3 = (x2-x1)*(y3-y1)-(y2-y1)*(x3-x1);


                                var area = 0.5* Math.sqrt(D1*D1 + D2*D2 + D3*D3);
                                area.toFixed(2);
                                try {
                                    //area = ( x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2) )/2
                                    //area.toFixed(2);
                                }
                                catch(err) {
                                    //area = 0.0;
                                }
                      
                               
                                // console.log(area)

                                var data_str=vA.x+'$'+ vA.y+'$'+vA.z+'$'+vB.x+'$'+vB.y+'$'+vB.z+'$'+vC.x+'$'+vC.y+'$'+vC.z+'$'+area+'$'+obj_id;
                                if (!data_str.contains("NaN")) {
                                    //console.log(vA,vB,vC)
                                    //data_str = data_str.replace(/NaN/g, '0');
                                    processed_data.push(data_str)
                                }
                               
                                
                            }
                        }

                    }else{

                        var positions = geometry.vb ? geometry.vb : attributes.position.array;
                        var stride = geometry.vb ? geometry.vbstride : 3;

                        for (var i = 0, j = 0, il = positions.length; i < il; i += 3, j += 9) {

                            var a = i;
                            var b = i + 1;
                            var c = i + 2;

                            vA.fromArray(positions, a * stride);
                            vB.fromArray(positions, b * stride);
                            vC.fromArray(positions, c * stride);

                            vA.applyMatrix4(matrix);
                            vB.applyMatrix4(matrix);
                            vC.applyMatrix4(matrix);

                          

                            var x1 = vA.x;
                            var y1 = vA.y;
                            var z1 = vA.z;

                                 
                            var x2 =vB.x;
                            var y2 =vB.y;
                            var z2 =vB.z;

                            var x3 = vC.x;
                            var y3 = vC.y;
                            var z3 = vC.z;

                            var D1 = (y2-y1)*(z3-z1)-(z2-z1)*(y3-y1);
                            var D2 = (z2-z1)*(x3-x1)-(x2-x1)*(z3-z1);
                            var D3 = (x2-x1)*(y3-y1)-(y2-y1)*(x3-x1);


                            var area = 0.5* Math.sqrt(D1*D1 + D2*D2 + D3*D3);
                            area.toFixed(2);

                            //console.log(area)

                            var data_str=vA.x+'$'+ vA.y+'$'+vA.z+'$'+vB.x+'$'+vB.y+'$'+vB.z+'$'+vC.x+'$'+vC.y+'$'+vC.z+'$'+area+'$'+obj_id;
                            // processed_data.push(data_str)

                        }
                    }

                    
                },
                true);
            }
        }
        function Setup_Model_for_view(){
            var rootId =  instanceTree.getRootId();
            var all_objids = getAllDbIds(viewer)
            var act_model_objids = [];
            for (var i = 0; i < all_objids.length; i++) {
                if (all_objids[i]!=rootId) {
                    var obj_name = instanceTree.getNodeName(all_objids[i])
                    if (obj_name != undefined && obj_name != null) {
                        if (obj_name.includes("cutting-plane-object")) {
                            viewer.impl.visibilityManager.setNodeOff(all_objids[i], true);
                        }
                        if (obj_name.includes("Slab")) {
                            act_model_objids.push(all_objids[i])
                        }
                    }
                       
                }
                    
            }
            viewer.fitToView(act_model_objids);
            setTimeout(function () {
                viewer.setViewCube("front")
            }, 500);

        }

        function getAllDbIds(viewer) {
            var instanceTree = viewer.model.getData().instanceTree;

            var allDbIdsStr = Object.keys(instanceTree.nodeAccess.dbIdToIndex);

            return allDbIdsStr.map(function(id) { return parseInt(id)});
        }

        function buildModelTree() {

            instanceTree = viewer.model.getData().instanceTree;
            var rootId = this.rootId = instanceTree.getRootId();
           

            var rootNode = {
                dbId: rootId,
                id: rootId,
                text: instanceTree.getNodeName(rootId)

            }
            buildModelTreeRec(rootNode)
            return rootNode


        }
        function buildModelTreeRec(node) {


            instanceTree.enumNodeChildren(node.dbId, function (childId) {

                node.children = node.children || []
                var childNode = {
                    dbId: childId,
                    id: childId,
                    text: instanceTree.getNodeName(childId)

                }
                // Remove Cutting Plane Object from Tree Structure
                if (!childNode.text.includes("cutting-plane-object")) {
                    node.children.push(childNode)
                }
               
                buildModelTreeRec(childNode)
            })
        }
        function Save_All_Objects(data){
           // console.log(data[0].children);
            var all_structures=data[0].children
            for (var i = 0; i < all_structures.length; i++) {
                
                var temp =all_structures[i].children;
                Get_All_Levels(temp);
            }
           
        }
        function Get_All_Levels(structure){
            var structure_name = structure[0].text;
            var current_structure_levels=structure[0].children
            //console.log(current_structure_levels);

           
            

            for (var i = 0; i < current_structure_levels.length; i++) {

                Get_All_Levels_Childs(structure_name,current_structure_levels[i].text,current_structure_levels[i].children)
            }
        }
        function Get_All_Levels_Childs(structure_name,level_name,childs){
            //console.log(childs)
            

            for (var i = 0; i < childs.length; i++) {
                
                

                var object_id =  childs[i].dbId;
                if (childs[i].text.substring(0,3)=="Cor") {
                    var object_Type = childs[i].text.substring(0,3);
                }else if (childs[i].text.substring(0,2)=="Wa") {
                    var object_Type = childs[i].text.substring(0,2);
                }else if (childs[i].text.substring(0,2)=="Fa") {
                    var object_Type = childs[i].text.substring(0,2);
                }else if (childs[i].text.substring(0,3)=="HVA") {
                   var object_Type = childs[i].text.substring(0,3);
                }else if (childs[i].text.substring(0,3)=="Flo") {
                    var object_Type = childs[i].text.substring(0,3);
                }else if (childs[i].text.substring(0,3)=="Plu") {
                    var object_Type = childs[i].text.substring(0,3);
                }else if (childs[i].text.substring(0,3)=="Fir") {
                    var object_Type = childs[i].text.substring(0,3);
                }else if (childs[i].text.substring(0,3)=="Dra"){
                    var object_Type = childs[i].text.substring(0,3);
                }else if (childs[i].text.substring(0,3)=="Ele"){
                    var object_Type = childs[i].text.substring(0,3);
                }else if (childs[i].text.substring(0,3)=="ELV"){
                    var object_Type = childs[i].text.substring(0,3);
                }else if (childs[i].text.substring(0,3)=="Gas"){
                    var object_Type = childs[i].text.substring(0,3);
                }else if (childs[i].text.substring(0,3)=="Cab"){
                    var object_Type = childs[i].text.substring(0,3);
                }else if (childs[i].text.substring(0,3)=="Cei"){
                    var object_Type = childs[i].text.substring(0,3);
                }
                else if (childs[i].text.substring(0,4)=="Site"){
                    var object_Type = childs[i].text.substring(0,4);
                }
                else{
                    var object_Type = childs[i].text.charAt(0);
                }
               
                var vol = getVolume(viewer, object_id).toFixed(2)
                //console.log(structure_name,level_name,object_Type,object_id,vol);

                var data_str=''+structure_name+'$'+level_name+'$'+object_Type+'$'+object_id+'$'+ vol+''
                processed_data.push(data_str)

               /* var purl = "?uid=" + userid + "&pid=" + projectid + "&eid=" + enterpriseid + "&uk=" + userkey + "&sname=" + structure_name + "&lname=" + level_name + "&objecttype=" + object_Type + "&objectid=" + object_id;
                var url = "http://aws.rimpexpmis.com/rimpex-dev/BIM/bim-objects-save-support.aspx" + purl;
                $.ajax({
                    url: url,async:false, success: function (result) {
                           console.log("inserted") 
                    }
                });*/
            }
        }
        function Get_object_original_color(objid){
            var color=[];
            var flag = 0;
            var tree = viewer.model.getData().instanceTree;
            tree.enumNodeFragments(objid,
            function(fragId) {
                if (flag==0) {
                    var mat = viewer.model.getFragmentList().getMaterial(fragId)
                    color.push(Math.round(mat.color.r*255))
                    color.push(Math.round(mat.color.g*255))
                    color.push(Math.round(mat.color.b*255))
                    flag=1;
                }
            },
            true);
            return color;
        }
        function rgbToHex(r, g, b) {
            return componentToHex(r) + componentToHex(g) + componentToHex(b);
        }
        function componentToHex(c) {
            var hex = c.toString(16);
            return hex.length == 1 ? "0" + hex : hex;
        }
        function Get_Object_CenterPoints(dbId){

           var pos = viewer.worldToClient(getModifiedWorldBoundingBox(dbId).center());
            return pos;
        }
        function getModifiedWorldBoundingBox(dbId) {

            var fragList = this.viewer.model.getFragmentList();
            const nodebBox = new THREE.Box3()
           
            viewer.model.getInstanceTree().enumNodeFragments(dbId, function (fragId) {
               
                const fragbBox = new THREE.Box3();
                fragList.getWorldBounds(fragId, fragbBox);
                nodebBox.union(fragbBox); // create a unifed bounding box

            });
                    
            return nodebBox
        }
        function getVolume(viewer, dbId) {
            var volume = 0;
            var it = viewer.model.getData().instanceTree;

            it.enumNodeFragments(dbId, function (fragId) {
                getVertices(viewer, fragId, (p1, p2, p3) => {
                    volume += getTriangleVolume(p1, p2, p3)
                })
            }, true);

            return volume;
        }
        function getSurfaceArea(viewer, dbId) {
            var area = 0;
            var it = viewer.model.getData().instanceTree;

            it.enumNodeFragments(dbId, function (fragId) {
                getVertices(viewer, fragId, (p1, p2, p3) => {
                    area += getTriangleArea(p1, p2, p3)
                })
            }, true);

            return area;
        }
        function getTriangleArea(p1, p2, p3) {
            var tr = new THREE.Triangle(p1, p2, p3);
            return tr.area();
        }
        function getTriangleVolume(p1, p2, p3) {
            return p1.dot(p2.cross(p3)) / 6.0;
        }
        function getVertices(viewer, fragId, callback) {
            var fragProxy = viewer.impl.getFragmentProxy(
              viewer.model,
              fragId);

            var renderProxy = viewer.impl.getRenderProxy(
              viewer.model,
              fragId);

            fragProxy.updateAnimTransform();

            var matrix = new THREE.Matrix4();
            fragProxy.getWorldMatrix(matrix);

            var geometry = renderProxy.geometry;

            var attributes = geometry.attributes;

            var vA = new THREE.Vector3();
            var vB = new THREE.Vector3();
            var vC = new THREE.Vector3();

            if (attributes.index !== undefined) {

                var indices = attributes.index.array || geometry.ib;
                var positions = geometry.vb ? geometry.vb : attributes.position.array;
                var stride = geometry.vb ? geometry.vbstride : 3;
                var offsets = geometry.offsets;

                if (!offsets || offsets.length === 0) {

                    offsets = [{ start: 0, count: indices.length, index: 0 }];
                }

                for (var oi = 0, ol = offsets.length; oi < ol; ++oi) {

                    var start = offsets[oi].start;
                    var count = offsets[oi].count;
                    var index = offsets[oi].index;

                    for (var i = start, il = start + count; i < il; i += 3) {

                        var a = index + indices[i];
                        var b = index + indices[i + 1];
                        var c = index + indices[i + 2];

                        vA.fromArray(positions, a * stride);
                        vB.fromArray(positions, b * stride);
                        vC.fromArray(positions, c * stride);

                        vA.applyMatrix4(matrix);
                        vB.applyMatrix4(matrix);
                        vC.applyMatrix4(matrix);

                        callback(vA, vB, vC)
                    }
                }
            }
            else {
                var positions = geometry.vb ? geometry.vb : attributes.position.array;
                var stride = geometry.vb ? geometry.vbstride : 3;

                for (var i = 0, j = 0, il = positions.length; i < il; i += 3, j += 9) {

                    var a = i;
                    var b = i + 1;
                    var c = i + 2;

                    vA.fromArray(positions, a * stride);
                    vB.fromArray(positions, b * stride);
                    vC.fromArray(positions, c * stride);

                    vA.applyMatrix4(matrix);
                    vB.applyMatrix4(matrix);
                    vC.applyMatrix4(matrix);

                    callback(vA, vB, vC)
                }
            }
        }

        function createJSTree(jsondata) {
            $('#SimpleJSTree').jstree({
                'core': {
                    'data': jsondata
                },
                checkbox: {

                    whole_node: false,  // to avoid checking the box just clicking the node 
                    tie_selection: false // for checking without selecting and selecting without checking
                },
                plugins: ['checkbox']
            });
        }
        $('#SimpleJSTree').on("select_node.jstree", function (e, data) {
            // alert("node_id: " + data.node.id);
          

            var mydbid = parseInt(data.node.id, 10);
            console.log(mydbid);
            //  viewer.isolate([mydbid]);
            viewer.select([mydbid])
            if (zoom_flag==1) {
                console.log("zoom enabled");
                viewer.fitToView([mydbid]);
            } else {
                console.log("zoom not enabled");
            }

            viewer.impl.setSelectionColor(new THREE.Color(1, 0, 0))


        });
    </script>
</body>
</html>
