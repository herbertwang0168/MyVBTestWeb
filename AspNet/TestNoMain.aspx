﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="TestNoMain.aspx.vb" Inherits="AspNet_TestNoMain" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
  
    <link href="../Styles/jquery-ui.min.css" rel="stylesheet" type="text/css" />
    <script src="../Scripts/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui.js" type="text/javascript"></script>
     <style type="text/css">
  .custom-combobox {
    position: relative;
    display: inline-block;
  }
  .custom-combobox-toggle {
    position: absolute;
    top: 0;
    bottom: 0;
    margin-left: -1px;
    padding: 0;
  }
  .custom-combobox-input {
    margin: 0;
    padding: 5px 10px;
  }
  </style>
   <script type="text/javascript">

       $(function () {
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
</head>
<body>

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

</body>
</html>