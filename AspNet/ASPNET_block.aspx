<%@ Page Title="" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false"
    CodeFile="ASPNET_block.aspx.vb" Inherits="AspNet_ASPNET_block" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="Server">
    <asp:UpdatePanel ID="btnRegin" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Button ID="btnTest" runat="server" Text="Button"  />
            <input type="button" id="btnTest2" value="Button2" onclick="busyBox.Show();alert('testxxx');" />
            <br />
            <br />
            <br />
              <div style="top: 100px;">
        <label for="number">
            Select a number</label>
        <select name="number" id="number">
            <option>1</option>
            <option selected="selected">2</option>
            <option>3</option>
            <option>4</option>
            <option>5</option>
            <option>6</option>
            <option>7</option>
            <option>8</option>
            <option>9</option>
            <option>10</option>
            <option>11</option>
            <option>12</option>
            <option>13</option>
            <option>14</option>
            <option>15</option>
            <option>16</option>
            <option>17</option>
            <option>18</option>
            <option>19</option>
        </select>
    </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnTest" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
</asp:Content>




    <script type="text/javascript">
        $(function () {
            //20150528 herbert 即時輸入//////////////////移開焦點時  
            $("#<%=QuestionTitle.ClientID %>").bind("input", function () {     //// 變更事件  $("#").blur(function () {      //// $("#").bind("input", function () {  .bind("input"
                var qtitle = this.value;
                //alert("qtitle----->" + qtitle);
                getKnowledgeExpandFunc(qtitle)
            }).keyup(function (e) {
                if (e.keyCode == 46 || e.keyCode == 8 || e.which == 8 || e.which == 46) {
                    var qtitle = this.value;
                    getKnowledgeExpandFunc(qtitle)
                }

            });
            ////////////////////////////////////////////////////////////////////////////////////////
        });

        function getKnowledgeExpandFunc(qtitle) {
            $.ajax({
                url: "/services/KnowledgeExpandFunc.ashx",  // /services/KnowledgeExpandFunc.ashx    ExpandFuncServices.asmx/SimilarQuestion
                data: { QTitle: qtitle },
                type: "Post",
                async: true,
                dataType: "text",
                error: function (ex) {
                    //alert(ex);
                },
                success: function (data) {
                    var da = data;
                    //alert(da);
                    $(".newExpFnc").html(da);
                },
                beforeSend: function (data) {
                    var shtml = "<div class='knowledge-content'><span>相關知識</span><p class='knowledge-content-loading'></p><div class='knowledge-content-bottom'>";
                    shtml += "<div class='bottom-blackboard'></div><div class='left-book'></div><div class='right-book'></div></div></div>";
                    $(".newExpFnc").html(shtml); //"搜尋中....." 起動前即開 非同歩才有效
                }
            })
        }


        function Validate() {
            var num = $("#<%=MemberCaptChaTBox.ClientID %>").val();
            var uid = $("#MemberGuid").val();

            if ($.trim($("#<%=QuestionTitle.ClientID %>").val()) == ""
                || $.trim($("#<%=QuestionTitle.ClientID %>").val()) == "請輸入清楚明白的問題標題，限 30 個字以內") {
                alert("請輸入問題標題！");
                return false;
            }

            if ($.trim($("#<%=QuestionContent.ClientID %>").val()) == ""
                || $.trim($("#<%=QuestionContent.ClientID %>").val()) == "請詳細說明問題的狀況") {
                alert("請輸入問題內容！");
                return false;
            }

            return ValidateCaptcha(uid, num) && checkTimer();
        }


    </script>
