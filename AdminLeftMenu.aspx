<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminLeftMenu.aspx.cs" Inherits="AdminLeftMenu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Menu</title>
    <meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
    
    <style>:root { --theme_clr:#0C2A51; --mmenu_unslctd_clr:#787A78; --mmenu_slctd_clr:#722BF0; --lmenu_unslctd_clr:#ADADAD; --lmenu_slctd_clr:#F6AF25;}</style>
    <style>
         @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap');
        *{
            font-family: 'Inter', sans-serif;
            box-sizing:border-box;
        }

        html,body,form {
            font-size: 12px;
            height:100%;
            margin:0;
        }
        .loading {
            position: fixed;
            top: 0;
            right: 0;
            width:calc(100% - 250px);
            height:100%;
            z-index: 100;
            background-color: rgba(192, 192, 192, 0.5);
            background-image: url("../../images/loading.gif");
            background-repeat: no-repeat;
            background-position: center;
            display: none;
        }

        .left-section {
            width: 250px;
            height: 100%;
            background-color: var(--theme_clr);
            float: left;
        }
            .left-section .hdr {
                font-weight: 600;
                border-bottom: 1px solid #fff;
                padding: 10px;
                color: #fff;
                letter-spacing: .5px;
                display: flex;
                align-items: center;
                height:40px;
            }
                .left-section .hdr i {
                    cursor: pointer;
                    font-size: 20px;
                    min-width: 15px;
                    text-align: center;
                }

        .right-section {
            width: calc(100% - 250px);
            height: 100%;
            float: left;
            border-top: solid var(--theme_clr);
        }
        #ifr {
            height: 100%;
            width: 100%;
            border: none;
            float:left;
        }

        .left-menu-holder {
            padding: 15px 10px 10px 10px;
            height: calc(100% - 40px);
            overflow: auto;
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
            .left-menu-holder::-webkit-scrollbar {
                display: none; /* Safari and Chrome */
            }

            .menu-item {
                margin-bottom: 15px;
                cursor: pointer;
                color: var(--lmenu_unslctd_clr);
                font-size: 12px;
            }
                .menu-item > div:nth-child(1) {
                    display: flex;
                    align-items: center;
                    line-height: 20px;
                }
                    .menu-item > div:nth-child(1):hover,.menu-item.slctd > div:nth-child(1) {
                        color: var(--lmenu_slctd_clr);
                    }

                .menu-item .icon {
                    width: 15px;
                    margin-right: 15px;
                    text-align: center;
                    font-size:14px;
                }
                .menu-item > div:nth-child(2) {
                    display: none;
                    margin: 15px 0 0 15px;
                }
                
                .menu-item .menu-item {
                    font-size: 10px;
                    color: #a1a1a1;
                    margin-bottom: 10px;
                }
                    .menu-item .menu-item .icon {
                        font-size: 11px;
                        margin-right: 10px;
                    }
                    .menu-item .menu-item > div:nth-child(2) {
                        margin-top: 10px;
                    }
                    .menu-item .menu-item > div:nth-child(1):hover,.menu-item .menu-item.slctd > div:nth-child(1) {
                        color: #fff;
                    }

                .menu-item .optinfo {
                    color: #f0ad4e;
                    margin-left: auto;
                    display: flex;
                    align-items: center;
                    font-size: 10px;
                }
                    .menu-item .optinfo > div:last-child {
                        height: 8px;
                        width: 8px;
                        border-radius: 50%;
                        background: #f0ad4e;
                        margin-left: 3px;
                        margin-top: -2px;
                    }

                .menu-item .menu-item .optinfo {
                    font-size: 8px;
                }
                    .menu-item .menu-item .optinfo > div:last-child {
                        height: 6px;
                        width: 6px;
                    }

        .left-section .hdr span {
            margin-right: auto;
            display: flex;
            align-items: center;
        }
            .left-section .hdr span i {
                margin-right: 15px;
                font-size: 14px;
            }
        .left-section .hdr i.fa-caret-left {
            display: block;
        }
        .left-section .hdr i.fa-caret-right {
            display: none;
        }
        .jcollapse .menu-item .ttl, .jcollapse .menu-item .optinfo {
            display: none;
        }
        .left-section.jcollapse .hdr span {
            display: none;
        }
        .left-section.jcollapse .hdr i.fa-caret-left {
            display: none;
        }
        .left-section.jcollapse .hdr i.fa-caret-right {
            display: block;
        }
        .jcollapse .menu-item > div:nth-child(2) {
            margin-left: 0;
        }
        .full-section {
            height:100%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="full-section">
          <div class="left-section">
            <div class="hdr"><span><i class="fa fa-tachometer"></i>Dashboard</span><i class="fa fa-caret-left"></i><i class="fa fa-caret-right"></i></div>
            <div class="left-menu-holder">
                <div class="menu-item" url="UploadModel_v2.aspx?">
                    <div>
                        <div class="icon"><i class="fa fa-hospital-o" title="Upload Model"></i></div>
                        <div class="ttl">Upload Model</div>
                    </div>
                </div>
                <div class="menu-item" url="model_library_view.aspx?">
                    <div>
                        <div class="icon"><i class="fa fa-building-o" title="View Model"></i></div>
                        <div class="ttl">View Model</div>
                    </div>
                </div>
               
                <div class="menu-item" url="Login.aspx">
                    <div>
                        <div class="icon"><i class="fa fa-user-circle" title="Logout"></i></div>
                        <div class="ttl">Logout</div>
                    </div>
                </div>
               
               
                
                
            </div>
        </div>

        <div class="right-section">
            <iframe id="ifr" onload="$('.loading').hide();" name="ifr"></iframe>
        </div>
        
        <div class="loading"></div>
    </div>
    </form>
    <script>
        $(".left-section .hdr i.fa-caret-left").click(function () {
            $(this).hide();
            $(".left-section").css("width", "35px");
            $(".left-section").addClass("jcollapse");
            $(".right-section, .loading").css("width", "calc(100% - 35px)");
            $(".left-section .hdr i.fa-caret-right").show();
        });
        $(".left-section .hdr i.fa-caret-right").click(function () {
            $(this).hide();
            $(".left-section").css("width", "250px");
            $(".left-section").removeClass("jcollapse");
            $(".right-section, .loading").css("width", "calc(100% - 250px)");
            $(".left-section .hdr i.fa-caret-left").show();
        });

        $(".left-menu-holder > .menu-item > div:nth-child(1)").click(function () {
            //if ($(this).parent().hasClass("slctd")) {
            //    $(".slctd").removeClass("slctd");
            //    $(".menu-item > div:nth-child(2)").slideUp();
            //    $("#ifr").attr("src", "");
            //    return;
            //}
            
            $(".slctd").removeClass("slctd");
            $(".menu-item > div:nth-child(2)").slideUp();
            $(this).parent().addClass("slctd");

            var url = $(this).parent().attr("url");
            if (url=="Login.aspx") {
                window.location.href = url;
            }
            if (typeof (url) !== "undefined") {
                $(".loading").show();
                url = url;
                $("#ifr").attr("src", url);
            }
            else {
                $(this).parent().find(">div:nth-child(2)").slideDown();

                url = $(this).parent().attr("grpurl");
                if (typeof (url) !== "undefined") {
                    $(".loading").show();
                    url = url;
                    $("#ifr").attr("src", url);
                }
            }
        });

        $(".left-menu-holder > .menu-item > div:nth-child(2) > .menu-item > div:nth-child(1)").click(function () {
            if ($(this).parent().hasClass("slctd")) {
                $(this).parent().parent().find(".slctd").removeClass("slctd");
                $(this).parent().parent().find(".menu-item > div:nth-child(2)").slideUp();
                $("#ifr").attr("src", "");
                return;
            }

            $(this).parent().parent().find(".slctd").removeClass("slctd");
            $(this).parent().parent().find(".menu-item > div:nth-child(2)").slideUp();
            $(this).parent().addClass("slctd");

            var url = $(this).parent().attr("url");
            
            if (typeof (url) !== "undefined") {
                $(".loading").show();
                url = url + "&eid=" + enterpriseId + "&pid=" + projectId + "&uid=" + userId + "&uk=" + userKey;
                $("#ifr").attr("src", url);
            }
            else {
                var grptb = $(this).parent().attr("grptb");
                if (typeof (grptb) !== "undefined") {
                    window.frames["ifr"].changeGroupTab(grptb);
                }
                else {
                    $(this).parent().find(">div:nth-child(2)").slideDown();
                }
            }
        });

        $(".left-menu-holder > .menu-item > div:nth-child(2) >  .menu-item > div:nth-child(2) > .menu-item > div:nth-child(1)").click(function () {
            if ($(this).parent().hasClass("slctd")) {
                $(this).parent().parent().find(".slctd").removeClass("slctd");
                $("#ifr").attr("src", "");
                return;
            }

            $(this).parent().parent().find(".slctd").removeClass("slctd");
            $(this).parent().addClass("slctd");

            var url = $(this).parent().attr("url");
            $(".loading").show();
            url = url + "&eid=" + enterpriseId + "&pid=" + projectId + "&uid=" + userId + "&uk=" + userKey;
            $("#ifr").attr("src", url);

            
        });

        $(".left-section .hdr i.fa-caret-left, .left-menu-holder > .menu-item:nth-child(1) > div:nth-child(1)").trigger("click");
    </script>
     <script src="https://unpkg.com/popper.js@1"></script>
    <script src="https://unpkg.com/tippy.js@5"></script>
    <script>
        tippy('.menu-item .icon i', {
            arrow: true,
            placement: 'right',
            delay: 5, //ms
            distance: 25, //px or string
            maxWidth: 400, //px or string
            followCursor: true,
            allowHTML: true,
            theme: 'custom',
            ignoreAttributes: true,
            content(reference) {
                const title = reference.getAttribute('title');
        reference.removeAttribute('title');
        return title;
        },
        });
    </script>
</body>
</html>
