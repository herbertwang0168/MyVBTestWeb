<%@ Page Title="" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false"
    CodeFile="OpenWindow.aspx.vb" Inherits="Javascript_OpenWindow" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        #warnings
        {
            position: fixed;
            bottom: 0;
            z-index: 999;
        }
        #floatdiv
        {
            position: absolute;
            top: 0;
            left: 0;
            border: 1px solid;
            width: 200px;
            height: 50px;
            display: none;
            background: #FFFF00;
            z-index: 100;
        }
    </style>
    <script type="text/javascript">
        //點鼠標 出現 浮動視窗 http://chan15.blogspot.com/2011/12/blog-post.html
        $(function () {
            var $div = $('#floatdiv');

            $('[name="btn"]').click(function (e) {
                var $wH = $(window).height(),
                    $sT = $(window).scrollTop(),
                    $pT = $(this).position().top,
                    $dH = $div.height(),
                    $eY = e.pageY,
                    $wW = $(window).width(),
                    $sL = $(window).scrollLeft(),
                    $pL = $(this).position().left,
                    $dW = $div.width(),
                    $eX = e.pageX;

                $top = ($wH - $pT + $sT < $dH) ? ($eY - $dH) : $eY;
                $left = ($wW - $pL + $sL < $dW) ? ($eX - $dW) : $eX;

                $div
                    .css({ left: $left, top: $top })
                    .show();
                return false;
            });

            $div.click(function (e) {
                // 點擊 div 本身不觸動消失
                e.stopPropagation();
            });

            $(document).click(function () {
                // 點擊任一物件使 div 消失
                $div.hide();
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="Server">
    <div style="border: 1px solid blue; padding: 10px; width: 1900px; height: 1200px;">
        <div style="border: 1px solid red; width: 300px; height: 200px;">
            test1
        </div>
        <div id="floatdiv">
        </div>
        <a href="#" name="btn">click me</a>
    </div>
    <div id="warnings" style="position: absolute; width: 150px; height: 150px; background-color: #d0d0ff;">
        簡單製作浮動視窗置底功能
    </div>
    <div id="divFadR" style="position: absolute; top: 100px; left: 1000px; visibility: visible;">
        <table>
            <tr>
                <td valign="top" style="border: 1px solid red;">
                    testxxxxxxxxxx<br />
                    tesxxxxxxxxxxx<br />
                    testxxxxxxxxxx<br />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <script type="text/javascript">
        // 可以參考1 http://abgne.tw/jquery/apply-jquery/jquery-window-scroll-ad.html 另外一些做法
        // 參考二 http://abgne.tw/jquery/apply-jquery/jquery-window-scroll-ad.html

        // 右側浮動廣告寬度
        var fadrWidth = 100;

        // 廣告預設位置
        var fadrInitX = 0;
        var fadrInitY = 0;

        // 廣告位置
        var fadrX = 0;
        var fadrY = 0;

        // 主要區塊大小 (廣告會置於主要區塊之右)
        var mainBlockWidth = 900;

        // FloatADRightInitial: 右側浮動廣告初始
        function FADR_Initial() {
            // 計算廣告之位置
            var pageWidth = document.documentElement.clientWidth || document.body.clientWidth;

            // 計算右側寬度, 若右側寬度大於廣告寬度, 則廣告接在主要區塊之右
            var edgeRight = (pageWidth - mainBlockWidth) / 2;

            if (edgeRight > fadrWidth) {
                fadrInitX = edgeRight + mainBlockWidth;
            }
            else {
                fadrInitX = pageWidth - fadrWidth;
            }

            // 設定位置Y
            fadrInitY = 100;
        }

        // FloatAdRightRefresh: 更新視窗位置
        function FADR_Refresh() {
            // 預防定義不同之設定
            var scrollLeft = window.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft;
            var scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;

            // 計算每次更新之位移
            fadrX += (fadrInitX + scrollLeft - fadrX) / 5;
            fadrY += (fadrInitY + scrollTop - fadrY) / 5;

            // 更新指定圖層之位置
            var fadrStyle = document.getElementById('divFadR').style;
            // 須加上'px'
            fadrStyle.left = fadrX + 'px';
            fadrStyle.top = fadrY + 'px';

            // 每次更新時間，預設為50微秒
            setTimeout('FADR_Refresh()', 50);
        }

        // FloatAdRightStart: 啟動
        function FADR_Start() {
            FADR_Initial();
            FADR_Refresh();
        }

        FADR_Start();

        //第二種 ///////////////////////////////////////////////////////////////
        //        var x_height = 100; //設定高度
        //        $("#floatlayer").css({ top: x_height + "px" }); //設定基本CSS
        //        $("#floatlayer").hide();
        //        $(document).ready(function () {

        //            $("#floatlayer").slideDown({ queue: false, duration: 800, easing: "sineEaseIn" });
        //        });
        //        $(window).scroll(function () {
        //            xx_m = document.body.scrollTop;
        //            xx_m += x_height;
        //            $("#floatlayer").stop();
        //            $("#floatlayer").animate({ "top": xx_m + "px" }, { queue: false, duration: 800, easing: "backEaseOut" }); //duration幾毫秒完成動作

        //        });
        /*
        animate( params, duration, easing, callback )
        params移動位置控制
        duration延遲控制  
        duration特效方式控制  linear   swing

        */
    </script>
    <script type="text/javascript">
        //簡單製作浮動視窗置底功能  http://bibby92.blogspot.com/2016/06/javascript.html
        jQuery(document).ready(function () {
            jQuery(window).scroll(function () {
                if (jQuery(window).scrollTop() + jQuery(window).height() == jQuery(document).height()) {
                    jQuery('#warnings').css("position", "static");
                    jQuery(window).scrollTop(jQuery(document).height());
                } else {
                    jQuery('#warnings').css("position", "fixed");
                }
            });
        });
        jQuery(window).scrollTop() + jQuery(window).height() == jQuery(document).height();
    </script>
</asp:Content>
