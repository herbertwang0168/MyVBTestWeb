<%@ Page Title="" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false"
    CodeFile="DropDownlistTest.aspx.vb" Inherits="AspNet_DropDownlistTest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .custom-combobox
        {
            position: relative;
            display: inline-block;
        }
        .custom-combobox-toggle
        {
            position: absolute;
            top: 0;
            bottom: 0;
            margin-left: -1px;
            padding: 0;
        }
        .custom-combobox-input
        {
            margin: 0;
            padding: 5px 10px;
        }
    </style>
    <script type="text/javascript">
        $(window).load(function () {

        })
        $(function () {
            $('.blockUI').remove()
            //            $.unblockUI();
            $.widget("custom.combobox", {
                _create: function () {
                    this.wrapper = $("<span>")
          .addClass("custom-combobox")
          .insertAfter(this.element);

                    this.element.hide();
                    this._createAutocomplete();
                    this._createShowAllButton();
                },

                _createAutocomplete: function () {
                    debugger;
                    var selected = this.element.children(":selected"),
          value = selected.val() ? selected.text() : "";

                    this.input = $("<input>")
          .appendTo(this.wrapper)
          .val(value)
          .attr("title", "")
          .addClass("custom-combobox-input ui-widget ui-widget-content ui-state-default ui-corner-left")
          .autocomplete({
              delay: 0,
              minLength: 0,
              source: $.proxy(this, "_source")
          })
          .tooltip({
              classes: {
                  "ui-tooltip": "ui-state-highlight"
              }
          });

                    this._on(this.input, {
                        autocompleteselect: function (event, ui) {
                            ui.item.option.selected = true;
                            this._trigger("select", event, {
                                item: ui.item.option
                            });
                        },

                        autocompletechange: "_removeIfInvalid"
                    });
                },

                _createShowAllButton: function () {
                    debugger;
                    var input = this.input,
          wasOpen = false;

                    $("<a>")
          .attr("tabIndex", -1)
          .attr("title", "Show All Items")
          .tooltip()
          .appendTo(this.wrapper)
          .button({
              icons: {
                  primary: "ui-icon-triangle-1-s"
              },
              text: false
          })
          .removeClass("ui-corner-all")
          .addClass("custom-combobox-toggle ui-corner-right")
          .on("mousedown", function () {
              wasOpen = input.autocomplete("widget").is(":visible");
          })
          .on("click", function () {
              input.trigger("focus");

              // Close if already visible
              if (wasOpen) {
                  return;
              }

              // Pass empty string as value to search for, displaying all results
              input.autocomplete("search", "");
          });
                },

                _source: function (request, response) {
                    var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
                    response(this.element.children("option").map(function () {
                        var text = $(this).text();
                        if (this.value && (!request.term || matcher.test(text)))
                            return {
                                label: text,
                                value: text,
                                option: this
                            };
                    }));
                },

                _removeIfInvalid: function (event, ui) {

                    // Selected an item, nothing to do
                    if (ui.item) {
                        return;
                    }

                    // Search for a match (case-insensitive)
                    var value = this.input.val(),
          valueLowerCase = value.toLowerCase(),
          valid = false;
                    this.element.children("option").each(function () {
                        if ($(this).text().toLowerCase() === valueLowerCase) {
                            this.selected = valid = true;
                            return false;
                        }
                    });

                    // Found a match, nothing to do
                    if (valid) {
                        return;
                    }

                    // Remove invalid value
                    this.input
          .val("")
          .attr("title", value + " didn't match any item")
          .tooltip("open");
                    this.element.val("");
                    this._delay(function () {
                        this.input.tooltip("close").attr("title", "");
                    }, 2500);
                    this.input.autocomplete("instance").term = "";
                },

                _destroy: function () {
                    this.wrapper.remove();
                    this.element.show();
                }
            });

            $("#combobox").combobox();
            $("#toggle").on("click", function () {
                debugger;
                $("combobox").toggle();
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="Server">
    <div style="z-index: 1000; border: medium none; margin: 0pt; padding: 0pt; width: 100%;
        height: 100%; top: 0pt; left: 0pt; background-color: rgb(0, 0, 0); opacity: 0.6;
        cursor: wait; position: fixed;" class="blockUI blockOverlay">
    </div>
    <div style="z-index: 1001; position: fixed; padding: 0px; margin: 0px; width: 30%;
        top: 40%; left: 35%; text-align: center; color: rgb(0, 0, 0); border: 3px solid rgb(170, 170, 170);
        background-color: rgb(255, 255, 255); cursor: wait;" class="blockUI blockMsg blockPage">
        <h1>
            Please wait...xxx</h1>
    </div>
    <div>
        <div style="z-index: 0; visibility: visible; clip: rect(0px 370px 80px 350px); position: absolute">
            <asp:DropDownList ID="ddlModel" runat="server" Style="z-index: -1" Width="370px"
                onchange="getModelTo(this)">
                <asp:ListItem Value="1">SSM-001</asp:ListItem>
                <asp:ListItem Value="2">DDW-523</asp:ListItem>
                <asp:ListItem Value="3">QSD-009</asp:ListItem>
            </asp:DropDownList>
        </div>
        <asp:TextBox ID="txtModel" runat="server" Style="z-index: 1px; position: absolute"
            Font-Size="9pt" Width="350px" Height="26px" MaxLength="50"></asp:TextBox>
    </div>
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
    <br />
    <br />
    <br />
    <div class="ui-widget">
        <label>
            Your preferred programming language:
        </label>
        <select id="combobox">
            <option value="">Select one...</option>
            <option value="ActionScript">ActionScript</option>
            <option value="AppleScript">AppleScript</option>
            <option value="Asp">Asp</option>
            <option value="BASIC">BASIC</option>
            <option value="C">C</option>
            <option value="C++">C++</option>
            <option value="Clojure">Clojure</option>
            <option value="COBOL">COBOL</option>
            <option value="ColdFusion">ColdFusion</option>
            <option value="Erlang">Erlang</option>
            <option value="Fortran">Fortran</option>
            <option value="Groovy">Groovy</option>
            <option value="Haskell">Haskell</option>
            <option value="Java">Java</option>
            <option value="JavaScript">JavaScript</option>
            <option value="Lisp">Lisp</option>
            <option value="Perl">Perl</option>
            <option value="PHP">PHP</option>
            <option value="Python">Python</option>
            <option value="Ruby">Ruby</option>
            <option value="Scala">Scala</option>
            <option value="Scheme">Scheme</option>
        </select>
    </div>
    <button id="toggle">
        Show underlying select</button>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <script type="text/javascript">
        //    //1.使用 master.page時 要加 container的名稱 我會比較建議用 #= dateinput.ClientID
        //2.$("input[id$='dateinput']").datepicker();
        //bodyContents_txtModel
        function getModelTo(e) {
            //        debugger;
            $("#<%=txtModel.ClientID%>").val($("#bodyContents_ddlModel").find("option:selected").text());
            $("#bodyContents_txtModel").select();
        } 
    </script>
</asp:Content>
